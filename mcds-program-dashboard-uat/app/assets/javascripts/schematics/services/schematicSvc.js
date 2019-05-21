'use strict';

angular.module('schematicApp')
  .factory('SchematicSvc', [
    '$resource',
    function ($resource) {
      var schematics, Schematic, Build, TransformInstance;

      TransformInstance = function(schematic){
        return Build(schematic);
      };

      schematics = [];
      Schematic = $resource('/api/v1/schematics/:id', {id: '@id'},
        {
          query: {
          method: 'GET',
          isArray: false, // <- not returning an array
          transformResponse: function(data, header) {
            var w = angular.fromJson(data);
            angular.forEach(w.schematics, function(schematic, idx) {
              // Replace each item with an instance of the resource object
              w.schematics[idx] = TransformInstance(schematic);
            });
            return w;
          }
        },
        get: {
          method: 'GET',
          isArray: false, // <- not returning an array
          transformResponse: function(data, header) {
            var w = angular.fromJson(data);
            w.schematic = TransformInstance(w.schematic);
            w.schematic.geographies = w.geographies;
            return w.schematic;
          }
        },
        coops: {
          method: 'GET',
          url: '/api/v1/schematics/:id/geographies_schematics'
        },
        update: { method: 'PUT' }
      });

      angular.extend(Schematic.prototype, {
        isNational: function(){
          return (
            (this.geography_ids && this.geography_ids.indexOf(232) > -1) ||
            (this.geographies && this.geographies.length > 0 && this.geographies[0].name === 'National')
          )
        }
      });


      Build = function(obj) {
        var status = (obj.status    || "planning")
        var displayStatus = status

        if(obj.archived){
          displayStatus = 'archived'
        }

        return new Schematic({
          id:                (obj.id        || null),
          name:              (obj.name      || ''),
          status:            (obj.status    || "planning"),
          display_status:    displayStatus,
          sch_type:          (obj.sch_type  || 0),
          release_date:      new Date(obj.release_date),
          end_date:          new Date(obj.end_date),
          updated_at:        new Date(obj.updated_at),
          geographies:       obj.geographies,
          parent_id:         obj.parent_id,
          agencies:          obj.agencies,
          programs:          obj.programs,
          last_modified_by:  obj.last_modified_by,
          parentId:          obj.parent_id,
          test:              obj.test,
          geography_ids:     obj.geography_ids,
          notes:             obj.notes || []
        })
      };

      return {
        resource: Schematic,
        build: Build,
        add: function(list){
          schematics.push(list);
        },
        set: function(list) {
          schematics = list;
        },
        schematics: function() {
          return schematics;
        }
      };
  }]);
