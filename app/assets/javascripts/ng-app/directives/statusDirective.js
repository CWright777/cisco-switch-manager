angular.module('networkApp')
.directive('displayStatusIcon', function(){
    return {
      link: function(scope,element,attrs){
        var date=new Date();
        var minutes=date.getMinutes();
        var seconds=date.getSeconds();
        var milliseconds=date.getMilliseconds();
        date.setMinutes(minutes-3,seconds,milliseconds);

        //If switch contacted within last minute
        //show happ face else unhappy
        scope.$watch(attrs.displayStatusIcon, function(value){
          if(Date.parse(value) > Date.parse(date)){
            element.html("<md-icon class='ng-scope material-icons' style='color:#7ac142;'>cloud_done</md-icon>")
          } else {
            element.html("<md-icon style='color:red' class='ng-scope material-icons'>cloud_off</md-icon>")
          }
        })
      }
    };
})

