require_relative 'lib/last_fm'

LastFm.api_key = ''
LastFm.api_secret = ''

u = LastFm::User.find_by_username ''
u.create_artwork :ipad, '~/Desktop/artwork.jpg'
