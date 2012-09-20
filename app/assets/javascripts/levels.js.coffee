$ ->
  $('.word').mouseover ->
    $(this).find('.known').css('color', 'black')
    $(this).find('.clip').css('color', 'black')
  .mouseout ->
    $(this).find('.known').css('color', '#dddddd')
    $(this).find('.clip').css('color', '#dddddd')

  $('.known').click ->
    word = $(this).parent()
    word.spin()
    id = word.find('.id').text().trim()
    $.post "/levels/known/#{id}", (data) ->
      word.spin(false)
      word.css('background', '#ff9999')
      remove_word_entry = -> word.fadeOut('slow')
      setTimeout remove_word_entry, 100

  $('.clip').click ->
    word = $(this).parent()
    word.spin()
    entry = word.find('.entry').text().trim()
    $.post "/async_import/#{entry}", (data) ->
      word.spin(false)
      word.css('background', '#9999ff')
      remove_word_entry = -> word.fadeOut('slow')
      setTimeout remove_word_entry, 100
