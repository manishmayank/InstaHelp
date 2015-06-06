var myApp =  angular.module('myApp', [
    'ngRoute',
    'myAppControllers'
]);

myApp.config(['$routeProvider', function($routeProvider) {
  "use strict";

  $routeProvider
    .when('/home', {
      templateUrl: 'assets/partials/home.html',
      controller: 'HomeCtrl'
    })
    .when('/login', {
      templateUrl: 'assets/partials/login.html',
      controller: 'LoginCtrl'
    })
    .when('/signup', {
      templateUrl: 'assets/partials/signup.html',
      controller: 'SignupCtrl'
    })
    .when('/question/:qid', {
      templateUrl: 'assets/partials/question.html',
      controller: 'QuestionCtrl'
    })
    .when('/ask_question', {
      templateUrl: 'assets/partials/add_question.html',
      controller: 'AskQuestionCtrl'
    })
    // Set defualt view of our app to home
    .otherwise({
      redirectTo: '/home'
    });
  }
]);
