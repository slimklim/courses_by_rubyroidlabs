require 'zlib'

class FilesSelector

  attr_reader :selected

  def initialize(filenames, options)
    filenames.uniq!
    @selected = {}
    options[:rekurs] ?
      rekurs(filenames) : filenames.each { |fn| @selected[fn] = File.open(fn)}
  end

  private

    # add to @selected all files from folder for each file of filenames
    def rekurs(filenames)
      filenames.each do |fn|
        files_collections = Dir[File.dirname(fn) + "/*"]
        files_collections.each { |fn| @selected[fn] = File.open(fn) }
      end
    end

end