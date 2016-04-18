angular.module('flapperNews')
.controller('dashboardCtrl', [
'$scope',
'$state',
'Auth',
'Switch',
function($scope,$state,Auth,Switch){
  Auth.currentUser().then(function(user){
    $scope.user = user
  })

  Auth.currentUser().then(function (user){
      $scope.user = user;
      console.log(user)
      Switch.show(function(switches){
        console.log(switches)
      })
  });

  $scope.addSwitch = function(){
    Switch.create($scope.newSwitch,function(){
      console.log('Switch created')
    })
  }

  //$scope.test = 'Hello world!';
  //$scope.posts = [
    //{title: 'post 1', upvotes: 5},
    //{title: 'post 2', upvotes: 2},
    //{title: 'post 3', upvotes: 15},
    //{title: 'post 4', upvotes: 9},
    //{title: 'post 5', upvotes: 4}
  //];
  //$scope.addPost = function(){
    //$scope.posts.push({title: 'A new post!', upvotes: 0});
  //};

  //$scope.us = function(){
    //console.log(3)
  //}
  //$scope.incrementUpvotes = function(post) {
    //console.log(3)
    //post.upvotes += 1;
  //};
  //$scope.addPost = function(){
    //if(!$scope.title || $scope.title === '') { return; }
    //$scope.posts.push({
        //title: $scope.title,
        //link: $scope.link,
        //upvotes: 0
      //});
    //$scope.title = '';
    //$scope.link = '';
  //};
}]);
