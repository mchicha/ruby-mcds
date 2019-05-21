'use strict';

angular
  .module('tkPaginate', [])
  .factory('PaginateSvc', function () {
    var _pullSize, _offSet;

    // Due to the way the limitTo function works with pagination the last page will
    // always show the current colletion size even if there are not enough. This
    // will cause records to show on two pages. This method detects if the user is
    // on the last page and if so adjust the pull size so records don't show on
    // multiple pages. If it's not the last page it will just return page size.
    // TODO: ABSTRACT THIS OUT AS A SERVICE.
    // TODO: REMOVE DEPENDENCIES WITH FILTERS BY ADDING MORE ARGUMENTS
    _pullSize = function(filters, collLength){
      if(filters.currPage === filters.numPages){
        return (filters.perPage - (_offSet(filters) - collLength)) * -1
      } else {
        return filters.perPage * -1
      }
    };

    // Return offet where limitTo should start at based on currPage
    _offSet = function(filters){
      return filters.perPage * filters.currPage
    };

    return {
      pullSize: _pullSize,
      offSet: _offSet
    }
  });
