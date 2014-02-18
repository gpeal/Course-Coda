
###
Highcharts plugin for setting a lower opacity for other series than the one that is hovered
in the legend
###
window.loadChartData = (data, xRange, yRange) ->
  i = 0

  while i < data.length
    organizedSection = window.organizedSections[sectionName(data[i])]
    organizedSections[sectionName(data[i])] = []  if organizedSection is `undefined`
    organizedSections[sectionName(data[i])].push data[i]
    ratings = [
      "course"
      "instruction"
      "learned"
      "challenged"
      "stimulated"
      "hours"
    ]
    ratingSeries = {}
    ratings.forEach (rating) ->
      ratingSeries[rating] = []
      return

    Object.keys(organizedSections).forEach (name) ->
      seriesTmp = {}
      ratings.forEach (rating) ->
        seriesTmp[rating] = {}
        seriesTmp[rating].name = name
        seriesTmp[rating].data = []
        return

      for j of organizedSections[name]
        section = organizedSections[name][j]
        sectionShortQuarterName = shortSectionTerm(section)
        ratings.forEach (rating) ->
          seriesTmp[rating].data.push [
            sectionShortQuarterName
            section[rating]
          ]
          return

      ratings.forEach (rating) ->
        ratingSeries[rating].push seriesTmp[rating]
        return

      return

    i++
  terms = generateTerms(xRange.firstQuarter.title, parseInt(xRange.firstYear.title))

  # draw the charts
  ratings.forEach (rating) ->
    if rating is "hours"
      yRange = [
        0.8
        25
      ]
    else
      yRange = [
        1
        6
      ]
    refreshChart rating, "chart-" + rating, ratingSeries[rating], terms, yRange
    window.charts[rating].setSize parseInt($(".tab-content:first").css("width")), parseInt($(".tab-content:first").css("height"))
    return

  window.populateFeedbackSelect organizedSections
  $(window).bind "resize", ->
    window.requireResize["course"] = true
    window.requireResize["instruction"] = true
    window.requireResize["learned"] = true
    window.requireResize["challenged"] = true
    window.requireResize["stimulated"] = true
    window.requireResize["hours"] = true
    return

  $("#course-tab-link").bind "click",
    rating: "course"
  , resizeChart
  $("#instruction-tab-link").bind "click",
    rating: "instruction"
  , resizeChart
  $("#learned-tab-link").bind "click",
    rating: "learned"
  , resizeChart
  $("#challenged-tab-link").bind "click",
    rating: "challenged"
  , resizeChart
  $("#stimulated-tab-link").bind "click",
    rating: "stimulated"
  , resizeChart
  $("#hours-tab-link").bind "click",
    rating: "hours"
  , resizeChart
  return
generateTerms = (firstQuarter, firstYear) ->
  quarterNames = [
    "W"
    "S"
    "Su"
    "F"
  ]
  terms = []

  # intentionally uses fall through switch
  switch firstQuarter
    when "Winter"
      terms.push quarterNames[0] + shortenYear(firstYear)
    when "Spring"
      terms.push quarterNames[1] + shortenYear(firstYear)
    when "Summer"
      terms.push quarterNames[2] + shortenYear(firstYear)
    when "Fall"
      terms.push quarterNames[3] + shortenYear(firstYear)
  year = firstYear + 1

  while year <= 2012
    terms.push quarterNames[0] + shortenYear(year)
    terms.push quarterNames[1] + shortenYear(year)
    terms.push quarterNames[2] + shortenYear(year)
    terms.push quarterNames[3] + shortenYear(year)
    year++
  terms
shortenYear = (year) ->
  year = parseInt(year)
  year -= 2000
  year = "" + year
  if year.length is 1
    prefix = "0"
  else prefix = ""  if year.length is 2
  prefix + year
sectionName = (section) ->
  [
    section.professor.title
    section.subject.title.split(" ")[0]
    section.title.title
  ].join " "
shortSectionTerm = (section) ->
  year = section.year.title
  year = shortenYear(year)
  quarter = section.quarter.title.toLowerCase()
  switch quarter
    when "winter"
      quarter = "W"
    when "spring"
      quarter = "S"
    when "summer"
      quarter = "Su"
    when "fall"
      quarter = "F"
  quarter + year
quarterName = (section) ->
  [
    section.quarter.title
    section.year.title
  ].join " "
resizeChart = (e) ->
  rating = e.data.rating
  unless window.requireResize[rating]
    return charts[rating].setSize(parseInt($(".tab-content:first").css("width")), parseInt($(".tab-content:first").css("height")),
      duration: 0
    )
  window.requireResize[rating] = false
  return
refreshChart = (name, id, series, categories, yRange) ->

  # fill in non existent quarters with null data
  newSeries = []
  for s_i of series
    newSeries[s_i] =
      name: series[s_i].name
      data: []

    s_categories = series[s_i].data.map((d) ->
      d[0]
    )
    for c_i of categories
      s_c_i = s_categories.indexOf(categories[c_i])
      if s_c_i isnt -1
        newSeries[s_i].data.push [
          categories[c_i]
          series[s_i].data[s_c_i][1]
        ]
      else
        newSeries[s_i].data.push [
          categories[c_i]
          null
        ]
  series = newSeries
  charts[name] = new Highcharts.Chart(
    chart:
      renderTo: id
      type: "spline"
      reflow: true
      zoomType: "xy"

    plotOptions:
      spline:
        connectNulls: true

    reflow: false
    credits:
      enabled: false

    title:
      text: " "

    xAxis:
      categories: categories
      max: null

    yAxis:
      title:
        text: "Rating"

      min: yRange[0]
      max: yRange[1]

    series: series
  )
  return
$(document).ready ->
  ((Highcharts) ->
    each = Highcharts.each
    Highcharts.wrap Highcharts.Legend::, "renderItem", (proceed, item) ->
      proceed.call this, item
      series = @chart.series
      element = item.legendGroup.element
      element.onmouseover = ->
        each series, (seriesItem) ->
          if seriesItem isnt item
            each [
              "group"
              "markerGroup"
            ], (group) ->
              seriesItem[group].attr "opacity", 0.25
              return

          return

        return

      element.onmouseout = ->
        each series, (seriesItem) ->
          if seriesItem isnt item
            each [
              "group"
              "markerGroup"
            ], (group) ->
              seriesItem[group].attr "opacity", 1
              return

          return

        return

      return

    return
  ) Highcharts
  return
