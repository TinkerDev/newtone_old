#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require_tree .
#= require jquery-fileupload/basic

$ ->
  $('[rel*="tooltip"]').tooltip()
  $('.j-record-button').on 'click', (e) ->
    e.preventDefault()
    $('.j-record-button').toggleClass('hide')

  $("#sample_upload").fileupload
    add:(e, data)->
      jqXHR = data.submit()
        .success (result, textStatus, jqXHR) ->
          if result != "null"
            state = result.status == 1 ? "good" : "bad"
            state = "bad"
            newtoneFace(state)
            setTimeout(
              () -> newtoneFace("normal"),
              1000
            ) 
@newtoneFace = (state) ->
  $('.j-newtone-state').removeClass('visible').addClass('hidden')
  $('.j-newtone-state.newtone-' + state).removeClass('hidden').addClass('visible')


