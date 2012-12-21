var charts = {}
var sectionData = undefined;
var organizedSections = {};

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
  if(data['info']) {
    bootstrap_alert.info(data['info']);
    return
  }
  else if(data['error']) {
    bootstrap_alert.error(data['error']);
    return
  }

  var sectionData = data.sections;

  for(var i = 0; i < sectionData.length; i++) {
    var organizedSection = organizedSections[sectionName(sectionData[i])];
    if(organizedSection === undefined) {
      organizedSections[sectionName(sectionData[i])] = []
    }

    organizedSections[sectionName(sectionData[i])].push(sectionData[i]);

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
        var sectionShortQuarterName = shortSectionTerm(section);
        ratings.forEach(function(rating) {
          seriesTmp[rating].data.push([sectionShortQuarterName, section[rating]]);
        });
      }

      ratings.forEach(function(rating) {
        ratingSeries[rating].push(seriesTmp[rating]);
      });
    });
  }


  var terms = generateTerms(data.xRange.firstQuarter.title, parseInt(data.xRange.firstYear.title));
  var yRange = findRange(ratingSeries);
  // draw the charts

  ratings.forEach(function(rating) {
    refreshChart(rating, 'chart-' + rating, ratingSeries[rating], terms, yRange);
    charts[rating].setSize(parseInt($(".tab-content:first").css("width")), parseInt($(".tab-content:first").css("height")));
  })

  populateFeedbackSelect(organizedSections);
}

function generateTerms(firstQuarter, firstYear) {
  var quarterNames = ['W', 'S', 'Su', 'F'];
  var terms = []
  // intentionally uses fall through switch
  switch(firstQuarter) {
    case 'Winter':
      terms.push(quarterNames[0] + shortenYear(firstYear));
    case 'Spring':
      terms.push(quarterNames[1] + shortenYear(firstYear));
    case 'Summer':
      terms.push(quarterNames[2] + shortenYear(firstYear));
    case 'Fall':
      terms.push(quarterNames[3] + shortenYear(firstYear));
  }
  for(var year = firstYear + 1; year <= 2012; year++) {
    terms.push(quarterNames[0] + shortenYear(year));
    terms.push(quarterNames[1] + shortenYear(year));
    terms.push(quarterNames[2] + shortenYear(year));
    terms.push(quarterNames[3] + shortenYear(year));
  }
  return terms;
}

function shortenYear(year) {
  year = parseInt(year);
  year -= 2000;
  year = '' + year;
  if(year.length === 1)
    prefix = '0';
  else if(year.length === 2)
    prefix = '';
  return prefix + year;
}

function sectionName(section) {
  return [section.professor.title, section.subject.title.split(' ')[0], section.title.title].join(' ');
}

function shortSectionTerm(section) {
  var year = section.year.title;
  year = shortenYear(year);
  var quarter = section.quarter.title.toLowerCase();
  switch(quarter) {
    case 'winter':
      quarter = 'W';
      break;
    case 'spring':
      quarter = 'S';
      break;
    case 'summer':
      quarter = 'Su';
      break;
    case 'fall':
      quarter = 'F';
      break;
    }
    return quarter + year;
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
      zoomType: 'xy'
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
