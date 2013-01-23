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

require 'digest'

module Ronin
  #
  # Represents a password that can be stored in the {Database}.
  #
  class Password

    include Model

    # Primary key of the password
    property :id, Serial

    # The clear-text of the password
    property :clear_text, String, length:   256,
                                  required: true,
                                  unique:   true

    # The credentials which use the password
    has 0..n, :credentials

    # The user names which use the password
    has 0..n, :user_names, through: :credentials

    #
    # Parses a password.
    #
    # @param [#to_s] password
    #   The password to parse.
    #
    # @return [Password]
    #   The parsed password.
    #
    # @since 1.4.0
    #
    # @api public
    #
    def self.parse(password)
      first_or_new(clear_text: password.to_s)
    end

    #
    # Hashes the password.
    #
    # @param [Symbol, String] algorithm
    #   The digest algorithm to use.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [String] :prepend_salt
    #   The salt data to prepend to the password.
    #
    # @option options [String] :append_salt
    #   The salt data to append to the password.
    #
    # @return [String]
    #   The hex-digest of the hashed password.
    #
    # @raise [ArgumentError]
    #   Unknown Digest algorithm.
    #
    # @example
    #   pass = Password.new(clear_text: 'secret')
    #   
    #   pass.digest(:sha1)
    #   # => "e5e9fa1ba31ecd1ae84f75caaa474f3a663f05f4"
    #   
    #   pass.digest(:sha1, prepend_salt: "A\x90\x00")
    #   # => "e2817656a48c49f24839ccf9295b389d8f985904"
    #   
    #   pass.digest(:sha1, append_salt: "BBBB")
    #   # => "aa6ca21e446d425fc044bbb26e950a788444a5b8"
    #
    # @since 1.0.0
    #
    # @api public
    #
    def digest(algorithm,options={})
      digest_class = begin
                       Digest.const_get(algorithm.to_s.upcase)
                     rescue LoadError
                       raise(ArgumentError,"Unknown Digest algorithm #{algorithm}")
                     end

      hash = digest_class.new

      if options[:prepend_salt]
        hash << options[:prepend_salt].to_s
      end

      hash << self.clear_text

      if options[:append_salt]
        hash << options[:append_salt].to_s
      end

      return hash.hexdigest
    end

    #
    # The number of credentials which use this password.
    #
    # @return [Integer]
    #   The number of credentials that use the password.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def count
      self.credentials.count
    end

    #
    # Converts the password into a String.
    #
    # @return [String]
    #   The clear-text of the password.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def to_s
      self.clear_text
    end

    #
    # Inspects the password.
    #
    # @return [String]
    #   The inspected password.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def inspect
      "#<#{self.class}: #{self.clear_text}>"
    end

  end
end
