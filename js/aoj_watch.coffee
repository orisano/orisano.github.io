$(() ->
  API_URL = "http://judge.u-aizu.ac.jp/onlinejudge/webservice/"
  USERS = ["fouga", "matetya911", "seungri", "ringoh72", "m_kyoujyu", "oken", "harekumo", "raimei10130", "kagamiz", "orisano", "li_saku", "marin72_com", "shogo1996", "Cmiz56", "defective"]

  get_api = (req_url) ->
    dfd = $.Deferred()
    $.ajax({
      type: "GET",
      url: req_url,
      dataType: "xml",
    }).done((res) ->
      dfd.resolve(res)
    ).fail((res) ->
      dfd.reject(res)
    )
    return dfd.promise()

  get_solve = (user) ->
    USER_API_URL = API_URL + "user?id="
    return get_api(USER_API_URL + user)

  get_solves = (user_list) ->
    dfds = (get_solve(user) for user in user_list)
    return $.when.apply($, dfds)
  
  parse_xml = (xml, scheme) ->
    xml = $(xml)
    element = {}
    for name, f of scheme
      names = name.split(">")
      key = names[names.length - 1]
      element[key] = f(xml.find(name).text())
    return element

  parse_solve = (xml) ->
    return parse_xml(xml, {"user>id": String, "user>status>solved": parseInt})

  user_template = _.template("<tr><td><%= id %></td><td><%= solved %></td></tr>")
  $.when(get_solves(USERS), {}).done((solves_xml) ->
    solves = (parse_solve(solve_xml) for solve_xml in solves_xml)
    solves.sort((a, b) ->
      if a.solved == b.solved
        if a.id < b.id
          return -1
        if a.id > b.id
          return 1
        return 0
      return a.solved - b.solved
    )
    context = document.getElementById("solved-graph").getContext("2d")
    for solver in solves
      $("table#watch-table").append(user_template(solver))
    new Chart(context).Bar({
      labels: (solver.id for solver in solves),
      datasets: [{
        data: (solver.solved for solver in solves),
      }]
    })
  )
)

