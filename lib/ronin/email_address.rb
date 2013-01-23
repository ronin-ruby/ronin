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

require 'ronin/extensions/regexp'
require 'ronin/model'
require 'ronin/model/importable'
require 'ronin/user_name'
require 'ronin/host_name'

require 'uri/mailto'
require 'dm-timestamps'

module Ronin
  #
  # Represents email addresses that can be stored in the {Database}.
  #
  class EmailAddress

    include Model

    # The primary key of the email address.
    property :id, Serial

    # The user-name component of the email address.
    belongs_to :user_name

    # The host-name component of the email address.
    belongs_to :host_name

    # Any IP addresses associated with the host name.
    has 0..n, :ip_addresses, through: :host_name,
                             model:   'IPAddress'

    # Any web credentials that are associated with the email address.
    has 0..n, :credentials

    # Tracks when the email address was created at.
    timestamps :created_at

    # Validates the uniqueness of the user-name and the host-name.
    validates_uniqueness_of :user_name, scope: [:host_name]

    #
    # Extracts email addresses from the given text.
    #
    # @param [String] text
    #   The text to parse.
    #
    # @yield [email]
    #   The given block will be passed each extracted email address.
    #
    # @yieldparam [EmailAddress] email
    #   An extracted host-name.
    #
    # @return [Array<EmailAddress>]
    #   If no block is given, an Array of email address will be returned.
    #
    # @see 1.3.0
    #
    # @api public
    #
    def self.extract(text)
      return enum_for(__method__,text).to_a unless block_given?

      scanner = StringScanner.new(text)

      while scanner.skip_until(Regexp::EMAIL_ADDR)
        yield parse(scanner.matched)
      end

      return nil
    end

    #
    # Searches for email addresses associated with the given host names.
    #
    # @param [Array<String>, String] names
    #   The host name(s) to search for.
    #
    # @return [Array<EmailAddress>]
    #   The matching email addresses.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.with_hosts(names)
      all('host_name.address' => names)
    end

    #
    # Searches for email addresses associated with the given IP address(es).
    #
    # @param [Array<String>, String] ips
    #   The IP address(es) to search for.
    #
    # @return [Array<EmailAddress>]
    #   The matching email addresses.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.with_ips(ips)
      all('ip_addresses.address' => ips)
    end

    #
    # Searches for email addresses associated with the given user names.
    #
    # @param [Array<String>, String] names
    #   The user name(s) to search for.
    #
    # @return [Array<EmailAddress>]
    #   The matching email addresses.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.with_users(names)
      all('user_name.name' => names)
    end

    #
    # Parses an email address.
    #
    # @param [String] email
    #   The email address to parse.
    #
    # @return [EmailAddress]
    #   A new or previously saved email address resource.
    #
    # @raise [RuntimeError]
    #   The email address did not have a user name or a host name.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.parse(email)
      user, host = email.split('@',2)

      user.strip!

      if user.empty?
        raise("email address #{email.dump} must have a user name")
      end

      host.strip!

      if host.empty?
        raise("email address #{email.dump} must have a host name")
      end

      return first_or_new(
        user_name: UserName.first_or_new(name: user),
        host_name: HostName.first_or_new(address: host)
      )
    end

    #
    # Creates a new Email Address.
    #
    # @param [URI::MailTo, #to_s] email
    #   The URI or String to create the Email Address from.
    #
    # @return [EmailAddress]
    #   The new Email Address.
    #
    # @since 1.4.0
    #
    # @api public
    #
    def self.from(email)
      email = case email
              when URI::MailTo then email.to
              else                  email.to_s
              end

      return parse(email)
    end

    #
    # The user of the email address.
    #
    # @return [String]
    #   The user name.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def user
      self.user_name.name if self.user_name
    end

    #
    # The host of the email address.
    #
    # @return [String]
    #   The host name.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def host
      self.host_name.address if self.host_name
    end

    #
    # Converts the email address into a String.
    #
    # @return [String]
    #   The raw email address.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def to_s
      "#{self.user_name}@#{self.host_name}"
    end

    #
    # Inspects the email address.
    #
    # @return [String]
    #   The inspected email address.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def inspect
      "#<#{self.class}: #{self}>"
    end

  end
end
