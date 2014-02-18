$(document).ready ->
  $("#login-button").bind "click", ->
    ga "send", "event", "registration", $("#user_email").val(), $(".alert").text()
    return

  return
