angular.module('networkApp')
.directive('portIcon', function(){
  var up = {
    first:'small-piece',
    third: 'large-piece'
  }
  var down = {
    first: 'large-piece',
    third:'small-piece'
  }

  return {
    template: "<div class='port'>" +
                "<div id='{{selection.first}}'></div><div id='medium-piece'></div><div id='{{selection.third}}'></div>" +
              "</div>",
    scope: {
      orient: '@orient'
    },
    link: function(scope, element, attributes){
      if(scope.orient == 'up'){
        scope.selection = up;
      } else {
        scope.selection = down;
      }
    }
  }
})
