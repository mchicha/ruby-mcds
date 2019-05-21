'use strict';

angular.module('tkDropdown', [])
  .directive('selectDropdown', ['$timeout', '$filter', function ($timeout, $filter) {
    return {
      restrict: 'AE',
      replace: true,
      transclude: 'true',
      scope: {
        defaultText : '@',
        btnClass    : '@',
        options     : '=',
        label       : '@',
        value       : '=',
        valOpt      : '@',
        includeBlank: '@',
        save        : '&'
      },
      template: '<div class="btn-group" dropdown><button type="button" class="btn btn-select" ng-class="btnClass || \'btn-primary\'"  disabled="true">{{selectedText}}</button><button type="button" class="btn btn-down"ng-class="btnClass ? btnClass + \'dropdown-toggle\' : \'btn-primary dropdown-toggle\'" dropdown-toggle><i class="fa fa-caret-down"></i></button><ul class="dropdown-menu dropdown-select"><li ng-repeat="opt in options"><a ng-click="setText(opt);">{{opt[label]}}</a></li></ul></div>',
      link: function postLink(scope, element, attrs) {
        scope.isopen        = false;

        scope.findTextValue = function(value){
          var obj, filter = {};

          filter[scope.valOpt] = scope.value;
          obj = $filter('filter')(scope.options, filter, true);

          if(obj.length > 0){
            scope.selectedText = obj[0][scope.label] || scope.defaultText ||scope.options[0][scope.label];
          }else{
            scope.selectedText = scope.defaultText || scope.options[0][scope.label];
          }
        };

        scope.setText = function(option){
          scope.value         = option[scope.valOpt];
          scope.selectedText  = option[scope.label];

          if(!angular.isUndefined(scope.save)){
            $timeout(scope.save, 50);
          }
        };

        scope.findTextValue(scope.value);

      }
    };
  }]);
