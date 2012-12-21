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
    var optgroup = $('#feedback-section-select optgroup');
    sections[key].forEach(function(section) {
      optgroup.append('<option value="' + section.id + '">' + section.quarter.title + ' ' + section.year.title + '</option>');
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
  var tableBody = $('#feedback-table > tbody:last')
  tableBody.find('tr').remove();
  data.forEach(function(feedback) {
    tableBody.append('<tr><td>' + feedback.feedback + '</td></tr>');
  });
}