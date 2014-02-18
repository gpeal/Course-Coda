window.bootstrap_alert = ->

window.bootstrap_alert.info = (message) ->
  $("#alert_placeholder").html "<div class=\"alert alert-info\"><a class=\"close\" data-dismiss=\"alert\">×</a><span>" + message + "</span></div>"
  return

window.bootstrap_alert.danger = (message) ->
  $("#alert_placeholder").html "<div class=\"alert alert-danger\"><a class=\"close\" data-dismiss=\"alert\">×</a><span>" + message + "</span></div>"
  return