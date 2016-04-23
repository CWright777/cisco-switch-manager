angular.module('networkApp')
.controller('dashboardCtrl', [
'$scope',
'$state',
'Auth',
'Switch',
'$mdDialog',
'$mdMedia',
'$interval',
function($scope,$state,Auth,Switch, $mdDialog, $mdMedia,$interval){
  getAllSwitchInfo = function(){
      Switch.show(function(data){
        $scope.switches = data.switches
      })
  }

  Auth.currentUser().then(function (user){
   getAllSwitchInfo()
   $scope.user = user;
  });

  //Add Switch Dialog Prompt
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
      .then(function(result) {
        //Add switch info to user
        Switch.create(result,function(data){
          $scope.switches = data.switches
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

  $interval(function(){
    getAllSwitchInfo()
  },30000)
}]);
