$(document).ready(function() {
  var select = $('#feedback-section-select');
  select.select2({
    placeholder: 'Choose a section', // this is actually done in the first call to formatSelection
    formatSelection: formatSelection
  });
  select.bind('change', feedbackSectionSelected);
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

function feedbackSectionSelected(item) {
  function requestData() {
    $.ajax({
      url: 'api/v1/feedback.json',
      dataType: 'json',
      type: 'POST',
      data: 's=' + item.id,
      success: loadFeedbackData
    });
  }
}

function loadFeedbackData(data) {

}