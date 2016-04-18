angular.module('flapperNews')
.service('Switch', ['$http',function($http){
  this.show = function(userId,callback){
    console.log(userId)
    $http.get('/dashboard/' + userId + '.json').success(function(switches){
      callback(switches)
    })
  }
}])
