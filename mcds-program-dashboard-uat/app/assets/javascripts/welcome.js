function initSlyProgramCarousel(containingDiv) {
  $containingDiv = $(containingDiv)
  var options = {
    itemNav: 'basic',
    horizontal: true,
    smart: 1,
    activateMiddle: 1,
    activateOn: 'click',
    mouseDragging: 1,
    touchDragging: 1,
    releaseSwing: 1,
    startAt: 0,
    pagesBar: $containingDiv.find('.pages'),
    activatePageOn: 'click',
    scrollBy: 1,
    speed: 300,
    elasticBounds: 1,
    easing: 'swing',
    dragHandle: 1,
    dynamicHandle: 1,
    clickBar: 1,
    nextPage: $containingDiv.find('.forward'),
    prevPage: $containingDiv.find('.backward')
  };
  $containingDiv.find('.frame').sly(options);
}

$(document).on('ready', function(){
  $(".schematic-row").each(function(i, el){
    initSlyProgramCarousel(el)
  })
})
