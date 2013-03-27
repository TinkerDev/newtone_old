class Dumper
  def self.parse_file file_path
    string = File.open(file_path){ |file| file.read }
    data = JSON.parse(string)
    data.each do |raw_fingerprint|
      Track.create(:raw_fingerprint=>raw_fingerprint)
    end
  end
end