window.loadOverviewData = (data) ->
  dataSource = new StaticDataSource(
    columns: [
      {
        property: "professor"
        label: "Professor"
        sortable: true
      }
      {
        property: "title"
        label: "Course"
        sortable: true
      }
      {
        property: "course"
        label: "Course"
        sortable: true
      }
      {
        property: "instruction"
        label: "Instruction"
        sortable: true
      }
      {
        property: "learned"
        label: "Amount Learned"
        sortable: true
      }
      {
        property: "stimulated"
        label: "Amount Stimulated"
        sortable: true
      }
      {
        property: "challenged"
        label: "Amount Challenged"
        sortable: true
      }
      {
        property: "hours"
        label: "Average Hours/Week"
        sortable: true
      }
      {
        property: "sentiment"
        label: "Average Sentiment"
        sortable: true
      }
      {
        property: "responses"
        label: "Responses"
        sortable: true
      }
    ]
    data: data
  )
  $("#overview-table").datagrid dataSource: dataSource
  return

# color code the values based on how good they are
# $('#overview-table').bind('loaded', function() {
#   tds = $('#overview-table td');
#   for(var i = 0; i < tds.size(); i++) {
#     var td = tds[i];
#     var value = td.innerText;
#     if(!isNaN(value)) {
#       td.style.fontWeight = "bold";
#       if(value < 4)
#         td.style.color = 'red';
#       else if(value < 5)
#         td.style.color = 'orange';
#       else
#         td.style.color = 'green';
#     }
#   }
# })
StaticDataSource = (options) ->
  @_formatter = options.formatter
  @_columns = options.columns
  @_delay = options.delay or 0
  @_data = options.data
  return

StaticDataSource:: =
  columns: ->
    @_columns

  data: (options, callback) ->
    self = this
    setTimeout (->
      data = $.extend(true, [], self._data)

      # SEARCHING
      if options.search
        data = _.filter(data, (item) ->
          for prop of item
            continue  unless item.hasOwnProperty(prop)
            return true  if ~item[prop].toString().toLowerCase().indexOf(options.search.toLowerCase())
          false
        )
      count = data.length

      # SORTING
      if options.sortProperty
        data = _.sortBy(data, options.sortProperty)
        data.reverse()  if options.sortDirection is "desc"

      # PAGING
      startIndex = options.pageIndex * options.pageSize
      endIndex = startIndex + options.pageSize
      end = (if (endIndex > count) then count else endIndex)
      pages = Math.ceil(count / options.pageSize)
      page = options.pageIndex + 1
      start = startIndex + 1
      data = data.slice(startIndex, endIndex)
      self._formatter data  if self._formatter
      callback
        data: data
        start: start
        end: end
        count: count
        pages: pages
        page: page

      return
    ), @_delay
    return