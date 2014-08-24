class AOJLib
  @BASE_URL = "http://judge.u-aizu.ac.jp/onlinejudge/webservice/"

  constractor: () ->

  getSolve: (user) =>
    @_reqAPI "user", {id: user}, @_parseSolve

  getSolveList: (userList) =>
    @_getPromiseList userList, @getSolve

  getStatus: (user) =>
    @_reqAPI "status_log", {user_id: user}, @_parseStatus

  getStatusList: (userList) =>
    @_getPromiseList userList, @getStatus

  _getPromiseList: (list, func) ->
    promises = (func x for x in list)
    $.when.apply($, promises)

  _getXML: (url, params) ->
    $.ajax({
      type: "GET",
      url: url,
      data: params,
      dataType: "xml",
    })

  _getParsed: (url, params, parseFunc) =>
    dfd = $.Deferred()
    @_getXML(url, params).done((xml) ->
      dfd.resolve parseFunc(xml)
    ).fail(() ->
      dfd.reject()
    )
    dfd.promise()

  _reqAPI: (api, params={}, parseFunc=$.noop) =>
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

  _parseSolve: (xml) =>
    @_parseXML(xml, {
      "user>id": String,
      "user>status>solved": parseInt,
    })
