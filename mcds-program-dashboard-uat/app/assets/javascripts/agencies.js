//= require autocomplete-rails

// Sweet Alert confirm boxes
function confirmAgencyDelete(el) {
  var agency_id = $(el).attr("data-agency-id");
  swal({
    title: "Are you sure?",
    text: "Delete " + $(el).attr("data-agency-name") + " agency? This cannot be undone!",
    type: "warning",
    showCancelButton: true,
    confirmButtonColor: "#DD6B55",
    confirmButtonText: "Yes, delete it!",
    closeOnConfirm: false
  }, function() {
    $.ajax({
      type: 'DELETE',
      url: "/manage-agencies/" + agency_id,
      success: function() {
        $("#agency-id-" + agency_id).fadeOut('slow');
        swal("Deleted!", "Agency has been deleted.", "success");
      },
      error: function(error) {
        swal("Error!", "Error message: " + error, "error");
      }
    });
  });
}

function confirmAgencyCoOp(el) {
  var agency_id = $(el).attr("data-agency-id");
  var geography_id = $(el).attr("data-co-op-id");
  swal({
    title: "Are you sure?",
    text: "Delete " + $(el).attr("data-co-op-name") + " from " + $(el).attr("data-agency-name") + " agency? This cannot be undone!",
    type: "warning",
    showCancelButton: true,
    confirmButtonColor: "#DD6B55",
    confirmButtonText: "Yes, delete it!",
    closeOnConfirm: false
  }, function() {
    $.ajax({
      type: 'DELETE',
      url: "/manage-agencies/" + agency_id + "/destroy_agency_geography/" + geography_id,
      success: function() {
        $("#agency-" + agency_id + "-co-op-" + geography_id + "").fadeOut('slow');
        swal("Deleted!", "Co-Op has been deleted from this agency.", "success");
      },
      error: function(error) {
        swal("Error!", "Error message: " + error, "error");
      }
    });
  });
}

function removeAllCoOps(el) {
  var agency_id = $(el).attr("data-agency-id");
  var geography_id = $(el).attr("data-co-op-id");
  swal({
    title: "Are you sure?",
    text: "Delete all co-ops from " + $(el).attr("data-agency-name") + " agency? This cannot be undone!",
    type: "warning",
    showCancelButton: true,
    confirmButtonColor: "#DD6B55",
    confirmButtonText: "Yes, delete it!",
    closeOnConfirm: false
  }, function() {
    $.ajax({
      type: 'DELETE',
      url: "/manage-agencies/" + agency_id + "/destroy_all_geographies_from_agency",
      success: function() {
        swal("Deleted!", "All co-ops have been deleted from this agency.", "success");
        window.location = "/manage-agencies"
      },
      error: function(error) {
        swal("Error!", "Error message: " + error, "error");
      }
    });
  });
}


function removeAgencyUser(el) {
  var agency_id = $(el).attr("data-agency-id");
  var user_id = $(el).attr("data-user-id");
  swal({
    title: "Are you sure?",
    text: "Delete " + $(el).attr("data-user-name") + " from " + $(el).attr("data-agency-name") + " agency? This cannot be undone!",
    type: "warning",
    showCancelButton: true,
    confirmButtonColor: "#DD6B55",
    confirmButtonText: "Yes, delete it!",
    closeOnConfirm: false
  }, function() {
    $.ajax({
      type: 'DELETE',
      url: "/manage-agencies/" + agency_id + "/destroy_agency_user/" + user_id,
      success: function() {
        $("#agency-" + agency_id + "-user-" + user_id + "").fadeOut('slow');
        swal("Deleted!", "User has been deleted from this agency.", "success");
      },
      error: function(error) {
        swal("Error!", "Error message: " + error, "error");
      }
    });
  });
}

function updateUserToGeography(el) {
  var checked = $(el).prop("checked");
  $.ajax({
    type: "POST",
    data: "checked="+checked+"&user_id=" + $(el).attr("data-user-id"),
    url: "/co-ops/" + $(el).val() + "/assign_user",
    success: function() {
      // no necessary success message/action needed
    },
    error: function(error) {
      swal("Error!", "Error message: " + error, "error");
    }
  });
}

$(function() {

  $(".co-op-checkbox").click(function() {
    var checkedLength = $(".co-op-checkbox:checked").length;
    if (checkedLength < 1) {
      $(".add-geographies-btn").attr("disabled", "disabled");
    } else {
      $(".add-geographies-btn").removeAttr("disabled");
    }
  });

});
