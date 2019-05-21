angular.module("McSource").
  controller('AssetCtrl', ['$scope', 'Asset', 'AssetType', function($scope, Asset, AssetType) {

  var defaultAssetTypeId = 0;

  $scope.init = function(programId, isShowPage){
    $scope.selectedAssetTypeId = "";
    $scope.assets = [];
    $scope.sortTerm = "SKU";
    $scope.assetForm = {
      title: "Add"
    };

    $scope.isShowPage = isShowPage;
    Asset.get(function(data){
      angular.forEach(data.assets, function(asset){
        if($scope.formattedMetadata(asset, "Program ID") && $scope.formattedMetadata(asset, "Program ID") == programId){
          $scope.assets.push(asset);
        }
      });
    });

    if(!isShowPage){
      // Asset Types are not needed for the show page, as no SAC
      AssetType.get(function(data){
        $scope.assetTypes = data.asset_types;
        setDefaultAssetTypeId(data.asset_types);
      });
    }
  };

  $scope.updateAssets = function(asset){
    var isNewAsset = true;
    angular.forEach($scope.assets, function(a, i){
      if (a.id == asset.id){
        isNewAsset = false;
        $scope.assets[i] = asset;
      }
    });
    if (isNewAsset){
      $scope.assets.push(asset);
    }
    $scope.assetForm.title = "Add";
    $scope.selectedAssetId = "";
  };

  $scope.formattedMetadata = function(asset, name) {
    var metadata = {};
    angular.forEach(asset.metadata, function(m){
      var key = m["name"];
      if (key){
        metadata[key.toLowerCase()] = m["value"];
      }
    });
    if (name){
      return metadata[name.toLowerCase()];
    } else {
      return metadata;
    }
  }

  $scope.changeAssetType = function(event, assetTypeId){
    event.preventDefault();
    $scope.selectedAssetTypeId = assetTypeId;
  };

  $scope.sortAssets = function(asset){
    var result = $scope.formattedMetadata(asset, $scope.sortTerm).toLowerCase()
    if (result !== ''){
      return $scope.formattedMetadata(asset, $scope.sortTerm).toLowerCase();
    }else{
      return 'zzzzzzzzz'; //Sort to end, otherwise it hops at the front
    }
  };

  $scope.clearSearchTerm = function(e){
    e.preventDefault();
    $scope.searchTerm = "";
  };

  $scope.editAssetMode = function(e, asset){
    eatingGlue(true) // This is a horrendous use of code...hence the name...programs.js
    e.preventDefault();
    $scope.assetForm.title = "Edit";
    $scope.selectedAssetId = asset.id;
  };

  $scope.addAssetMode = function(e){
    eatingGlue(true) // This is a horrendous use of code...hence the name...programs.js
    e.preventDefault();
    $scope.assetForm.title = "Add";
    $scope.selectedAssetId = "";
    $scope.selectedAssetTypeId = defaultAssetTypeId;
  };

  var setDefaultAssetTypeId = function (assetTypes){
    angular.forEach(assetTypes, function(assetType, i){
      var lowerCaseName = (assetType.name || "").toLowerCase();
      if (lowerCaseName === "local element"){
        $scope.selectedAssetTypeId = defaultAssetTypeId = assetType.id;
      }
    });
  };

}])
.directive('ngTableSorter', function() {
  return {
    restrict: 'A',
    template: function(element){
      return element.text() + "<span class='up' reverse=false>&#9650;</span><span class='down' reverse=true>&#9660;</span>";
    },
    link: function(scope, element, attrs){
      element.on('click', function(e){
        scope.sortTerm = attrs.sortTerm;
        scope.reverse = (angular.element(e.target).attr('reverse') === "true");
        scope.$apply();
      });
    }
  };
});
