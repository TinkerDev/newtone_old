class Recognition

  def initialize audio_file_path
    @audio_file_path = audio_file_path
  end

  def recognize elbow=10
    @fingerprint = Fingerprint.new @audio_file_path
    @fingerprint.clean_codes_by_time
    solr_result = Solr.search @fingerprint.solr_string
    docs = solr_result['response']['docs'] || []
    results_hash = docs.inject({}){|res, el| key = el['track_id'].split('-').first; res.has_key?(key) ? res[key] << el['score'] : res[key] = [];res;}
    results_hash.map{|track_id, scores| [Track.find_by_track_id(track_id), scores.sum]}.sort_by{|track, score| score}.reverse
  end

end