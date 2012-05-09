module LastFm
  class User
    attr_reader :username

    def initialize lastfm_username
      @username = lastfm_username
    end

    def create_artwork format, artwork_path
      format_spec = if format.is_a?(Symbol)
        LastFm.artwork_formats.fetch(format) { raise 'Format not found' }
      else
        format
      end

      number_of_images = format_spec[:rows]*format_spec[:cols]
      cover_paths = recent_albums(number_of_images).collect do |a|
        a.resized_cover_path "#{format_spec[:size]}x#{format_spec[:size]}"
      end

      `montage -tile #{format_spec[:cols]}x#{format_spec[:rows]} -geometry +0+0 -quality 96 #{cover_paths.join(' ')} #{artwork_path}`
    end

    def recent_albums number_of_albums
      periods = %w(12month 6month 3month 1month 7day)
      albums = []

      while albums.size < number_of_albums
        Album.find(:username => username, :period => periods.pop).each do |album|
          albums << album if album.has_cover? && !albums.include?(album)
        end
      end

      albums.take number_of_albums
    end

    def self.find_by_username(_username)
      LastFm::User.new _username
    end

  end
end
