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

require 'ronin/credential'

module Ronin
  #
  # Represents Credentials used to access websites at specified {URL}s.
  #
  class WebCredential < Credential

    # The URL the credential can be used with.
    belongs_to :url, required: false,
                     model:    'URL'

    #
    # Searches all web credentials that are associated with an
    # email address.
    #
    # @param [String] email
    #   The email address to search for.
    #
    # @return [Array<WebCredential>]
    #   The web credentials associated with the email address.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.with_email(email)
      unless email.include?('@')
        raise("invalid email address #{email.dump}")
      end

      user, domain = email.split('@',2)

      return all(
        'email_address.user_name.name'    => user,
        'email_address.host_name.address' => domain
      )
    end

    #
    # Converts the web credential to a String.
    #
    # @return [String]
    #   The user name, clear-text password and the optional email address.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def to_s
      if self.email_address then "#{super} (#{self.email_address})"
      else                       super
      end
    end

  end
end
