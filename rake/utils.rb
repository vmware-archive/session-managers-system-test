require 'fileutils'
require 'pathname'
require 'rest_client'
require 'yaml'

module Utils

  def download(url, destination)
    cache_file = Pathname.new(destination)
    FileUtils.makedirs cache_file.parent unless cache_file.parent.exist?

    puts "Downloading #{destination} from #{url}..."

    cache_file.write(RestClient.get(url)) unless cache_file.exist?
  end

end
