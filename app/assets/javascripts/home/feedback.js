$(document).ready(function() {
  $('#feedback-section-select').select2({
    placeholder: 'Choose a section', // this is actually done in the first call to formatSelection
    formatSelection: formatSelection
  });
  $('#feedback-section-select').on('change', feedbackSectionSelected);
});

function populateFeedbackSelect(sections) {
  var select = $('#feedback-section-select');
  Object.keys(sections).forEach(function(key) {
    select.append('<optgroup label="' + key + '"></optgroup>');
    var optgroup = $('#feedback-section-select optgroup:last');

    sections[key].sort(function(a,b) {
      if(a.year.title < b.year.title)
        return -1;
      else if(a.year.title > b.year.title)
        return 1;
      quarterHash = {
        Winter: 0,
        Spring: 1,
        Summer: 2,
        Fall: 3
      }
      return quarterHash[a.quarter.title] - quarterHash[b.quarter.title];
    });

    sections[key].forEach(function(section) {
      optgroup.append('<option value="' + section.id + '">' + section.quarter.title + ' ' + section.year.title + '</option>');
      console.log('adding to optgroup: ' + optgroup.label);
    })
  });
}

function formatSelection(item) {
  if(item.id === undefined)
    return 'Choose a section'

  return $(item.element).parent()[0].label + ' ' + item.text
}

function feedbackSectionSelected(e) {
  $.ajax({
    url: 'api/v1/feedback/' + e.val + '.json',
    dataType: 'json',
    type: 'POST',
    success: loadFeedbackData
  });
}

function loadFeedbackData(data) {
  var keywords = data.keywords;
  var tableBody = $('#keywords-table > tbody:last')
  var td = $('#keywords-table td:first');
  td.text('');
  keywords.forEach(function(keyword) {
    td.append(keyword + ', ');
  });

  var sentiment = data.sentiment;
  tableBody = $('#keywords-table > tbody:last')
  td = $('#keywords-table td:last');
  td.text('');
  td.append(sentiment + '%');


  var feedback = data.feedback
  tableBody = $('#feedback-table > tbody:last')
  tableBody.find('tr').remove();
  feedback.forEach(function(feedback) {
    tableBody.append('<tr><td><span>' + feedback.feedback + '</span></td></tr>');
  });
}