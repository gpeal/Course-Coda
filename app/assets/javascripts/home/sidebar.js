$(document).ready(function() {
  setupSelect2('search-professor', '/api/v1/professors/search.json', 'Professor', 'title', 100);
  setupSelect2('search-title', '/api/v1/titles/search.json', 'Course Title', 'to_s', 1000);

   $('#search-button').bind('click', search);
});


function search() {
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

function select2ToQueryParams(id, queryParamId) {
  var queryString = '';
  professors = $('#' + id).select2('data');
  if(professors.length > 0) {
    queryString += queryParamId + '='
    for(var i = 0; i < professors.length; i++) {
      queryString += professors[i].id + ',';
    }
    queryString = queryString.slice(0, -1);
  }
  return queryString;
}

function setupSelect2(id, url, placeholder, titleProperty, quietMillis) {
  $('#' + id).select2({
       formatSelection: function(item) {
         return item[titleProperty];
       },
       formatResult: function(item) {
         return item[titleProperty];
       },
       minimumInputLength: 2,
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