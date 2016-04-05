$( document ).ready(function() {

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
  });
});

function getFirstdayOfWeek() {
  var curr = new Date; // get current date
  var first = curr.getDate() - curr.getDay(); // First day is the day of the month - the day of the week
  var firstday = new Date(curr.setDate(first));
  console.log(firstday.toString());
  return firstday;
}

function getCurHour() {
  var start = moment();
  remainder = (30 - start.minute()) % 30;
  diff_sec = start.second();
  var retval = moment(start).add(remainder, "minutes").subtract(diff_sec, "seconds");
  console.log(retval);
  return retval;
}
