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

require 'ronin/config'
require 'ronin/ui/console/commands'

require 'set'

complete(on: Ronin::UI::Console::Commands::PATTERN) do |cmd|
  name     = cmd[1..-1]
  commands = Set[]
  
  Ronin::UI::Console::Commands.singleton_methods.each do |method|
    commands << ".#{method}" if method.start_with?(name)
  end

  commands
end

#
# {URL} completion in the context of URLs.
#
# 
#     http://www.example.com/in[TAB][TAB] => http://www.example.com/index.html
#
complete(anywhere: /[a-z]+:\/\/([^:\/\?]+(:\d+)?(\/[^\?;]*(\?[^\?;]*)?)?)?/) do |url|
  match = url.match(/([a-z]+):\/\/([^:\/\?]+)(:\d+)?(\/[^\?;]*)?(\?[^\?;]*)?/)

  query = Ronin::URL.all('scheme.name' => match[1])

  if match[2]
    query = unless (match[4] || match[3])
              query.all('host_name.address.like' => "#{match[2]}%")
            else
              query.all('host_name.address' => match[2])
            end
  end

  if match[3]
    query = query.all('port.number' => match[3])
  end

  if match[4]
    query = unless match[5]
              query.all(:path.like => "#{match[4]}%")
            else
              query.all(:path => match[4])
            end
  end

  if match[5]
    params = URI::QueryParams.parse(match[5][1..-1]).to_a

    params[0..-2].each do |name,value|
      query = query.all(
        'query_params.name.name' => name,
        'query_params.value'     => value
      )
    end

    if (param = params.last)
      query = if param[1].empty?
                query.all('query_params.name.name.like' => "#{param[0]}%")
              else
                query.all(
                  'query_params.name.name'  => param[0],
                  'query_params.value.like' => "#{param[1]}%"
                )
              end
    end
  end

  query
end

#
# {IPAddress} completion:
#
#     192.168.[TAB][TAB] => 192.168.0.1
#
complete(anywhere: /(\d{1,3}\.){1,3}\d{0,2}/) do |addr|
  Ronin::Address.all(:address.like => "#{addr}%")
end

#
# {HostName} completion:
#
#     www.[TAB][TAB] => www.example.com
#
complete(anywhere: /[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]*/) do |host|
  Ronin::HostName.all(:address.like => "#{host}%")
end

#
# {EmailAddress} completeion:
#
#     alice@[TAB][TAB] => alice@example.com
#
complete(anywhere: /[a-zA-Z0-9\._-]+@[a-zA-Z0-9\._-]*/) do |email|
  user, host = email.split('@',2)

  Ronin::EmailAddress.all(
    'user_name.name'         => user,
    'host_name.address.like' => "#{host}%"
  )
end

#
# Path completion.
#
#     /etc/pa[TAB][TAB] => /etc/passwd
#
complete(anywhere: /\/([^\/]+\/)*[^\/]*/) do |path|
  Dir["#{path}*"]
end
