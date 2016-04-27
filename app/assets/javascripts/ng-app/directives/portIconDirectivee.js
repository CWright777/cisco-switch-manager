angular.module('networkApp')
.directive('portIcon', function(){

  var up = "<div class='port'>" +
                "<div id='small-piece'></div><div id='medium-piece'></div><div id='large-piece'></div>" +
              "</div>"

  var down = "<div class='port'>" +
                "<div id='large-piece'></div><div id='medium-piece'></div><div id='small-piece'></div>" +
              "</div>"

  return {
    scope: {
      portNum: '='
    },
    link: function(scope, element, attributes){
      var result = "<div layout='row' class='switch-body'>"
      for(var i=0;i < scope.portNum;i++){
        if(i%2==0){
          result += "<div layout='column' class='chasis'>"
          result += up;
        } else {
          result += down;
          result += "</div>"
        }
      }
      result += "</div>"
      element.html(result)
    }
  }
})
