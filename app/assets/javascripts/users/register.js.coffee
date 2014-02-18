$(document).ready ->
  $("#register-button").bind "click", ->
    ga "send", "event", "registration", $("#user_email").val(), $(".registration-alert").text()
    return

  return
