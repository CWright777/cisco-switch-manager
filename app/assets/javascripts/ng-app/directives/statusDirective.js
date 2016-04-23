angular.module('networkApp')
.directive('displayStatusIcon', function(){
    return {
      link: function(scope,element,attrs){
        var date=new Date();
        var minutes=date.getMinutes();
        var seconds=date.getSeconds();
        var milliseconds=date.getMilliseconds();
        date.setMinutes(minutes-1,seconds,milliseconds);

        //If switch contacted within last minute
        //show happ face else unhappy
        scope.$watch(attrs.displayStatusIcon, function(value){
          if(Date.parse(value) > Date.parse(date)){
            element.html("<md-icon class='ng-scope material-icons' style='color:blue'>sentiment_very_satisfied</md-icon>")
          } else {
            element.html("<md-icon class='ng-scope material-icons'>sentiment_very_dissatisfied</md-icon>")
            console.log(value)
          }
        })
      }
      //template: function(){
        //var date=new Date();
        //var minutes=date.getMinutes();
        //var seconds=date.getSeconds();
        //var milliseconds=date.getMilliseconds();
        //date.setMinutes(minutes-1,seconds,milliseconds);
        //return "{{info.contacted_at}}"
        //if("{{info.contacted_at}}" <= date){
          //return "works"
        //} else {
          //return "yolo"
        //}
      //}
    };
})

