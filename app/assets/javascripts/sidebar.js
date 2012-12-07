$(document).ready(function() {
   $('#search-professor').select2({
        formatSelection: function(item) {
          return item.title;
        },
        formatResult: function(item) {
          return item.title;
        },
        minimumInputLength: 2,
        multiple: true,
        placeholder: 'Professor',
        ajax: {
          url: location.origin + '/api/v1/professors/search.json',
          dataType: 'json',
          type: 'POST',
          quietMillis: 100,
          data: function (term, page) {
              return {
                  q: term, //search term
              };
          },
          results: function (data, page) {
              return {results: data.map(function(item) { return item.professor}), more: null};
          }
        }
    });

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
