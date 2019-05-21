'use strict';

angular.module('schematicApp')
    .directive('noteCollection', [
        'NoteSvc',
        function(NoteSvc) {
            return {
                restrict: 'E',
                scope: {
                  editable:   "=edit",
                  removable:  "=removable",
                  doc:        "=doc",
                  schem:      "=schem"
                },
                bindToController: true,
                link: {
                  post: function postLink(scope, iElement, iAttrs, controller) {
                      var offset = iElement.offset();

                      iElement.on('dblclick', function(e){
                          if(scope.ntColCtrl.editable){
                              scope.ntColCtrl.addNote(offset, e);
                              scope.$digest();
                          }
                      });

                      scope.$watch('ntColCtrl.editable', function(newValue, oldValue) {
                          if (newValue === true) {
                              iElement.css({
                                width: scope.ntColCtrl.doc.width,
                                height: scope.ntColCtrl.doc.height
                              });
                          } else {
                              iElement.css({
                                width: 0,
                                height: 0
                              });
                          }
                      });
                  }
                },
                template: '<adjustable note="note" doc="ntColCtrl.doc" edit="ntColCtrl.editable" ng-repeat="note in ntColCtrl.doc.notes" ng-class="{editable: ntColCtrl.editable, removable: ntColCtrl.removable}"><a confirmable class="delete" success="ntColCtrl.removeNote(note)" text="{{ntColCtrl.removeMsg}}"><i class="fa fa-fw fa-times fa-2x"></i></a><noteable note="note" doc="ntColCtrl.doc" schem="ntColCtrl.schem" edit="ntColCtrl.editable" /></adjustable>',
                controller: function() {
                  var ntColCtrl             = this;

                  ntColCtrl.removeMsg = "Are you sure you want to remove this note?"

                  ntColCtrl.addNote = function(offset, e){
                    var y = ((e.pageY - offset.top - 30) / ntColCtrl.doc.config.scale),
                        x = ((e.pageX - offset.left + 10) / ntColCtrl.doc.config.scale),
                        name = new Date().getTime();

                    var note = new NoteSvc.build({
                      name: name,
                      x: x,
                      y: y,
                      document_id:  ntColCtrl.doc.id,
                      schematic_id: ntColCtrl.schem.id
                    });

                    ntColCtrl.doc.notes.push(note);

                    return note;
                  }

                  ntColCtrl.removeNote = function(note){
                    var idx = ntColCtrl.doc.notes.indexOf(note);

                    if(note.id) {
                        note.$delete({document_id: ntColCtrl.doc.id, schematic_id: ntColCtrl.schem.id}, function(success){
                            ntColCtrl.doc.notes.splice(idx, 1);
                        }, function(error){
                            alert('Cannot remove this note at this time.');
                        })
                    } else {
                        ntColCtrl.doc.notes.splice(idx, 1);
                    }

                  }
                },
                controllerAs: "ntColCtrl"
            };
        }
    ]);
