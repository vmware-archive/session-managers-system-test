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

require 'aws-sdk'
require_relative 'utils'
require 'rake'
require 'rake/tasklib'

class RedisStoreRakeTask < Rake::TaskLib
  include Rake::DSL if defined?(::Rake::DSL)
  include Utils

  attr_reader :name

  def initialize
    @version, @uri = artifact_details
    @name = "vendor/redis-store-#{@version}.jar"

    desc 'Utils Redis Store binary' unless Rake.application.last_comment

    file @name do |t|
      download(@uri, t.name)
    end

  end

  private

  def artifact_details
    s3     = AWS::S3.new(region: 'eu-west-1')
    bucket = s3.buckets['maven.gopivotal.com']

    artifact = bucket.as_tree(prefix: 'snapshot/com/gopivotal/manager/redis-store/').children
    .select(&:branch?).sort { |a, b| a.key <=> b.key }.last.children
    .select { |node| node.key =~ /[\d]\.jar$/ }.sort { |a, b| a.key <=> b.key }.last

    uri = artifact.object.public_url(secure: false).to_s
    [version(uri), uri]
  end

  def version(uri)
    /.*\/redis-store-(.+)\.jar/.match(uri)[1]
  end

end
