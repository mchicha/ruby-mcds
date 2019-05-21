'use strict';

angular.module('schematicApp')
  .service('CloneSvc', ['$state', function($state) {
    var _pendingClones = [],
        _addClone,
        _removeClone,
        _createClone,
        _wipePending,
        _buildClone;

    _addClone = function(schematic){
      var newSchematic  = angular.copy(schematic),
          oldDate       = new Date(newSchematic.release_date),
          newDate       = new Date(oldDate.setDate(oldDate.getDate() + 7));

      newSchematic.release_date = newDate;

      _pendingClones.push(newSchematic);
      return _pendingClones
    };

    _removeClone = function(idx){
      if(idx > -1){
       return _pendingClones.splice(idx, 1);
      }
    };

    _createClone = function(schematic){
      return schematic.$clone({id: schematic.id}, function(success) {
        return true;
      }, function(errorResult) {
        // Error Callback
        return false;
      });
    };

    _wipePending = function(){
      _pendingClones = [];
    };


    return {
      pending: function(){ return _pendingClones; },
      add:    _addClone,
      remove: _removeClone,
      create: _createClone,
      wipe:   _wipePending
    }

  }]);
