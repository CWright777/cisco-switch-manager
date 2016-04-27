angular.module('networkApp')
.controller('showSwitchCtrl', [
'$scope',
'$state',
'Switch',
"$stateParams",
'$mdDialog',
'$mdMedia',
function($scope,$state,Switch,$stateParams,$mdDialog, $mdMedia){
  //Need to initiate variable for ng-model in table
  $scope.switchInfo = {}
  $scope.loaded = false;

  Switch.show($stateParams.switchId,function(switchData){
    $scope.switchData = switchData;
    $scope.loaded = true;
  })

  $scope.moduleState = 'link';

  $scope.revealConfigure = function(){
    $scope.moduleState = 'configure';
  }

  $scope.disappearConfigure = function(){
    $scope.moduleState = 'link';
  }

  //Remove Switch Dialog Prompt
  $scope.showAdvanced = function(ev) {
    var useFullScreen = $scope.customFullscreen;

    $mdDialog.show({
      controller: DialogController,
      templateUrl: '_removeSwitch.html',
      parent: angular.element(document.body),
      targetEvent: ev,
      clickOutsideToClose:true,
      fullscreen: useFullScreen
    })
    .then(function() {
      //Add switch info to user
      Switch.remove($stateParams.switchId,function(){
        $state.go('dashboard')
      })
    }, function() {
      //When user clicks cancel
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

  $scope.saveInfo = function(){
    $scope.loaded = false;
    Switch.update($stateParams.switchId,$scope.switchInfo,function(switchdata){
      Switch.show($stateParams.switchId,function(switchData){
        $scope.switchData = switchData;
        $scope.loaded = true;
        $scope.switchInfo = {}
      })
    });
  };
}])
