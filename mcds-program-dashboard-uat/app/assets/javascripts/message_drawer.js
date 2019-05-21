// makes sure at least one panel in the accordion is open at all times
$('.panel-heading label').on('click',function(e){
  if($(this).parents('.panel').children('.panel-collapse').hasClass('in')) {
    e.stopPropagation();
  }
});


// functions to check if proper information was filled out:

var messageToDashboardCheck = function(e){
  if($('#message_publish_date').length < 1 || $('.assigned-geographies-list').find('li').length < 1 || $('#message_subject').val().length < 1){
    e.preventDefault()
    alert("One of the required fields was not filled out.    Required: Publish Date, Group(s), and Subject")
  }
}

var messageAsEmailCheck = function(e){
  if( ($('.users-selected').find('div').length < 1 && $('.contact-lists-selected').find('div').length < 1) || $('#message_subject').val().length < 1){
    e.preventDefault()
    alert("One of the required fields was not filled out.    Required: Subject and At least one User or Contact List")
  }
}


// the default must be bound to begin with:
  $('#message_sent').val('true')
  $('#message_delivery_type_email').prop('checked', true);
  $("#submit-message-btn").on('click', function(e){
    messageAsEmailCheck(e);
  })

  $(document).on('submit', '.messaging-form', function(){
    $("#submit-message-btn").prop('disabled', true);

  })


// select the hidden radio button input when you expand the accordion drawer
// $('#collapseOne').on('shown.bs.collapse', function(){
//   $('#message_delivery_type_published').prop('checked', true);

//   $("#collapseTwo").find('input, select').each(function() {
//     $(this).val('');
//     $(".users-selected").html('');
//   });

//   $("#submit-message-btn").val('Publish Message to Dashboard');

//   $("#submit-message-btn").off('click')
//   $("#submit-message-btn").on('click', function(e){messageToDashboardCheck(e)})
// });

// $('#collapseTwo').on('shown.bs.collapse', function(){
//   $('#message_delivery_type_email').prop('checked', true);

//   $("#collapseOne").find('input').not(".co-op-checkbox").each(function() {
//     $(this).val('');
//   });

//   $(".co-op-checkbox").each(function() {
//     $(this).prop('checked', false);
//   });

//   $('#message_sent').val('true')

//   $(".assigned-geographies-list").html('');

//   $("#submit-message-btn").val('Send/Schedule Email');

//   $("#submit-message-btn").off('click')
//   $("#submit-message-btn").on('click', function(e){messageAsEmailCheck(e)})
// });



$("select#message_sent").on('change', function() {
  if ($(this).val() == "false") {
    $("#send-at-later-date").show();
    // $("#message_send_date").val('');
  } else {
    $("#send-at-later-date").hide();
  }
})

$("#find-recipient").autocomplete({
  source: $('#find-recipient').data('autocomplete-source'),
  select: function (a, b) {
    $(".users-selected").append("<div id='user_selected_" + b.item.value + "'><input type='hidden' value='" + b.item.value + "' name=user_ids[]>" + b.item.label + " <a onclick=\"$('#user_selected_" + b.item.value + "').remove();\">Remove</a></div>");
  },
  close: function(a, b) {
    $(this).val('');
  }
});

$("#find-contact-list-recipients").autocomplete({
  source: $('#find-contact-list-recipients').data('autocomplete-source'),
  select: function (a, b) {
    $(".contact-lists-selected").append("<div id='contact_list_selected_" + b.item.value + "'><input type='hidden' value='" + b.item.value + "' name=contact_list_ids[]>" + b.item.label + " <a onclick=\"$('#contact_list_selected_" + b.item.value + "').remove();\">Remove</a></div>");
  },
  close: function(a, b) {
    $(this).val('');
  }
});

$(".form-date-time-input").datetimepicker({
  useCurrent: false,
  showClear: true,
  minDate: new Date(),
  widgetPositioning: {
    horizontal: 'right',
    vertical: 'bottom'
  }
});
