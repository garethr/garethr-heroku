source "http://rubygems.org"

if ENV.key?('PUPPET_VERSION')
  puppetversion = "= #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['~> 2.7']
end

gem "rake"
gem "puppet", puppetversion
gem "puppet-lint"
gem "rspec-puppet", :git => 'https://github.com/rodjek/rspec-puppet.git'
gem "puppetlabs_spec_helper"
