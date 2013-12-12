$(document).ready(function() {
  $("#guessing-form").submit(function(e) {
    e.preventDefault();
    var username = $("#username").val();
    $.get(username + "/favourite")
      .success(function(answer) {
        $("#answer").html(answer.username + "'s favourite language seems to be <strong>" + answer.favourite + "</strong>")
                    .removeClass('hidden')
                    .addClass('alert-success')
                    .removeClass('alert-danger');
      })
      .error(function(err) {
        $("#answer").text(err.responseText)
                    .removeClass('hidden')
                    .addClass('alert-danger')
                    .removeClass('alert-success');
      });
  }); 
});
