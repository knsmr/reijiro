# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
//= require jquery.jqplot
//= require jqplot.barRenderer

$ ->
# Draw chart
  if ($('#chart').length > 0)
    $.getJSON '/stats.json', (data) ->
      undone = []
      done = []
      remain = []
      for i in [1..12]
        undone.push(data[i+''].undone)
        done.push(data[i+''].done)
        remain.push(data[i+''].remain)

      undone.push(data['0'].undone)
      done.push(data['0'].done)
      remain.push(data['0'].remain)

      $.jqplot('chart',  [done, undone, remain], {
        title: 'ALC 12000 Progress'
        stackSeries: true,
        seriesDefaults: {
          renderer:$.jqplot.BarRenderer,
          rendererOptions: {
              barMargin: 25,
            },
          pointLabels: {show: true}
        },
      })
