// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import ahoy from "ahoy.js";
import LocalTime from "local-time-cdn";

LocalTime.start();

ahoy.configure({ cookies: false });
ahoy.trackView();
ahoy.trackClicks("a, button, input[type=submit]");
ahoy.trackSubmits("form");
ahoy.trackChanges("input, textarea, select");
