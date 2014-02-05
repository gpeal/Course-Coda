$(document).ready(function() {
  $('#register-button').bind('click', function() {
    ga('send', 'event', 'registration', $('#user_email').val(), $('.registration-alert').text())
  })
})