//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require moment
//= require bootstrap-datetimepicker
//= require bootstrap-datepicker
//= require sweet-alert.min
//= require geographies

$(document).on('change', '#alertable_type_select', function(){
  setAlertDropDowns();
})

$(document).on('ready', function(){
  setAlertDropDowns();


  // These are from application.js....need to be in their own file
  // date only
  $(".form-date-input").datetimepicker({
    useCurrent: false,
    showClear: true,
    format: "MM/DD/YYYY"
  });

  $(".fa-calendar").on('click', function(){
    $(this).siblings('.form-date-input').focus();
  });
})

var setAlertDropDowns = function(){
  $('.alertable_id_select').hide().attr('name', '');

  var typeValue = $('#alertable_type_select').val();

  if(typeValue){
    $('.alert_for_container').show();
    $('#' + typeValue.toLowerCase() + '_select').show().attr('name', currentClass + '[' + currentClass + 'able_id]');
  }
  else{
    $('.alert_for_container').hide();
  }
}
