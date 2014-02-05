$(document).ready(function() {
  setupSelect2('search-professor', '/api/v1/professors/search.json', 'Professor', 'title', 100);
  setupSelect2('search-title', '/api/v1/titles/search.json', 'Course Title', 'to_s', 1000);

   $('#search-button').bind('click', search);
   console.log('sidebar.js')
});


function search() {
  logSearchEvent()
  var queryString = '/?';
  pParams = select2ToQueryParams('search-professor', 'p');
  if(pParams != '')
    queryString = queryString.concat(pParams, '&');
  tParams = select2ToQueryParams('search-title', 't');
  if(tParams != '')
    queryString = queryString.concat(tParams, '&');

  queryString = queryString.slice(0, -1);

  window.location =  queryString;
}

function logSearchEvent() {
  professors = $('#search-professor').select2('data').map(function(p) { return p.title}).toString()
  courses = $('#search-title').select2('data').map(function(p) { return p.to_s}).toString()
  ga('send', 'event', 'search', window.userEmail, [professors, courses].join(','))
}

function select2ToQueryParams(id, queryParamId) {
  professors = $('#' + id).select2('data');
  ids = professors.map(function(p) { return p.id}).toString()
  if (ids.length == 0) {
    return ""
  } else {
    return queryParamId + "=" + ids
  }
}

function select2ToString(id) {
  values = $('#' + id).select2('data');
  return values.map(function(p) { return p.title}).toString()
}

function setupSelect2(id, url, placeholder, titleProperty, quietMillis) {
  $('#' + id).select2({
       formatSelection: function(item) {
         return item[titleProperty];
       },
       formatResult: function(item) {
         return item[titleProperty];
       },
       minimumInputLength: 3,
       multiple: true,
       placeholder: placeholder,
       ajax: {
         url: url,
         dataType: 'json',
         type: 'POST',
         quietMillis: quietMillis,
         data: function (term, page) {
             return {
                 q: term, //search term
             };
         },
         results: function (data, page) {
             return {results: data.map(function(item) { return item}), more: null};
         }
       }
   });
}