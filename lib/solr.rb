class Solr

  def self.solr
    @connection ||= RSolr.connect :url => 'http://localhost:8502/solr/fp'
  end

  def self.search query
    params = {:q => query, :fl=>'*,score', :qt => "/hashq", :wt => :standard, :rows=>30, :version=>'2.2', :echoParams=>:none}
    self.solr.post 'select', :data=>params
  end

  def self.human_response response
    #puts if top_match_score < code_len * 0.05:
    if response['docs'].any?
      docs = response['docs']
      {:artist => docs[0]['artist'], :track => docs[0]['track'], :status => 1 }
    else
      nil
    end
  end

  def self.add_track track
    solr_data = {
        "fp" => track.fingerprint.solr_string,
        "track_id" => track.track_id,
        "length" => track.duration,
        "codever" => track.version,
        'artist' => track.artist,
        'title' => track.title,
        'release' => track.release
    }

    documents = self.split_data_to_documents(solr_data)

    self.solr.add documents
    self.solr.commit
  end

  def self.update_track track

  end

  def self.delete_track track
    solr.delete_by_query("track_id:[#{track.track_id} *]")
    solr.commit
  end


  def self.split_data_to_documents solr_data
    #Split a codestring into a list of codestrings. Each string contains
    #    at most 60 seconds of codes, and codes overlap every 30 seconds. Given a
    #    track id, return track ids of the form trid-0, trid-1, trid-2, etc.

    # Convert seconds into time units
    segmentlength = 60 * 1000.0 / 23.2
    halfsegment = segmentlength / 2.0

    trid = solr_data["track_id"]
    codestring = solr_data["fp"]
    codes = codestring.split(' ')
    pairs = codes.each_slice(2).to_a
    pairs = pairs.map{|el| [el[1].to_i, el.join(' ')]}
    pairs = pairs.sort
    size = pairs.count

    numsegs = 0
    if pairs.count > 0
      lasttime = pairs[-1][0]
      numsegs = (lasttime / halfsegment).to_i + 1
    end

    ret = []
    sindex = 0
    numsegs
    pairs[0]
    0.upto(numsegs-1) do |i|
      s = i * halfsegment
      e = i * halfsegment + segmentlength

      #[s,e]

      while sindex < size and pairs[sindex][0] < s do
        #print "s", sindex, l[sindex]
        sindex+=1
      end
      eindex = sindex

      while eindex < size and pairs[eindex][0] < e do
        #print "e",eindex,l[eindex]
        eindex+=1
      end

      key = "#{trid}-#{i}"


      segment = {"track_id"=> key,
                 "fp" => pairs[sindex..eindex].map{|p| p[1]}.join(' '),
                 "length"=> solr_data["length"],
                 'source' => 'local',
                 'import_date' => Time.now.strftime("%Y-%m-%dT%H:%M:%SZ"),
                 "codever"=> solr_data["codever"]}
      ["artist", 'release', 'track', 'source', 'import_date'].each do |key|
        segment[key] = solr_data[key] if solr_data.has_key?(key)
      end
      ret << segment
    end
    ret
  end
end