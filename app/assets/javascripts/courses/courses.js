$(document).ready(function() {
  requestData();
})

function requestData() {
  $.ajax({
    url: '/api/v1/subjects/course.json',
    dataType: 'json',
    type: 'POST',
    data: location.search.slice(1),
    success: loadData
  });
}

function loadData(data) {
  var dataSource = new StaticDataSource({
    columns: [
    {
      property: 'course_num_2',
      label: 'Course Number',
      sortable: true
    },
    {
      property: 'name',
      label: 'Course',
      sortable: true
    },
    {
      property: 'average_challenged',
      label: 'Challenged',
      sortable: true
    },
    {
      property: 'average_instruction',
      label: 'Instruction',
      sortable: true
    },
    {
      property: 'average_learned',
      label: 'Amount Learned',
      sortable: true
    },
    {
      property: 'average_stimulated',
      label: 'Amount Stimulated',
      sortable: true
    },
    {
      property: 'average_challenged',
      label: 'Amount Challenged',
      sortable: true
    },
    {
      property: 'average_hours',
      label: 'Average Hours/Week',
      sortable: true
    }
    ],
    data: data
  });
  $('#courses-table').datagrid({dataSource: dataSource});
}