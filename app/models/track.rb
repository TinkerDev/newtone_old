# encoding: utf-8
class Track < ActiveRecord::Base
  include Tire::Model::Search

  attr_accessor :raw_fingerprint, :artist_name
  attr_reader :fingerprint
  attr_accessible :track_file, :remote_track_file_url, :artist, :artist_id, :raw_fingerprint,
                  :title, :release, :genre, :duration, :version, :artist_name
  mount_uploader :track_file, TrackUploader

  tire.mapping do
    indexes :id, :index => :not_analyzed
    indexes :terms, :type => :string, :index_name=>'term', :as => ->(track) {track.fingerprint.terms}# , :include_in_all => false, :analyzer => 'keyword'
  end

  validates :fingerprint, :presence => true, :on => :create
  validates :artist_id, :title, :presence => true
  validates :artist_id, :uniqueness => {:scope => :title}

  before_validation :generate_fingerprint
  before_validation :copy_fingerprint_info
  after_save :update_elastic
  after_create :remove_track_file!
  after_create :delete_track_file_folder

  after_destroy :update_index

  belongs_to :artist, :counter_cache => true

  def generate_fingerprint
    @fingerprint = Fingerprint.new track_file.file.file if track_file.present?
    @fingerprint = Fingerprint.new raw_fingerprint if raw_fingerprint.present?
  end

  def copy_fingerprint_info
    if @fingerprint.present?
      self.artist_name = @fingerprint.artist if self.artist_name.blank?
      if self.artist.nil?
        self.artist = Artist.find_or_create_by_name(self.artist_name)
      end

      attributes=[:release, :genre, :duration, :version].inject({}){|res, attr| val = @fingerprint.send(attr); res[attr] = val unless val.blank?; res;}
      attributes[:title] = @fingerprint.title unless self.title.present?
      self.assign_attributes(attributes)
    end
  end

  def update_elastic
    update_index if @fingerprint.present?
  end

  def delete_track_file_folder
    FileUtils.remove_dir("#{Rails.root}/public/uploads/#{self.class.to_s.underscore}/#{self.id}", :force => true)
  end

  def self.seed
    songs = ['Без шансов', 'Гора', 'Деньги', 'Если бы', 'Кофевино', 'Похоронила', 'Река', 'Чайка', 'Жить В Твоей Голове', 'Кувырок']
    songs.map do |song|
      my_file = "/Users/unloved/Downloads/Земфира - #{song}.mp3"
      t=Track.new(:title=>song)
      t.track_file.store!(File.open(my_file))
      t.save
    end
  end
end
