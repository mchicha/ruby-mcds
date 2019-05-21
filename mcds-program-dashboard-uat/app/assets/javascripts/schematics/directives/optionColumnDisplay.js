'use strict';

angular.module('schematicApp')
  .directive("optionsColumnDisplay", ['current_user', function(current_user) {
    return {
      restrict: "A",
      link: function(scope, element) {
        if(current_user.role === "us_read_only" || current_user.role === "leadership"){
          element.remove();
        }
        else if(current_user.role === "inputter"){
          var user = current_user || {},
              geographies = user.geographies || [],
              selectedGeography = [user.selected_geography_id];

          var found;
          geographies.forEach(function(n) {
            if (user.selected_geography_id === n.id){
              found = true;
              return
            }
          });
          if (!found){
            element.remove()
          }
        }
      }
    };
  }]);
