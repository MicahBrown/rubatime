# Test if client is using IE
detectIE = ->
  ua = window.navigator.userAgent
  msie = ua.indexOf('MSIE ')
  if (msie > 0)
    # IE 10 or older => return version number
    return parseInt(ua.substring(msie + 5, ua.indexOf('.', msie)), 10)

  trident = ua.indexOf('Trident/')
  if (trident > 0)
    # IE 11 => return version number
    rv = ua.indexOf('rv:')
    return parseInt(ua.substring(rv + 3, ua.indexOf('.', rv)), 10)

  edge = ua.indexOf('Edge/')
  if (edge > 0)
    # Edge (IE 12+) => return version number
    return parseInt(ua.substring(edge + 5, ua.indexOf('.', edge)), 10)

  false

document.addEventListener "js.load", ->
  # Animated clock in <title> attribute

  showClock = document.body.dataset.currentLog
  showClock = showClock == "true" if typeof showClock == "string"

  if showClock && detectIE() == false
    title   = document.getElementsByTagName("title")[0]
    origTxt = title.textContent
    clocks  = ["&#128347;","&#128336;","&#128337;","&#128338;","&#128339;","&#128340;","&#128341;","&#128342;","&#128343;","&#128344;","&#128345;","&#128346;"]
    counter = 0

    updateClock = ->
      title.innerHTML = clocks[counter%clocks.length] + " " + origTxt
      counter++

    updateClock()
    setInterval updateClock, 1000