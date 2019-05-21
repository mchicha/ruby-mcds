'use strict';

angular.module('schematicApp')
  .filter('utcDate', [
    '$filter',
    function($filter){
    return function(date, format) {
      format = format || "mediumDate";
      return $filter('date')(date, format, "UTC");
    };
}]);
