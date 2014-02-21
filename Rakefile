# Copyright 2014 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

require 'rubocop/rake_task'
Rubocop::RakeTask.new

require 'rake/clean'
CLOBBER.include 'test-application/target', 'vendor'

file 'test-application/target/application.war' =>
         FileList['test-application/src/main/java/**/*.java', 'test-application/pom.xml'] do
  Dir.chdir('test-application') { system 'mvn package' }
end

tomcat_version = ENV['TOMCAT_VERSION'] || '8.0.3'

require 'fileutils'
require 'rest_client'
file "vendor/apache-tomcat-#{tomcat_version}.tar.gz" do |f|
  tomcat_url = "http://mirror.cc.columbia.edu/pub/software/apache/tomcat/tomcat-#{tomcat_version.chars[0]}" \
  "/v#{tomcat_version}/bin/apache-tomcat-#{tomcat_version}.tar.gz"

  cache_file = Pathname.new(f.name)
  FileUtils.makedirs cache_file.parent unless cache_file.parent.exist?

  puts "Downloading #{f.name} from #{tomcat_url}..."
  cache_file.write(RestClient.get(tomcat_url)) unless cache_file.exist?
end

task spec: ['test-application/target/application.war', "vendor/apache-tomcat-#{tomcat_version}.tar.gz"]
task warfile: 'test-application/target/application.war'
task default: [:rubocop, :spec]
