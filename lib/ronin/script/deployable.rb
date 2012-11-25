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

require 'ronin/script/exceptions/deploy_failed'
require 'ronin/script/testable'
require 'ronin/ui/printing'

module Ronin
  module Script
    #
    # Adds deployment methods to an {Script}.
    #
    # @since 1.1.0
    #
    module Deployable
      include Testable, UI::Printing

      #
      # Initializes the deployable script.
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

        @deploy_blocks = []
        @deployed = false

        @evacuate_blocks = []
        @evacuated = false
      end

      #
      # Determines whether the script was deployed.
      #
      # @return [Boolean]
      #   Specifies whether the script was previously deployed.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      def deployed?
        @deployed == true
      end

      #
      # Tests and then deploys the script.
      #
      # @yield []
      #   If a block is given, it will be passed the deployed script
      #   after a successful deploy.
      #
      # @return [Script]
      #   The deployed script.
      #
      # @see deploy
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      def deploy!
        test!

        print_info "Deploying #{self.class.short_name} #{self} ..."

        @deployed = false
        @deploy_blocks.each { |block| block.call() }
        @deployed = true
        @evacuated = false

        print_info "#{self.class.short_name} #{self} deployed!"

        yield if block_given?
        return self
      end

      #
      # Determines whether the script was evacuated.
      #
      # @return [Boolean]
      #   Specifies whether the script has been evacuated.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      def evacuated?
        @evacuated == true
      end

      #
      # Evacuates the deployed script.
      #
      # @yield []
      #   If a block is given, it will be called before the script is
      #   evacuated.
      #
      # @return [Script]
      #   The evacuated script.
      #
      # @see #evacuate
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      def evacuate!
        yield if block_given?

        print_info "Evauating #{self.class.short_name} #{self} ..."

        @evacuated = false
        @evacuate_blocks.each { |block| block.call() }
        @evacuated = true
        @deployed = false

        print_info "#{self.class.short_name} #{self} evacuated."
        return self
      end

      protected

      #
      # Indicates the deployment of the script has failed.
      #
      # @raise [DeployFailed]
      #   The deployment of the script failed.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def deploy_failed!(message)
        raise(DeployFailed,message)
      end

      #
      # Registers a given block to be called when the script is being
      # deployed.
      #
      # @yield []
      #   The given block will be called when the script is being
      #   deployed.
      #
      # @return [Script]
      #   The script.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def deploy(&block)
        @deploy_blocks << block
        return self
      end

      #
      # Registers a given block to be called when the script is being
      # evacuated.
      #
      # @yield []
      #   The given block will be called when the script is being
      #   evacuated.
      #
      # @return [Script]
      #   The script.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def evacuate(&block)
        @evacuate_blocks.unshift(block)
        return self
      end
    end
  end
end
