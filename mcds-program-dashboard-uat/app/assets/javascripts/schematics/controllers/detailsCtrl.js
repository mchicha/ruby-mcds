'use strict';

angular.module('schematicApp').controller('detailsCtrl', [ '$scope', function($scope) {
  var detailsCtrl = this;

  $scope.init = function($schematic) {
    $scope.schematic = $schematic;
  };

  $scope.saveForm = function() {
    if ($scope.form.$valid){
      $scope.schematic.$update(function(success){
        console.log("successsfully saved.")
      }, function(errorResult){
        console.log("something isn't right...");
        console.log(errorResult);
      });
    }
  }

}]);
