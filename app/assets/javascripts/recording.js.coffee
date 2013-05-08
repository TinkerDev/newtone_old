$ ->
  $.jRecorder
      host : 'http://yourdomain.com/acceptfile.php?filename=hello.wav' ,
      callback_started_recording: ->
        @callback_started()
      callback_stopped_recording: ->
        callback_stopped()
      callback_activityLevel: (level) ->
        callback_activityLevel(level)
      callback_activityTime: (time) ->
        callback_activityTime(time)
      callback_finished_sending: (time) ->
        callback_finished_sending()
      swf_path : 'jRecorder.swf'

  $('#record').click ->
    $.jRecorder.record(30)

  $('#stop').click ->
    $.jRecorder.stop()

  $('#send').click ->
    $.jRecorder.sendData()

@callback_finished = ->
  $('#status').html('Recording is finished')

@callback_started = ->
  alert('hello')
  $('#status').html('Recording is started')

@callback_error = (code) ->
  $('#status').html('Error, code:' + code)

@callback_stopped = ->
  $('#status').html('Stop request is accepted')

@callback_finished_recording = ->
  $('#status').html('Recording event is finished')

@callback_finished_sending = ->
  $('#status').html('File has been sent to server mentioned as host parameter')

@callback_activityLevel=  (level) ->
  $('#level').html(level)
  if(level == -1)
    $('#levelbar').css("width",  "2px")
  else
    $('#levelbar').css("width", (level * 2)+ "px")

@callback_activityTime = (time) ->
#    $('.flrecorder').css("width", "1px")
#    $('.flrecorder').css("height", "1px")
  $('#time').html(time)