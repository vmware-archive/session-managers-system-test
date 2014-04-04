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

require_relative 'utils'
require 'rake'
require 'rake/tasklib'

class TomcatRakeTask < Rake::TaskLib
  include Rake::DSL if defined?(::Rake::DSL)
  include Utils

  attr_reader :name

  def initialize(options)
    @version = ENV['TOMCAT_VERSION'] || options[:default_version]
    @name = "vendor/apache-tomcat-#{@version}.tar.gz"

    desc 'Utils Tomcat binary' unless Rake.application.last_comment

    file @name do |t|
      download(url, t.name)
    end

  end

  private

  def url
    "http://archive.apache.org/dist/tomcat/tomcat-#{@version.chars.first}/v#{@version}/bin" \
    "/apache-tomcat-#{@version}.tar.gz"
  end

end
