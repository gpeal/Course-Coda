$(document).ready(function() {
   $("#e9").select2({
        minimumInputLength: 1,
        multiple: true,
        placeholder: "Start Typing",
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
              return {results: data.movies, more: more};
          }
      },
    });
});
