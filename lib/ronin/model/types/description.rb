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

require 'dm-core'

module Ronin
  module Model
    module Types
      #
      # The Description property type is similar to the `Text` type,
      # but automatically strips all leading and tailing white-space
      # from every line.
      #
      class Description < DataMapper::Property::Text

        #
        # Type-casts the description.
        #
        # @param [Object] value
        #   The text of the description.
        #
        # @return [String, nil]
        #   The type-casted description.
        #
        # @since 1.0.0
        #
        # @api private
        #
        def typecast(value)
          return nil if value.nil?

          sanitized_lines = []

          value.to_s.each_line do |line|
            sanitized_lines << line.strip
          end

          return sanitized_lines.join($/).strip
        end

      end
    end
  end
end
