# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require jquery-fileupload/basic
#= require recorder
#= require bootstrap
#= require_tree .

$ ->
  $('[rel*="tooltip"]').tooltip()
  $('.j-record-button').on 'click', (e) ->
    e.preventDefault()
    $('.j-record-button').toggleClass('hide')

@newtoneFace = (state) ->
  $('.j-newtone-state').removeClass('visible').addClass('hidden')
  $('.j-newtone-state.newtone-' + state).removeClass('hidden').addClass('visible')
  #audio_recorder = new AudioRecorder($("#sound"))
 
class AudioRecorder
  recorder: ''
  recording: false
  audioContext: ''
  wav: '' 
  constructor: (@audio)->
    navigator.getUserMedia  = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia
    navigator.getUserMedia {"audio": true}, gotStream, gotStreamFailed

  play = ()->
    console.log @recorder
    @recorder.getBuffers (buffers)->

      console.log @audioContext
      source = @audioContext.createBufferSource()
      source.buffer = @audioContext.createBuffer(1, buffers[0].length, 44100)
      source.buffer.getChannelData(0).set(buffers[0])
      source.buffer.getChannelData(0).set(buffers[1])
      source.connect(@audioContext.destination)
      source.noteOn(0)
  
  start = ()->
    console.log "Star recording"
    @recorder.clear()
    @recorder.record()
  
  stop = ()->
    console.log "Stop recording"
    @recorder.stop()
    @recorder.exportWAV (wav)->
      url = window.webkitURL.createObjectURL(wav)
      $(@audio).attr('src', url)
      console.log url
      $(@audio).load()
  
  gotStream = (stream)->
    @audioContext = new webkitAudioContext()
    mediaStreamSource = @audioContext.createMediaStreamSource( stream )
    filter = @audioContext.createBiquadFilter()
    mediaStreamSource.connect( filter )
    filter.connect(@audioContext.destination) 
    @recorder = new Recorder(filter)
    
    recording = false

    $("#start").click ->
      start()
    $("#stop").click ->
      stop()
    $("#play").click ->
      play()

  gotStreamFailed = (error)->
    console.log error
