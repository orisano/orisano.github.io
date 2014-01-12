$(function(){
	var apiUrl = "http://judge.u-aizu.ac.jp/onlinejudge/webservice/user?id=";
	var users = ["raimei10130", "kagamiz", "orisano"];
	var userTemplate = _.template("<tr><td><%= name %></td><td><%= solved %></td></tr>");
	for (var i = 0; i < users.length; ++i){
		$.ajax({
			url: apiUrl + users[i],
			type: 'get',
			dataType: 'xml',
			success: function(xml, status){
				var username = $(xml).find("user > id").text();
				var solved = $(xml).find("user > status > solved").text();
				$("#watch-table").append(userTemplate({name: username, solved: solved}));
			}
		});
	}
});