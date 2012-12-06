$(document).ready(function() {
   $("#e9").select2({
        formatSelection: function(item) {
          return item.title;
        },
        formatResult: function(item) {
          return item.title;
        },
        minimumInputLength: 2,
        multiple: true,
        ajax: {
          url: location.origin + "/api/v1/query.json",
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
});
