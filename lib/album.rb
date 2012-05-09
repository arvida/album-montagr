module LastFm
  class Album
    attr_reader :attributes

    def initialize album_attributes
      @attributes = album_attributes
    end

    def slug
      #basically remove all characters that is not word character (a-z , A-Z , 0-9) ??
      attributes['name'].gsub(/\W/, '')
    end

    def has_cover?
      cover_url
    end

    def cover_url
      cover = attributes['image'].detect do |image|
        image['size'] == 'extralarge' && image['content'] !~ /noimage/
      end

      cover && cover['content']
    end

    def resized_cover_path(size)
      cover = MiniMagick::Image.open cover_url
      cover.resize size
      tempfile_path = File.join(Dir.tmpdir, "#{slug}.jpg")
      cover.write tempfile_path

      tempfile_path
    end

    def self.find(options = {})
      raise "Username required" unless options[:username]

      LastFm.client.user.get_top_albums(options[:username], options[:period]).collect do |album|
        Album.new album
      end
    end
  end
end
