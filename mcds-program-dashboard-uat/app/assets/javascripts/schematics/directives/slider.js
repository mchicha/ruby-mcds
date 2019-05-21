
'use strict';

angular.module('schematicApp')
  .directive('mcdSlider', [
    '$timeout',
    function($timeout) {
    return {
      restrict: 'EA',
      replace:  true,
      scope: {
        min: "@min",
        max: "@max",
        scale: "@scale",
        qualifier: "@qualifier"
      },
      template: '<div><rzslider rz-slider-model="value" rz-slider-options="config"></rzslider></div>',
      require: 'ngModel',
      compile: function(){
        return {
          pre: function(scope, element, attrs, model){
            scope.value   = 0;
            scope.scale   = parseFloat(scope.scale  || 1);
            scope.min     = parseFloat(scope.min    || 0);
            scope.max     = parseFloat(scope.max    || 1000);
            scope.config  = {
              step:   1,
              floor:  scope.min,
              ceil:   scope.max,
              translate: function(value) {
                return value + scope.qualifier;
              }
            }

            scope.$watch(function () {
                return model.$modelValue;
              }, function(newValue, oldValue) {

                if(angular.isDefined(newValue)){
                  scope.value = Math.round(newValue / scope.scale);
                  $timeout(function(){
                    scope.$broadcast('reCalcViewDimensions')
                  }, 100);
              }
            });

            scope.getScaledValue = function(value) {
              return Math.round((value * scope.scale) * 100)/100
            }

            scope.$on("slideEnded", function() {
                model.$setViewValue(scope.getScaledValue(scope.value));
            });
          }
        }
      }
    };
 }]);
