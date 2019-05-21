'use strict';

angular.module('schematicApp')
  .factory('NoteSvc', [
    '$resource',
    function ($resource) {
      var Note, Build;
      Note  = $resource('/api/v1/schematics/:schematic_id/document/:document_id/notes/:id', {
        id: '@id',
        schematic_id: '@schematic_id',
        document_id: '@document_id'
      },
        {
        //   query: {
        //   method: 'GET',
        //   isArray: false, // <- not returning an array
        //   transformResponse: function(data, header) {
        //     var w = angular.fromJson(data);
        //     angular.forEach(w.notes, function(note, idx) {
        //       // Replace each item with an instance of the resource object
        //       w.notes[idx] = new Note(note);
        //       w.notes[idx].created_at = new Date(w.notes[idx].created_at);
        //     });
        //     return w;
        //   }
        // },
        update: {
          method: 'PUT'
        },
        save: {
          method: 'POST',
          isArray: false, // <- not returning an array
          transformRequest: function(data, header) {
            var p = angular.toJson({note: data});
            return p;
          },
          transformResponse: function(data, header) {
            var w = angular.fromJson(data);

            return w.note;
          }
        }
      });

      Build = function(obj) {
        obj = obj || {};
        return new Note({
          id:           obj.id            || null,
          name:         obj.name          || '',
          body:         obj.body          || '',
          width:        obj.width         || 290,
          height:       obj.height        || 80,
          x:            obj.x             || 0,
          y:            obj.y             || 0,
          schematic_id: obj.schematic_id,
          document_id:  obj.document_id,
          created_at:   obj.created_at    || new Date(),
          updated_at:   obj.updated_at    || new Date()
        })
      };

      return {
        resource: Note,
        build: Build,
      };
  }]);
