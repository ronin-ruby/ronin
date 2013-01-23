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

module Ronin
  module Model
    #
    # Adds a `name` property to a model.
    #
    module HasName
      #
      # Adds the `name` property and {ClassMethods} to the model.
      #
      # @param [Class] base
      #   The model.
      #
      # @api semipublic
      #
      def self.included(base)
        base.send :include, Model, InstanceMethods
        base.send :extend, ClassMethods

        base.module_eval do
          # The name of the model
          property :name, String, required: true, index: true
        end
      end

      #
      # Class methods that are added when {HasName} is included into a
      # model.
      #
      module ClassMethods
        #
        # Finds models with names containing a given fragment of text.
        #
        # @param [String] fragment
        #   The fragment of text to search for within the names of models.
        #
        # @return [Array<Model>]
        #   The found models.
        #
        # @example
        #   Exploit.named 'ProFTP'
        #
        # @api public
        #
        def named(fragment)
          all(:name.like => "%#{fragment}%")
        end
      end

      #
      # Instance methods that are added when {HasName} is included into a
      # model.
      #
      module InstanceMethods
        #
        # Converts the named resource into a String.
        #
        # @return [String]
        #   The name of the resource.
        #
        # @since 1.0.0
        #
        # @api public
        #
        def to_s
          self.name.to_s
        end
      end
    end
  end
end
