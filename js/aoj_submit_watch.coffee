
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

  get_status = (user) ->
    STATUS_API_URL = API_URL + "status_log?user_id="
    return get_api(STATUS_API_URL + user)

  get_status_list = (user_list) ->
    dfds = (get_status(user) for user in user_list)
    return $.when.apply($, dfds)

  parse_xml = (xml, scheme) ->
    xml = $(xml)
    element = {}
    for name, f of scheme
      names = name.split(">")
      key = names[names.length - 1]
      element[key] = f(xml.find(name).text())
    return element

  parse_status = (xml) ->
    status_list = $(xml).find("status_list>status")
    return (parse_xml(status, {
      "status>run_id": String, 
      "status>problem_id": String, 
      "status>language": String,
      "status>cputime": parseInt,
      "status>memory": parseInt,
      "status>code_size": parseInt,
      "status>user_id": String,
      "status>status": String,
      "status>submission_date": parseInt,
      "status>submission_date_str": String,
    }) for status in status_list)

  submit_log_template = _.template('<tr class="dat" style="display: table-row; background-color: rgb(255, 255, 255);"><td class="text-left"><a href="http://judge.u-aizu.ac.jp/onlinejudge/review.jsp?rid=<%= run_id %>&tab=1"><%= run_id %></a></td><td class="text-left"><a href="http://judge.u-aizu.ac.jp/onlinejudge/user.jsp?id=<%= user_id %>#1"><%= user_id %></a></td><td class="text-left" style="line-height:12pt; padding-bottom:4px"><a href="http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=<%= problem_id %>"><%= problem_id %> </a></td><td class="detail_link" href="verdict.jsp?runID=<%= run_id %>" title="<%= run_id %>"><a><%= status %></a></td><td class="text-left"><a href="http://judge.u-aizu.ac.jp/onlinejudge/status_note.jsp?tab=2"><%= language %></a></td><td class="text-center"><%= cputime %> ms</td><td class="text-right" style="line-height:12pt; padding-bottom:4px"><%= memory %> KB</td><td class="text-right" style="line-height:12pt; padding-bottom:4px"><%= code_size %> B</td><td class="text-center" style="line-height: 12pt; padding-bottom: 4px; border-right-style: none;"><%= submission_date_str %></td>')
  $.when(get_status_list(USERS), {}).done((status_list_xml) ->
    status_list = (parse_status(status_xml) for status_xml in status_list_xml)
    all_status = []
    for status in status_list
      for s in status
        all_status.push(s)

    all_status.sort((a, b) ->
      return b.submission_date - a.submission_date
    )
    for status in all_status
      $(".tablewrapper").append(submit_log_template(status))
  )
)
