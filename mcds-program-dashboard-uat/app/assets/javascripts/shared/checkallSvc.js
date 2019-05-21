'use strict';

angular
  .module('rbListMgmt', [])
  .factory('rbCheckbox', ['$filter', function($filter) {
    var _checkCollection, _allChecked;

    _checkCollection = function(collection, checked) {
      angular.forEach(collection, function(obj, idx){
        collection[idx].checked = checked;
      });
    };

    _allChecked = function(collection, perPage) {
      return $filter('filter')(collection, {checked: true}).length === perPage;
    };

    return {
      checkCollection: _checkCollection,
      allChecked: _allChecked
    }
  }]);
