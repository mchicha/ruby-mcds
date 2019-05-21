'use strict';

angular
  .module('tkmlFilters', []).
  filter('range', function() {
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
}).filter('collection', function(){
  return function(objs, values, key){
    if(key && angular.isArray(values) && values.length > 0){
      //filter objects
      var filtvalues = [];
      angular.forEach(objs, function(obj){

        if(values.indexOf(obj[key]) > -1){
          this.push(obj);
        }
      }, filtvalues);

      return filtvalues;

    }else{
      return objs;
    }
  };
}).filter('colToCol', function(){
  return function(objs, values, key){
    if(key && angular.isArray(values) && values.length > 0){
      //filter objects
      var filtvalues = [];
      angular.forEach(objs, function(obj){

        for (var i = obj[key].length - 1; i >= 0; i--) {
          if (values.indexOf(obj[key][i]) > -1) {
            filtvalues.push(obj);
            break;
          }
        };

      }, filtvalues);

      return filtvalues;

    }else{
      return objs;
    }
  };
});
