# Encoding: utf-8
# Copyright 2014 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'rake'
require 'rake/tasklib'
require 'rakelib/utils'
require 'rest_client'

class RedisStoreRakeTask < Rake::TaskLib
  include Rake::DSL if defined?(::Rake::DSL)
  include Utils

  attr_reader :name

  def initialize
    @version, @uri = artifact_details
    @name          = "vendor/redis-store-#{@version}.jar"

    desc 'Utils Redis Store binary' unless Rake.application.last_comment

    file @name do |t|
      download(@uri, t.name)
    end

  end

  private

  def artifact_details
    uri = 'https://repo.spring.io/libs-snapshot-local/com/gopivotal/manager/' \
          'redis-store/1.3.0.BUILD-SNAPSHOT/redis-store-1.3.0.BUILD-SNAPSHOT.jar'
    [version(uri), uri]
  end

  def version(uri)
    header = RestClient.head(uri).headers[:x_artifactory_filename]
    /redis-store-(.+)\.jar/.match(header)[1]
  end

end
