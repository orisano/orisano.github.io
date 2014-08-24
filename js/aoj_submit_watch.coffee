
$(() ->
  class AOJLib
    @BASE_URL = "http://judge.u-aizu.ac.jp/onlinejudge/webservice/"

    constractor: () ->

    getStatus: (user) ->
      @_reqAPI "status_log", {user_id: user}, @_parseStatus

    getStatusList: (userList) ->
      promises = (@getStatus user for user in userList)
      $.when.apply($, promises)

    _getXML: (url, params) ->
      $.ajax({
        type: "GET",
        url: url,
        data: params,
        dataType: "xml",
      })

    _getParsed: (url, params, parseFunc) ->
      dfd = $.Deferred()
      @_getXML(url, params).done((xml) ->
        dfd.resolve parseFunc(xml)
      ).fail(() ->
        dfd.reject()
      )
      dfd.promise()

    _reqAPI: (api, params={}, parseFunc=$.noop) ->
      @_getParsed AOJLib.BASE_URL + api, params, parseFunc

    _parseXML: (xml, schema) ->
      xml = $ xml
      element = {}
      for name, f of schema
        names = name.split ">"
        key = names[names.length - 1]
        element[key] = f xml.find(name).text()
      element

    _parseStatus: (xml) =>
      statusList = $(xml).find "status_list>status"
      (@_parseXML(status, {
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
      }) for status in statusList)

  aojLib = new AOJLib()
  submitLogTemplate = _.template '<tr class="dat" style="display: table-row; background-color: rgb(255, 255, 255);"><td class="text-left"><a href="http://judge.u-aizu.ac.jp/onlinejudge/review.jsp?rid=<%= run_id %>&tab=1"><%= run_id %></a></td><td class="text-left"><a href="http://judge.u-aizu.ac.jp/onlinejudge/user.jsp?id=<%= user_id %>#1"><%= user_id %></a></td><td class="text-left" style="line-height:12pt; padding-bottom:4px"><a href="http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=<%= problem_id %>"><%= problem_id %> </a></td><td class="detail_link" href="verdict.jsp?runID=<%= run_id %>" title="<%= run_id %>"><a><%= status %></a></td><td class="text-left"><a href="http://judge.u-aizu.ac.jp/onlinejudge/status_note.jsp?tab=2"><%= language %></a></td><td class="text-center"><%= cputime %> ms</td><td class="text-right" style="line-height:12pt; padding-bottom:4px"><%= memory %> KB</td><td class="text-right" style="line-height:12pt; padding-bottom:4px"><%= code_size %> B</td><td class="text-center" style="line-height: 12pt; padding-bottom: 4px; border-right-style: none;"><%= submission_date_str %></td>'

  appendSubmitLog = (submitLog, start=0, end) ->
    end ||= submitLog.length
    for i in [start ... end]
      $(".tablewrapper").append submitLogTemplate(submitLog[i])
    0

  $.getJSON("users.json").done((json) ->
    users = json["users"]
    $.when(aojLib.getStatusList(users), {}).done((statusList) ->
      console.log statusList
      allStatus = Array.prototype.concat.apply([], statusList)
      console.log allStatus
      allStatus.sort (a, b) ->
        b.submission_date - a.submission_date
      appendSubmitLog allStatus, 0, 100
    )
  )
)
