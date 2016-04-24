angular.module('networkApp', [
'ui.router',
'templates',
'Devise',
'ngMaterial',
'ngAnimate',
'ngAria',
'ngMessages'
])
.config([
'$stateProvider',
'$urlRouterProvider',
function($stateProvider, $urlRouterProvider) {

  $stateProvider
    .state('login', {
      url: '/login',
      templateUrl: '_login.html',
      controller: 'AuthCtrl',
      onEnter: ['$state', 'Auth', function($state, Auth) {
        Auth.currentUser().then(function (){
          $state.go('dashboard');
        })
      }]
    })
    .state('register', {
      url: '/register',
      templateUrl: '_register.html',
      controller: 'AuthCtrl',
      onEnter: ['$state', 'Auth', function($state, Auth) {
        Auth.currentUser().then(function (){
          $state.go('dashboard');
        })
      }]
    })
    .state('dashboard', {
      url: '/dashboard',
      templateUrl: '_dashboard.html',
      controller: 'dashboardCtrl'
    })
    .state('switch', {
      url: '/dashboard/:switchId',
      templateUrl: '_show_switch.html',
      controller: 'showSwitchCtrl'
    })

  $urlRouterProvider.otherwise('dashboard');
}])
