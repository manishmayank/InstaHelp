//to get current url
function get_current_url(callback) {
  chrome.tabs.query({ active: true }, function(tabs) {
    var tabUrl = tabs[0].url;
    callback(tabUrl);
  });
}

function setCookie(cname, cvalue) {
    var d = new Date();
    d.setTime(d.getTime() + (300*24*60*60*1000));
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + "; " + expires;
}

function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1);
        if (c.indexOf(name) == 0) return c.substring(name.length,c.length);
    }
    return "";
}

function checkCookie() {
    var username=getCookie("username");
    if (username!="") {
        alert("Welcome again " + username);
    }else{
        username = prompt("Please enter your name:", "");
        if (username != "" && username != null) {
            setCookie("username", username, 365);
        }
    }
}

var myAppControllers = angular.module('myAppControllers', []);

myAppControllers.config( [
  '$compileProvider',
  function( $compileProvider )
  {
    $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|http|mailto|chrome-extension):/);
  }
]);

// Home controller
myAppControllers.controller('HomeCtrl', [
	"$scope",
  "$http",
 	function($scope, $http) {
	 	"use strict";
     //$scope.url = "tablink";
     var page_url = "";
     get_current_url(function(tabURL) {
       page_url = tabURL;
       $http.get("http://128.199.245.64:3000/questions/index?url="+page_url+"&page_num=1")
       .success(function(response) {
         $scope.questions = response;
       });
     });
     //setCookie("username","1234567890");
     //var cookie_value = getCookie("username");
     //$scope.cookie = cookie_value;
   }
]);

//Question controller
myAppControllers.controller('QuestionCtrl', [
  "$scope",
  "$http",
  "$routeParams",
  function($scope, $http, $routeParams) {
    "use strict";

    //$scope.lid = $routeParams.qid;
    $http.get("https://gist.githubusercontent.com/modassir/fa8c32fe66c348bc5af5/raw/705c16e53c01fcfb537ff54d91eb2468c284b2c0/question.json")
    .success(function(response) {
      //$scope.questions = response;
      $scope.title = response.title;
      $scope.text = response.text;
      $scope.user = response.user;
      $scope.upvotes = response.upvotes;
      $scope.downvotes = response.downvotes;
      $scope.created_at = response.created_at;
      $scope.comments = response.comments;
      $scope.answers = response.answers;
    });
  }
]);
