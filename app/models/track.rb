class Track < ActiveRecord::Base
  attr_accessor :raw_fingerprint
  attr_reader :fingerprint
  attr_accessible :track_file, :raw_fingerprint, :track_id, :title, :release, :genre, :duration, :version
  mount_uploader :track_file, TrackUploader

  validates :track_file, :presence => true, :if => Proc.new { |t| t.raw_fingerprint.blank? }, :on => :create
  validates :raw_fingerprint, :presence => true, :if => Proc.new { |t| t.track_file.blank? }, :on => :create
  before_save :get_fingerprint_info
  after_save :update_solr
  after_save :remove_track_file!
  after_destroy :delete_solr
  belongs_to :artist, :counter_cache => true


  def get_fingerprint_info
    return unless track_file.present? or raw_fingerprint.present?
    if track_file.present?
      @fingerprint = Fingerprint.new track_file.file.file
    else
      @fingerprint = Fingerprint.new raw_fingerprint
    end

    attributes=[:artist, :title, :release, :genre, :duration, :version].inject({}){|res, attr| val = @fingerprint.send(attr); res[attr] = val unless val.blank?; res;}
    attributes[:track_id] = Digest::MD5.hexdigest(Time.now.to_s(:db)+rand(100000).to_s)
    self.assign_attributes(attributes)
  end

  def update_solr
    if self.fingerprint.present?
      Solr.delete_track(self)
      Solr.add_track(self)
    end
  end

  def delete_solr
    Solr.delete_track(self)
  end

  def solr_documents
    Solr.track_docs(self)
  end

end
