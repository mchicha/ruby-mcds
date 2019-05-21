$(document).on('change', '.calendar-filter-checkbox', function(){
  var checkClass = (this.getAttribute('check-class'))

  if(this.checked){
    $('.' + checkClass).show()
  }else{
    $('.' + checkClass).hide()
  }
})
