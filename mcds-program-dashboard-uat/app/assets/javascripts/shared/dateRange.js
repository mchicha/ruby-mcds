angular
  .module('customFilters', []).
  filter('dateRange', function() {
  return function(objs, start, end, attr) {
    if (start && end) {
      var filtDates = []

      angular.forEach(objs, function(obj){
          if(obj[attr] >= start && obj[attr] <= end){
            this.push(obj);
          }
        },
      filtDates);

      return filtDates;

    } else {
      return objs
    }
  };
}).filter('displayStatus', function(){
  return function(objs, statuses){
    if(angular.isArray(statuses) && statuses.length > 0){
      //filter objects
      var filtStatuses = [];
      angular.forEach(objs, function(obj){

        if(statuses.indexOf(obj.display_status) > -1){
          this.push(obj);
        }
      }, filtStatuses);

      return filtStatuses;

    }else{
      return objs;
    }
  };
});
