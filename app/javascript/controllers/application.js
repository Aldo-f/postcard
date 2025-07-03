import { Application } from "@hotwired/stimulus";
const application = Application.start();

application.handleError = (error, message, detail) => {
  console.warn(message, detail);

  if (typeof Honeybadger != "undefined") {
    Honeybadger.notify(error);
  }
};

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

import Notification from "stimulus-notification";
application.register("notification", Notification);

import Dropdown from "stimulus-dropdown";
application.register("dropdown", Dropdown);

export { application };
