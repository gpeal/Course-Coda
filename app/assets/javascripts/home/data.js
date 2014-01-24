var charts = {}
var sectionData = undefined;
var organizedSections = {};
var requireResize = {course: false, instruction: false, learned: false, stimulated: false, challenged: false, hours: false}

$(document).ready(function() {
  startLoadingAnimation();

  requestData();
});

function startLoadingAnimation() {

}

function requestData() {
  $.ajax({
    url: 'api/v1/search.json',
    dataType: 'json',
    type: 'POST',
    data: location.search.slice(1),
    success: loadData
  });
}

function loadData(data) {
  if(data['info']) {
    if (isOnRootPage()) {
      showWelcomeText();
    } else {
      bootstrap_alert.info(data['info']);
    }
    hideLoadingAnimation();
    return
  } else if(data['error']) {
    bootstrap_alert.error(data['error']);
    return
  } else {
    hideLoadingAnimation();
    addTabs();
    loadOverviewData(data.averages);
    loadChartData(data.sections, data.xRange, data.yRange);
  }

}

function hideLoadingAnimation() {
    $('#loading').css('display', 'none');
}

function addTabs() {
    $('#tab-container').css('display', 'block');
}

function showWelcomeText() {
  $('#hero-main').text("Welcome to Northwestern CTECs. Use the search boxes on the left to begin.");
}

function isOnRootPage() {
  return location.pathname === '/' && location.search === '';
}