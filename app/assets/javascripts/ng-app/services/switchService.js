angular.module('networkApp')
.service('Switch', ['$http',function($http){
  this.index = function(callback){
    $http.get('/switches').success(function(switches){
      callback(switches)
    })
  }
  this.create = function(newSwitch, callback){
    $http.post('/switches', newSwitch).success(function(switches){
      callback(switches)
    })
  }
  this.show = function(switchId,callback){
    $http.get('/switches/' + switchId).success(function(switchData){
      callback(switchData)
    })
    
  }
}])
