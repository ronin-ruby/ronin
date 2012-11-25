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

require 'ronin/ui/cli/resources_command'
require 'ronin/campaign'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # Manages {Campaign Campaigns}.
        #
        # ## Usage
        # 
        #     ronin campaigns [options]
        #
        # ## Options
        # 
        #      -v, --[no-]verbose               Enable verbose output.
        #      -q, --[no-]quiet                 Disable verbose output.
        #          --[no-]silent                Silence all output.
        #      -D, --database [URI]             The Database URI.
        #          --[no-]csv                   CSV output.
        #          --[no-]xml                   XML output.
        #          --[no-]yaml                  YAML output.
        #          --[no-]json                  JSON output.
        #      -n, --named [NAMED]              Name to search for.
        #      -d, --describing [DESCRIBING]    Description to search for.
        #      -T, --targeting [ADDR [...]]     Addresses to search for.
        #      -O [NAME [...]],                 Orgs to search for.
        #          --targeting-orgs
        #      -l, --[no-]list                  List all Campaigns.
        #                                       Default: true
        #      -a, --add [NAME]                 Create a new Campaign.
        #          --targets [ADDR [...]]       Addresses to target.
        #
        class Campaigns < ResourcesCommand

          model Campaign

          summary 'Managed Campaigns'

          query_option :named, :type        => String,
                               :flag        => '-n',
                               :description => 'Name to search for'

          query_option :describing, :type        => String,
                                    :flag        => '-d',
                                    :description => 'Description to search for'

          query_option :targeting, :type        => Array,
                                   :flag        => '-T',
                                   :usage       => 'ADDR [...]',
                                   :description => 'Addresses to search for'

          query_option :targeting_orgs, :type        => Array,
                                        :flag        => '-O',
                                        :usage       => 'NAME [...]',
                                        :description => 'Orgs to search for'

          option :list, :type        => true,
                        :default     => true,
                        :flag        => '-l',
                        :description => 'List all Campaigns'

          option :add, :type        => String,
                       :flag        => '-a',
                       :usage       => 'NAME',
                       :description => 'Create a new Campaign'

          option :targets, :type        => Array,
                           :usage       => 'ADDR [...]',
                           :description => 'Addresses to target'

          #
          # Queries the {Campaign} model.
          #
          # @since 1.0.0
          #
          def execute
            if    add?  then add(@add)
            elsif list? then super
            end
          end

          protected

          #
          # Adds a new campaign.
          #
          # @param [String] name
          #   The name of the new campaign.
          #
          # @since 1.0.0
          #
          def add(name)
            campaign = Campaign.new(:name => name)

            if targets?
              # add targets to the campaign
              @targets.each { |target| campaign.target!(target) }
            end

            if campaign.save
              print_info "Added campaign #{campaign}"
            else
              print_error "Could not add campaign #{name.dump}."
            end
          end

          #
          # Prints a campaign.
          #
          # @param [Campaign] campaign
          #   The campaign to print.
          #
          # @since 1.0.0
          #
          def print_resource(campaign)
            return super(campaign) unless verbose?

            print_title campaign.name

            indent do
              if campaign.description
                print_section 'Description' do
                  campaign.description.each_line do |line|
                    puts line
                  end
                end
              end

              unless campaign.organizations.empty?
                print_array campaign.organizations, :title => 'Targeted Organizations'
              end

              unless campaign.targets.empty?
                print_array campaign.targets, :title => 'Targets'
              end
            end
          end

        end
      end
    end
  end
end
