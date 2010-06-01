#Author: Khaja Minhajuddin ( minhajuddin@cosmicvent.com )
#Source: http://github.com/minhajuddin/the-maker
require 'stringio'

module TheMaker
  class Creator

    def create(file, master)
      @io = StringIO.new
      File.open(master,'r') do |f|
        while line = f.gets
          if line.strip == '==content=='
            write_content(file) 
          else
            write line
          end
        end
      end

      filename = "_site/#{file.split('/')[1]}"
      File.open(filename,'w') do |f|
        f.puts @io.string
      end

    end

    def write_content(file)

      File.open(file,'r') do |f|
        while line = f.gets
          write line
        end
      end

    end

    def write(line)
      @io.puts line
    end

  end

  class Runner
    def run
      master = Dir.glob('layout.master')[0]
      content_files = Dir.glob('content/*.html')
      setup
      content_files.each do |file|
        creator.create(file,master)
      end
    end

    def creator
      @creator ||= Creator.new
    end

    def setup
      Dir.mkdir('_site') if Dir.glob('_site').empty?
    end
  end
end

TheMaker::Runner.new.run
