angular.module('contactListApp')
  .controller('ContactListsCtrl',
    function(users, contact_lists, current_user, $modal, $filter, ContactListSvc, ContactListUserSvc) {
      // initialize
      var contact = this;
      contact.users = users.users;
      contact.contact_lists = contact_lists;

      contact.pageTitle = 'Manage Contacts & Contact Groups';
      contact.listName = '';
      contact.selectedList = '';
      contact.showUpdateList = false;
      contact.showGroupListField = false;
      contact.selectedAllUsers = false;
      contact.current_user = current_user;
      contact.predicate = '-email';

      contact.checkAllUsers = function () {
        if (contact.selectedAllUsers) {
          contact.selectedAllUsers = true;
        } else {
          contact.selectedAllUsers = false;
        }
        angular.forEach(contact.users, function (item) {
          item.checked = contact.selectedAllUsers;
        });
      };

      // FILTER RECORDS THAT ARE CHECKED
      // Users when creating/updating a list
      contact.selectedUsers = function() {
        return $filter('filter')(contact.users, {checked: true});
      }

      // Personal lists that are checked for removal
      contact.selectedLists = function() {
        return $filter('filter')(contact.contact_lists, {checked: true});
      }

      contact.selectedListUsers = function() {
        if (contact.selectedContactGroup) {
          return $filter('filter')(contact.selectedContactGroup.contact_list_users, {checked: true});
        }
      }

      // create a contact list with the selected users.
      contact.createNewList = function() {
        var modalInstance = $modal.open({
          templateUrl: 'create_new_list.html',
          controller: 'ModalInstanceCtrl as modal',
          resolve: {
            selected_users: function() {
              return contact.selectedUsers();
            },
            contact: function(){
              return contact;
            },
            contact_lists: function() {
              return contact.contact_lists;
            }
          }
        });
        return;
      }

      contact.updateListModal = function() {
        var modalInstance = $modal.open({
          templateUrl: 'update_list.html',
          controller: 'ModalInstanceCtrl as modal',
          resolve: {
            selected_users: function() {
              return contact.selectedUsers();
            },
            contact: function(){
              return contact;
            },
            contact_lists: function() {
              return contact.contact_lists;
            }
          }
        });
        return;
      }

      contact.resetContactLists = function() {
        contact.contact_lists = ContactListSvc.resource.query({user_id: current_user.id});
      }

      contact.clearInputs = function(collection) {
        for (var i = 0; i < collection.length; i++) {
          collection[i].checked = false;
        }
      }

      contact.inputChanged = function(str) {
        contact.listName = str;
      }

      // METHOD FOR AUTOCOMPLETE WHEN ASSIGNING USERS TO A LIST
      contact.contactSearch = function(selected) {
        if (selected) {
          contact.listName = selected;
          contact.showUpdateList = true;
        } else {
          contact.listName = '';
          contact.showUpdateList = false;
        }
      }

  });



angular.module('contactListApp').controller('ModalInstanceCtrl',
  function($modalInstance, selected_users, ContactListSvc, current_user, contact, contact_lists) {
    var modal = this;
    modal.cancel = function () {
      $modalInstance.close();
    }
    // methods/variables below for creating a new list
    modal.number_of_users = selected_users;
    modal.contact_lists = contact_lists;
    modal.selectedList = '';

    modal.makeList = function() {
      var selectedUsers = modal.number_of_users;
      var listName = modal.newListName;

      modal.contactList = new ContactListSvc.build({
        name: listName,
        user_id: current_user.id,
        users: selectedUsers
      });

      modal.contactList.$save(function(success) {
        contact.contact_lists = ContactListSvc.resetLists();
        contact.clearInputs(contact.users);
        $modalInstance.close();
      }, function(error) {
        console.log("Error: " + error);
      });
    }

    // update the list with new users.
    modal.updateList = function(list) {
      var selectedUsers = modal.number_of_users;

      list.users = {};
      list.users = selectedUsers;
      list.$update(function(success) {
        contact.contact_lists = ContactListSvc.resetLists();
        contact.clearInputs(contact.users);
        $modalInstance.close();
      }, function(error) {
        // error
      });
    }

  }
);
