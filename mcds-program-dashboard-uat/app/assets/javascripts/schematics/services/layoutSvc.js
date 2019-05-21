'use strict';

angular.module('schematicApp')
  .factory('LayoutSvc', [
    '$resource',
    'ElementSvc',
    function ($resource, ElementSvc) {
      var Transformer, Layout, Build;

      Transformer = function(data){
        var w = angular.fromJson(data);

        angular.forEach(w.elements, function(el, edx){
            w.elements[edx] = new ElementSvc.resource(el);
        });

        if(w.layouts){
          angular.forEach(w.layouts, function(doc, idx){
            w.layouts[idx] = new Layout(doc);
          });
        } else if (w.layout){
          w.layout = new Layout(w.layout);
          w.layout.elements = w.elements
        }

        return w;
      };

      Layout = $resource('/api/v1/schematics/:schematic_id/layouts/:id', {schematic_id: '@schematic_id', id: '@id'}, {
        query: {
          method: 'GET',
          isArray: false, // <- not returning an array
          transformResponse: Transformer
        },
        save: {
          method: 'POST',
          isArray: false, // <- not returning an array
          transformResponse: function(data){
            return Transformer(data);
          }
        },
        get: {
          method: 'GET',
          isArray: false, // <- not returning an array
          transformResponse: function(data){
            return Transformer(data);
          }
        },
        update: {
          method: 'PUT',
          isArray: false, // <- not returning an array
          transformResponse: function(data){
            return Transformer(data);
          }
        }
      });

      Build = function(obj) {
        // return new Layout({
        //   name     : obj['name'] || '',
        //   _destroy  : false
        // })
      };

      return {
        resource: Layout,
        build: Build
      };
  }]);
