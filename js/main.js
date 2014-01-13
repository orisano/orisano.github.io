$(function(){	
	var getSolved = function(username, callback){
		var apiUrl = "http://judge.u-aizu.ac.jp/onlinejudge/webservice/user?id=";
		$.ajax({
			url: apiUrl + username,
			type: 'get',
			dataType: 'xml',
			success: function(xml, status){
				var username_ = $(xml).find("user > id").text();
				var solved_ = $(xml).find("user > status > solved").text();
				callback(username_, solved_, status);
			}
		});
	}

	var users = ["raimei10130", "kagamiz", "orisano", "li_saku", "marin72_com"];
	var users_ = [];
	var solved_ = [];
	var count = 0;
	var userTemplate = _.template("<tr><td><%= name %></td><td><%= solved %></td></tr>");
	_.each(users, function(user){ getSolved(user, function(username, solved){
		$("table#watch-table").append(userTemplate({name: username, solved: solved}));
		count++;
		users_.push({name: username, solved: solved});
	});});

	var waitComplete = function(span, callback){
		if (count == users.length){
			callback();
		}
		else {
			setTimeout(function(){
				waitComplete(span, callback);
			}, span);
		}
	};
	
	waitComplete(1000, function(){
		var ctx = document.getElementById("solved-graph").getContext("2d");
		users_.sort(function(a, b){
				return a.solved - b.solved;
		});
		new Chart(ctx).Bar({
			labels: _.map(users_, function(usr){ return (usr.name) }),
			datasets : [{ data : _.map(users_, function(usr){ return (usr.solved)}) }]
		});
	});
});