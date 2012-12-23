function loadOverviewData(data) {
  var dataSource = new StaticDataSource({
    columns: [
    {
      property: 'professor',
      label: 'Professor',
      sortable: true
    },
    {
      property: 'title',
      label: 'Course',
      sortable: true
    },
    {
      property: 'course',
      label: 'Course',
      sortable: true
    },
    {
      property: 'instruction',
      label: 'Instruction',
      sortable: true
    },
    {
      property: 'learned',
      label: 'Amount Learned',
      sortable: true
    },
    {
      property: 'stimulated',
      label: 'Amount Stimulated',
      sortable: true
    },
    {
      property: 'challenged',
      label: 'Amount Challenged',
      sortable: true
    },
    {
      property: 'hours',
      label: 'Average Hours/Week',
      sortable: true
    }
    ],
    data: data
  });
  $('#overview-table').datagrid({dataSource: dataSource});
}

var StaticDataSource = function (options) {
  this._formatter = options.formatter;
  this._columns = options.columns;
  this._delay = options.delay || 0;
  this._data = options.data;
};

StaticDataSource.prototype = {

  columns: function () {
    return this._columns;
  },

  data: function (options, callback) {
    var self = this;

    setTimeout(function () {
      var data = $.extend(true, [], self._data);

      // SEARCHING
      if (options.search) {
        data = _.filter(data, function (item) {
          for (var prop in item) {
            if (!item.hasOwnProperty(prop)) continue;
            if (~item[prop].toString().toLowerCase().indexOf(options.search.toLowerCase())) return true;
          }
          return false;
        });
      }

      var count = data.length;

      // SORTING
      if (options.sortProperty) {
        data = _.sortBy(data, options.sortProperty);
        if (options.sortDirection === 'desc') data.reverse();
      }

      // PAGING
      var startIndex = options.pageIndex * options.pageSize;
      var endIndex = startIndex + options.pageSize;
      var end = (endIndex > count) ? count : endIndex;
      var pages = Math.ceil(count / options.pageSize);
      var page = options.pageIndex + 1;
      var start = startIndex + 1;

      data = data.slice(startIndex, endIndex);

      if (self._formatter) self._formatter(data);

      callback({ data: data, start: start, end: end, count: count, pages: pages, page: page });

    }, this._delay)
  }
};