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
    dataType: 'json',
    type: 'POST',
    data: location.search.slice(1),
    success: loadData
  });
}

function loadData(data) {
  var sectionData = data;
  for(var i = 0; i < sectionData.length; i++) {
    var organizedSection = organizedSections[sectionName(sectionData[i])];
    if(organizedSection === undefined) {
      organizedSections[sectionName(sectionData[i])] = []
    }

    organizedSections[sectionName(sectionData[i])].push(sectionData[i]);

    if($.inArray(quarterName(sectionData[i]), quarters) === -1) {
      quarters.push(quarterName(sectionData[i]));
    }

    var ratings = ['course', 'instruction', 'learned', 'challenged', 'stimulated']
    var ratingSeries = {}
    ratings.forEach(function(rating) {
      ratingSeries[rating] = [];
    });
    Object.keys(organizedSections).forEach(function(name) {
      var seriesTmp = {};

      ratings.forEach(function(rating) {
        seriesTmp[rating] = {};
        seriesTmp[rating].name = name;
        seriesTmp[rating].data = [];
      });

      for(var j in organizedSections[name]) {
        var section = organizedSections[name][j]

        ratings.forEach(function(rating) {
          seriesTmp[rating].data.push([quarterName(section), section[rating]]);
        });
      }

      ratings.forEach(function(rating) {
        ratingSeries[rating].push(seriesTmp[rating]);
      });
    });
  }

  yRange = findRange(ratingSeries);
  // draw the charts
  refreshChart('course', 'chart-course', ratingSeries['course'], quarters, yRange);
  refreshChart('instruction', 'chart-instruction', ratingSeries['instruction'], quarters, yRange);
  // you have to manually set the size of all charts after the first
  charts.instruction.setSize(parseInt($(".tab-content:first").css("width")), parseInt($(".tab-content:first").css("height")));
  refreshChart('learned', 'chart-learned', ratingSeries['learned'], quarters, yRange);
  charts.learned.setSize(parseInt($(".tab-content:first").css("width")), parseInt($(".tab-content:first").css("height")));
  refreshChart('challenged', 'chart-challenged', ratingSeries['challenged'], quarters, yRange);
  charts.challenged.setSize(parseInt($(".tab-content:first").css("width")), parseInt($(".tab-content:first").css("height")));
  refreshChart('stimulated', 'chart-stimulated', ratingSeries['stimulated'], quarters, yRange);
  charts.stimulated.setSize(parseInt($(".tab-content:first").css("width")), parseInt($(".tab-content:first").css("height")));
}

function sectionName(section) {
  return [section.professor.title, section.subject.title.split(' ')[0], section.title.title].join(' ');
}

function quarterName(section) {
  return [section.quarter.title, section.year.title].join(' ');
}

function findRange(series) {
  return [0.8, 6.2];
}

function refreshChart(name, id, series, categories, yRange) {
  // fill in non existent quarters with null data
  var newSeries = [];
  for(var s_i in series) {
    newSeries[s_i] = { name: series[s_i].name, data: [] }
    var s_categories = series[s_i].data.map(function(d) { return d[0] });
    for(var c_i in categories) {
      var s_c_i = s_categories.indexOf(categories[c_i])
      if(s_c_i !== -1) {
        newSeries[s_i].data.push([categories[c_i], series[s_i].data[s_c_i][1]])
      }
      else {
        newSeries[s_i].data.push([categories[c_i], null])
      }
    }
  }
  series = newSeries

  charts[name] = new Highcharts.Chart({
    chart: {
      renderTo: id,
      type: 'spline',
      reflow: true,
      zoomType: 'y'
    },
    plotOptions: {
        spline: {
            connectNulls: true
        }
    },
    reflow: false,
    credits: {
      enabled: false
    },
    title: {
      text: ' '
    },
    xAxis: {
      categories: categories,
      max: null
    },
    yAxis: {
      title: {
        text: 'Rating'
      },
      min: yRange[0] * 0.9 < 1 ? 1 : yRange[0] * 0.9,
      max: yRange[1] * 1.1 > 6 ? 6 : yRange[1] * 1.1
    },
    series: series
  });
}
