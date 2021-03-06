#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Copyright:: Copyright (c) 2011 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require File.expand_path('../../../knife-eucalyptus/highline_patch', __FILE__)
require 'chef/knife'

class Chef
  class Knife
    module EucaBase

      # :nodoc:
      # Would prefer to do this in a rational way, but can't be done b/c of
      # Mixlib::CLI's design :(
      def self.included(includer)
        includer.class_eval do

          deps do
            require 'fog'
            require 'readline'
            require 'chef/json_compat'
          end

          option :euca_access_key_id,
            :short => "-A ID",
            :long => "--euca-access-key-id KEY",
            :description => "Your Eucalyptus Access Key ID",
            :proc => Proc.new { |key| Chef::Config[:knife][:euca_access_key_id] = key }

          option :euca_secret_access_key,
            :short => "-K SECRET",
            :long => "--euca-secret-access-key SECRET",
            :description => "Your Eucalyptus API Secret Access Key",
            :proc => Proc.new { |key| Chef::Config[:knife][:euca_secret_access_key] = key }

          option :euca_api_endpoint,
            :long => "--euca-api-endpoint ENDPOINT",
            :description => "Your Eucalyptus API endpoint",
            :default => "http://ecc.eucalyptus.com:8773/services/Eucalyptus",
            :proc => Proc.new { |endpoint| Chef::Config[:knife][:euca_api_endpoint] = endpoint }

          option :region,
            :long => "--region REGION",
            :description => "Your Eucalyptus region",
            :proc => Proc.new { |region| Chef::Config[:knife][:region] = region }
        end
      end

      def connection
        @connection ||= begin
          Fog::Compute.new(
            :provider => 'AWS',
            :aws_access_key_id => Chef::Config[:knife][:euca_access_key_id],
            :aws_secret_access_key => Chef::Config[:knife][:euca_secret_access_key],
            :endpoint => Chef::Config[:knife][:euca_api_endpoint] || config[:euca_api_endpoint],
            :region => Chef::Config[:knife][:region] || config[:region]
          )
        end
      end

      def public_ip(public_dns)
        @public_ip ||= begin
          require 'resolv'
          Resolv.getaddress(public_dns)
        rescue
        end
      end

      def locate_config_value(key)
        key = key.to_sym
        Chef::Config[:knife][key] || config[key]
      end
    end
  end
end


