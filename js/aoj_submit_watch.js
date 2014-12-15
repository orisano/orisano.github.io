$(function() {
  var aojLib, appendSubmitLog, cache, getSubmitLog, hash_users, submitLogTemplate;
  aojLib = new AOJLib();
  submitLogTemplate = _.template('<tr class="dat" style="display: table-row; background-color: rgb(255, 255, 255);"><td class="text-left"><a href="http://judge.u-aizu.ac.jp/onlinejudge/review.jsp?rid=<%= run_id %>&tab=1"><%= run_id %></a></td><td class="text-left"><a href="http://judge.u-aizu.ac.jp/onlinejudge/user.jsp?id=<%= user_id %>#1"><%= user_id %></a></td><td class="text-left" style="line-height:12pt; padding-bottom:4px"><a href="http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=<%= problem_id %>"><%= problem_id %> </a></td><td class="detail_link" href="verdict.jsp?runID=<%= run_id %>" title="<%= run_id %>"><a><%= status %></a></td><td class="text-left"><a href="http://judge.u-aizu.ac.jp/onlinejudge/status_note.jsp?tab=2"><%= language %></a></td><td class="text-center"><%= cputime %> ms</td><td class="text-right" style="line-height:12pt; padding-bottom:4px"><%= memory %> KB</td><td class="text-right" style="line-height:12pt; padding-bottom:4px"><%= code_size %> B</td><td class="text-center" style="line-height: 12pt; padding-bottom: 4px; border-right-style: none;"><%= submission_date_str %></td></tr>');
  appendSubmitLog = function(submitLog, start, end) {
    var el, i, _i;
    if (start == null) {
      start = 0;
    }
    end || (end = submitLog.length);
    if (end > submitLog.length) {
      end = submitLog.length;
    }
    el = "";
    for (i = _i = start; _i < end; i = _i += 1) {
      el += submitLogTemplate(submitLog[i]);
    }
    return $(".tablewrapper").append(el);
  };
  getSubmitLog = function(users) {
    return $.when(aojLib.getStatusList(users), {}).done(function(statusList) {
      var allStatus, cache;
      allStatus = Array.prototype.concat.apply([], statusList, cache);
      allStatus = _.uniq(allStatus);
      allStatus.sort(function(a, b) {
        return b.submission_date - a.submission_date;
      });
      localStorage.setItem("cache", JSON.stringify(allStatus));
      cache = allStatus;
      $(".dat").remove();
      return appendSubmitLog(allStatus, 0, 100);
    });
  };
  cache = $.parseJSON(localStorage.getItem("cache"));
  if (cache) {
    appendSubmitLog(cache, 0, 30);
  }
  hash_users = location.hash.substr(1).split(",");
  if (hash_users.length > 1) {
    return getSubmitLog(hash_users);
  } else {
    return $.getJSON("users.json").done(function(json) {
      return getSubmitLog(json["users"]);
    });
  }
});
