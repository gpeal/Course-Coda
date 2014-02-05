$(document).ready(function() {
  $('#login-button').bind('click', function() {
    ga('send', 'event', 'registration', $('#user_email').val(), $('.alert').text())
  })
})