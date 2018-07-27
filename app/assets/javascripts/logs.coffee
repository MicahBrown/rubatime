# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

document.addEventListener "js.load", (event) ->
  console.log "here"
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
