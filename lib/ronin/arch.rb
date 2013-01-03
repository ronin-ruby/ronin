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

module Ronin
  #
  # Represents a Computer Architecture and predefines many other common
  # architectures ({x86}, {x86_64}, {ia64}, {ppc}, {ppc64}, {sparc},
  # {sparc64}, {mips} and {arm}).
  #
  class Arch

    include Model
    include Model::HasUniqueName

    # Primary key
    property :id, Serial

    # Endianness of the architecture
    property :endian, String, :set => ['little', 'big'], :required => true

    # Address length of the architecture
    property :address_length, Integer, :required => true

    #
    # Defines a new pre-defined Arch.
    #
    # @param [Symbol, String] name
    #   The name of the architecture.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [Symbol, String] :endian
    #   The endianness of the architecture.
    #
    # @option options [Integer] :address_length
    #   The address-length of the architecture.
    #
    # @example Defining a pre-defined Arch
    #   Arch.predefine :alpha, :endian => :big, :address_length => 8
    #
    # @example Retrieving a pre-defined Arch
    #   Arch.alpha
    #
    # @api private
    #
    def self.predefine(name,options={})
      super(name,{:name => name}.merge(options))
    end

    #
    # The x86 Architecture
    #
    # @return [Arch]
    #
    def self.x86
      first(:name => 'x86')
    end

    #
    # @see x86
    #
    def self.i386; x86; end

    #
    # @see x86
    #
    def self.i486; x86; end

    #
    # @see x86
    #
    def self.i686; x86; end

    #
    # @see x86
    #
    def self.i986; x86; end

    #
    # The x86_64 Architecture
    #
    # @return [Arch]
    #
    def self.x86_64
      first(:name => 'x86-64')
    end

    #
    # The ia64 Architecture
    #
    # @return [Arch]
    #
    def self.ia64
      first(:name => 'ia64')
    end

    #
    # The 32-bit PowerPC Architecture
    #
    # @return [Arch]
    #
    def self.ppc
      first(:name => 'ppc')
    end

    #
    # The 64-bit PowerPC Architecture
    #
    # @return [Arch]
    #
    def self.ppc64
      first(:name => 'ppc64')
    end

    #
    # The 32-bit SPARC Architecture
    #
    # @return [Arch]
    #
    def self.sparc
      first(:name => 'sparc')
    end

    #
    # The 64-bit SPARC Architecture
    #
    # @return [Arch]
    #
    def self.sparc64
      first(:name => 'sparc64')
    end

    #
    # The MIPS (little endian) Architecture
    #
    # @return [Arch]
    #
    def self.mips_le
      first(:name => 'mips_le')
    end

    #
    # The MIPS (big endian) Architecture
    #
    # @return [Arch]
    #
    def self.mips_be
      first(:name => 'mips_be')
    end

    #
    # @see mipse_be
    #
    def self.mips; mips_be; end

    #
    # The ARM (little endian) Architecture
    #
    # @return [Arch]
    #
    def self.arm_le
      first(:name => 'arm_le')
    end

    #
    # The ARM (big endian) Architecture
    #
    # @return [Arch]
    #
    def self.arm_be
      first(:name => 'arm_be')
    end

    #
    # @see arm_be
    #
    def self.arm; arm_be; end

  end
end
