#
# Ronin - A decentralized repository for the storage and sharing of computer
# security advisories, exploits and payloads.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

require 'exploits/bufferoverflow'
require 'repo/platformexploitcontext'

module Ronin
  module Repo
    class BufferOverflowTargetContext < TargetContext

      def initialize(&block)
	# initialize bufferoverflow target metadata
	metadata_set(:buffer_length,0)
	metadata_set(:return_length,0)
	metadata_set(:bp,0)
	metadata_set(:ip,0)

	super(&block)
      end

      def to_target
	BufferOverflowTarget.new(product_version,platform,buffer_length,return_length,bp,ip,comments)
      end

      protected

      # Buffer length
      attr_metadata :buffer_length

      # Return length
      attr_metadata :return_length

      # Stack base pointer
      attr_metadata :bp

      # Instruction Pointer
      attr_metadata :ip

    end

    class BufferOverflowContext < PlatformExploitContext

      def initialize(path)
	super(path)
      end

      def create
	return BufferOverflow.new(advisory) do |exp|
	  load_platformexploit(exp)
	end
      end

      protected

      # Name of object to load
      attr_object :bufferoverflow

      def target(&block)
	@targets << BufferOverflowTargetContext.new(&block)
      end

    end
  end
end
