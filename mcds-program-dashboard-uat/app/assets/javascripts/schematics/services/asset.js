'use strict';

angular.module('schematicApp')
  .service('DamAssetSvc', ['$resource', 'dam_host', 'dam_client_token', function($resource, dam_host, dam_client_token) {
    var Asset;

    Asset = $resource('/api/v1/asset_caches/:id.json',
      {
        id:         "@id"
      },
      {
        query: {
          method: 'GET',
          transformResponse: function(data, header) {
            var w = angular.fromJson(data);

            // Position Ids is a string with values split by ','s.
            // Rather than turn to an array each time we need to look at assets, we can do it here and cache it
            w.assets.forEach(function(asset){
              // this makes sure they are in the same order as the lookup table
              asset.metadata = asset.metadata.sort(function(a,b){return a.id - b.id});

              asset.metadata.forEach(function(meta){
                if (meta.name === 'Position Ids'){
                  meta.value = meta.value || ''; // We need to check if it was not defined yet
                  meta.value = meta.value.split(',');
                }
              })
            })

           return w.assets;
          },
          isArray: true
        },
        save: {
          method: 'POST',
          headers: {
            'Authorization':'Token token=' + dam_client_token
          },
          isArray: false
        },
        update: {
          method: 'PUT',
          headers: {
            'Authorization':'Token token=' + dam_client_token
          }
        }
      });

    return {
      resource: Asset,
    }

  }]);
