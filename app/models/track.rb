class Track < ActiveRecord::Base
  attr_accessor :fingerprint
  attr_accessible :track_file, :fingerprint, :track_id, :artist, :title, :release, :genre, :duration, :version
  mount_uploader :track_file, TrackUploader
  validates :track_file, :presence => true, :if => Proc.new { |t| t.fingerprint.blank? }, :on => :create
  validates :fingerprint, :presence => true, :if => Proc.new { |t| t.track_file.blank? }, :on => :create
  before_save :get_fingerprint_info
  after_save :update_solr
  after_destroy :delete_solr


  def get_fingerprint_info
    @fingerprint = Fingerprint.new track_file.file.file if track_file.present?
    attributes=[:artist, :title, :release, :genre, :duration, :version].inject({}){|res, attr| val = @fingerprint.send(attr); res[attr] = val unless val.blank?; res;}
    attributes[:track_id] = Digest::MD5.hexdigest(Time.now.to_s(:db)+rand(100000).to_s)
    self.assign_attributes(attributes)
  end

  def update_solr

    if self.fingerprint.present?
      #Solr.delete_track(self)
      Solr.add_track(self)
    else
      Solr.update_track(self)
    end
  end

  def delete_solr
    Solr.delete_track(self)
  end

end
