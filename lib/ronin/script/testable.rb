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

require 'ronin/script/exceptions/test_failed'
require 'ronin/ui/printing'

module Ronin
  module Script
    #
    # Adds testing methods to an {Script}.
    #
    # @since 1.1.0
    #
    module Testable
      include UI::Printing

      #
      # Initializes the testable script.
      #
      # @param [Hash] attributes
      #   Additional attributes for the script.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      def initialize(attributes={})
        super(attributes)

        @test_blocks = []
      end

      #
      # Tests that the script is properly configured.
      #
      # @return [true]
      #   The script is built and ready for deployment.
      #
      # @see test
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      def test!
        print_info "Testing #{self.class.short_name} ..."

        @test_blocks.each { |block| block.call() }

        print_info "#{self.class.short_name} tested!"
        return true
      end

      protected

      #
      # Flunks the testing process.
      #
      # @param [String] message
      #   The message on why the testing failed.
      #
      # @raise [TestFailed]
      #   The testing failure message.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def flunk(message)
        raise(TestFailed,message)
      end

      #
      # Registers a given block to be called when the script is tested.
      #
      # @yield []
      #   The given block will be called when the script is being tested.
      #
      # @return [Script]
      #   The script.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def test(&block)
        @test_blocks << block
        return self
      end

      #
      # Tests whether an expression is true.
      #
      # @param [String] message
      #   The failure message if the expression was not true.
      #
      # @yield []
      #   The given block will contain the expression to evaluate.
      #
      # @return [true]
      #   The expression was true.
      #
      # @raise [TestFailed]
      #   The expression was not true.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def test?(message,&block)
        test { flunk(message) unless block.call() }
      end

      #
      # Tests whether a method has the expected value.
      #
      # @param [Symbol] name
      #   The method to call.
      #
      # @param [Object] expected_value
      #   The expected value.
      #
      # @param [String] message
      #   Optional failure message.
      #
      # @return [true]
      #   The method returned the expected value.
      #
      # @raise [TestFailed]
      #   The method did not return the expected value.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def test_equal(name,expected_value,message=nil)
        name = name.to_sym

        test do
          actual_value = self.send(name)
          message ||= "#{name} (#{actual_value.inspect}) must equal #{expected_value.inspect}"

          flunk(message) unless actual_value == expected_value
        end
      end

      #
      # Tests whether a method does not have the unexpected value.
      #
      # @param [Symbol] name
      #   The method to call.
      #
      # @param [Object] unexpected_value
      #   The unexpected value.
      #
      # @param [String] message
      #   Optional failure message.
      #
      # @return [true]
      #   The method did not return the unexpected value.
      #
      # @raise [TestFailed]
      #   The method did return the unexpected value.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def test_not_equal(name,unexpected_value,message=nil)
        name = name.to_sym

        test do
          actual_value = self.send(name)
          message ||= "#{name} (#{actual_value.inspect}) cannot equal #{unexpected_value.inspect}"

          flunk(message) unless actual_value != unexpected_value
        end
      end

      #
      # Tests whether a method returns a non-`nil` value.
      #
      # @param [Symbol] name
      #   The method to call.
      #
      # @param [String] message
      #   Optional failure message.
      #
      # @return [true]
      #   The method returned a non-`nil` value.
      #
      # @raise [TestFailed]
      #   The method returned `nil`.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def test_set(name,message=nil)
        name = name.to_sym

        test do
          actual_value = self.send(name)
          message ||= "#{name} is not set"

          blank = if actual_value.respond_to?(:empty?)
                    actual_value.empty?
                  else
                    actual_value.nil?
                  end

          flunk(message) if blank
        end
      end

      #
      # Tests whether a method matches the pattern.
      #
      # @param [Symbol] name
      #   The method to call.
      #
      # @param [Regexp, String] pattern
      #   The pattern to match against.
      #
      # @param [String] message
      #   Optional failure message.
      #
      # @return [true]
      #   The method matched the pattern.
      #
      # @raise [TestFailed]
      #   The method did not match the pattern.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def test_match(name,pattern,message=nil)
        name = name.to_sym

        test do
          actual_value = self.send(name)
          message ||= "#{name} (#{actual_value.inspect}) must match #{pattern.inspect}"

          flunk(message) unless actual_value.match(pattern)
        end
      end

      #
      # Tests whether a method does not matches the pattern.
      #
      # @param [Symbol] name
      #   The method to call.
      #
      # @param [Regexp, String] pattern
      #   The pattern to match against.
      #
      # @param [String] message
      #   Optional failure message.
      #
      # @return [true]
      #   The method matched the pattern.
      #
      # @raise [TestFailed]
      #   The method did not match the pattern.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def test_no_match(name,pattern,message=nil)
        name = name.to_sym

        test do
          actual_value = self.send(name)
          message ||= "#{name} (#{actual_value.inspect}) cannot match #{pattern.inspect}"

          flunk(message) unless !actual_value.match(pattern)
        end
      end

      #
      # Tests a method has a value in the expected values.
      #
      # @param [Symbol] name
      #   The method name.
      #
      # @param [#include?]  expected_values
      #   The expected values.
      #
      # @param [String] message
      #   Optional failure message.
      #
      # @return [true]
      #   The method returned one of the expected values.
      #
      # @raise [TestFailed]
      #   The method did not return one of the expected values.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def test_in(name,expected_values,message=nil)
        name = name.to_sym

        test do
          actual_value = self.send(name)
          message ||= "#{name} (#{actual_value.inspect}) must be one of #{expected_values.inspect}"

          flunk(message) unless expected_values.include?(actual_value)
        end
      end

      #
      # Tests a method does not have a value in the unexpected values.
      #
      # @param [Symbol] name
      #   The method name.
      #
      # @param [#include?]  unexpected_values
      #   The unexpected values.
      #
      # @param [String] message
      #   Optional failure message.
      #
      # @return [true]
      #   The method did not return one of the unexpected values.
      #
      # @raise [TestFailed]
      #   The method did return one of the unexpected values.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def test_not_in(name,unexpected_values,message=nil)
        name = name.to_sym

        test do
          actual_value = self.send(name)
          message ||= "#{name} (#{actual_value.inspect}) cannot be one of #{unexpected_values.inspect}"

          flunk(message) unless !unexpected_values.include?(actual_value)
        end
      end
    end
  end
end
