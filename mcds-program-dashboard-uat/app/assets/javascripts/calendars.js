//= require fullcalendar/gcal
//= require calendars

function showEventDetail(ev, event_id) {
  var selector = "#this_event_" + event_id;
  if (ev.innerText == 'Show Details') {
    $(selector).removeClass('hidden');
    ev.innerText = 'Hide Details';
  }
  else {
    $(selector).addClass('hidden');
    ev.innerText = 'Show Details';
  }
};

$(document).ready(function() {
  var selected_date = null;
  var search_value = '';

  function getAllEventsForSelectedFilters(event) {
    search_value = $('.search-calendar input#search').val();

    if ($('#calendar')[0].style.display == 'none') {
      $.ajax({
        url: '/calendars/events/show',
        type: 'GET',
        data: {
          coops: function(){
            return $.map($('input[type="checkbox"]:checked'), function(bx){
              return bx.value;
            })
          },
          user_selected: function(){
            return $('div#select_user_type button').val();
          },
          start_date: function() {
            return $("#picktheday").datepicker("getDate");
          },
          search_field: function(){
            return search_value;
          }
        },
        success: function(data, textStatus, jqXHR ) {
          $('.search-calendar input#search').val(search_value);
          if ($( event.target ).is('.search-calendar input#search')) {
            $('.search-calendar input#search').focus();
          }
        },
        error: function(jqXHR, textStatus, errorThrown) {
          alert("Error getting events:  ", textStatus);
        }
      })
    }
    else {
      $('#calendar').fullCalendar('refetchEvents');
    }
  };

  function getEventsForEventCategory(event_cat) {
    search_value = $('.search-calendar input#search').val();
    $.ajax({
      url: '/calendars/events/show',
      type: 'GET',
      data: {
        coops: function(){
          return $.map($('input[type="checkbox"]:checked'), function(bx){
            return bx.value;
          })
        },
        user_selected: function(){
          return $('div#select_user_type button').val();
        },
        start_date: function() {
          return $("#picktheday").datepicker("getDate");
        },
        event_categories: function() {
          return event_cat;
        },
        search_field: function(){
          return search_value;
        }
      },
      success: function(data, textStatus, jqXHR ) {
        $('.search-calendar input#search').val(search_value);
      },
      error: function(jqXHR, textStatus, errorThrown) {
        alert("Error getting events:  ", textStatus);
      }
    });
  };

  function resetCalendarView() {
    $('div#select_user_type button').html("View All Events");
    $('div#select_user_type button').val($('div#select_user_type button').attr('user_id'));
    $('#assign-calendar-geographies input[type="checkbox"]:checked').prop('checked', false);
    $('.search-calendar input#search').val("");
    getAllEventsForSelectedFilters(event);
  };

  $("#events_list").hide();

  $('#picktheday').datepicker({
    autoclose: true,
    todayHighlight: true,
    format: 'yyyy-mm-dd'
  });

  $("#picktheday").on("changeDate", function(event) {
    $("[data-date=" + selected_date + "]").removeClass('fc-highlight');
    $('div#select_user_type button').html("View All Events");

    var event_month = null;
    var event_date = null;

    if (event.date.getMonth() + 1 <= 9) {
      event_month = "0" + (event.date.getMonth() + 1)}
    else {
      event_month = event.date.getMonth() + 1;};

    if (event.date.getDate() <= 9) {
      event_date = "0" + (event.date.getDate())}
    else {
      event_date = event.date.getDate();};

    selected_date = event.date.getFullYear() + '-' + event_month + '-' + event_date;
    $("[data-date=" + selected_date + "]").addClass('fc-highlight');

    if ($('#calendar')[0].style.display == 'none') {
      getAllEventsForSelectedFilters(event);
    }
    else
    {
      $('#calendar').fullCalendar( 'gotoDate', selected_date);
      $('#calendar').fullCalendar('render');
    }
  });

  $('#calendar').fullCalendar({
    titleFormat: 'MMMM, YYYY',
    header:
      {
        left: 'today prev,next title',
        center: '',
        right: ''
      },
    buttonIcons:
      {
        prev: 'left-single-arrow',
        next: 'right-single-arrow',
        prevYear: 'left-double-arrow',
        nextYear: 'right-double-arrow'
      },
    buttonText:
      {
        today: 'Today'
      },
    defaultView: 'month',
    editable: false,
    height: 'auto',
    fixedWeekCount: false,
    slotMinutes: 30,
    dragOpacity: "0.5",
    dayRender: function(date, cell){
      if (selected_date == date._i){
        $("[data-date=" + date._i + "]").addClass('fc-highlight');
      }
    },
    eventSources: {
      url: '/calendars/events',
      type: 'GET',
      data: {
        coops: function(){
          return $.map($('input[type="checkbox"]:checked'), function(bx){
            return bx.value;
          })
        },
        user_selected: function(){
          return $('div#select_user_type button').val();
        }
      },
      error: function(jqXHR, textStatus, errorThrown) {
        alert("Error getting events:  ", textStatus);
      }
    },
    eventRender: function(event, element) {
      return $('<div>' + "<span class='fc-event-icons " + event.imageurl + "'>" + "</span>" + "<span class='fc-count'>" + event.count + "</span>" + '</div>');
    },
    eventClick: function(calEvent, jsEvent, view) {
      var coops = [];
      $('input[type="checkbox"]:checked').each(function(i){
        coops[i] = $(this).val();
      });

      var url = '/calendars/events/show_modal' + '?start_date=' + calEvent.start._i + '&event_category=' + calEvent.title + '&user_selected=' + $('div#select_user_type button').val() + '&coops=' + coops;

      $('#calendar_modal').modal({
        remote: url,
        show: true,
        type: 'GET'
      });
      $('body').on('hidden.bs.modal', '.modal', function () {
        $(this).removeData('bs.modal');
      });
    }
  });

  $('.fc-today-button').click(function() {
    var today = new Date();
    $("#picktheday").datepicker("setDate", today);
  });

  $("#picktheday").datepicker("getDate");
  //$('input#search').val();

  window.MCDSListView = function(){
    $('.list-today-button.btn.btn-default.btn-sm').click(function() {
      var today = new Date();
      $("#picktheday").datepicker("setDate", (today.getFullYear() + '-' +
                                             (today.getMonth() + 1) + '-' +
                                              today.getDate()));
    });

    $('.list-previous-day-button').click(function() {
      var displayed_date = $("#picktheday").datepicker("getDate");
      var previous_day = new Date(),
          previous_day = new Date(previous_day.setDate(displayed_date.getDate()-1));
      $("#picktheday").datepicker("setDate", (previous_day.getFullYear() + '-' +
                                             (previous_day.getMonth() + 1) + '-' +
                                              previous_day.getDate()));
    });

    $('.list-next-day-button').click(function() {
      var displayed_date = $("#picktheday").datepicker("getDate");
      var next_day = new Date(),
          next_day = new Date(next_day.setDate(displayed_date.getDate()+1));
      $("#picktheday").datepicker("setDate", (next_day.getFullYear() + '-' +
                                             (next_day.getMonth() + 1) + '-' +
                                              next_day.getDate()));
    });

    $('.all-items').click(function(e) {
      getEventsForEventCategory('All');
    });

    $('.national-items').click(function(e) {
      getEventsForEventCategory('National');
    });

    $('.coop-items').click(function(e) {
      getEventsForEventCategory('COOP');
    });

    $('.search-calendar input#search').keyup(function() {
      getAllEventsForSelectedFilters(event);
    });

    $(".calendar-refresh-button").click(function() {
      resetCalendarView();
    });

    $(".search-calendar .clear-button").click(function() {
      $(".search-calendar input#search").val("");
    });
  }

  window.MCDSListView();

  $(".calendar-refresh-button").click(function() {
    resetCalendarView();
  });

  $('#assign-calendar-geographies').change('input',function() {
    getAllEventsForSelectedFilters(event);
  });

  $('div#select_user_type button').click(function() {
    if ($(this).html() === 'View My Events') {
      $(this).html("View All Events");
      $(this).val($(this).attr('user_id'));}
    else {
      $(this).html("View My Events");
      $(this).val("all");
    };
    getAllEventsForSelectedFilters(event);
  });

  $('.calendar_grid_list_option .list_view').click(function() {
    $('div#select_user_type button').html("View All Events");
    $("#picktheday").datepicker("setDate", new Date());
  });




});
