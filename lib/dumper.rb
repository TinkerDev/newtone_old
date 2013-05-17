class Dumper
  def self.parse_file file_path
    string = File.open(file_path){ |file| file.read }
    data = JSON.parse(string)
      data[12283..-1].each do |raw_fingerprint|
        begin
          Track.create(:raw_fingerprint=>raw_fingerprint)
        rescue FingerprintError

        end
      end
  end
end