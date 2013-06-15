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

  def results
    @results ||= search.map{|r| [Track.find(r.id), r._score]}
  end

  def tracks
    @tracks ||= results.map{|el| el[0]}
  end

  def scores
    @scores ||= results.map{|el| el[1]}
  end

  def top_result_ratio
    return @top_result_ratio if @top_result_ratio
    if scores.many?
      diffs = []
      scores.each_with_index do |el, i|
        diffs << (el - scores[i+1]) if scores[i+1]
      end
      average_diff = diffs[1..-1].inject(:+)/(scores.count-1)
      @top_result_ratio = diffs[0]/average_diff
    else
      @top_result_ratio = 99999999
    end
  end
end