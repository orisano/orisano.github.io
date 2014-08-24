$(() ->
  aojLib = new AOJLib()

  solveTemplate = _.template '<td><a target="_blank" href="http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=<%= id %>"><%= id %></a></td>'
  tweetTemplate = _.template '<%= rivalName %>さんと私は<%= bothCount %>問一緒に解いていて、<%= myOnlyCount %>問が私だけ解いていて <%= rivalOnlyCount %>問が<%= rivalName %>さんだけが解いています http://orisano.github.io/aoj_compare'
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
    tweet = tweetTemplate({rivalName: rivalId, bothCount: both.length, myOnlyCount: myOnly.length, rivalOnlyCount: rivalOnly.length})
    $(".tweet").attr("href", 'https://twitter.com/intent/tweet?text=' + tweet)


  compareSolved = (myId, rivalId) ->
    aojLib.getSolvesList([myId, rivalId]).done((mySolveIds, rivalSolveIds) ->
      lowwer = (a, b) ->
        parseInt(a) - parseInt(b)

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

  $("#compare-button").click(() ->
    myId = $("#my-id").val()
    rivalId = $("#rival-id").val()
    compareSolved myId, rivalId
  )
)

