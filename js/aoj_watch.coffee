
$(() ->
  getSolved = (username, callback) ->
    API_URL = "http://judge.u-aizu.ac.jp/onlinejudge/webservice/user?id="
    request_url = API_URL + username
    $.ajax({
      url: request_url,
      type: "get",
      dataType: "xml",
      success: (xml, status) ->
        uname  = $(xml).find("user > id").text()
        solved = $(xml).find("user > status > solved").text()
        callback(uname, solved, status)
    })
    return 0

  users = ["raimei10130", "kagamiz", "orisano", "li_saku", "marin72_com", "shogo1996"]
  user_template = _.template("<tr><td><%= uname %></td><td><%= solved %></td></tr>")

  looper = null
  looper = (ready_user, processed_user, callback) ->
    if ready_user.length == 0
      callback(processed_user)
    else
      uname = ready_user.shift()
      getSolved(uname, (name, solve, status) ->
        processed_user.push({uname: name, solved: parseInt(solve)})
        looper(ready_user, processed_user, callback)
      )

  looper(users, [], (ulist) ->
    context = document.getElementById("solved-graph").getContext("2d")
    ulist.sort((a, b) ->
      if a.solved == b.solved
        if a.uname < b.uname
          return -1
        if a.uname > b.uname
          return 1
        return 0
      return a.solved - b.solved
    )
    _.each(ulist, (item) ->
      $("table#watch-table").append(user_template(item))
    )
    new Chart(context).Bar({
      labels: _.map(ulist, (usr) ->
        return usr.uname
      ),
      datasets: [{
        data: _.map(ulist, (usr) ->
          return usr.solved
        )
      }]
    })
  )
)

