angular.module('flapperNews')
.service('Switch', [function($http){
  this.show = function(callback){
    $http.get('/switches/')
  }
}])
