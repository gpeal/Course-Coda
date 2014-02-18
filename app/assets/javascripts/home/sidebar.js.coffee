search = ->
  queryString = "/?"
  pParams = select2ToQueryParams("search-professor", "p")
  queryString = queryString.concat(pParams, "&")  unless pParams is ""
  tParams = select2ToQueryParams("search-title", "t")
  queryString = queryString.concat(tParams, "&")  unless tParams is ""
  queryString = queryString.slice(0, -1)
  window.location = queryString
  return
select2ToQueryParams = (id, queryParamId) ->
  professors = $("#" + id).select2("data")
  ids = professors.map((p) ->
    p.id
  ).toString()
  if ids.length is 0
    ""
  else
    queryParamId + "=" + ids
select2ToString = (id) ->
  values = $("#" + id).select2("data")
  values.map((p) ->
    p.title
  ).toString()
setupSelect2 = (id, url, placeholder, titleProperty, quietMillis) ->
  $("#" + id).select2
    formatSelection: (item) ->
      item[titleProperty]

    formatResult: (item) ->
      item[titleProperty]

    minimumInputLength: 3
    multiple: true
    placeholder: placeholder
    ajax:
      url: url
      dataType: "json"
      type: "POST"
      quietMillis: quietMillis
      data: (term, page) ->
        q: term #search term

      results: (data, page) ->
        results: data.map((item) ->
          item
        )
        more: null

  return
$(document).ready ->
  setupSelect2 "search-professor", "/api/v1/professors/search.json", "Professor", "title", 1000
  setupSelect2 "search-title", "/api/v1/titles/search.json", "Course Title", "to_s", 1000
  $("#search-button").bind "click", search
  return
