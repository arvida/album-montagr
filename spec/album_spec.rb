require 'minitest/autorun'
require_relative '../lib/album'

describe 'Album' do

  subject { LastFm::Album.new 'name' => 'Bistra Tider' }

  it 'accepts attributes on initialize' do
    subject.attributes['name'].must_equal 'Bistra Tider'
  end

  it 'generates a slug based on name attribute'

  describe '#cover_url' do
    it 'finds the image url for extralarge image size' do
      subject.attributes['image'] = [
        { 'size' => 'small', 'content' => 'small_image_url' },
        { 'size' => 'extralarge', 'content' => 'extralarge_image_url' }
      ]

      subject.cover_url.must_equal 'extralarge_image_url'
    end

    it 'skips urls with placeholder image'
  end

  describe '#cover_url' do

    it 'returns true if cover exists' do
      subject.stub :cover_url, 'http://...' do
        subject.has_cover?.must_equal true
      end
    end

    it 'returns false if no cover exists' do
      subject.stub :cover_url, nil do
        subject.has_cover?.must_equal false
      end
    end

  end

  it 'resizes cover image' do
    cover_image_mock = MiniTest::Mock.new
    cover_image_mock.expect :resize, true, ['80x80']
    cover_image_mock.expect :write, true, [String]

    subject.stub :cover_image, -> { cover_image_mock } do # weird issue, had to put the mock in a proc for this to work
      subject.resized_cover_path '80x80'
      cover_image_mock.verify
    end
  end

  describe 'Album#find' do

    it 'requires a username'
    it 'returns albums matching query'

  end
end
