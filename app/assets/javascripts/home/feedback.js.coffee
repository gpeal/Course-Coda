# this is actually done in the first call to formatSelection
window.populateFeedbackSelect = (sections) ->
  select = $("#feedback-section-select")
  Object.keys(sections).forEach (key) ->
    select.append "<optgroup label=\"" + key + "\"></optgroup>"
    optgroup = $("#feedback-section-select optgroup:last")
    sections[key].sort (a, b) ->
      if a.year.title < b.year.title
        return -1
      else return 1  if a.year.title > b.year.title
      quarterHash =
        Winter: 0
        Spring: 1
        Summer: 2
        Fall: 3

      quarterHash[a.quarter.title] - quarterHash[b.quarter.title]

    sections[key].forEach (section) ->
      optgroup.append "<option value=\"" + section.id + "\">" + section.quarter.title + " " + section.year.title + "</option>"
      return

    return

  return
formatSelection = (item) ->
  return "Choose a section"  if item.id is `undefined`
  $(item.element).parent()[0].label + " " + item.text
feedbackSectionSelected = (e) ->
  $("#feedback-holder").css "display", "none"
  $.ajax
    url: "api/v1/feedback/" + e.val + ".json"
    dataType: "json"
    type: "POST"
    success: loadFeedbackData

  return
loadFeedbackData = (data) ->
  $("#feedback-holder").css "display", "block"
  keywords = data.keywords
  tableBody = $("#keywords-table > tbody:last")
  td = $("#keywords-table td:first")
  td.text ""
  keywords.forEach (keyword) ->
    td.append keyword + ", "
    return

  td.text td.text().slice(0, -1)
  sentiment = data.sentiment
  tableBody = $("#keywords-table > tbody:last")
  td = $("#keywords-table td:last")
  td.text ""
  td.append sentiment + "%"
  feedback = data.feedback
  tableBody = $("#feedback-table > tbody:last")
  tableBody.find("tr").remove()
  feedback.forEach (feedback) ->
    tableBody.append "<tr><td><span>" + feedback.feedback + "</span></td></tr>"
    return

  return
$(document).ready ->
  $("#feedback-section-select").select2
    placeholder: "Choose a section"
    formatSelection: formatSelection

  $("#feedback-section-select").on "change", feedbackSectionSelected
  return
