var charts = {}
var sectionData = undefined;
var organizedSections = {};
var quarters = [];

$(document).ready(function() {
  /**
       * Highcharts plugin for setting a lower opacity for other series than the one that is hovered
       * in the legend
       */
      (function (Highcharts) {
          var each = Highcharts.each;

          Highcharts.wrap(Highcharts.Legend.prototype, 'renderItem', function (proceed, item) {

              proceed.call(this, item);


              var series = this.chart.series,
                  element = item.legendGroup.element;

              element.onmouseover = function () {
                 each(series, function (seriesItem) {
                      if (seriesItem !== item) {
                          each(['group', 'markerGroup'], function (group) {
                              seriesItem[group].attr('opacity', 0.25);
                          });
                      }
                  });
              }
              element.onmouseout = function () {
                 each(series, function (seriesItem) {
                      if (seriesItem !== item) {
                          each(['group', 'markerGroup'], function (group) {
                              seriesItem[group].attr('opacity', 1);
                          });
                      }
                  });
              }

          });
      }(Highcharts));

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
      var courseSeries_tmp = {};
      courseSeries_tmp.name = section_name;
      courseSeries_tmp.data = [];
      for(var j in organizedSections[section_name]) {
        var section = organizedSections[section_name][j].section
        courseSeries_tmp.data.push([quarterName(section), section.course]);
      }
      courseSeries.push(courseSeries_tmp);
    }
  }

  refreshChart(charts.course, 'chart-course', courseSeries, 'Course Rating', quarters, 'Score');
}

function sectionName(section) {
  return [section.professor.title, section.subject.title.split(' ')[0], section.title.title].join(' ');
}

function quarterName(section) {
  return [section.quarter.title, section.year.title].join(' ');
}

function refreshChart(chart, id, series, title, categories, yTitle) {
  chart = new Highcharts.Chart({
    chart: {
      renderTo: id,
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
