eatingGlue = function(extraTimeout){
  // Don't even ask...but this has a timeout so it can modify the SAC without thorugh customized client logic into it
  // It should burn your eyes.
  setTimeout(function(){
    $( "label:contains('Template Name')" ).addClass('required');
    if(extraTimeout){
      setTimeout(theHeartOfEatingGlue, 250);
    }
    else{
      theHeartOfEatingGlue();
    }
  }, 500)
}

theHeartOfEatingGlue = function(){
  var $sel = $("label:contains(Template Name)").parent().children('select')
  var $cont = $sel;

  $sel.find('option').each(function () {
    if ($(this).text().indexOf('++') !== 0) {
      $cont.find('optGroup').last().append($(this));
    } else {
      $('<optGroup/>').attr('label', $(this).text().replace(/\+/g, '')).appendTo($cont);
      $(this).remove();
    }
  });

  removeNationalOption();

  reOrganizaingSACDropdown();
}

removeNationalOption = function(){
  if (userRole != 'inputter'){
    $("option[label='National Element']").remove()
  }

}

reOrganizaingSACDropdown = function(){
  // these are in reverse order so that unfound ones (-1) are listed last
  var deliciousDeliciousGlue = ["Template Name", "Down Date", "Up Date", "Vendor Name", "SKU", "Document", "Filename", "Asset Type"];

  var sortBySeemingArbitraryList = function(a, b) {
    var aIndex = deliciousDeliciousGlue.indexOf($(a).find('label').first().html());
    var bIndex = deliciousDeliciousGlue.indexOf($(b).find('label').first().html());

    return aIndex < bIndex;
  }

  var list = $(".fb-form-object.ng-scope:not('.ng-hide')");

  list.sort(sortBySeemingArbitraryList);

  for (var i = 0; i < list.length; i++) {
    list[i].parentNode.appendChild(list[i]);
  }
}

$(function() {

  $(document).on('change', ".asset-type-selector", function(){
    setTimeout(function(){
      eatingGlue();
    }, 100)
  })

  $('#upload-a-resource').on('shown.bs.modal', function (e) {
    var $el = $(this),
        $form = $el.find('form'),
        $target = $(e.relatedTarget),
        detail = {
          description: ($target.data('resource-description') || ''),
          fileName: ($target.data('resource-file-name') || ''),
          id: ($target.data('resource-id') || ''),
          programId: ($target.data('program-id') || '')
        },
        url = "/programs/" + detail.programId + "/resources/" + detail.id;

    $el.find('#errors-div').html('');
    $form.find('textarea').val(detail.description);
    $form.find('.current-file > .value').text(detail.fileName);
    $form.find('#resource_id').val(detail.id);
    $form.attr("method", "post");
    $form.attr("action", url);
  });

  $('.datepicker').datepicker();

  $('#popdates1, #popdates2, #moddates1, #moddates2').datetimepicker({
    widgetPositioning: {
      horizontal: 'left',
      vertical: 'bottom'
    }
  });

  function copyStartDate(e, selector){
    var val = $(e.target).val(),
        $endDate = $(selector + ':eq(1)')
        endDateVal = $endDate.val() || '';
    if (endDateVal.length === 0){ $endDate.val(val); }
  };

  var popInstallDateTypeSelector = 'input.form-date-input[data-name="pop_install"]',
      popTakeDownDateTypeSelector = 'input.form-date-input[data-name="pop_take_down"]';
      kitDeliveryBetween = 'input.form-date-input[data-name="kit_delivery_between"]';

  var fieldsToCopyStartDate = [popInstallDateTypeSelector, popTakeDownDateTypeSelector, kitDeliveryBetween];

  // Auto Populate End Date from Start Date
  $.each(fieldsToCopyStartDate, function(index, field){
    $(field + ":eq(0)").on('dp.change', function(e){
      copyStartDate(e, field);
    });
  });

  $('#filter-program-list-form .fa-calendar').click(function(){
    $(this).prev('.form-date-input').focus();
  });

  // if they fill out a field in the filter section, show message saying they
  // need to click the apply filter button to see the filtered results.
  $('#filter-program-list-form').change(function(){
    $("#apply-filter-message").show();
  });

  $('.form-date-input').on('dp.change', function(){
    $("#apply-filter-message").show();
  });

  $(".tablesorter").not("#programs-list").tablesorter({
    headers: { 0: { sorter: false}, 7: {sorter: false} }
  });

  $.tablesorter.addParser({
        id: "pop_install_date_sorter",
        is: function(pop_install_date) {
            return false;
        },
        format: function(pop_install_date) {
            var s1, s2, d1, d2, date;
            s1 = pop_install_date.match(/^\d{1,2}[-\/]\d{1,2}[-\/]\d{2}(\d{2})?/);
            s2 = pop_install_date.match(/\d{1,2}[-\/]\d{1,2}[-\/]\d{2}(\d{2})?$/);
            d1 = new Date(s1[0]);
            d2 = new Date(s2[0]);

            function zeroPadding(str_input) {
              var str = "" + str_input
              var pad = "00";
              return pad.substring(0, pad.length - str.length) + str;
            }

            date = "" + zeroPadding(d1.getFullYear()) + zeroPadding(d1.getMonth() + 1) + zeroPadding(d1.getDate()) + zeroPadding(d2.getFullYear()) + zeroPadding(d2.getMonth() + 1) + zeroPadding(d2.getDate());
            return date;
        },
        type: 'text'
    });

   $("#programs-list").tablesorter({
        headers: {
          0: { sorter: false },
          3: { sorter:'pop_install_date_sorter'},
          7: { sorter: false }
        }
      });

  $('#associated-elements .table-sorter').tablesorter();

  $("#program-keyword-search").keydown(function() {
    var keywordVal = $(this).val();
    var formElement = $(this).parents('form')[0];
    if (formElement) {
      $(formElement).submit();
    }
  });

  $('#email-a-resource').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal

    // Extract info from data-* attributes
    var url = button.data('url')
    var id = button.data('id')

    var modal = $(this);
    var editor = CKEDITOR.instances.message_content_wysiwyg;
    if (id) {
      modal.find('.dynamic-label').html('Attached File');
      modal.find('.resource-url').html("<a href='"+url+"' target='_blank'>"+url+"</a>");
      modal.find("#resource-id").val(id);
      modal.find("#message-content-wysiwyg").val(url);
      editor.setData("");
    } else {
      modal.find('.dynamic-label').html('Progam Resource');
      modal.find('.resource-url').html("<a href='" + url + "' target='_blank'>" + url + "</a>");
      editor.setData("<a href='" + url + "' target='_blank'>" + url + "</a>");
      modal.find("#resource-id").val('');
    }
  })

  var nationalRegionsShowCheck = function(){
    var $list = $('#geography-accordion').find('.col-xs-12')
    var $national = $list.filter(function(i){return $($list[i]).find("[data-geography-name='National']").length > 0})
    $regions = $list.not($list.filter(function(i){return $($list[i]).find("[data-geography-name='National']").length > 0}))

    if($national.find('input').is(':checked')){
      $regions.hide()
    }
    else{
      $regions.show()
    }

    if($regions.find('input').is(':checked')){
      $national.hide()
    }
    else{
      $national.show()
    }
  }

  nationalRegionsShowCheck()

  $('#geography-accordion').on('click', 'input', function(){
    nationalRegionsShowCheck()
  });

  $('.color-block').each(function(i, el){
    applyGradient(el);
  });

});

function applyGradient(el){
  var start = $(el).data('start-hex'),
      end = $(el).data('end-hex'),
      css =  {
        background: "-webkit-linear-gradient(" + start + ", " + end  + ")", /* For Safari 5.1 to 6.0 */
        background: "-o-linear-gradient(" + start + ", " + end + ")", // For Opera 11.1 to 12.0
        background: "-moz-linear-gradient(" + start + ", " + end + ")", /* For Firefox 3.6 to 15 */
        background: "linear-gradient(" + start + ", " + end + ")" /* Standard syntax */
      }
  $(el).css(css);
};

function addSelectedCoOp(el) {
  var selected_option = $("option:selected", el);
  $(".selected-geographies").append(
    "<div class='selected-option geography' onclick='removeFilter(this);'><input type='hidden' name='program[geography_id][]' value='" + selected_option.val() + "'/>" + selected_option.text() + " <strong class='pull-right'>X</strong></div>"
  );
  $(el).val('');
}

function addSelectedUser(el) {
  var selected_option = $("option:selected", el);
  $(".selected-users").append(
    "<div class='selected-option user' onclick='removeFilter(this);'><input type='hidden' name='program[user_id][]' value='" + selected_option.val() + "'/>" + selected_option.text() + " <strong class='pull-right'>X</strong></div>"
  );
  $(el).val('');
}


function removeFilter(el) {
  var formElement = $(el).parents('form')[0];
  $(el).remove();
  $(formElement).submit();
}

function addColorBlock(el) {
  var val = $(el).val(),
      colorName = $(el).attr("data-color-name"),
      checked = $(el).prop('checked'),
      $colorBlock = $(el).parent().siblings('.color-block'),
      startHex = $colorBlock.data('start-hex'),
      endHex = $colorBlock.data('end-hex');

  if (checked) {
    $("#program-color-blocks-table").html(
      "<tbody><tr id='color-block-row-" + val + "'> \
          <td class='color-block' id='color-block-" + val + "' data-start-hex='" + startHex + "' data-end-hex='" + endHex + "'></td> \
          <td>" + colorName + "</td></tr></tbody>"
    ).find('.color-block').each(function(i, el){ applyGradient(el); });
  }
}

function clearFilterFields(el) {
  var formElement = $(el).parents('form')[0];
  if (formElement) {
    // clear out any inputs
    $(formElement).find('input, select').each(function() {
      $(this).val('');
    });

    // set default program status filter
    $(formElement).find("select#select-program").val("active");

    $(".selected-option").each(function() {
      $(this).remove();
    });
  }
  $("#apply-filter-message").hide();
  $(formElement).submit();
}

function clearFuzzySearch(list) {
  $("input.search").val('');
  list.search();
}

function clearEditChanges(el) {
  swal({
    title: "Are you sure?",
    text: "None of your info will be saved.",
    type: "warning",
    showCancelButton: true,
    confirmButtonColor: "#DD6B55",
    confirmButtonText: "Yes, I'm sure",
    closeOnConfirm: false
  }, function() {
    window.location = "/programs/" + $(el).attr("program-id");
  });
}

function returnToProgramList() {
  swal({
    title: "Are you sure?",
    text: "You have not saved any changes to this program, are you sure you want to return to the program list without saving your changes?",
    type: "warning",
    showCancelButton: true,
    confirmButtonColor: "#DD6B55",
    confirmButtonText: "Yes",
    cancelButtonText: "No",
    closeOnConfirm: false
  }, function() {
    window.location = "/programs/";
  });
}


function removeResource(el) {
  swal({
    title: "Confirm Remove/Delete",
    text: "Are you sure you want to delete/remove this asset/resource from the program?",
    type: "warning",
    showCancelButton: true,
    confirmButtonColor: "#DD6B55",
    confirmButtonText: "Yes delete the asset",
    cancelButtonText: "No",
    closeOnConfirm: false
  }, function() {
    $.ajax({
      type: 'DELETE',
      url: "/programs/" + $(el).attr("data-program-id") + "/resources/" + $(el).attr("data-resource-id"),
      success: function() {
        swal("Deleted!", "Resource has been deleted.", "success");
      },
      error: function(error) {
        swal("Error!", "Error message: " + error, "error");
      }
    });
  });
}

function setWarningMessage(id){
  $('#edit_program_' + id).data('serialize',$('#edit_program_' + id).serialize());

  $(document).on('click', 'a', function(e){
    var linkHref = this.getAttribute('href');
    if(linkHref && linkHref[0] !='#'){
      if($($('#edit_program_' + id)).serialize()!=$($('#edit_program_' + id)).data('serialize')){
        e.preventDefault()
        swal({
          title: "Are you sure?",
          text: "You have unsaved changes to this program. Are you sure you want to leave this page without saving your changes?",
          type: "warning",
          showCancelButton: true,
          confirmButtonColor: "#DD6B55",
          confirmButtonText: "Yes",
          cancelButtonText: "No",
          closeOnConfirm: false
        }, function() {
          window.location = linkHref
        });
      }
    }
  })
}

$(document).on('click', '.change-status', function(e){
    // These links are rails link_to that are posts. These will ignore the next two lines.
    // To get around it, we add the data-method only if the user confirms the popup, and then we hit the link again.
    if($(this).attr('data-method') != 'post'){
      e.preventDefault();
      e.stopImmediatePropagation();
      warningArchiveActivate(e, this);
    }
})

function warningArchiveActivate(e, clicked){
  return swal({
    title: "Are you sure?",
    text: "You are about to change the program status. Are you sure you want to commit this change?",
    type: "warning",
    showCancelButton: true,
    confirmButtonColor: "#DD6B55",
    confirmButtonText: "Yes",
    cancelButtonText: "No",
    closeOnConfirm: false
  }, function() {
    $(clicked).attr('data-method', 'post');
    $(clicked).click();
  });
}

