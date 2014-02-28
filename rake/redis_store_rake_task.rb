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
