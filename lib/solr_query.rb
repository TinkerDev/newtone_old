class SolrQuery
  def self.do_solr_query query
    solr = RSolr.connect :url => 'http://localhost:8502/solr/fp'
    params = {:q => query, :fl=>'*,score', :qt => "/hashq", :wt => :standard, :rows=>30, :version=>'2.2', :echoParams=>:none}
    solr.post 'select', :data=>params
  end

  def self.human_response response
    if response['numFound'] > 0
      docs = response['docs']
      {:artist => docs[0]['artist'], :track => docs[0]['track'], :status => 1 }
    else
      nil
    end
  end
end