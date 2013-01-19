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
require 'ronin/model/importable'
require 'ronin/url_scheme'
require 'ronin/url_query_param'
require 'ronin/host_name'
require 'ronin/tcp_port'

require 'dm-timestamps'
require 'uri/generic'
require 'uri/http'
require 'uri/https'
require 'uri/ftp'
require 'uri/query_params'

module Ronin
  #
  # Represents URLs that can be stored in the {Database}.
  #
  class URL

    include Model
    include Model::Importable

    # Mapping of URL Schemes and URI classes
    SCHEMES = {
      'https' => ::URI::HTTPS,
      'http'  => ::URI::HTTP,
      'ftp'   => ::URI::FTP
    }

    # Primary key of the URL
    property :id, Serial

    # The scheme of the URL
    belongs_to :scheme, :model => 'URLScheme'

    # The host name of the URL
    belongs_to :host_name

    # Port of the URL
    belongs_to :port, :model => 'TCPPort', :required => false

    # Path of the URL
    property :path, String

    # The fragment of the URL
    property :fragment, String

    # The query params of the URL
    has 0..n, :query_params, :model => 'URLQueryParam'

    # Any credentials used with the URL
    has 0..n, :web_credentials

    # When the URL was last scanned
    property :last_scanned_at, Time

    # Defines the created_at timestamp
    timestamps :created_at

    #
    # Extracts URLs from the given text.
    #
    # @param [String] text
    #   The text to parse.
    #
    # @yield [url]
    #   The given block will be passed each extracted URL.
    #
    # @yieldparam [URL] url
    #   An extracted URL from the text.
    #
    # @return [Array<URL>]
    #   If no block is given, an Array of the extracted URLs is returned.
    #
    # @see http://rubydoc.info/stdlib/uri/URI#extract-class_method
    # @see URL.parse
    #
    # @since 1.3.0
    #
    # @api public
    #
    def self.extract(text)
      return enum_for(__method__,text).to_a unless block_given?

      ::URI.extract(text) do |uri|
        uri = begin
                ::URI.parse(uri)
              rescue URI::InvalidURIError
                # URI.extract can parse URIs that URI.parse cannot handle
                next
              end

        yield from(uri)
      end

      return nil
    end

    #
    # Searches for all URLs using HTTP.
    #
    # @return [Array<URL>]
    #   The matching URLs.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.http
      all('scheme.name' => 'http')
    end

    #
    # Searches for all URLs using HTTPS.
    #
    # @return [Array<URL>]
    #   The matching URLs.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.https
      all('scheme.name' => 'https')
    end

    #
    # Searches for URLs with specific host name(s).
    #
    # @param [Array<String>, String] names
    #   The host name(s) to search for.
    #
    # @return [Array<URL>]
    #   The matching URLs.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.hosts(names)
      all('host.address' => names)
    end

    #
    # Searches for URLs with the specific port number(s).
    #
    # @param [Array<Integer>, Integer] numbers
    #   The port numbers to search for.
    #
    # @return [Array<URL>]
    #   The matching URLs.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.ports(numbers)
      all('port.number' => numbers)
    end

    #
    # Searches for all URLs sharing a common sub-directory.
    #
    # @param [String] root_dir
    #   The sub-directory to search for.
    #
    # @return [Array<URL>]
    #   The URL with the common sub-directory.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.directory(root_dir)
      all(:path => root_dir) | all(:path.like => "#{root_dir}/%")
    end

    #
    # Searches for all URLs with a common file-extension.
    #
    # @param [String] ext
    #   The file extension to search for.
    #
    # @return [Array<URL>]
    #   The URLs with the common file-extension.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.extension(ext)
      all(:path => "%.#{ext}")
    end

    #
    # Searches for URLs with the given query param.
    #
    # @param [Array<String>, String] name
    #   The query param name to search for.
    #
    # @return [Array<URL>]
    #   The URLs with the given query param.
    #
    # @since 1.4.0
    #
    # @api public
    #
    def self.with_query_param(name)
      all('query_params.name.name' => name)
    end

    #
    # Search for all URLs with a given query param value.
    #
    # @param [Array<String>, String] value
    #   The query param value to search for.
    #
    # @return [Array<URL>]
    #   The URLs with the given query param value.
    #
    # @since 1.4.0
    #
    # @api public
    #
    def self.with_query_value(value)
      all('query_params.value' => value)
    end

    #
    # Searches for a URL.
    #
    # @param [URI::HTTP, String] url
    #   The URL to search for.
    #
    # @return [URL, nil]
    #   The matching URL.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.[](url)
      return super(url) if url.kind_of?(Integer)

      # optionally parse the URL
      url = ::URI.parse(url.to_s) unless url.kind_of?(::URI)

      # create the initial query
      query = all(
        'scheme.name'       => url.scheme,
        'host_name.address' => url.host,
        :path               => normalized_path(url),
        :fragment           => url.fragment
      )

      if url.port
        # query the port
        query = query.all('port.number' => url.port)
      end

      if url.query
        # add the query params to the query
        ::URI::QueryParams.parse(url.query).each do |name,value|
          query = query.all(
            'query_params.name.name' => name,
            'query_params.value'     => value 
          )
        end
      end

      return query.first
    end

    #
    # Creates a new URL.
    #
    # @param [URI::HTTP] uri
    #   The URI to create the URL from.
    #
    # @return [URL]
    #   The new URL.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.from(uri)
      # find or create the URL scheme, host_name and port
      scheme    = URLScheme.first_or_new(:name => uri.scheme)
      host_name = HostName.first_or_new(:address => uri.host)
      port      = if uri.port
                    TCPPort.first_or_new(:number => uri.port)
                  end

      path     = normalized_path(uri)
      fragment = uri.fragment

      query_params = []
      
      if uri.respond_to?(:query_params)
        # find or create the URL query params
        uri.query_params.each do |name,value|
          query_params << {
            :name  => URLQueryParamName.first_or_new(:name => name),
            :value => value
          }
        end
      end

      # find or create the URL
      return first_or_new(
        :scheme       => scheme,
        :host_name    => host_name,
        :port         => port,
        :path         => path,
        :fragment     => fragment,
        :query_params => query_params
      )
    end

    #
    # Parses the URL.
    #
    # @param [String] url
    #   The raw URL to parse.
    #
    # @return [URL]
    #   The parsed URL.
    #
    # @see URL.from
    #
    # @since 1.0.0
    #
    # @api public
    #
    def self.parse(url)
      from(::URI.parse(url))
    end

    #
    # The host name of the URL.
    #
    # @return [String]
    #   The address of host name.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def host
      self.host_name.address
    end

    #
    # The port number used by the URL.
    #
    # @return [Integer, nil]
    #   The port number.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def port_number
      self.port.number if self.port
    end

    #
    # Dumps the URL query params into a URI query string.
    #
    # @return [String]
    #   The URI query string.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def query_string
      params = {}

      self.query_params.each do |param|
        params[param.name] = param.value
      end

      return ::URI::QueryParams.dump(params)
    end

    #
    # Sets the query params of the URL.
    #
    # @param [String] query
    #   The query string to parse.
    #
    # @return [String]
    #   The given query string.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def query_string=(query)
      self.query_params.clear

      ::URI::QueryParams.parse(query).each do |name,value|
        self.query_params.new(
          :name  => URLQueryParamName.first_or_new(:name => name),
          :value => value
        )
      end

      return query
    end

    #
    # Builds a URI object from the URL.
    #
    # @return [URI::HTTP, URI::HTTPS]
    #   The URI object created from the URL attributes.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def to_uri
      # map the URL scheme to a URI class
      url_class = SCHEMES.fetch(self.scheme.name,::URI::Generic)

      host = if self.host_name
               self.host_name.address
             end
      port = if self.port
               self.port.number
             end

      query = unless self.query_params.empty?
                self.query_string
              end

      # build the URI
      return url_class.build(
        :scheme   => self.scheme.name,
        :host     => host,
        :port     => port,
        :path     => self.path,
        :query    => query,
        :fragment => self.fragment
      )
    end

    #
    # Converts the URL to a String.
    #
    # @return [String]
    #   The string form of the URL.
    #
    # @since 1.0.0
    #
    # @api public
    #
    def to_s
      self.to_uri.to_s
    end

    #
    # Inspects the URL.
    #
    # @return [String]
    #   The inspected URL.
    #
    # @since 1.4.0
    #
    # @api public
    #
    def inspect
      "#<#{self.class}: #{self}>"
    end

    protected

    #
    # Normalizes the path of a URI.
    #
    # @param [URI] uri
    #   The URI containing the path.
    #
    # @return [String, nil]
    #   The normalized path.
    #
    # @since 1.0.0
    #
    # @api private
    #
    def self.normalized_path(uri)
      case uri
      when ::URI::HTTP
        # map empty HTTP paths to '/'
        unless uri.path.empty? then uri.path
        else                        '/'
        end
      else
        uri.path
      end
    end

  end
end
