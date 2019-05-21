'use strict';

angular.module('schematicApp')
  .directive("userGeographyOnly", ['current_user', function(current_user) {
    return {
      restrict: "A",
      scope: {
        geographyIds: '=geographyIds'
      },
      link: function(scope, element) {
        if(current_user.role === "admin" || current_user.role === "tukaiz_super_admin"){return}

        element.addClass('ng-hide');

        if(current_user.role === "leadership" || current_user.role === "us_read_only"){return}

        // Only continue if an inputter
        var user = current_user || {},
            geographies = user.geographies || [],
            userGeographyIds = [],
            geographyIds = scope.geographyIds || [];

        for (var i=0; i < geographies.length; i++){
          userGeographyIds.push(geographies[i].id);
        }

        var matches = userGeographyIds.filter(function(n) {
          return geographyIds.indexOf(n) != -1
        });

        if (matches.length > 0){
          element.removeClass('ng-hide');
        }

      }
    };
  }]);
