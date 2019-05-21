'use strict';

angular
  .module('TKscrollTo', [])
  .directive('scrollTo', [
    '$window',
    function ($window) {
    return {
      restrict: 'A',
      scope: {
        top: '@',
        left: '@'
      },
      link: function postLink(scope, element, attrs) {
        element.on('click', function(){
          $window.scrollTo((scope.top || 0), (scope.left || 0));
        });
      }
    };
  }]);
