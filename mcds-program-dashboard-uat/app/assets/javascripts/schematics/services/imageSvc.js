'use strict';

angular.module('schematicApp')
  .factory('PdfSvc', [
    '$resource',
    function ($resource) {
      var PDF, Build, TransformInstance, pdfs = [];

      TransformInstance = function(schematic){
        // Seems we dont need to coerce this anymore
        // if(angular.isDefined(schematic.release_date)){
        //   schematic.release_date = new Date(schematic.release_date);
        // }
        // schematic.end_date = new Date(schematic.end_date);
        return new PDF(schematic);
      };

      PDF  = $resource('/api/v1/schematics/:schematic_id/pdfs/:id',
        {
          id: '@id',
          schematic_id: '@schematic_id'
        },
        {
          query: {
          method: 'GET',
          isArray: true, // <- not returning an array
          transformResponse: function(data, header) {
            var w = angular.fromJson(data);
            // angular.forEach(w.pdfs, function(image, idx) {
            //   // Replace each item with an instance of the resource object
            //   w.pdfs[idx] = TransformInstance(image);
            // });
            return w.pdfs;
          }
        },
        get: {
          method: 'GET',
          isArray: false, // <- not returning an array
          transformResponse: function(data, header) {
            var w = angular.fromJson(data);
            return TransformInstance(w.image);
          }
        },
        update: {
          method:'PUT',
          transformRequest: function(data, header) {
            var p = angular.toJson({image: data});
            return p;
          }
        }
      });

      Build = function(obj) {
        return new PDF({
          schematic_id: obj.title   || '',
          document_id:  obj.status,
          image:        obj.image   || {},
          file:         obj.file    || ''
        })
      };

      return {
        resource: PDF,
        build: Build,
        add: function(list){
          pdfs.push(list);
        },
        set: function(list) {
          pdfs = list;
        },
        pdfs: function() {
          return pdfs;
        }
      };
  }]);
