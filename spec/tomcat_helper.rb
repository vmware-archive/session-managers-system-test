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

require 'format_duration'
require 'pathname'
require 'rest_client'
require 'tmpdir'

shared_context 'tomcat_helper' do

  let(:http_port) { 8081 }

  let(:location) { Pathname.new(Dir.mktmpdir) }

  let(:shutdown_port) { 8082 }

  let(:cache_file) { Pathname.new("vendor/apache-tomcat-#{ENV['TOMCAT_VERSION'] || '7.0.52'}.tar.gz") }

  let(:log_content) { (location + 'logs/catalina.out').read }

  before do |example|
    with_timing("Starting Tomcat on #{http_port}...") do
      untar_tomcat location
      copy_test_files example.metadata[:fixture], location
      start_tomcat location, shutdown_port, http_port, example.metadata[:ignore_startup_failure]
    end
  end

  after do
    with_timing('Stopping Tomcat...') do
      stop_tomcat location, shutdown_port
      location.rmtree
    end
  end

  def copy_test_files(context_xml, dir)
    FileUtils.copy 'spec/fixtures/server.xml', "#{dir}/conf/server.xml"
    FileUtils.copy "spec/fixtures/#{context_xml}.xml", "#{dir}/conf/context.xml"
    FileUtils.copy 'vendor/redis-store.jar', "#{dir}/lib/redis-store.jar"
    FileUtils.makedirs "#{dir}/webapps" unless Dir.exist? "#{dir}/webapps"
    FileUtils.copy 'test-application/target/application.war', "#{dir}/webapps/ROOT.war"
  end

  def start_tomcat(dir, shutdown_port, http_port, suppress_fail)
    File.open("#{dir}/bin/setenv.sh", 'w') do |f|
      f.write("CATALINA_PID=$CATALINA_BASE/logs/tomcat.pid\n")
      f.write("JAVA_OPTS=\"-Dshutdown.port=#{shutdown_port} -Dhttp.port=#{http_port}\"")
    end
    `#{dir}/bin/catalina.sh start`
    wait_for_start(http_port, dir, suppress_fail)
  end

  def stop_tomcat(dir, shutdown_port)
    `JAVA_OPTS=\"-Dshutdown.port=#{shutdown_port}\" #{dir}/bin/catalina.sh stop`
  end

  def untar_tomcat(dir)
    `tar zxf #{cache_file} --strip 1 --exclude \'webapps\' -C #{dir}`
  end

  def wait_for_start(http_port, dir, suppress_fail)
    Process.getpgid(File.open("#{dir}/logs/tomcat.pid").read.to_i)

    response = nil
    until response && response.body == 'ok'
      sleep 0.5
      response = RestClient.get "http://localhost:#{http_port}"
    end
  rescue Errno::ECONNREFUSED
    retry
  rescue Errno::ESRCH => e
    fail StandardError, "Tomcat process was not running: #{e.message}\nLog Content:\n#{log_content}" unless suppress_fail
  rescue StandardError => e
    fail StandardError, "Unable to connect to Tomcat: #{e.message}\nLog Content:\n#{log_content}" unless suppress_fail
  end

  def with_timing(caption)
    start_time = Time.now
    print "#{caption} "

    yield

    puts "(#{(Time.now - start_time).duration})"
  end

end
