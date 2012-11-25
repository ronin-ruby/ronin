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

require 'ronin/script/path'
require 'ronin/model/model'
require 'ronin/model/has_name'
require 'ronin/model/has_description'
require 'ronin/model/has_version'
require 'ronin/model/has_license'
require 'ronin/model/has_authors'
require 'ronin/ui/printing'

require 'object_loader'
require 'data_paths/finders'
require 'parameters'

module Ronin
  #
  # {Script} is a high-level module that enables a Class to load
  # instances from files and cache them into the {Database}.
  # Classes that include {Script}, may also include Script sub-modules
  # that define behaviors of the Script Class:
  #
  # * {Buildable}
  # * {Testable}
  # * {Deployable}
  #
  # @since 1.1.0
  #
  module Script
    include UI::Printing

    #
    # Adds the following to the Class.
    #
    # * {Script::InstanceMethods}
    # * {Model}
    # * {Model::HasName}
    # * {Model::HasDescription}
    # * {Model::HasVersion}
    # * {Model::HasLicense}
    # * {Model::HasAuthors}
    # * [ObjectLoader](http://rubydoc.info/gems/object_loader)
    # * [DataPaths::Finders](http://rubydoc.info/gems/data_paths)
    # * [Parameters](http://rubydoc.info/gems/parameters)
    # * {ClassMethods}
    #
    # @api semipublic
    #
    def self.included(base)
      base.send :include, InstanceMethods,
                          Model,
                          Model::HasName,
                          Model::HasDescription,
                          Model::HasVersion,
                          Model::HasLicense,
                          Model::HasAuthors,
                          ObjectLoader,
                          DataPaths::Finders,
                          Parameters

      base.send :extend, ClassMethods

      base.module_eval do
        # The class-name of the cached object
        property :type, DataMapper::Property::Discriminator

        # The cached file of the object
        belongs_to :script_path, Ronin::Script::Path, :required => false

        # Validations
        validates_uniqueness_of :version, :scope => [:name]
      end

      Path.has 1, base.relationship_name, base, :child_key => [:script_path_id]
    end

    #
    # @since 1.1.0
    #
    module ClassMethods
      #
      # The shortened name of the Script class.
      #
      # @return [String]
      #   The shortened name.
      #
      # @since 1.4.0
      #
      # @api semipublic
      #
      def short_name
        @short_name ||= self.name.split('::').last
      end

      #
      # Loads the {Script} of the same class.
      #
      # @param [String] path
      #   The path to load the script from.
      #
      # @return [Script]
      #   The loaded script.
      #
      # @example
      #   Exploits::HTTP.load_from('mod_php_exploit.rb')
      #   # => #<Ronin::Exploits::HTTP: ...>
      #
      # @since 1.1.0
      #
      def load_from(path)
        load_object(path)
      end

      #
      # Loads all objects with the matching attributes.
      #
      # @param [Hash] attributes
      #   Attributes to search for.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def load_all(attributes={})
        resources = all(attributes)
        resources.each { |resource| resource.load_script! }

        return resources
      end

      #
      # Loads the first object with matching attributes.
      #
      # @param [Hash] attributes
      #   Attributes to search for.
      #
      # @return [Cacheable]
      #   The loaded cached objects.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def load_first(attributes={})
        if (resource = first(attributes))
          resource.load_script!
        end

        return resource
      end
    end

    #
    # Instance methods for an {Script}.
    #
    # @since 1.1.0
    #
    module InstanceMethods
      #
      # Initializes the Ronin Script.
      #
      # @param [Array] arguments
      #   Arguments for initializing the Script.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      def initialize(*arguments,&block)
        @script_loaded = false
        @cache_prepared = false

        if arguments.first.kind_of?(Hash)
          initialize_params(arguments.first)
        end

        super(*arguments,&block)
      end

      #
      # Determines if the original code, from the cache file, has been
      # loaded into the object.
      #
      # @return [Boolean]
      #   Specifies whether the original code has been loaded into the
      #   object.
      #
      # @since 1.1.0
      #
      # @api private
      #
      def script_loaded?
        @script_loaded == true
      end

      #
      # Loads the code from the cached file for the object, and instance
      # evaluates it into the object.
      #
      # @return [Boolean]
      #   Indicates the original code was successfully loaded.
      #
      # @since 1.1.0
      #
      # @api private
      #
      def load_script!
        if (cached? && !script_loaded?)
          block = self.class.load_object_block(self.script_path.path)

          @script_loaded = true
          instance_eval(&block) if block
          return true
        end

        return false
      end

      #
      # @return [Boolean]
      #   Specifies whether the object has been prepared to be cached,
      #
      # @since 1.1.0
      #
      # @api private
      #
      def prepared_for_cache?
        @cache_prepared == true
      end

      #
      # Indicates whether the object has been cached.
      #
      # @return [Boolean]
      #   Specifies whether the object has been previously cached.
      #
      # @since 1.1.0
      #
      # @api private
      #
      def cached?
        (saved? && self.script_path)
      end

      #
      # Default method which invokes the script.
      #
      # @param [Array] arguments
      #   Optional arguments.
      #
      # @since 1.1.0
      #
      def run(*arguments)
      end

      #
      # Converts the script to a String.
      #
      # @return [String]
      #   The name and version of the script.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def to_s
        if (self.name && self.version)
          "#{self.name} #{self.version}"
        elsif self.name
          super
        elsif self.version
          self.version.to_s
        end
      end

      #
      # Inspects both the properties and parameters of the Ronin Script.
      #
      # @return [String]
      #   The inspected Ronin Script.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def inspect
        body = []

        self.attributes.each do |name,value|
          body << "#{name}: #{value.inspect}"
        end

        param_pairs = []

        self.params.each do |name,param|
          param_pairs << "#{name}: #{param.value.inspect}"
        end

        body << "params: {#{param_pairs.join(', ')}}"

        return "#<#{self.class}: #{body.join(', ')}>"
      end

      protected

      #
      # Will call the given block only once, in order to prepare the
      # object for caching.
      #
      # @yield []
      #   The block will be ran inside the object when the object is to be
      #   prepared for caching.
      #
      # @return [Boolean]
      #   Specifies whether the object was successfully prepared for
      #   caching.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def cache
        if (block_given? && !(cached? || prepared_for_cache?))
          @cache_prepared = true

          yield
          return true
        end

        return false
      end
    end

    # 
    # Loads a script from a file.
    #
    # @param [String] path
    #   The path to the file.
    #
    # @return [Script]
    #   The loaded script.
    #
    # @since 1.1.0
    #
    # @api semipublic
    #
    def Script.load_from(path)
      path = File.expand_path(path)
      script = ObjectLoader.load_objects(path).find do |obj|
        obj.class < Script
      end

      unless script
        raise("No cacheable object defined in #{path.dump}")
      end

      script.instance_variable_set('@script_loaded',true)
      script.script_path = Path.new(
        :path => path,
        :timestamp => File.mtime(path),
        :class_name => script.class.to_s
      )

      return script
    end
  end
end
