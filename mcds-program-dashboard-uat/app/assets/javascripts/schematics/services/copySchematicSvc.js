'use strict';

angular.module('schematicApp')
  .service('CopySchematicSvc', ['$state', 'current_user', function($state, current_user) {
    var Generate;

    Generate = function(schematic, parentLevelSelected){
      var schematicClone = angular.copy(schematic);   // Make a copy of the given schematic
      schematicClone.sourceName = schematic.name
      schematicClone.status = 'planning';

      if(schematic.parent_id){                        // If copied from a child, they share parents
        schematicClone.source_id = schematicClone.id;
        schematicClone.parent_id = schematicClone.parent_id;
      }
      else if(parentLevelSelected){
        schematicClone.source_id = schematicClone.id; // If copied parent to parent, it's a clone
      }
      else {
        schematicClone.parent_id = schematicClone.id; // If copied parent to child, it's a child
        schematicClone.source_id = null               // Wipe parent's source in case there is one
      }
      schematicClone.id = null;                       // Wipe the original ID, this is new record

      return schematicClone
    }

    return {
      generate: Generate
    }

  }]);
