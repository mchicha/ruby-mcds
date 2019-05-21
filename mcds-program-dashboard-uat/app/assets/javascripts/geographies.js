$(document).on('change', '#geography_select_dropdown', function(){
  swal(
    {
      title: "Are you sure?",
      text: "Are you sure you want to change your selected geography? Your work will be lost.",
      type: "warning",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Yes",
      cancelButtonText: "No",
      closeOnConfirm: false,
      closeOnCancel: true
    },
    function(isConfirm) {
      if (isConfirm) {
        $("#select_geography_form").submit();
      }
      else{
        $('#geography_select_dropdown').val(originalGeographySelection);
      }
    }
  );
})

