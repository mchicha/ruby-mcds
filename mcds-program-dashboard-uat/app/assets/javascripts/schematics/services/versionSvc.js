'use strict';

angular.module('schematicApp')
  .factory('VersionSvc', [
    function () {
      var _versions_ = [],
          _currentVersion_ = 0,
          _add_,
          _remove_,
          _wipe_,
          _all_,
          _getCurrentVersion_,
          _setCurrentVersion_,
          _isCurrent_,
          _wipeInvalidVersions_,
          _setGrouped_,
          _versionsGrouped_ = null;

      _setGrouped_ = function(count){
        _versionsGrouped_ = 2;
      };

      _add_ = function(version){
        var array;

        if(!_isCurrent_()) { _wipeInvalidVersions_() };

        if(_versionsGrouped_) {
          // determine if version is first one in groups
          if(_versionsGrouped_ === 2){
            _versions_.push([version]);
          } else {
            _versions_[_versions_.length - 1].push(version);
          }

          // reduce version count
          _versionsGrouped_ -=  1;
          // blank if versions grouped count is 0
          if(_versionsGrouped_ === 0){
            _versionsGrouped_ = null;
          }
        } else {
          _versions_.push([version]);
        };

        _currentVersion_ = _versions_.length;
        return _versions_;
      }

      _remove_ = function(index, size){
        return _versions_.splice(index, size);
      }

      _wipe_ = function(){
        _versions_ = [];

        return _versions_;
      }

      _all_ = function(){
        return _versions_;
      }

      _isCurrent_ = function(){
        return _versions_.length == _currentVersion_;
      }

      _getCurrentVersion_ = function(){
        return _currentVersion_;
      }

      _setCurrentVersion_ = function(index){
        if(angular.isDefined(_versions_[index])){
          _currentVersion_ = index;
        } else {
          _currentVersion_ = _versions_.length;
        }
      }

      _wipeInvalidVersions_ = function(){
        var cv = _currentVersion_;
        _versions_.splice(cv, _versions_.length - cv);
      }

      return {
        setGrouped:     _setGrouped_,
        add:            _add_,
        remove:         _remove_,
        wipe:           _wipe_,
        all:            _all_,
        currentVersion: _getCurrentVersion_,
        setVersion:     _setCurrentVersion_,
        isCurrent:      _isCurrent_
      };


  }]);
