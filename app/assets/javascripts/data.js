var charts = {}
var sectionData = undefined;
var organizedSections = {};

$(document).ready(function() {
  charts.course = new Highcharts.Chart({
    chart: {
      renderTo: 'container',
      type: 'spline'
    },
    credits: {
      enabled: false
    },
    title: {
      text: 'Course Rating'
    },
    xAxis: {
      categories: ['Apples', 'Bananas', 'Oranges']
    },
    yAxis: {
      title: {
      text: 'Score'
    }
    },
    series: [{
      name: 'Jane',
      data: [1, 0, 4]
      }, {
      name: 'John',
      data: [5, 7, 3]
    }]
  });
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
  sectionData = data;
  for(var i = 0; i < sectionData.length; i++) {
    var organizedSection = organizedSections[sectionName(sectionData[i].section)];
    if(organizedSection === undefined) {
      organizedSections[sectionName(sectionData[i].section)] = []
    }

    organizedSections[sectionName(sectionData[i].section)].push(sectionData[i]);
  }
}

function sectionName(section) {
  return [section.professor.title, section.subject.title.split(' ')[0], section.title.title].join(' ');
}
