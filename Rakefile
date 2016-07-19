# Encoding: utf-8
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

$LOAD_PATH.unshift File.expand_path('..', __FILE__)

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

require 'rubocop/rake_task'
RuboCop::RakeTask.new

require 'rake/clean'
CLOBBER.include 'test-application/target', 'vendor'

require 'rakelib/redis_store_rake_task'
redis_store_rake_task = RedisStoreRakeTask.new

require 'rakelib/tomcat_rake_task'
tomcat_rake_task = TomcatRakeTask.new(default_version: '8.5.4')

file 'test-application/target/application.war' =>
         FileList['test-application/src/main/java/**/*.java', 'test-application/pom.xml'] do
  Dir.chdir('test-application') { system './mvnw package' }
end

task :versions do
  versions = { redis_store_version: redis_store_rake_task.name, tomcat_version: tomcat_rake_task.name }
  Pathname.new('vendor/versions.yml').write versions.to_yaml
end

task spec: ['test-application/target/application.war', redis_store_rake_task.name, tomcat_rake_task.name, :versions]
task warfile: 'test-application/target/application.war'
task default: [:rubocop, :spec]
