angular
    .module('DAM', []).filter('attr', [
        'DamAssetTypeSvc',
        function(DamAssetTypeSvc) {
            return function(asset, attribute, placeholder) {
                if (angular.isUndefined(asset)) {
                  return placeholder || 'Not Defined'
                };

                var idx = DamAssetTypeSvc.lookup()[asset.asset_type_id][attribute];
                if (asset.metadata.length > 0 && idx > -1) {
                    return asset.metadata[idx].value;

                } else if (placeholder) {
                    return placeholder

                } else {
                    return 'Not Defined';
                }
            };
        }
    ]).filter('damImage', [
        function() {
            return function(asset, size) {

                if (asset && size) {
                    return asset[size];

                } else if (asset) {
                    return asset.url;

                } else {
                    return 'data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/PjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB3aWR0aD0iMTcxIiBoZWlnaHQ9IjE4MCIgdmlld0JveD0iMCAwIDE3MSAxODAiIHByZXNlcnZlQXNwZWN0UmF0aW89Im5vbmUiPjwhLS0KU291cmNlIFVSTDogaG9sZGVyLmpzLzEwMCV4MTgwCkNyZWF0ZWQgd2l0aCBIb2xkZXIuanMgMi42LjAuCkxlYXJuIG1vcmUgYXQgaHR0cDovL2hvbGRlcmpzLmNvbQooYykgMjAxMi0yMDE1IEl2YW4gTWFsb3BpbnNreSAtIGh0dHA6Ly9pbXNreS5jbwotLT48ZGVmcz48c3R5bGUgdHlwZT0idGV4dC9jc3MiPjwhW0NEQVRBWyNob2xkZXJfMTRlMDJjNzZkMzEgdGV4dCB7IGZpbGw6I0FBQUFBQTtmb250LXdlaWdodDpib2xkO2ZvbnQtZmFtaWx5OkFyaWFsLCBIZWx2ZXRpY2EsIE9wZW4gU2Fucywgc2Fucy1zZXJpZiwgbW9ub3NwYWNlO2ZvbnQtc2l6ZToxMHB0IH0gXV0+PC9zdHlsZT48L2RlZnM+PGcgaWQ9ImhvbGRlcl8xNGUwMmM3NmQzMSI+PHJlY3Qgd2lkdGg9IjE3MSIgaGVpZ2h0PSIxODAiIGZpbGw9IiNFRUVFRUUiLz48Zz48dGV4dCB4PSI1OS41NDY4NzUiIHk9Ijk0LjUiPjE3MXgxODA8L3RleHQ+PC9nPjwvZz48L3N2Zz4='
                }
            };
        }
    ]).filter('damCoopStatus', [
        'DamAssetTypeSvc',
        function(DamAssetTypeSvc) {
            return function(asset, checkIfLocked) {
                if (angular.isUndefined(asset)) {
                  return 'Not Defined'
                };

                var attribute = "Status";
                var lockedStatus = "Processed";
                var notLockedStatus = "Pending";
                var idx = DamAssetTypeSvc.lookup()[asset.asset_type_id][attribute];

                if (asset.metadata.length <= 0 || idx < 0) {
                    return !checkIfLocked; // default to not locked
                }

                if (checkIfLocked && asset.metadata[idx].value == "Processed"){
                    return "Locked";
                } else {
                    return "Not Locked";
                }
            };
        }
    ]);
