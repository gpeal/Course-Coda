$(document).ready(function() {
  setupSelect2('search-professor', '/api/v1/professors/search.json', 'Professor', 'title');
  setupSelect2('search-section-name', '/api/v1/sections/search.json', 'Section', 'to_s');

   $('#search-button').bind('click', search);
});


function search() {
  queryString = '/?';
  professors = $('#search-professor').select2('data');
  if(professors.length > 0) {
    queryString += 'p='
    for(var i = 0; i < professors.length; i++) {
      queryString += professors[i].id + ',';
    }
    queryString = queryString.slice(0, -1);
  }

  window.location = location.origin + queryString;
}

function setupSelect2(id, url, placeholder, titleProperty) {
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
         url: location.origin + url,
         dataType: 'json',
         type: 'POST',
         quietMillis: 100,
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