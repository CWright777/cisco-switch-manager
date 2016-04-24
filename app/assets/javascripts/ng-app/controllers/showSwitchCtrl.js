angular.module('networkApp')
.controller('showSwitchCtrl', [
'$scope',
'$state',
'Switch',
"$stateParams",
function($scope,$state,Switch,$stateParams){
  console.log($stateParams)
  Switch.show($stateParams.switchId,function(switchData){
    console.log(switchData)
  })
}])
