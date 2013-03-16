#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require_tree .

$ ->
  $('.j-record-button').on 'click', (e) ->
    e.preventDefault()
    $('.j-record-button').toggleClass('hide')
