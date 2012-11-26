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

require 'ronin/ui/printing'

module Ronin
  module UI
    module CLI
      #
      # CLI Printing helper methods.
      #
      # @since 1.4.0
      #
      module Printing
        include UI::Printing

        #
        # Initializes Printing settings.
        #
        def initialize
          @indent = 0
        end

        #
        # Increases the indentation out output temporarily.
        #
        # @param [Integer] n
        #   The number of spaces to increase the indentation by.
        #
        # @yield []
        #   The block will be called after the indentation has been
        #   increased. After the block has returned, the indentation will
        #   be returned to normal.
        #
        # @return [nil]
        #
        # @api semipublic
        #
        def indent(n=2)
          @indent += n

          yield

          @indent -= n
          return nil
        end

        #
        # Prints an empty line.
        #
        # @api semipublic
        #
        # @since 1.6.0
        #
        def spacer
          puts
        end

        #
        # Print the given messages with indentation.
        #
        # @param [Array] messages
        #   The messages to print, one per-line.
        #
        # @api semipublic
        #
        def puts(*messages)
          super(*(messages.map { |mesg| (' ' * @indent) + mesg.to_s }))
        end

        #
        # Prints a given title.
        #
        # @param [String] title
        #   The title to print.
        #
        # @api semipublic
        #
        def print_title(title)
          puts "[ #{title} ]"
          spacer
        end

        #
        # Prints a section with a title.
        #
        # @yield []
        #   The block will be called after the title has been printed
        #   and indentation increased.
        #
        # @since 1.0.0
        #
        # @api semipublic
        #
        def print_section(title,&block)
          print_title(title)
          indent(&block)
          spacer
        end

        #
        # Prints a given Array.
        #
        # @param [Array] array 
        #   The Array to print.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [String] :title
        #   The optional title to print before the contents of the Array.
        #
        # @return [nil]
        #
        # @api semipublic
        #
        def print_array(array,options={})
          print_title(options[:title]) if options[:title]

          indent do
            array.each { |value| puts value }
          end

          spacer if options[:title]
          return nil
        end

        #
        # Prints a given Hash.
        #
        # @param [Hash] hash
        #   The Hash to print.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [String] :title
        #   The optional title to print before the contents of the Hash.
        #
        # @return [nil]
        #
        # @api semipublic
        #
        def print_hash(hash,options={})
          align = hash.keys.map { |name|
            name.to_s.length
          }.max

          print_title(options[:title]) if options[:title]

          indent do
            hash.each do |name,value|
              name = "#{name}:".ljust(align)
              puts "#{name}\t#{value}"
            end
          end

          spacer if options[:title]
          return nil
        end
      end
    end
  end
end
