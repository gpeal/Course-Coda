var charts = {}
var sectionData = undefined;
var organizedSections = {};
var quarters = [];

$(document).ready(function() {
  requestData();
});

function requestData() {
  $.ajax({
    url: 'api/v1/search.json',
    type: 'POST',
    data: location.search.slice(1),
    success: loadData
  });
}

function loadData(data) {
  var sectionData = data;
  for(var i = 0; i < sectionData.length; i++) {
    var organizedSection = organizedSections[sectionName(sectionData[i].section)];
    if(organizedSection === undefined) {
      organizedSections[sectionName(sectionData[i].section)] = []
    }

    organizedSections[sectionName(sectionData[i].section)].push(sectionData[i]);

    if($.inArray(quarterName(sectionData[i].section), quarters) === -1) {
      quarters.push(quarterName(sectionData[i].section));
    }

    courseSeries = [];
    var keys = Object.keys(organizedSections);
    for(var section_id in keys) {
      var section_name = keys[section_id];
      var series = {};
      series.name = section_name;
      series.data = [];
      for(var j in organizedSections[section_name]) {
        var section = organizedSections[section_name][j].section
        series.data.push([quarterName(section), section.course]);
      }
      courseSeries.push(series);
    }
  }

  refreshChart(charts.course, courseSeries, 'Course Rating', quarters, 'Score');
}

function sectionName(section) {
  return [section.professor.title, section.subject.title.split(' ')[0], section.title.title].join(' ');
}

function quarterName(section) {
  return [section.quarter.title, section.year.title].join(' ');
}

function refreshChart(chart, series, title, categories, yTitle) {
  chart = new Highcharts.Chart({
    chart: {
      renderTo: 'container',
      type: 'spline'
    },
    credits: {
      enabled: false
    },
    title: {
      text: title
    },
    xAxis: {
      categories: categories
    },
    yAxis: {
      title: {
      text: yTitle
    }
    },
    series: series
  });
}
