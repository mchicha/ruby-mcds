var colorBlockApp = angular.module('colorBlockApp', []);
colorBlockApp.controller('AdminColorBlockController', [
  '$scope', '$location', '$http', function($scope, $location, $http) {
    $scope.color_blocks = [];
    $http.get('./color-blocks.json').success(function(data) {
      return $scope.color_blocks = data;
    });
    return $scope.viewColorBlock = function(id) {
      return $location.url("/color-blocks/" + id);
    };
  }
]);
