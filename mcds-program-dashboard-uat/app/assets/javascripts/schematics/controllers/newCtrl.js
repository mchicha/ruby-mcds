'use strict';

angular.module('schematicApp')
  .controller('NewCtrl', [
    '$state',
    'schematic',
    'geographies',
    'SchematicSvc',
    'CopySchematicSvc',
    '$modalInstance',
    'current_user',
    function($state, schematic, geographies, SchematicSvc, CopySchematicSvc, $modalInstance, current_user){
      var newSchem = this;
      newSchem.user = current_user;
      newSchem.saving = false;
      newSchem.showErrorMessage = false;

      if(current_user.selected_geography){ // Current user selected geography check if national
        newSchem.parentLevelSelected = (current_user.selected_geography.name === 'National');
      }


      if (schematic){                      // If schematic is given, then it is copied
        schematic.geographies = [];
        angular.forEach(geographies, function(geog){
          if(schematic.geography_ids.indexOf(geog.id) > -1){
            schematic.geographies.push(geog);
          }
        });

        newSchem.schematic = CopySchematicSvc.generate(schematic, newSchem.parentLevelSelected);
      }
      else{
        newSchem.today = new Date();
        // make end date at least one day in the future, otherwise it will start archived
        var endDate = new Date(newSchem.today.getTime() + 86400000);
        newSchem.schematic = new SchematicSvc.build({
          release_date: newSchem.today,
          end_date: endDate,
          status: "planning"
        });
      }

      newSchem.close = function(){
        newSchem.canceled = true;
        $modalInstance.dismiss('cancel');
      };

      newSchem.save = function(){
        newSchem.saving = true;
        newSchem.showErrorMessage = false;
        if (!newSchem.canceled){
          // Check if form valid, and if the js object has geography_ids
          if (newSchem.form.$valid && newSchem.schematic.geography_ids && newSchem.schematic.geography_ids.length > 0){
            newSchem.schematic.$save(function(success){
              //$state.go('',{id: success.id});
              $state.go('root', null, {'reload':true});
              newSchem.saving = false;
              newSchem.close();

            }, function(errorResult){
              newSchem.saving = false;
              newSchem.showErrorMessage = true;
            });
          } else {
            newSchem.saving = false;
            newSchem.showErrorMessage = true;
            newSchem.errors = [];

            if(newSchem.form.$error && newSchem.form.$error.required && newSchem.form.$error.required.length > 0){
              newSchem.form.$error.required.forEach(function(error){
                if(error.$name == "name"){
                  newSchem.errors.push('Name');
                }
                else{
                  // Warning for missing dates are combined for ease and less space, but only add once:
                  if(newSchem.errors.indexOf('Start/End Date') === -1){
                    newSchem.errors.push('Start/End Date');
                  }
                }
              })
            }

            if(!newSchem.schematic.geography_ids || newSchem.schematic.geography_ids.length < 1){
              newSchem.errors.push('Geography');
            }
          }
        }
      };

      newSchem.submitText = function(){
        var save_text = "Save & Continue "
        var saving_text = "Saving..."
        return newSchem.saving ? saving_text : save_text
      }
    }
  ]);
