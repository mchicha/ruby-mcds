angular
  .module('carrierwave', []).filter('imagePath', function() {
  return function(images, version) {
    if(version && images.length > 0){
      return images[images.length - 1].image.image[version].url

    } else if(images.length > 0) {
      return images[images.length - 1].image.image.url

    } else {
      return '/images/image_not_found.png'
    }
  };
});
