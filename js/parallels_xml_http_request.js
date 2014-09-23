var ParallelXMLHttpRequest;

ParallelXMLHttpRequest = (function() {
  function ParallelXMLHttpRequest() {}

  ParallelXMLHttpRequest.prototype.constractor = function() {};

  ParallelXMLHttpRequest.prototype.get = function(url, params) {
    var bb, blobURL, code, dfd, k, pairs, query, v, worker;
    if (params == null) {
      params = {};
    }
    code = "var that = self;\nself.addEventListener(\"message\", function(e){\n  var url = e.data.url;\n  var req = new XMLHttpRequest();\n  req.onreadystatechange = function(){\n    if (req.readyState == 4){\n      that.postMessage({\"response\": req.responseText});\n    }\n  }\n  req.open(\"GET\", url)\n  req.send()\n}, false);";
    dfd = $.Deferred();
    bb = new Blob([code], {
      "type": "text/javascript"
    });
    blobURL = URL.createObjectURL(bb);
    worker = new Worker(blobURL);
    worker.addEventListener("message", function(e) {
      if (e.data.response === null) {
        dfd.reject();
      } else {
        dfd.resolve(e.data.response);
      }
      return URL.revokeObjectURL(blobURL);
    }, false);
    pairs = [];
    for (k in params) {
      v = params[k];
      pairs.push(k + "=" + v);
    }
    query = pairs.join("&");
    if (query !== "") {
      url += "?" + query;
    }
    worker.postMessage({
      "url": url
    });
    return dfd.promise();
  };

  return ParallelXMLHttpRequest;

})();
