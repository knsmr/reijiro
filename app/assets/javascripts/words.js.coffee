# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  jumptoNext = ->
    nextPath = -> window.location = '/next'
    setTimeout nextPath, 800

  highlightButton = ->
    for i in [0..8]
      $("#status#{i}").removeClass('active')
    n = $('#status-digit').text().trim()
    $("#status#{n}").addClass('active')

  $('#status').bind "ajax:success", (e, data, status, xhr) ->
    $('#status-digit').text(data.status)
    highlightButton()
    jumptoNext()

  highlightButton()

  $('.next').click ->
    status = $('#status-digit').text().trim()
    status++
    if status <= 8
      $("#status#{status}").click()

