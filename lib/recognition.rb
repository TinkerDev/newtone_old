require 'fileutils'
class Recognition

  def initialize audio_file_path

    @fingerprint = Fingerprint.new audio_file_path, 'match'
  end

  def search
    return @results if @results
    term_string = @fingerprint.term_string
    @results = Track.tire.search do
      query do
        terms :terms, term_string
      end
    end
  end

  def tracks
    @tracks ||= search.map{|r| [Track.find(r.id), r._score]}
  end

  def top_result_ratio
    return @top_result_ratio if @top_result_ratio
    scores = tracks.map{|el| el[1]}
    diffs = (1..scores.count-2).map{|i| scores[i]-scores[i+1]}
    average_diff = diffs[1..-1].inject(0){|res, x| res = res+x;res;}/(scores.count-2)
    first_diff=scores[0]-scores[1]
    @top_result_ratio = first_diff/average_diff
  end
end