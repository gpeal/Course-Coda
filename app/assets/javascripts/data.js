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
    instructionSeries = [];
    learnedSeries = [];
    challengedSeries = [];
    stimulatedSeries = [];
    var keys = Object.keys(organizedSections);
    for(var section_id in keys) {
      var section_name = keys[section_id];
      var courseSeries_tmp = {};
      courseSeries_tmp.name = section_name;
      courseSeries_tmp.data = [];

      var instructionSeries_tmp = {};
      instructionSeries_tmp.name = section_name;
      instructionSeries_tmp.data = [];

      var learnedSeries_tmp = {};
      learnedSeries_tmp.name = section_name;
      learnedSeries_tmp.data = [];

      var challengedSeries_tmp = {};
      challengedSeries_tmp.name = section_name;
      challengedSeries_tmp.data = [];

      var stimulatedSeries_tmp = {};
      stimulatedSeries_tmp.name = section_name;
      stimulatedSeries_tmp.data = [];

      for(var j in organizedSections[section_name]) {
        var section = organizedSections[section_name][j].section
        courseSeries_tmp.data.push([quarterName(section), section.course]);
        instructionSeries_tmp.data.push([quarterName(section), section.instruction]);
        learnedSeries_tmp.data.push([quarterName(section), section.learned]);
        challengedSeries_tmp.data.push([quarterName(section), section.challenge]);
        stimulatedSeries_tmp.data.push([quarterName(section), section.stimulation]);
      }
      courseSeries.push(courseSeries_tmp);
      instructionSeries.push(instructionSeries_tmp);
      learnedSeries.push(learnedSeries_tmp);
      challengedSeries.push(challengedSeries_tmp);
      stimulatedSeries.push(stimulatedSeries_tmp);
    }
  }

  yRange = findRange([courseSeries, instructionSeries, learnedSeries, challengedSeries, stimulatedSeries]);
  // draw the charts
  refreshChart('course', 'chart-course', courseSeries, quarters, yRange);
  refreshChart('instruction', 'chart-instruction', instructionSeries, quarters, yRange);
  // you have to manually set the size of all charts after the first
  charts.instruction.setSize(parseInt($(".tab-content:first").css("width")), parseInt($(".tab-content:first").css("height")));
  refreshChart('learned', 'chart-learned', learnedSeries, quarters, yRange);
  charts.learned.setSize(parseInt($(".tab-content:first").css("width")), parseInt($(".tab-content:first").css("height")));
  refreshChart('challenged', 'chart-challenged', challengedSeries, quarters, yRange);
  charts.challenged.setSize(parseInt($(".tab-content:first").css("width")), parseInt($(".tab-content:first").css("height")));
  refreshChart('stimulated', 'chart-stimulated', stimulatedSeries, quarters, yRange);
  charts.stimulated.setSize(parseInt($(".tab-content:first").css("width")), parseInt($(".tab-content:first").css("height")));
}

function sectionName(section) {
  return [section.professor.title, section.subject.title.split(' ')[0], section.title.title].join(' ');
}

function quarterName(section) {
  return [section.quarter.title, section.year.title].join(' ');
}

function findRange(series) {
  var minDataValue = 7;
  var maxDataValue = -1;
  for(var i in series) {
    for(var j in series[i]) {
      for(var k in series[i][j].data) {
        var dataValue = series[i][j].data[k][1];
        if(dataValue < minDataValue) {
          minDataValue = dataValue;
        }
        if(dataValue > maxDataValue) {
          maxDataValue = dataValue
        }
      }
    }
  }
  return [minDataValue, maxDataValue];
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
