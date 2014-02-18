bootstrap_alert = ->

bootstrap_alert.info = (message) ->
  $("#alert_placeholder").html "<div class=\"alert alert-info\"><a class=\"close\" data-dismiss=\"alert\">×</a><span>" + message + "</span></div>"
  return

bootstrap_alert.error = (message) ->
  $("#alert_placeholder").html "<div class=\"alert alert-error\"><a class=\"close\" data-dismiss=\"alert\">×</a><span>" + message + "</span></div>"
  return