#
# Copyright (c) 2006-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/model'
require 'ronin/script/script'

require 'object_loader'

module Ronin
  module Script
    #
    # The {Path} model stores information in the {Database} about
    # cached {Script} objects.
    #
    # @since 1.1.0
    #
    class Path

      include Model

      # The primary key of the cached file
      property :id, Serial

      # The path to the file where the object was defined in
      property :path, FilePath, required: true

      # The timestamp of the cached file
      property :timestamp, Time, required: true

      # The class name of the cached object
      property :class_name, String, required: true

      # The repository the file was cached from
      belongs_to :repository

      # Any exceptions raise when loading a fresh object
      attr_reader :cache_exception

      # Any cache errors encountered when caching the object
      attr_reader :cache_errors

      #
      # The path to require to access the Class of the cached object.
      #
      # @return [String]
      #   The possible path inferred from the class name.
      #
      # @since 1.1.0
      #
      def class_path
        if self.class_name
          DataMapper::Inflector.underscore(self.class_name)
        end
      end

      #
      # The Model of the cached object.
      #
      # @return [Class, nil]
      #   Returns the Model of the cached object, or `nil` if the class
      #   could not be loaded or found.
      #
      # @since 1.1.0
      #
      def script_class
        return unless self.class_name

        # filter out unloadable script classes
        begin
          require class_path
        rescue Gem::LoadError => e
          raise(e)
        rescue ::LoadError
        end

        # filter out missing class names
        loaded_class = begin
                         DataMapper::Ext::Object.full_const_get(self.class_name)
                       rescue NameError
                         return nil
                       end

        # filter out non-script classes
        return loaded_class if loaded_class < Script
      end

      #
      # The object from the Database that was cached from the file.
      #
      # @return [Model]
      #   The previously cached object connected to the cache file.
      #
      # @since 1.1.0
      #
      def cached_script
        if (cached_class = script_class)
          return cached_class.first(script_path: self)
        end
      end

      #
      # A freshly loaded {Script} object from the cache file.
      #
      # @return [Script, nil]
      #   The first {Script} object loaded from the cache file.
      #   If `nil` is returned, the file did not contain any cacheable
      #   objects or the cache file contained a syntax error.
      #   
      # @since 1.1.0
      #
      def load_script
        begin
          # load the first found object
          blocks = ObjectLoader.load_blocks(self.path)
        rescue ::Exception => e
          @cache_exception = e
          return nil
        end

        blocks.each do |object_class,object_block|
          if object_class < Script
            # create the fresh object
            object = object_class.new()

            begin
              object.instance_eval(&object_block)

              @cache_exception = nil
              return object
            rescue ::Exception => e
              @cache_exception = e
            end
          end
        end

        return nil
      end

      #
      # Determines if the cache file was updated.
      #
      # @return [Boolean]
      #   Specifies whether the cache file was updated.
      #
      # @since 1.1.0
      #
      def updated?
        # assume updates if there is no timestamp
        return true unless self.timestamp

        if File.file?(self.path)
          return self.path.mtime > self.timestamp
        end

        # do not assume updates, if there is no path
        return false
      end

      #
      # Determines if the cache file was deleted.
      #
      # @return [Boolean]
      #   Specifies whether the cache file was deleted.
      #
      # @since 1.1.0
      #
      def missing?
        !(self.path.file?)
      end

      #
      # Caches the freshly loaded object from the cache file into the
      # Database.
      #
      # @return [Boolean]
      #   Specifies whether the object was successfully cached.
      #
      # @since 1.1.0
      #
      def cache
        if (new_script = load_script)
          # reset the model-class
          self.class_name = new_script.class.to_s

          # update the timestamp
          self.timestamp = self.path.mtime

          # re-cache the newly loaded script
          new_script.script_path = self

          if new_script.save
            @cache_errors = nil
            return true
          else
            @cache_errors = new_script.errors
          end
        end

        return false
      end

      #
      # Syncs the cached object in the Database with the object loaded from
      # the cache file.
      #
      # @return [Boolean]
      #   Specifies whether the cached object was successfully synced.
      #
      # @since 1.1.0
      #
      def sync
        if missing?
          # destroy the cached file, if the actual file is missing
          return destroy
        elsif updated?
          # clean the previously cached file
          clean

          # if we couldn't cache anything, self-destruct
          destroy unless cache
          return true
        end

        return false
      end

      #
      # Cleans the cached file from the Database.
      #
      # @since 1.4.0
      #
      def clean
        if (script = cached_script)
          # destroy the previously cached object
          script.destroy!
        end
      end

      #
      # Before destroying the cached file object, also destroy the
      # associated cached object.
      #
      # @since 1.1.0
      #
      def destroy
        clean unless destroyed?

        return super
      end

      #
      # Before forcibly destroying the cached file object, also destroy the
      # associated cached object.
      #
      # @since 1.4.0
      #
      def destroy!
        clean unless destroyed?

        return super
      end

      #
      # Converts the script path to a String.
      #
      # @return [String]
      #   The path of the script path.
      #
      # @since 1.1.0
      #
      def to_s
        self.path.to_s
      end

    end
  end
end
