$(function() {
  var aojLib, userTemplate;
  aojLib = new AOJLib();
  userTemplate = _.template('<tr><td><a target="_blank" href="aoj_compare.html?rivalId=<%= id %>"><%= id %></a> <a href="aoj_submit_watch.html#<%= id %>" target="_blank">Log</a></td><td><%= solved %></td></tr>');
  return $.getJSON("users.json").done(function(json) {
    var users;
    users = json["users"];
    return $.when(aojLib.getSolveList(users), {}).done(function(solveList) {
      var context, solver, _i, _len;
      solveList.sort(function(a, b) {
        if (a.solved === b.solved) {
          if (a.id < b.id) {
            return -1;
          }
          if (a.id > b.id) {
            return 1;
          }
          return 0;
        }
        return a.solved - b.solved;
      });
      context = document.getElementById("solved-graph").getContext("2d");
      for (_i = 0, _len = solveList.length; _i < _len; _i++) {
        solver = solveList[_i];
        $("table#watch-table").append(userTemplate(solver));
      }
      return new Chart(context).Bar({
        labels: (function() {
          var _j, _len1, _results;
          _results = [];
          for (_j = 0, _len1 = solveList.length; _j < _len1; _j++) {
            solver = solveList[_j];
            _results.push(solver.id);
          }
          return _results;
        })(),
        datasets: [
          {
            data: (function() {
              var _j, _len1, _results;
              _results = [];
              for (_j = 0, _len1 = solveList.length; _j < _len1; _j++) {
                solver = solveList[_j];
                _results.push(solver.solved);
              }
              return _results;
            })()
          }
        ]
      });
    });
  });
});
