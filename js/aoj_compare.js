// Generated by CoffeeScript 1.7.1
$(function() {
  var aojLib, appendSolved, compareSolved, enterEvent, keypressEvent, solveTemplate, tweetTag, tweetTemplate, updateTweetButton;
  aojLib = new AOJLib();
  solveTemplate = _.template('<td><a target="_blank" href="http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=<%= id %>"><%= id %></a></td>');
  tweetTemplate = _.template('<%= rivalName %>さんと私は<%= bothCount %>問共通の問題を解いていて、<%= myOnlyCount %>問が私だけ解いていて <%= rivalOnlyCount %>問が<%= rivalName %>さんだけが解いています http://orisano.github.io/aoj_compare');
  tweetTag = "";
  appendSolved = function(list, tableName, nlspan) {
    var count, tr, x, _i, _len;
    if (nlspan == null) {
      nlspan = 10;
    }
    count = 0;
    tr = $("<tr></tr>");
    for (_i = 0, _len = list.length; _i < _len; _i++) {
      x = list[_i];
      tr.append(solveTemplate({
        id: x
      }));
      count += 1;
      if (count >= nlspan) {
        count = 0;
        $(tableName).append(tr);
        tr = $("<tr></tr>");
      }
    }
    if (count !== 0) {
      $(tableName).append(tr);
    }
    return 0;
  };
  updateTweetButton = function(myId, rivalId, both, myOnly, rivalOnly) {
    var tweet;
    tweet = tweetTemplate({
      rivalName: rivalId,
      bothCount: both.length,
      myOnlyCount: myOnly.length,
      rivalOnlyCount: rivalOnly.length
    });
    return $(".tweet").attr("href", 'https://twitter.com/intent/tweet?text=' + tweet);
  };
  compareSolved = function(myId, rivalId) {
    return aojLib.getSolvesList([myId, rivalId]).done(function(mySolveIds, rivalSolveIds) {
      var bothSolveIds, lowwer, myOnlySolveIds, rivalOnlySolveIds;
      lowwer = function(a, b) {
        return parseInt(a) - parseInt(b);
      };
      $("table>tbody>").remove();
      mySolveIds.sort(lowwer);
      rivalSolveIds.sort(lowwer);
      bothSolveIds = _.intersection(mySolveIds, rivalSolveIds);
      myOnlySolveIds = _.difference(mySolveIds, rivalSolveIds);
      rivalOnlySolveIds = _.difference(rivalSolveIds, mySolveIds);
      appendSolved(bothSolveIds, "#both-table");
      appendSolved(myOnlySolveIds, "#my-only-solve-table");
      appendSolved(rivalOnlySolveIds, "#rival-only-solve-table");
      updateTweetButton(myId, rivalId, bothSolveIds, myOnlySolveIds, rivalOnlySolveIds);
      return 0;
    });
  };
  enterEvent = function() {
    var myId, rivalId;
    myId = $("#my-id").val();
    rivalId = $("#rival-id").val();
    return compareSolved(myId, rivalId);
  };
  keypressEvent = function(event) {
    if (event.which === 13) {
      return enterEvent();
    }
  };
  $("#compare-button").click(enterEvent);
  $("#my-id").keypress(keypressEvent);
  return $("#rival-id").keypress(keypressEvent);
});
