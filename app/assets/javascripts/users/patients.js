$(document).on('ready', function() {
  $('.avatar-editor').on('change', '.avatar-input', function(event) {
    var f = event.target.files[0];
    var fr = new FileReader();
    var $wrapper = $(this).closest('.avatar-editor');

    fr.onload = function(ev) {
        console.dir(ev);
        $wrapper.find('.avatar-img').attr('src', ev.target.result);
    };

    fr.readAsDataURL(f);
  });
});
