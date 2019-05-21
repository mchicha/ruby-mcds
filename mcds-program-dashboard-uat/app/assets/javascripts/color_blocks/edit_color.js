$(document).ready( function() {
  $('.color-select').each( function() {
    $(this).minicolors({
      inline: $(this).attr('data-inline') === 'true',
      letterCase: $(this).attr('data-letterCase') || 'uppercase',
      position: $(this).attr('data-position') || 'bottom left',
      theme: 'bootstrap',
      change: function(hex) {
        console.log(hex)
        if ($(this).attr('id') === 'start'){
          $('input#hidden_start_hex').val(hex);
        }
        if ($(this).attr('id') === 'end'){
          $('input#hidden_end_hex').val(hex);
        }
      },
    });
  });
});
