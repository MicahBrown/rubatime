# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

setHours = ->
  hoursInput = document.getElementById("hours")
  sdateValue = document.getElementById("log_start_date").value
  stimeValue = document.getElementById("log_start_time").value
  edateValue = document.getElementById("log_end_date").value
  etimeValue = document.getElementById("log_end_time").value

  if sdateValue == "" || stimeValue == "" || edateValue == "" || etimeValue == ""
    hoursInput.value = "--"
    return false

  edatetime = moment(edateValue + " " + etimeValue, "MM-DD-YYYY hh:mm A")
  sdatetime = moment(sdateValue + " " + stimeValue, "MM-DD-YYYY hh:mm A")
  diff = edatetime - sdatetime

  hoursInput.value = diff / 1000.0 / 60/  60

initChangeEvent = (inputs) ->
  for input in inputs
    input.onchange = -> setHours()

document.addEventListener "js.load", (event) ->
  if document.querySelector(".log-form") != null
    dateMask = new Inputmask {
      regex: "(0\\d|1[0-2])/(0\\d|1\\d|2\\d|3[0-1])/\\d{4}"
      placeholder: "mm/dd/yyyy"
    }
    dateInputs = document.querySelectorAll(".date-input")
    dateMask.mask(input) for input in dateInputs


    timeMask = new Inputmask {
      regex: "([0-1])?(\\d):([0-5])(\\d)(\\s)?(A|P)M"
      placeholder: "HH:MM xm"
      hourFormat: 12
    }
    timeInputs = document.querySelectorAll(".time-input")
    timeMask.mask(input) for input in timeInputs

    initChangeEvent(timeInputs)
    initChangeEvent(dateInputs)
    setHours()
