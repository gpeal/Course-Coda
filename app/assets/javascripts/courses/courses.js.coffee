requestData = ->
  $.ajax
    url: "/api/v1/subjects/course.json"
    dataType: "json"
    type: "POST"
    data: location.search.slice(1)
    error: hideSpinner
    success: loadData

  return
hideSpinner = ->
  $("#loading").css "display", "none"
  return
loadData = (data) ->
  hideSpinner()
  $("#courses-table").css "display", "block"
  dataSource = new StaticDataSource(
    columns: [
      {
        property: "to_s"
        label: "Title"
        sortable: true
      }
      {
        property: "course_num_2"
        label: "Course Number"
        sortable: true
      }
      {
        property: "average_course"
        label: "Course"
        sortable: true
      }
      {
        property: "average_instruction"
        label: "Instruction"
        sortable: true
      }
      {
        property: "average_learned"
        label: "Amount Learned"
        sortable: true
      }
      {
        property: "average_stimulated"
        label: "Amount Stimulated"
        sortable: true
      }
      {
        property: "average_challenged"
        label: "Amount Challenged"
        sortable: true
      }
      {
        property: "average_hours"
        label: "Average Hours/Week"
        sortable: true
      }
      {
        property: "enrollment_count"
        label: "Responses"
        sortable: true
      }
    ]
    data: data
  )
  $("#courses-table").datagrid dataSource: dataSource
  return
$(document).ready ->
  requestData()
  return
