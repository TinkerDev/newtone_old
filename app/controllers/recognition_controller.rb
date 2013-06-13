class RecognitionController < ApplicationController
  def recognize
    audio_path = params[:audio][:sample].tempfile.path
    file_ext = params[:audio][:sample].original_filename.split('.').last
    new_path = "#{Rails.root}/tmp#{Time.now.to_i.to_s}-#{rand(999999)}.#{file_ext}"
    FileUtils.cp(audio_path, new_path)
    recognition = Recognition.new(new_path)
    FileUtils.rm(new_path)
    response = nil
    if recognition.tracks.any? and recognition.top_result_ratio > 100
      track = recognition.tracks.first[0]
      response = {:artist => track.artist.name, :track => track.title, :status => 1}
    end
    render :json => response
  end
end
