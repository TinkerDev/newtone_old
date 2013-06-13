class Fingerprint
  attr_reader :offsets, :terms

  def initialize source, type='add'
    fingerprint = Newtone::Fingerprint.build source, type
    @offsets = fingerprint.map{|el| el[0]}
    @terms = fingerprint.map{|el| el[1]}
  end

  def term_string
    @terms
  end
end