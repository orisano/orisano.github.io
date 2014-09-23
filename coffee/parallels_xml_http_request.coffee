class ParallelXMLHttpRequest
  constractor: () ->

  get: (url, params={}) ->
    code = """
    var that = self;
    self.addEventListener("message", function(e){
      var url = e.data.url;
      var req = new XMLHttpRequest();
      req.onreadystatechange = function(){
        if (req.readyState == 4){
          that.postMessage({"response": req.responseText});
        }
      }
      req.open("GET", url)
      req.send()
    }, false);
    """
    dfd = $.Deferred()
    bb = new Blob([code], {
      "type": "text/javascript"
    })
    blobURL = URL.createObjectURL(bb)
    worker = new Worker(blobURL)
    worker.addEventListener("message", (e) ->
      if e.data.response == null
        dfd.reject()
      else
        dfd.resolve(e.data.response)
      URL.revokeObjectURL(blobURL)
    , false)
    
    pairs = []
    for k, v of params
      pairs.push(k + "=" + v)
    query = pairs.join("&")
    if query != ""
      url += "?" + query
    worker.postMessage({"url": url})
    dfd.promise()
