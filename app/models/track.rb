class Track < ActiveRecord::Base
  attr_accessor :raw_fingerprint, :artist_name
  attr_reader :fingerprint
  attr_accessible :track_file, :remote_track_file_url, :artist, :raw_fingerprint, :track_id,
                  :title, :release, :genre, :duration, :version, :artist_name
  mount_uploader :track_file, TrackUploader

  validates :track_file, :presence => true, :if => Proc.new { |t| t.raw_fingerprint.blank? }, :on => :create
  validates :raw_fingerprint, :presence => true, :if => Proc.new { |t| t.track_file.blank? }, :on => :create
  validates :artist, :presence => true, :if => Proc.new { |t| t.artist_name.blank? }, :on => :create
  validates :artist_name, :presence => true, :if => Proc.new { |t| t.artist.nil? }, :on => :create

  before_create :generate_fingerprint
  before_create :copy_fingerprint_info
  after_save :update_solr
  after_create :remove_track_file!
  after_create :delete_track_file_folder

  after_destroy :delete_solr

  belongs_to :artist, :counter_cache => true

  def generate_fingerprint
    if track_file.present?
      @fingerprint = Fingerprint.new track_file.file.file
    else
      @fingerprint = Fingerprint.new raw_fingerprint
    end
  end

  def copy_fingerprint_info
    self.artist_name = @fingerprint.artist
    if self.artist.nil?
      artist = Artist.find_or_create_by_name(self.artist_name)
      self.artist = artist
    end
    attributes=[:title, :release, :genre, :duration, :version].inject({}){|res, attr| val = @fingerprint.send(attr); res[attr] = val unless val.blank?; res;}
    attributes[:track_id] = Digest::MD5.hexdigest(Time.now.to_s(:db)+rand(100000).to_s)
    self.assign_attributes(attributes)
  end

  def update_solr
    if self.fingerprint.present?
      Solr.delete_track(self) if self.solr_documents.count > 0
      Solr.add_track(self)
    end
  end

  def delete_solr
    Solr.delete_track(self)
  end

  def solr_documents
    Solr.track_docs(self)
  end

  def delete_track_file_folder
    FileUtils.remove_dir("#{Rails.root}/public/uploads/#{self.class.to_s.underscore}/#{self.id}", :force => true)
  end
end
