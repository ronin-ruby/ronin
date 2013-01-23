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

require 'ronin/model/has_unique_name'
require 'ronin/model'

module Ronin
  #
  # Represents the name of a {URLQueryParam}.
  #
  class URLQueryParamName

    include Model
    include Model::HasUniqueName

    # The primary-key of the URL query param
    property :id, Serial

    # The name of the URL query param
    property :name, String, length:   256,
                            required: true,
                            unique:   true

    # The URL query params
    has 0..n, :query_params, model:     'URLQueryParam',
                             child_key: [:name_id]

    #
    # Specifies when the URL query param name was first seen.
    #
    # @return [Time]
    #   The timestamp that the query param name was first seen.
    #
    # @since 1.1.0
    #
    # @api public
    #
    def created_at
      if (url = self.query_params.urls.first(fields: [:created_at]))
        url.created_at
      end
    end

    #
    # Converts the URL query param name to a String.
    #
    # @return [String]
    #   The name of the URL query param
    #
    # @since 1.1.0
    #
    # @api public
    #
    def to_s
      self.name.to_s
    end

    #
    # Inspects the URL query param name.
    #
    # @return [String]
    #   The inspected URL query param name.
    #
    # @since 1.1.0
    #
    # @api public
    #
    def inspect
      "#<#{self.class}: #{self}>"
    end

  end
end
