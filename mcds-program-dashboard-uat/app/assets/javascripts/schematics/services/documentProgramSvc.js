'use strict';

angular.module('schematicApp')
  .factory('DocumentProgramSvc', [
    '$resource',
    function ($resource) {
      return $resource('/api/v1/schematics/:schematic_id/document/:document_id/programs.json', {id: '@id', document_id: '@document_id'});
    }
  ]);
