require 'digest/md5'
require 'find'
FILE_ATTR = { '\.tar\.gz' => 'tar xzf', '\.tar\.bz2' => 'tar xjf', '\.tar' => 'tar xf', '\.zip' => 'unzip -o' }
EXCLUDE_FILES = %r/__MAC/i
class FileCollection
  attr_reader :collections, :dir

  def initialize(file, extension = '.zip')
    @collections = {}
    @extension = extension
    if file.kind_of?(Array)
      file.each { |f| @collections[f] = extension }
    elsif file.kind_of?(Hash)
      @collections = file
    elsif file.kind_of?(String)
      @collections[file] = extension
    end
    raise if @collections.empty?
    time = Time.now.to_s+"#{Process.pid}#{self.object_id}"
    @dir = "#{RAILS_ROOT || ".." }/tmp/#{Digest::MD5.hexdigest(time)}" 
  end

  def process
    m = 
    Dir.mkdir(@dir)
    Dir.chdir(@dir) do
      @collections.each do |c,extension|
        tmpdir = Digest::MD5.hexdigest(Time.now.to_s)[0..5]
        Dir.mkdir(tmpdir)
        Dir.chdir(tmpdir) do
          FILE_ATTR.each do |pattern,cmd|
            if c =~ /#{pattern}/ or extension =~ /#{pattern}/i
              IO.popen("#{cmd} #{c}") { |io| }
            end
          end
        end
      end
    end
    self
  end

  def delete
    system "rm -rf #{@dir}"
  end

  def find(pattern)
    results = [ ]
    Find.find(@dir) do |file|
      next if File.directory?(file) or file =~ EXCLUDE_FILES
      results.push(file) if file =~ pattern
    end
    results
  end
end