angular.module('contactListApp')
  .controller('ContactListCtrl',
    function(contact_lists, current_user, $modal, $filter, ContactListSvc, ContactListUserSvc, $state) {

      var list = this;
      list.current_user = current_user;
      list.contact_lists = contact_lists;
      list.current_list = $filter('filter')(contact_lists, {id: $state.params.listId})[0];
      list.predicate = '-user.email';

      list.selectedUsers = function() {
        return $filter('filter')(list.current_list.contact_list_users, {checked: true});
      }

      list.checkAllUsers = function () {
        if (list.selectedAllUsers) {
          list.selectedAllUsers = true;
        } else {
          list.selectedAllUsers = false;
        }
        angular.forEach(list.current_list.contact_list_users, function (item) {
          item.checked = list.selectedAllUsers;
        });
      };

      list.removeUsersFromList = function(contact_list) {
        var selectedListUsers = list.selectedUsers();
        swal({
          title: "Are you sure?",
          text: "You are deleting " + selectedListUsers.length + " users from this list. This action cannot be undone.",
          type: "warning",
          showCancelButton: true,
          confirmButtonColor: "#DD6B55",
          confirmButtonText: "Yes",
          cancelButtonText: "No",
          closeOnConfirm: false,
          closeOnCancel: true
        }, function(isConfirm) {
          if (isConfirm) {
            angular.forEach(selectedListUsers, function(user) {
              ContactListUserSvc.resource.delete({id: user.id}, function(success) {
                // insert some success message
              }, function(error) {
                swal("Error", "List could not be deleted: " + error, "error");
              })
            });
            list.current_list = ContactListSvc.resource.get({user_id: current_user.id, id: contact_list.id});
            swal("Deleted!", selectedListUsers.length + " users has been removed from this list.", "success");
          }
        });
      }
      // END OF BULK REMOVAL METHODS

      // remove the join record between the users personal group and contact list
      // ContactListUser is the Rails model (api/v1/contact_list_users_controller.rb)
      list.removeContactListUser = function(contact_list, contact_list_user, index) {
        swal({
          title: "Are you sure?",
          text: "You are about to remove this contact from the list. Are you sure you want to remove this contact? This action cannot be undone.",
          type: "warning",
          showCancelButton: true,
          confirmButtonColor: "#DD6B55",
          confirmButtonText: "Yes",
          cancelButtonText: "No",
          closeOnConfirm: false,
          closeOnCancel: true
        }, function(isConfirm) {
          if (isConfirm) {
            ContactListUserSvc.resource.delete({id: contact_list_user.id}, function(success) {
              swal("Deleted!", "User has been deleted from the " + contact_list.name + " group.", "success");
              list.current_list = ContactListSvc.resource.get({user_id: current_user.id, id: contact_list.id});
            }, function(error) {
              swal("Error", "User could not be deleted from group: " + error, "error");
            });
          }
        });
      }

  });
