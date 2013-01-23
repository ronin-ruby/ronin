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
require 'ronin/model/has_unique_name'
require 'ronin/model/has_description'
require 'ronin/address'
require 'ronin/target'

require 'dm-timestamps'

module Ronin
  #
  # Represents a grouping of targeted {Address}es.
  #
  class Campaign

    include Model
    include Model::HasUniqueName
    include Model::HasDescription

    # Primary key of the campaign
    property :id, Serial

    # Defines the `created_at` and `updated_at` timestamps
    timestamps :at

    # The targets of the campaign
    has 0..n, :targets

    # The addresses being targeted in the campaign
    has 0..n, :addresses, through: :targets

    # The organization the campaign covers
    has 0..n, :organizations, through: :targets

    #
    # Searches for all campaigns targeting an {Address}.
    #
    # @param [Array<String>, String] addr
    #   The address(es) to search for.
    #
    # @return [Array<Campaign>]
    #   The campaigns that target the given address.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.targeting(addr)
      all('addresses.address' => addr)
    end

    #
    # Searches for all campaigns targeting an {Organization}.
    #
    # @param [Array<String>, String] names
    #   The organization name(s) to search for.
    #
    # @return [Array<Campaign>]
    #   The campaigns that target the specified organizations.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.targeting_orgs(names)
      all('organizations.name' => names)
    end

    #
    # Determines if an address is targeted by the campaign.
    #
    # @param [Address] address
    #   The address.
    #
    # @return [Boolean]
    #   Specifies whether the address is targeted.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def targets?(address)
      self.addresses.include?(address)
    end

    #
    # Adds an address to the campaign.
    #
    # @param [String] addr
    #   The address that will be targeted.
    #
    # @return [Target]
    #   The new target of the campaign.
    #
    # @raise [RuntimeError]
    #   The given address could not be found.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def target!(addr)
      unless (address = Address.first(address: addr))
        raise("unknown address #{addr.dump}")
      end

      return Target.first_or_create(campaign: self, address: address)
    end

  end
end
