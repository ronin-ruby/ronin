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
require 'ronin/license'

module Ronin
  module Model
    #
    # Adds a `license` relationship between a model and the {License} model.
    #
    module HasLicense
      #
      # Adds the `license` relationship and {ClassMethods} to the model.
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
          # The license
          belongs_to :license, Ronin::License, :required => false

          Ronin::License.has 0..n, self.relationship_name, :model => self
        end
      end

      #
      # Class methods that are added when {HasLicense} is included into a
      # model.
      #
      module ClassMethods
        #
        # Finds all models associated with a given license.
        #
        # @param [License, Symbol, #to_s] license
        #   The license which models are associated with.
        #
        # @return [Array<Model>]
        #   The models associated with a given license.
        #
        # @example Query using a predefined {License} resource.
        #   LicensedModel.licensed_under(License.mit)
        #   # => [#<Ronin::LicensedModel: ...>, ...]
        #
        # @example Query using the name of a predefined {License}.
        #   LicensedModel.licensed_under(:cc_by_nc)
        #   # => [#<Ronin::LicensedModel: ...>, ...]
        #
        # @example Query using the name of a {License}.
        #   LicensedModel.licensed_under('GPL-2')
        #   # => [#<Ronin::LicensedModel: ...>, ...]
        #
        # @since 1.0.0
        #
        # @api public
        #
        def licensed_under(license)
          conditions = case license
                       when License
                         {:license => license}
                       when Symbol
                         unless License.methods(false).include?(license)
                           raise(ArgumentError,"unknown license: #{license}")
                         end

                         {:license => License.send(license)}
                       else
                         {'license.name' => license.to_s}
                       end

          all(conditions)
        end
      end

      #
      # Instance methods that are added when {HasLicense} is included into a
      # model.
      #
      module InstanceMethods
        #
        # Sets the license of the model.
        #
        # @param [Symbol, String] name
        #   The name of the license to use.
        #
        # @return [License]
        #   The new license of the model.
        #
        # @example
        #   licensed_under :mit
        #
        # @since 1.3.0
        #
        # @api public
        #
        def licensed_under(name)
          self.license = Ronin::License.predefined_resource(name)
        end
      end
    end
  end
end
