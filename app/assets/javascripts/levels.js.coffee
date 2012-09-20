$ ->
  $('.word').mouseover ->
    $(this).css('background-color', '#cccccc')
  .mouseout ->
    $(this).css('background-color', '#ffffff')

  remove_entry = (elm , disappearingColor) ->
    elm.spin(false)
    elm.css('background', disappearingColor)
    remove = -> elm.fadeOut('slow')
    setTimeout remove, 150

  $('.known').click ->
    word = $(this).parent()
    word.spin()
    id = word.find('.id').text().trim()
    $.post "/levels/known/#{id}", (data) ->
      remove_entry(word, '#ff9999')

  $('.clip').click ->
    word = $(this).parent()
    word.spin()
    entry = word.find('.entry').text().trim()
    $.post "/async_import/#{entry}", (data) ->
      remove_entry(word, '#9999ff')
