angular.module('networkApp')
.controller('showSwitchCtrl', [
'$scope',
'$state',
'Switch',
"$stateParams",
function($scope,$state,Switch,$stateParams){
  Switch.show($stateParams.switchId,function(switchData){
    $scope.switchData = switchData;
  })

  $scope.moduleState = 'link';

  $scope.revealConfigure = function(){
    $scope.moduleState = 'configure';
  }

  $scope.disappearConfigure = function(){
    $scope.moduleState = 'link';
  }
}])
