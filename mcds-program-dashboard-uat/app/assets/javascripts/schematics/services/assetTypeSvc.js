'use strict';

angular.module('schematicApp')
  .service('DamAssetTypeSvc', [
    '$resource',
    'dam_host',
    'dam_client_token',
    function($resource, dam_host, dam_client_token){

    var AssetType, Build, BuildLookup, Lookup = {};

    AssetType = $resource('/api/v1/asset_type_caches.json',
      {
        id:         "@id",
        verbose:    true
      },
      {
        query: {
          method: 'GET',
          headers: {
            'Authorization':'Token token=' + dam_client_token
          },
          isArray: false,
          transformResponse: function(data, header) {
            var w = angular.fromJson(data);

            Lookup = BuildLookup(w);
            return {lookup: w};
          }
        }
      });

      Build = function(obj) {
        return new Rule(obj);
      };

      BuildLookup = function(data){
        var table = {};

        angular.forEach(data.asset_types, function(assetType, index) {
          this[assetType.id] = {}

          assetType.parameter_ids = assetType.parameter_ids.sort(function(a,b){ return a - b});

          angular.forEach(data.parameters, function(parameter, index){
            var paramIndex = assetType.parameter_ids.indexOf(parameter.id);

            if (paramIndex > -1)
              this[parameter.name] = paramIndex
          },
          this[assetType.id])

        },
        table);

        return table;
      }


    return {
      resource: AssetType,
      build:    Build,
      lookup:   function(){return Lookup}
    }
  }]);

