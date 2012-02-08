# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  highlightButton = ->
    for i in [0..8]
      $("#status#{i}").removeClass('active')
    n = $('#status-digit').text().trim()
    $("#status#{n}").addClass('active')

  $('#status').bind "ajax:success", (e, data, status, xhr) ->
    $('#status-digit').text(data.status)
    highlightButton()

  highlightButton()
