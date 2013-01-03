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
  if(data['info'] && !(location.pathname === '/' && location.search === '')) {
    bootstrap_alert.info(data['info']);
    return
  }
  else if(data['error']) {
    bootstrap_alert.error(data['error']);
    return
  }

  addTabs();

  loadOverviewData(data.averages);

  loadChartData(data.sections, data.xRange, data.yRange);
}

function addTabs() {
    $('#loading').css('display', 'none');
    $('#tab-container').css('display', 'block');
}