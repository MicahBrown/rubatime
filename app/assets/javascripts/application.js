// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require moment
//= require chart
//= require inputmask
//= require_self
//= require title_clock
//= require logs

var loadEvent = new Event('js.load');

var loadJavascript = function(){
  var body = document.body
  var isSet = body.dataset.jsSet

  if (isSet != "true") {
    body.dataset.jsSet = true;
    document.dispatchEvent(loadEvent);
    return true;
  }

  return false;
}

document.addEventListener('js.load', function(){ initHeader() });
document.addEventListener('turbolinks:load', loadJavascript);
document.addEventListener('DOMContentLoaded', loadJavascript);

var initHeader = function(){
  // Get all "navbar-burger" elements
  var $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

  // Check if there are any navbar burgers
  if ($navbarBurgers.length > 0) {
    // Add a click event on each of them
    arrayLength = $navbarBurgers.length

    for (var i = 0; i < arrayLength; i++) {
      var el = $navbarBurgers[i];
      el.addEventListener('click', function(){

        // Get the target from the "data-target" attribute
        var target = el.dataset.target;
        var $target = document.getElementById(target);

        // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
        el.classList.toggle('is-active');
        $target.classList.toggle('is-active');
      });
    }
  }
};
