$(() ->
  aojLib = new AOJLib()

  solveTemplate = _.template '<td><a target="_blank" href="http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=<%= id %>"><%= id %></a></td>'
  tweetTemplate = _.template '<%= rivalName %>さんと私は<%= bothCount %>問共通の問題を解いていて、<%= myOnlyCount %>問が私だけ解いていて <%= rivalOnlyCount %>問が<%= rivalName %>さんだけが解いています http://orisano.github.io/aoj_compare?myId=<%= myName %>%26rivalId=<%= rivalName %>'
  tweetTag = ""
  appendSolved = (list, tableName, nlspan=10) ->
    count = 0
    tr = $("<tr></tr>")
    for x in list
      tr.append solveTemplate({id: x})
      count += 1
      if count >= nlspan
        count = 0
        $(tableName).append tr
        tr = $("<tr></tr>")
    if count != 0
      $(tableName).append tr
    0

  updateTweetButton = (myId, rivalId, both, myOnly, rivalOnly) ->
    tweet = tweetTemplate({myName: myId, rivalName: rivalId, bothCount: both.length, myOnlyCount: myOnly.length, rivalOnlyCount: rivalOnly.length})
    $(".tweet").attr("href", 'https://twitter.com/intent/tweet?text=' + tweet)


  compareSolved = (myId, rivalId) ->
    aojLib.getSolvesList([myId, rivalId]).done((mySolveIds, rivalSolveIds) ->
      lowwer = (a, b) ->
        parseInt(a) - parseInt(b)

      $("table>tbody>").remove()
      mySolveIds.sort lowwer
      rivalSolveIds.sort lowwer
      bothSolveIds = _.intersection mySolveIds, rivalSolveIds
      myOnlySolveIds = _.difference mySolveIds, rivalSolveIds
      rivalOnlySolveIds = _.difference rivalSolveIds, mySolveIds

      appendSolved bothSolveIds, "#both-table"
      appendSolved myOnlySolveIds, "#my-only-solve-table"
      appendSolved rivalOnlySolveIds, "#rival-only-solve-table"

      updateTweetButton myId, rivalId, bothSolveIds, myOnlySolveIds, rivalOnlySolveIds
      0
    )

  enterEvent = () ->
    myId = $("#my-id").val()
    rivalId = $("#rival-id").val()
    compareSolved myId, rivalId
  
  keypressEvent = (event) ->
    if event.which == 13
      enterEvent()

  $("#compare-button").click enterEvent
  $("#my-id").keypress keypressEvent
  $("#rival-id").keypress keypressEvent

  getParams = (query) ->
    ret = {}
    params = query.substring(1).split '&'
    for param in params
      keySearch = param.indexOf '='
      if keySearch != -1
        key = param.substring 0, keySearch
        val = param.substring keySearch + 1
        ret[key] = decodeURI val
    ret
  params = getParams location.search
  if params?.myId? and params?.rivalId?
    $("#my-id").val params.myId
    $("#rival-id").val params.rivalId
    enterEvent()
)

