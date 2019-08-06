#!/usr/bin/env ruby

require 'aws-sdk-core'
require 'aws-sigv4'
require 'conjur-api'

# name of Conjur var to retrieve
VAR_ID="#{ARGV.first}"

# setup Conjur configuration object
Conjur.configuration.account = "#{ENV['CONJUR_ACCOUNT']}"
Conjur.configuration.appliance_url = "#{ENV['CONJUR_APPLIANCE_URL']}"
Conjur.configuration.authn_url = "#{Conjur.configuration.appliance_url}/authn-iam/#{ENV['AUTHN_IAM_SERVICE_ID']}"
Conjur.configuration.cert_file = "#{ENV['CONJUR_CERT_FILE']}"
Conjur.configuration.apply_cert_config!

# Make a signed request to STS to get an authorization header
begin
    header = Aws::Sigv4::Signer.new(
      service: 'sts',
      region: 'us-east-1',
      credentials_provider: Aws::InstanceProfileCredentials.new
    ).sign_request(
      http_method: 'GET',
     url: 'https://sts.amazonaws.com/?Action=GetCallerIdentity&Version=2011-06-15'
    ).headers
rescue
    puts "Could not get AWS credential"
end

# Authenticate Conjur host identity using signed header in json format
conjur = Conjur::API.new_from_key("#{ENV['CONJUR_AUTHN_LOGIN']}", header.to_json)
# Get access token
conjur.token

# Use the cached token to get the secrets
variable_value = conjur.resource("#{ENV['CONJUR_ACCOUNT']}:variable:#{VAR_ID}").value
puts "#{variable_value}"

