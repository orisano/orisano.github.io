$(() ->
  aojLib = new AOJLib()

  userTemplate = _.template('<tr><td><a target="_blank" href="aoj_compare.html?rivalId=<%= id %>"><%= id %></a> <a href="aoj_submit_watch.html#<%= id %>" target="_blank">Log</a></td><td><%= solved %></td></tr>')
  $.getJSON("users.json").done((json) ->
    users = json["users"]
    $.when(aojLib.getSolveList(users), {}).done((solveList) ->

      solveList.sort (a, b) ->
        if a.solved == b.solved
          if a.id < b.id
            return -1
          if a.id > b.id
            return 1
          return 0
        return a.solved - b.solved
      
      context = document.getElementById("solved-graph").getContext("2d")
      for solver in solveList
        $("table#watch-table").append(userTemplate(solver))
      new Chart(context).Bar({
        labels: (solver.id for solver in solveList),
        datasets: [{
          data: (solver.solved for solver in solveList),
        }]
      })
    )
  )
)

