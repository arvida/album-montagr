require 'tmpdir'

module LastFm
  class Album
    attr_reader :attributes

    def initialize album_attributes = {}
      @attributes = album_attributes
    end

    # Converts spaces to -, removes all chars not mathing a-z0-9 and downcases the album name
    def slug
      attributes['name'].gsub(/\s/, '-').gsub(/[^\w\-]/, '').downcase
    end

    def has_cover?
      !cover_url.nil?
    end

    def cover_url
      cover = attributes['image'].detect do |image|
        image['size'] == 'extralarge' && image['content'] !~ /noimage/
      end

      cover && cover['content']
    end

    def resized_cover_path(size)
      cover_image.resize(size)
      cover_image.write tempfile_path

      tempfile_path
    end

    def self.find(options = {})
      raise "Username required" unless options[:username]

      LastFm.client.user.get_top_albums(options[:username], options[:period]).collect do |album|
        Album.new album
      end
    end

    private

    def cover_image
      MiniMagick::Image.open(cover_url)
    end

    def tempfile_path
      File.join(Dir.tmpdir, "#{slug}.jpg")
    end

  end
end
