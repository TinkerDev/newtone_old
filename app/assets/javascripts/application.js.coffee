#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require jquery-fileupload/basic
#= require swfobject
#= require recorder

$(document).ready ->
  jqXHR = null
  $('[rel*="tooltip"]').tooltip()

  $('#cancel_processing').click ->
    jqXHR.abort()
    screenState('welcome')

  $("#audio_sample").fileupload
#    acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i ,
    add:(e, data)->
      data.context = $("#upload a.upload-button").removeClass("disabled").click ->
        screenState('processing')
        jqXHR = data.submit()
          .success (result, textStatus, jqXHR) ->
            ajaxSuccess(result)
            $("#upload a.upload-button").unbind('click')
          .error (jqXHR, textStatus, errorThrown) ->
            ajaxError(errorThrown)
            $("#upload a.upload-button").unbind('click')
    always: (e, date)->
      $("#upload a.upload-button").addClass("disabled")

  flashvars = {
    'event_handler': 'microphone_recorder_events',
  };
  swfobject.embedSWF("recorder.swf", "flashcontent", 1, 1, "11.0.0", "", flashvars, {}, {'id': "recorderApp", 'name':  "recorderApp"});

  $("a[data-toggle=\"tab\"]").on "shown", (e) ->
     if e.target.id=='audio-button-record'
       Recorder.showPermissionWindow() if !Recorder.isReady
     else
       Recorder.defaultSize()
#    e.target # activated tab
#    e.relatedTarget # previous tab

  @configureMicrophone = () ->
    return if(!Recorder.isReady)
    Recorder.configure(22, 100, 0, 2000);
    Recorder.setUseEchoSuppression(false);
    Recorder.setLoopBack(false);

  $('#record .record-button').click ->
    Recorder.record('audio', 'audio.wav');
  $('#record .send-button').click ->
    screenState('processing');
    Recorder.save();

@newtoneFace = (state) ->
  $('.j.newtone-face').removeClass('visible').addClass('hidden')
  $('.j.newtone-face.newtone-' + state).removeClass('hidden').addClass('visible')

@screenState = (screen) ->
  screens= ['.j-welcome-screen', '.j-processing-screen', '.j-results-screen', '.j-error-screen' ]
  $(screens.join(", ")).each ->
    if not $(@).hasClass('hide')
      $(@).addClass('hide')
  $('.j-'+screen+'-screen').removeClass('hide')

@resultsGoodOutput = (artist=null, title=null)->
  $('.j-artist').html(artist)
  $('.j-title').html(title)
  $('.j-results-screen .good').removeClass('hide')
  $('.j-results-screen .bad').addClass('hide')

@resultsBadOutput = () ->
  $('.j-results-screen .good').addClass('hide')
  $('.j-results-screen .bad').removeClass('hide')

@ajaxSuccess = (result) ->
  if result != null
    newtoneFace('good')
    resultsGoodOutput(result.artist, result.track)
    screenState('results')
  else
    newtoneFace('bad')
    resultsBadOutput()
    screenState('results')

@ajaxError = (errorThrown) ->
  if (errorThrown != 'abort')
    screenState('error')