#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require_tree .

$ ->
  $('.j-record-button').on 'click', (e) ->
    e.preventDefault()
    $('.j-record-button').toggleClass('hide')
  newtoneFace('normal')

@newtoneFace = (state) ->
  $('.j-newtone-state').removeClass('visible').addClass('hidden')
  $('.j-newtone-state.newtone-' + state).removeClass('hidden').addClass('visible')
