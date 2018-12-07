({
	doInit: function (component, event) {
		this.fetchRssFeedData(component, event);
		// this.fetchTwitterFeedData(component, event);
	},
	fetchRssFeedData: function (component, event) {
		var action = component.get("c.makeXmlHttpGetRequest");
		var url = "https://www.carrier.com/commercial/en/us/news/RSSFeed.aspx";

		action.setParams({
			"url": url
		});

		var self = this;

		action.setCallback(this, function (response) {
			self.actionResponseHandler(response, self.setRssFeedData, component);
		});

		$A.enqueueAction(action);
	},
	setRssFeedData: function (returnValue, component) {
		var rssData = JSON.parse(returnValue);
		component.set("v.rssData", rssData);
	},
	actionResponseHandler: function (response, cb, component) {
		var state = response.getState();
		if (state === "SUCCESS") {
			var retVal = response.getReturnValue();
			// console.log('Result = ' + JSON.stringify(retVal));
			cb(retVal, component);
		}
		else if (state === "ERROR") {
			var errors = response.getError();
			if (errors) {
				console.log("Errors", errors);
				if (errors[0] && errors[0].message) {
					alert("Error message: " + errors[0].message);
				}
			}
			else {
				alert("Unknown error");
			}
		}
	},
	// This method will only be used if we decide to craft a custom component using the Twitter API
	fetchTwitterFeedData: function (component) {
		var xmlHttp = new XMLHttpRequest();
		var url = 'https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=Carrier';
		xmlHttp.open("GET", url, true);
		xmlHttp.setRequestHeader('Content-Type', 'application/json');
		xmlHttp.responseType = 'json';
		xmlHttp.onload = function () {
			if (xmlHttp.readyState === 4) {
				if (xmlHttp.status === 200) {
					var options = xmlHttp.response;
				}
			}
		};
		xmlHttp.send(null);
	},
})