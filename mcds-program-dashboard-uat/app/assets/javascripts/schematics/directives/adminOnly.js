'use strict';

angular.module('schematicApp')
  .directive("adminOnly", ['current_user', function(current_user) {
    return {
      restrict: "A",
      link: function(scope, element) {
        if (element.hasClass('ng-hide')){return} // In case something else hid this element

        var user = current_user || {};

        if (user.role != 'admin' && user.role != 'tukaiz_super_admin'){
          element.remove();
        }

      }
    };
  }]);
