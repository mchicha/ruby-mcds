$(function() {
  $('.drawer').slideDrawer({
    showDrawer: false,
    slideSpeed: 700,
    slideTimeout: true,
    slideTimeoutCount: 5000,
    drawerHiddenHeight: 0
  });
});

function removeMessage(el) {
  swal({
    title: "Confirm Remove/Delete",
    text: "Are you sure you want to delete/remove this message?",
    type: "warning",
    showCancelButton: true,
    confirmButtonColor: "#DD6B55",
    confirmButtonText: "Yes delete the message",
    cancelButtonText: "No",
    closeOnConfirm: false
  }, function() {
    $.ajax({
      type: 'DELETE',
      url: "/message-center/" + $(el).attr("data-message-id"),
      success: function() {
        swal("Deleted!", "Message has been deleted.", "success");
      },
      error: function(error) {
        swal("Error!", "Error message: " + error, "error");
      }
    });
  });
}

function removeResource(el) {
  swal({
    title: "Confirm Remove/Delete",
    text: "Are you sure you want to delete/remove this asset/resource from the message?",
    type: "warning",
    showCancelButton: true,
    confirmButtonColor: "#DD6B55",
    confirmButtonText: "Yes delete the asset",
    cancelButtonText: "No",
    closeOnConfirm: false
  }, function() {
    $.ajax({
      type: 'DELETE',
      url: "/message-center/" + $(el).attr("data-message-id") + "/resources/" + $(el).attr("data-resource-id"),
      success: function() {
        swal("Deleted!", "Resource has been deleted.", "success");
      },
      error: function(error) {
        swal("Error!", "Error message: " + error, "error");
      }
    });
  });
}



function removeMultipleMessages() {
  swal({
    title: "Confirm Remove/Delete",
    text: "Are you sure you want to delete/remove these message(s)?",
    type: "warning",
    showCancelButton: true,
    confirmButtonColor: "#DD6B55",
    confirmButtonText: "Yes delete the messages",
    cancelButtonText: "No",
    closeOnConfirm: false
  }, function() {

    var messages_to_be_removed = $('input.remove-message-checkbox:checked');
    messages_to_be_removed.each(function() {
      $.ajax({
        type: 'DELETE',
        url: "/message-center/" + $(this).val(),
        success: function() {
          swal("Deleted!", "Message(s) has been deleted.", "success");
        },
        error: function(error) {
          swal("Error!", "Error message: " + error, "error");
        }
      });
      $("#message_"+$(this).val()).fadeOut('slow');
    });

  });
}
