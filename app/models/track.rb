# encoding: utf-8
class Track < ActiveRecord::Base
  include Tire::Model::Search

  attr_reader :fingerprint
  attr_accessible :track_file, :remote_track_file_url, :artist, :artist_id,
                  :title, :release, :genre, :duration, :version
  mount_uploader :track_file, TrackUploader

  tire.mapping do
    indexes :id, :index => :not_analyzed
    indexes :terms, :type => :string, :index_name=>'term', :as => ->(track) {f=Fingerprint.new self.track_file.path; f.term_string}# , :include_in_all => false, :analyzer => 'keyword'
  end

  validates :fingerprint, :presence => true, :on => :create
  validates :artist_id, :title, :presence => true
  validates :artist_id, :uniqueness => {:scope => :title}

  before_validation :generate_fingerprint
  after_save :update_elastic
  after_create :remove_track_file!
  after_create :delete_track_file_folder

  after_destroy :update_index

  belongs_to :artist, :counter_cache => true

  def generate_fingerprint
    @fingerprint = Fingerprint.new track_file.file.file if track_file.present?
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
      a=Artist.find_or_create_by_name('Земфира')
      t=Track.new(:title=>song, :artist=>a)
      t.track_file.store!(File.open(my_file))
      t.save
    end
  end
end
