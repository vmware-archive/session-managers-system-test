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
    "http://mirror.cc.columbia.edu/pub/software/apache/tomcat/tomcat-#{@version.chars[0]}/v#{@version}/bin" \
    "/apache-tomcat-#{@version}.tar.gz"
  end

end
