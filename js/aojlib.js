var AOJLib,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

AOJLib = (function() {
  function AOJLib() {
    this._parseSolve = __bind(this._parseSolve, this);
    this._parseStatus = __bind(this._parseStatus, this);
    this._reqAPI = __bind(this._reqAPI, this);
    this._getParsed = __bind(this._getParsed, this);
    this.getStatusList = __bind(this.getStatusList, this);
    this.getStatus = __bind(this.getStatus, this);
    this.getSolvesList = __bind(this.getSolvesList, this);
    this.getSolves = __bind(this.getSolves, this);
    this.getSolveList = __bind(this.getSolveList, this);
    this.getSolve = __bind(this.getSolve, this);
  }

  AOJLib.BASE_URL = "http://judge.u-aizu.ac.jp/onlinejudge/webservice/";

  AOJLib.prototype.constractor = function() {};

  AOJLib.prototype.getSolve = function(user) {
    return this._reqAPI("user", {
      id: user
    }, this._parseSolve);
  };

  AOJLib.prototype.getSolveList = function(userList) {
    return this._getPromiseList(userList, this.getSolve);
  };

  AOJLib.prototype.getSolves = function(user) {
    return this._reqAPI("user", {
      id: user
    }, this._parseSolves);
  };

  AOJLib.prototype.getSolvesList = function(userList) {
    return this._getPromiseList(userList, this.getSolves);
  };

  AOJLib.prototype.getStatus = function(user) {
    return this._reqAPI("status_log", {
      user_id: user
    }, this._parseStatus);
  };

  AOJLib.prototype.getStatusList = function(userList) {
    return this._getPromiseList(userList, this.getStatus);
  };

  AOJLib.prototype._getPromiseList = function(list, func) {
    var promises, x;
    promises = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = list.length; _i < _len; _i++) {
        x = list[_i];
        _results.push(func(x));
      }
      return _results;
    })();
    return $.when.apply($, promises);
  };

  AOJLib.prototype._getXML = function(url, params) {
    return $.ajax({
      type: "GET",
      url: url,
      data: params,
      dataType: "xml"
    });
  };

  AOJLib.prototype._getParsed = function(url, params, parseFunc) {
    var dfd;
    dfd = $.Deferred();
    this._getXML(url, params).done(function(xml) {
      return dfd.resolve(parseFunc(xml));
    }).fail(function() {
      return dfd.reject();
    });
    return dfd.promise();
  };

  AOJLib.prototype._reqAPI = function(api, params, parseFunc) {
    if (params == null) {
      params = {};
    }
    if (parseFunc == null) {
      parseFunc = $.noop;
    }
    return this._getParsed(AOJLib.BASE_URL + api, params, parseFunc);
  };

  AOJLib.prototype._parseXML = function(xml, schema) {
    var element, f, key, name, names;
    xml = $(xml);
    element = {};
    for (name in schema) {
      f = schema[name];
      names = name.split(">");
      key = names[names.length - 1];
      element[key] = f(xml.find(name).text());
    }
    return element;
  };

  AOJLib.prototype._parseStatus = function(xml) {
    var status, statusList, _i, _len, _results;
    statusList = $(xml).find("status_list>status");
    _results = [];
    for (_i = 0, _len = statusList.length; _i < _len; _i++) {
      status = statusList[_i];
      _results.push(this._parseXML(status, {
        "status>run_id": String,
        "status>problem_id": String,
        "status>language": String,
        "status>cputime": parseInt,
        "status>memory": parseInt,
        "status>code_size": parseInt,
        "status>user_id": String,
        "status>status": String,
        "status>submission_date": parseInt,
        "status>submission_date_str": String
      }));
    }
    return _results;
  };

  AOJLib.prototype._parseSolve = function(xml) {
    xml = xml.substr(0, xml.indexOf("<solved_list>")) + "</user>";
    return this._parseXML(xml, {
      "user>id": String,
      "user>status>solved": parseInt
    });
  };

  AOJLib.prototype._parseSolves = function(xml) {
    var id, _i, _len, _ref, _results;
    _ref = $(xml).find("user>solved_list>problem>id");
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      id = _ref[_i];
      _results.push($(id).text());
    }
    return _results;
  };

  return AOJLib;

})();
