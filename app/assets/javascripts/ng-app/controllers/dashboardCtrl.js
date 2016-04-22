angular.module('networkApp')
.controller('dashboardCtrl', [
'$scope',
'$state',
'Auth',
'Switch',
'ngMaterial',
function($scope,$state,Auth,Switch, $mdDialog, $mdMedia){
  Auth.currentUser().then(function(user){
    $scope.user = user
  })

  Auth.currentUser().then(function (user){
      $scope.user = user;
      console.log(user)
      Switch.show(function(data){
        console.log(data)
        $scope.switches = data.switches
      })
  });

  $scope.addSwitch = function(){
    Switch.create($scope.newSwitch,function(data){
      $scope.switches = data.switches
    })
  }

  //Add Switch Dialog Prompt
  $scope.status = '  ';
  $scope.customFullscreen = $mdMedia('xs') || $mdMedia('sm');

  $scope.showPrompt = function(ev) {
  console.log(4)
    // Appending dialog to document.body to cover sidenav in docs app
    var confirm = $mdDialog.prompt()
          .clickOutsideToClose(true)
          .title('What would you name your dog?')
          .textContent('Bowser is a common name.')
          .placeholder('dog name')
          .ariaLabel('Dog name')
          .targetEvent(ev)
          .ok('Okay!')
          .cancel('I\'m a cat person');

    $mdDialog.show(confirm).then(function(result) {
      $scope.status = 'You decided to name your dog ' + result + '.';
    }, function() {
      $scope.status = 'You didn\'t name your dog.';
    });
  };

}]);
