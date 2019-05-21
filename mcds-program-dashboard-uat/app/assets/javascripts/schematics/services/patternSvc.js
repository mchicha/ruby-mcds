'use strict';

angular.module('schematicApp')
  .factory('PatternSvc', [
    '$resource',
    '$http',
    'ElementSvc',
    function ($resource, $http, ElementSvc) {
      var Transformer, Pattern, Build;

      Transformer = function(data){
        var w = angular.fromJson(data);
        angular.forEach(w.patterns, function(doc, idx){
          w.patterns[idx] = new Pattern(doc);
        });

        angular.forEach(w.elements, function(el, edx){
            w.elements[edx] = new ElementSvc.resource(el);
        });

        return w;
      };

      Pattern = $resource('/api/v1/schematics/:schematic_id/pattern', {schematic_id: '@schematic_id'}, {
        query: {
          method: 'GET',
          isArray: false, // <- not returning an array
          transformResponse: Transformer
        }
      });

      Build = function(obj) {
        return new Pattern({
          title     : obj['title'] || '',
          _destroy  : false
        })
      };

      return {
        resource: Pattern,
        build: Build,
        all: function(){
          return $http.get('/api/v1/patterns/', {
          method: 'GET',
          transformResponse: Transformer,
          cache: false
        })},
        findOrCreate: function(result){
          if(angular.isObject(result)){
            return result;
          } else{
            return Build({title: result});
          }
        }
      };
  }]);
