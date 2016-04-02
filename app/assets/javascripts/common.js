$( document ).ready(function() {
  $(document).on('click', '#add-event', function (data){
    formData = $('form').serializeArray();
    var data = { appointments: {}, users: {} }
    formData.forEach(function(element, index){
      data['appointments'][element['name']] = element['value']
    });
    data['users']['id'] = parseInt(window.location.href.split("/")[window.location.href.split("/").length - 2])
    $.ajax({
      type: "POST",
      url: "/appointments",
      data: data,
      success: function(data) {
        window.location = window.location.href
      },
      error: function(data) {
        console.log(data)
      }
    })
  });

  $('#reSchedule').on('click', function(data) {
    formData = $('form').serializeArray();
    var data = { appointments: {}, users: {} }
    formData.forEach(function(element, index){
      data['appointments'][element['name']] = element['value']
    });
    console.log("RE-schedule", data)
    $.ajax({
      type: "PUT",
      url: "/appointments/" + data['appointments']['id'],
      data: {'appointments': data['appointments'] },
      success: function(data) {
        window.location = window.location.href
      },
      error: function(data) {
        console.log(data)
      }
    })
  })

  $(document).on('click', '#update-event', function(data) {
    formData = $('form').serializeArray();
    var data = { appointments: {}, users: {} }
    formData.forEach(function(element, index){
      data['appointments'][element['name']] = element['value']
    });
    console.log("Updating", data)
    $.ajax({
      type: "PUT",
      url: "/appointments/" + data['appointments']['id'],
      data: {'appointments': data['appointments'] },
      success: function(data) {
        window.location = window.location.href
      },
      error: function(data) {
        console.log(data)
      }
    })
  })

  $(document).on('click', '#import-event', function(data) {
    formData = $('form').serializeArray();
    var data = { appointments: {}, users: {} }
    formData.forEach(function(element, index){
      data['appointments'][element['name']] = element['value']
    });
    console.log("Importing", data)
    $.ajax({
      type: "POST",
      url: "/appointments/"+ data['appointments']['id'] +"/import",
      data: {'appointments': data['appointments'] },
      success: function(data) {
        console.log('boki')
      },
      error: function(data) {
        console.log(data)
      }
    })
  })


  $("#cancel").on('click', function() {
    var that = $(this).closest('tr');
    that.hide();
  })

  $(document).on("ajax:success", "a[data-remote]", function(e, data, status, xhr) {
    $(this).closest('.booking-box').slideUp(300, function() {
      $(this).remove();
    })
  })
});

$(function() {
  $('#pictureInput').on('change', function(event) {
    var files = event.target.files;
    var image = files[0]
    var reader = new FileReader();
    reader.onload = function(file) {
      var img = new Image();
      console.log(file);
      img.src = file.target.result;
      $('#target').html(img);
    }
    reader.readAsDataURL(image);
    console.log(files);
  });
});
