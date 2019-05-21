'use strict';

angular.module('schematicApp')
  .factory('ElementSvc', [
    '$resource',
    '$filter',
    'VersionSvc',
    function ($resource, $filter, VersionSvc) {
      var elements, Element, Build;
      elements = [];
      Element = $resource('/api/v1/schematics/:schematic_id/document/elements/:id',
      {
        schematic_id: '@schematic_id',
        id:           '@id'
      }, {
        query: {
        method: 'GET',
        isArray: false, // <- not returning an array
        transformResponse: function(data, header) {
          var w = angular.fromJson(data);
          angular.forEach(w.elements, function(element, idx) {
            // Replace each item with an instance of the resource object
            w.elements[idx] = new Element(element);
          });
          return w;
        }
      },
      save: {
        method: 'POST',
        isArray: false, // <- not returning an array
        transformResponse: function(data, header) {
          var w = angular.fromJson(data);

          return w;
        }
      },
      get: {
        method: 'GET',
        isArray: false, // <- not returning an array
        transformResponse: function(data, header) {
          var w = angular.fromJson(data);

          return w;
        }
      },
      update: {
        method:'PUT',
        transformRequest: function(data, header) {
          delete data.canvasElement;
          delete data.asset;
          var e = angular.toJson({element: data});
          return e;
        },
        transformResponse: function(data, header) {
            var w = angular.fromJson(data);
            if(w.versions){
              VersionSvc.add(w.versions[0]);
            }
            return null;
        },
      },
      updateCanvasElement: {
        method:'PUT',
        transformRequest: function(data, header) {
          var params = {};
          angular.forEach(data, function(value, key) {
            if(["asset", "canvasElement"].indexOf(key) < 0){
              params[key] = value;
            }
          });
          var e = angular.toJson({element: params});
          return e;
        },
        transformResponse: function(data, header) {
            var w = angular.fromJson(data);
            if(w.versions){
              VersionSvc.add(w.versions[0]);
            }
            return null;
          }
        },
      },
      {
        // timeout: 60000
      }
    );

    Build = function(obj) {
      return new Element({
        name:     obj.name     || '',
        zindex:   obj.zindex   || 1,
        editable: obj.editable || false,
        modified: obj.modified || false,
        grayscale: obj.grayscale,
        values:   obj.values || {}
      })
    };

    return {
      resource: Element,
      build: Build,

      add: function(list){
        elements.push(list);
      },
      set: function(list) {
        elements = list;
      },
      elements: function() {
        return elements;
      }
    };
  }]);
