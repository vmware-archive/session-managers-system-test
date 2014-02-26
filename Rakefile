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

require 'fileutils'
require 'rest_client'

def download(destination, url)
  cache_file = Pathname.new(destination)
  FileUtils.makedirs cache_file.parent unless cache_file.parent.exist?
  puts "Downloading #{destination} from #{url}..."
  cache_file.write(RestClient.get(url)) unless cache_file.exist?
end

def tomcat_url
  "http://mirror.cc.columbia.edu/pub/software/apache/tomcat/tomcat-#{tomcat_version.chars[0]}" \
  "/v#{tomcat_version}/bin/apache-tomcat-#{tomcat_version}.tar.gz"
end

def tomcat_version
  ENV['TOMCAT_VERSION'] || '7.0.52'
end

def redis_store_url
  "http://maven.gopivotal.com.s3.amazonaws.com/snapshot/com/gopivotal/manager/redis-store/1.0.0.BUILD-SNAPSHOT/redis-store-1.0.0.BUILD-#{redis_store_version}.jar"
end

def redis_store_version
  '20140224.151228-10'
end

file "vendor/apache-tomcat-#{tomcat_version}.tar.gz" do |t|
  download(t.name, tomcat_url)
end

file "vendor/redis-store.jar" do |t|
  download(t.name, redis_store_url)
end

task spec: ['test-application/target/application.war', "vendor/apache-tomcat-#{tomcat_version}.tar.gz",
            'vendor/redis-store.jar']
task warfile: 'test-application/target/application.war'
task default: [:rubocop, :spec]
