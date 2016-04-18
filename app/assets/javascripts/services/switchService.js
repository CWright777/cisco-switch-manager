angular.module('flapperNews')
.service('Switch', ['$http',function($http){
  this.show = function(callback){
    $http.get('/dashboard/' + 'temp' + '.json').success(function(switches){
      callback(switches)
    })
  }
  this.create = function(newSwitch, callback){
    $http.post('/switches', newSwitch).success(function(switches){
      callback(switches)
    })
  }
}])
