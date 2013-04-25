class ElasticSearch
  def self.create_track_mapping
    Tire.index 'tracks' do
      delete

      create :mappings => {
        :track => {
          :properties => {
            :id       => { :type => 'string', :index => 'not_analyzed', :include_in_all => false },
            :fingerprint    => { :type => 'string', :analyzer => 'snowball'  }
          }
        }
      }
    end
  end

  def self.add_track
    #file = Recognition.recognize
    @fingerprint = Fingerprint.new '/Users/unloved/Downloads/hey.mp3'

    tracks = [
        { :id => 1, :fingerprint => @fingerprint.solr_string}
    ]

    Tire.index 'tracks' do
      import tracks
    end
  end

  def self.search
    @fingerprint = Fingerprint.new '/Users/unloved/Downloads/hey.mp3'
    #s = @fingerprint.solr_string
    s='809256 6260 809256 6260'
    #Tire.search 'tracks', :query => { :prefix => { :title => 'fou' } }
    s = Tire.search('tracks') { query { string s } }
  end

end