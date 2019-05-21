'use strict';

angular.module('schematicApp')
  .factory('DocumentSvc', [
    '$resource',
    '$http',
    'ElementSvc',
    'NoteSvc',
    function ($resource, $http, ElementSvc, NoteSvc) {
      var Transformer, Document, Build;

      Transformer = function(data){
        var w = angular.fromJson(data);
        angular.forEach(w.documents, function(doc, idx){
          w.documents[idx] = new Document(doc);

          angular.forEach(w.documents[idx].notes, function(note, ndx){
            w.documents[idx].notes[ndx] = NoteSvc.build(note);
          });
        });

        angular.forEach(w.elements, function(el, edx){
            w.elements[edx] = new ElementSvc.resource(el);
        });

        return w;
      };

      Document = $resource('/api/v1/schematics/:schematic_id/document', {schematic_id: '@schematic_id'}, {
        query: {
          method: 'GET',
          isArray: false, // <- not returning an array
          transformResponse: Transformer
        }
      });

      Build = function(obj) {
        return new Document({
          title     : obj['title'] || '',
          _destroy  : false
        })
      };

      return {
        resource: Document,
        build: Build,
        all: function(){
          return $http.get('/api/v1/documents/', {
          method: 'GET',
          transformResponse: Transformer,
          cache: false
        })},
        findOrCreate: function(result){
          if(angular.isObject(result)){
            return result;
          } else{
            return Build({title: result});
          }
        }
      };
  }]);
