angular.module('contactListApp')
  .controller('MyContactListsCtrl',
    function(contact_lists, current_user, $modal, $filter, ContactListSvc, ContactListUserSvc) {
      // initialize
      var my_lists = this;
      my_lists.contact_lists = contact_lists;
      my_lists.current_user = current_user;
      my_lists.predicate = 'name';

      // view contact detail modal
      my_lists.open = function(user) {
        var modalInstance = $modal.open({
          templateUrl: 'view_contact.html',
          controller: 'ModalInstanceCtrl as modal',
          resolve: {
            user: function() {
              return user;
            }
          }
        });
        return;
      }

      my_lists.checkAllUsers = function () {
        if (my_lists.selectedAllUsers) {
          my_lists.selectedAllUsers = true;
        } else {
          my_lists.selectedAllUsers = false;
        }
        angular.forEach(my_lists.users, function (item) {
          item.checked = my_lists.selectedAllUsers;
        });
      };

      // FILTER RECORDS THAT ARE CHECKED
      // Personal lists that are checked for removal
      my_lists.selectedLists = function() {
        return $filter('filter')(my_lists.contact_lists, {checked: true});
      }

      // REMOVAL OF THE CONTACT LIST
      // remove the personal contact group from the users profile
      my_lists.removeGroup = function(contactGroup) {
        swal({
          title: "Are you sure?",
          text: "Delete " + contactGroup.name + "? You cannot undo this action.",
          type: "warning",
          showCancelButton: true,
          confirmButtonColor: "#DD6B55",
          confirmButtonText: "Yes, delete it!",
          cancelButtonText: "No, cancel!",
          closeOnConfirm: false,
          closeOnCancel: true
        }, function(isConfirm) {
          if (isConfirm) {
            contactGroup.$remove(function(success) {
              my_lists.resetContactLists();
              swal("Deleted!", "Contact group has been deleted.", "success");
            }, function(error) {
              swal("Error", "Contact group could not be deleted: " + error, "error");
            });
          }
        });
      }

      // Bulk removal of contact lists
      my_lists.removeBulkContactGroups = function() {
        var total_contacts_in_lists = 0;
        var selectedLists = my_lists.selectedLists();

        angular.forEach(my_lists.selectedLists(), function(list) {
          total_contacts_in_lists += list.contact_list_users.length;
        });

        // if selected list is only 1, show different message than multiple
        if (selectedLists.length == 1) {
          alertText = "You are about to delete a list containing " + total_contacts_in_lists + " contacts. Are you sure you want to delete this list? This action cannot be undone.";
        } else {
          alertText = "You are about to delete " + selectedLists.length + " lists containing " + total_contacts_in_lists + " contacts. Are you sure you want to delete these lists? This action cannot be undone.";
        }

        swal({
          title: "Are you sure?",
          text: alertText,
          type: "warning",
          showCancelButton: true,
          confirmButtonColor: "#DD6B55",
          confirmButtonText: "Yes",
          cancelButtonText: "No",
          closeOnConfirm: false,
          closeOnCancel: true
        }, function(isConfirm) {
          if (isConfirm) {
            angular.forEach(selectedLists, function(list) {
              list.$remove(function(success) {
                // insert some success message
              }, function(error) {
                swal("Error", "List could not be deleted: " + error, "error");
              })
            });
            my_lists.resetContactLists();
            swal("Deleted!", selectedLists.length + " lists has been deleted.", "success");
          }
        });
      }

      my_lists.resetContactLists = function() {
        my_lists.contact_lists = ContactListSvc.resource.query({user_id: current_user.id});
      }


  });
