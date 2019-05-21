'use strict';

angular.module('schematicApp')
  .factory('ProgramSvc', [
    '$resource',
    function ($resource) {
      return $resource('/api/v1/programs/:id.json', {id: '@id'},{
        query: {
          isArray: false,
          transformResponse: function(data){
            var JsonData = angular.fromJson(data),
                response = { programs: JsonData.programs, marketCategories: [] },
                colorBlockIds = [];

            angular.forEach(JsonData.programs, function(program){
              var colorBlocks = program["color_blocks"] || [];

              if (colorBlocks.length > 0){
                angular.forEach(colorBlocks, function(colorBlock){
                  if(colorBlockIds.indexOf(colorBlock.id) === -1){
                    response.marketCategories.push(colorBlock);
                    colorBlockIds.push(colorBlock.id);
                  }
                });
              }
            });

            return response;
          }
        }
      });
    }
  ]);
