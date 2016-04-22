angular.module('appRoutes', [])
.config([
'$stateProvider',
'$urlRouterProvider',
function($stateProvider, $urlRouterProvider) {
  $stateProvider
    .state('dashboard', {
      url: '/dashboard',
      templateUrl: '_dashboard.html',
      controller: 'dashboardCtrl'
    })
    .state('login', {
      url: '/login',
      templateUrl: '_login.html',
      controller: 'authCtrl',
      onEnter: ['$state', 'Auth', function($state, Auth) {
        Auth.currentUser().then(function (){
          $state.go('dashboard');
        })
      }]
    })
    .state('register', {
      url: '/register',
      templateUrl: '_register.html',
      controller: 'authCtrl',
      onEnter: ['$state', 'Auth', function($state, Auth) {
        Auth.currentUser().then(function (){
          $state.go('dashboard');
        })
      }]
    });

  $urlRouterProvider.otherwise('dashboard');
}])
