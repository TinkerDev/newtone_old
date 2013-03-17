#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require jquery-fileupload/basic

$ ->
  $('[rel*="tooltip"]').tooltip()
  $('.j-record-button').on 'click', (e) ->
    e.preventDefault()
    $('.j-record-button').toggleClass('hide')

  $("#sample_upload").fileupload
    add:(e, data)->
      data.context = $("#upload a.record-button").removeClass("disabled").click ->
        screenState('processing')
        jqXHR = data.submit()
          .success (result, textStatus, jqXHR) ->
            if result != null
              console.log 1
              state = result.status == 1 ? "good" : "bad"
              newtoneFace(state)
              setTimeout(
                () -> newtoneFace("normal"),
                1000
              )
              resultsOutput('success!', result.artist, result.track)
              screenState('results')
            else
              resultsOutput("Not found")
              screenState('results')
              newtoneFace('bad')
              setTimeout(
                () -> newtoneFace("normal"),
                1000
              )
            $("#upload a.record-button").unbind('click')
          .error (jqXHR, textStatus, errorThrown) ->
            screenState('welcome')
            $("#upload a.record-button").unbind('click')
    
    always: (e, date)->
      $("#upload a.record-button").addClass("disabled")
  
  screenState('welcome')

@newtoneFace = (state) ->
  $('.j-newtone-state').removeClass('visible').addClass('hidden')
  $('.j-newtone-state.newtone-' + state).removeClass('hidden').addClass('visible')

@screenState = (screen) ->
  screens= ['.j-welcome-screen', '.j-processing-screen', '.j-results-screen' ]
  $(screens.join(", ")).each ->
    if not $(@).hasClass('hide')
      $(@).addClass('hide')
  $('.j-'+screen+'-screen').removeClass('hide')

@resultsOutput = (message, artist=null, title=null)->
  $('.j-message').html(message)
  $('.j-author').html(artist)
  $('.j-title').html(title)
