'use strict';

angular.module('schematicApp')
    .directive('noteable', [
        '$document',
        function($document) {
            return {
                restrict: 'E',
                scope: {
                    editable: '=edit',
                    note:     '=note',
                    schem:    '=schem',
                    doc:      '=doc'
                },
                replace: true,
                template: '<textarea class="form-control note" name="note" ng-model="note.body" placeholder="Insert text here." ng-model-options="{updateOn: \'default blur\', debounce: {default: 1500, blur: 0}}" ng-readonly="!editable" ng-required="true" ng-maxlength="20000" ng-class="{\'read-only\': !editable}">',
                require: '^noteCollection',
                link: function link(scope, element, attrs, models) {

                    element.css({
                        width:  scope.note.width,
                        height: scope.note.height
                    });

                    // ********************************************************
                    //                  Directive Functions
                    // ********************************************************

                    function saveNote() {
                        if(scope.note.id){
                            updateNote();
                        } else {
                            createNote();
                        }
                    };

                    function createNote() {
                        if(scope.note.body && scope.note.width && scope.note.height && scope.note.x && scope.note.y) {
                            scope.note.$save({
                                schematic_id: scope.schem.id,
                                document_id: scope.doc.id
                            }, function(success){

                            }, function(error){
                                alert('Could not create note at this time');
                            });
                        }
                    };

                    function updateNote() {

                        scope.note.$update({
                            schematic_id: scope.schem.id,
                            document_id: scope.doc.id
                        }, function(success) {

                        }, function(error) {
                            alert('Could not update note at this time');
                        })
                    };

                    // the handler function
                    function resizeEvent(textarea) {
                        if(textarea){
                          scope.note.width  = parseInt(textarea[0].style.width);
                          scope.note.height = parseInt(textarea[0].style.height);
                          scope.$apply();
                        }
                    };

                    function triggerEvent(e) {
                        resizeEvent(element);
                    };

                    // ********************************************************
                    //                    Event Watchers
                    // ********************************************************

                    element.on('dblclick', function(e) {
                        e.stopPropagation();
                    });

                    scope.$watch('editable', function(newValue, oldValue) {
                        if (newValue === true) {
                            $document.on("mouseup", triggerEvent);
                        } else {
                            $document.off("mouseup", triggerEvent);
                        }
                    });

                    scope.$watch('note', function(newValue, oldValue) {
                        if (oldValue !== newValue &&
                            (
                              newValue.body   !== oldValue.body ||
                              newValue.width  !== oldValue.width ||
                              newValue.height !== oldValue.height ||
                              newValue.x      !== oldValue.x ||
                              newValue.y      !== oldValue.y
                            )
                          ) {
                            saveNote();
                        }
                    }, true)

                    if (!scope.note.id){
                        element.focus();
                    }

                }
            };
        }
    ]);
