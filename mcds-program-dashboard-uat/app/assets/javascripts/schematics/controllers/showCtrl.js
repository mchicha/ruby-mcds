'use strict';

angular.module('schematicApp')
    .controller('ShowCtrl', [
        'PdfSvc',
        'pdfs',
        'schematic',
        '$timeout',
        'current_user',
        function(PdfSvc, pdfs, schematic, $timeout, current_user) {
          var showCtrl = this;

          showCtrl.pdfs         = pdfs;
          showCtrl.schematic    = schematic;
          showCtrl.isPending    = false;
          showCtrl.itterations  = 0;
          showCtrl.current_user = current_user;

          showCtrl.compareSchematicPdf = function(){

            schematic.$get(function(success){
              ////////////////
              // This is commented out because PDF generation is not being worked on.
              ////////////

              //     if (showCtrl.pdfPending()) {
              //         showCtrl.itterations += 1;
              //         showCtrl.isPending = true;
              //         showCtrl.reloadPDFS();
              //     } else {
              //         showCtrl.isPending = false;
              //         showCtrl.itterations = 0;
              //     }

              }, function(error){
                  alert('Failed to reload schematic');
              });
          }

          showCtrl.reloadPDFS = function(){
            $timeout(function(){

                PdfSvc.resource.query({
                    schematic_id: showCtrl.schematic.id
                }, function(success){
                    showCtrl.pdfs = success;
                    showCtrl.compareSchematicPdf();

                },function(error){
                    alert('Failed to reload pdfs');
                });

            }, 45000);
          }

          showCtrl.pdfPending = function(){
              var pdfCreatedAt        = new Date(showCtrl.pdfs[0] ? showCtrl.pdfs[0].created_at : null),
                  schematicUpdatedAt  = showCtrl.schematic.updated_at;

              return pdfCreatedAt.getTime() < schematicUpdatedAt.getTime();
          }

          showCtrl.compareSchematicPdf();

        }
    ]);
