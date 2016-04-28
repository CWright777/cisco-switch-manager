angular.module('networkApp')
.directive('displayActivityIcon', function(){
    return {
      link: function(scope,element,attrs){
        scope.$watch(attrs.displayActivityIcon, function(value){
          if(value == "active"){
            element.html("<md-icon class='ng-scope material-icons' style='color:#7ac142;'>sentiment_very_satisfied</md-icon>")
          } else {
            element.html("<md-icon class='ng-scope material-icons'>sentiment_very_dissatisfied</md-icon>")
          }
        })
      }
    };
})

