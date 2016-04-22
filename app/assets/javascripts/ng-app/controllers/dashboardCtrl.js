angular.module('networkApp')
.controller('dashboardCtrl', [
'$scope',
'$state',
'Auth',
'Switch',
'$mdDialog',
'$mdMedia',
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

    $scope.showAdvanced = function(ev) {
      var useFullScreen = $scope.customFullscreen;

      $mdDialog.show({
        controller: DialogController,
        templateUrl: '_newSwitchForm.html',
        parent: angular.element(document.body),
        targetEvent: ev,
        clickOutsideToClose:true,
        fullscreen: useFullScreen
      })
      .then(function(answer) {
        $scope.status = 'You said the information was "' + answer + '".';
      }, function() {
        $scope.status = 'You cancelled the dialog.';
      });
    };

  function DialogController($scope, $mdDialog) {
    $scope.hide = function() {
      $mdDialog.hide();
    };

    $scope.cancel = function() {
      $mdDialog.cancel();
    };

    $scope.answer = function(answer) {
      $mdDialog.hide(answer);
    };
  }

}]);
