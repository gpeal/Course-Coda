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

  refreshChart('course', 'chart-course', courseSeries, 'Course Rating', quarters, 'Score');
  refreshChart('instruction', 'chart-instruction', instructionSeries, 'Instruction Rating', quarters, 'Score');
  // you have to manually set the size of all charts after the first
  charts.instruction.setSize(parseInt($(".tab-content:first").css("width")), parseInt($(".tab-content:first").css("height")));
  refreshChart('learned', 'chart-learned', learnedSeries, 'Amount Learned', quarters, 'Score');
  charts.learned.setSize(parseInt($(".tab-content:first").css("width")), parseInt($(".tab-content:first").css("height")));
  refreshChart('challenged', 'chart-challenged', challengedSeries, 'Amount Challenged', quarters, 'Score');
  charts.challenged.setSize(parseInt($(".tab-content:first").css("width")), parseInt($(".tab-content:first").css("height")));
  refreshChart('stimulated', 'chart-stimulated', stimulatedSeries, 'Amount Stimulated', quarters, 'Score');
  charts.stimulated.setSize(parseInt($(".tab-content:first").css("width")), parseInt($(".tab-content:first").css("height")));
}

function sectionName(section) {
  return [section.professor.title, section.subject.title.split(' ')[0], section.title.title].join(' ');
}

function quarterName(section) {
  return [section.quarter.title, section.year.title].join(' ');
}

function refreshChart(name, id, series, title, categories, yTitle) {
  charts[name] = new Highcharts.Chart({
    chart: {
      renderTo: id,
      type: 'spline'
    },
    reflow: false,
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
