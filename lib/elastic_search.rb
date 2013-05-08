class ElasticSearch
  def self.bootstrap
    Tire.index 'tracks' do
      delete
      #create :mappings => {
      #  :track => {
      #    :properties => {
      #      :id       => {  :index => 'not_analyzed', :include_in_all => true },
      #      :fingerprint    => { :type => 'string', :include_in_all => false }
      #    }
      #  }
      #}
    end
  end
end