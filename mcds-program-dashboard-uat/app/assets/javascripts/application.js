// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require angular
//= require "./shared/ajaxLoader"
//= require sly
//= require tkml-dam-client.min
//= require angular/config
//= require_tree ./angular/controllers
//= require autocomplete-rails
//= require programs
//= require color_blocks
//= require contact_lists
//= require list.min.js
//= require bootstrap-sprockets
//= require jquery.tablesorter.min
//= require contact_lists
//= require agencies
//= require sweet-alert.min
//= require moment
//= require bootstrap-datetimepicker
//= require bootstrap-datepicker
//= require fullcalendar
//= require ckeditor/init
//= require ckeditor/config
//= require messages
//= require message_drawer
//= require jquery.slidedrawer.min
//= require jquery.remotipart

$(function() {

  // use these classes to assign a date picker to the input
  // date & time
  $(".form-date-time-input").datetimepicker({
    useCurrent: false,
    showClear: true,
    minDate: new Date(),
    widgetPositioning: {
      horizontal: 'right',
      vertical: 'bottom'
    }
  });

  // date only
  $(".form-date-input").datetimepicker({
    useCurrent: false,
    showClear: true,
    format: "MM/DD/YYYY"
  });

  $(".fa-calendar").on('click', function(){
    $(this).siblings('.form-date-input').focus();
  });

});

function addNewGeographies(el) {
  var checkedValue = $(el).val();
  if ($(el).prop('checked')) {
    $(".assigned-geographies-list").append(
      "<li id='new_program_geographies_" + checkedValue + "'>" + $(el).attr("data-geography-name") + "</li>"
    );
  } else {
    $("#new_program_geographies_" + checkedValue).remove();
  }
}

$(".close").on("click", function(){
  $(this).parent().slideUp();
});
