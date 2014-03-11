startLoadingAnimation = ->
requestData = ->
  $.ajax
    url: "api/v1/search.json"
    dataType: "json"
    type: "POST"
    data: location.search.slice(1)
    error: hideLoadingAnimation
    success: loadData

  return
loadData = (data) ->
  if data["info"]
    if isOnRootPage()
      showWelcomeText()
    else
      bootstrap_alert.info data["info"]
    hideLoadingAnimation()
    return
  else if data["error"]
    bootstrap_alert.error data["error"]
    return
  else
    hideLoadingAnimation()
    addTabs()
    window.loadOverviewData data.averages
    window.loadChartData data.sections, data.xRange, data.yRange
  return
hideLoadingAnimation = ->
  $("#loading").css "display", "none"
  return
addTabs = ->
  $("#tab-container").css "display", "block"
  return
showWelcomeText = ->
  $("#hero-main").text "Welcome to Course Coda. Use the search boxes on the left to begin."
  return
isOnRootPage = ->
  location.pathname is "/" and location.search is ""
window.charts = {}
sectionData = `undefined`
window.organizedSections = {}
window.requireResize =
  course: false
  instruction: false
  learned: false
  stimulated: false
  challenged: false
  hours: false

$(document).ready ->
  startLoadingAnimation()
  requestData()
  return
