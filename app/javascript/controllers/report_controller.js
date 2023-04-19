import { Controller } from "stimulus";
import StimulusReflex from "stimulus_reflex";

export default class extends Controller {
  static targets = ["startDate", "endDate", "date"];

  connect() {
    StimulusReflex.register(this);

    document.addEventListener("click", function (e) {
      let elements = document.getElementsByClassName("dropdown");
      if (elements.length != 0 && !elements[0].contains(e.target)) {
        let dropdownMenu = document.getElementsByClassName("dropdown-menu")[0];
        console.log(dropdownMenu.classList.contains("show"));
        if (dropdownMenu.classList.contains("show")) {
          dropdownMenu.classList.toggle("show");
        }
      }
    });
  }

  change_date(event) {
    const startDate = this.startDateTarget.value,
      session_name = event.target.dataset.session;
    this.stimulate("Report#change_date", session_name, startDate);
  }

  change_dates(event) {
    const startDate = this.startDateTarget.value,
      endDate = this.endDateTarget.value,
      sessionName = event.target.dataset.session;
    const change_dates_url = "/reports/change_dates";
    const data = {
      start_date: startDate,
      end_date: endDate,
      session_name: sessionName,
    };
    const csrf_token = document.head
      .querySelector(`meta[name="csrf-token"]`)
      .getAttribute("content");
    let url = new URL(window.location.href);

    if (startDate) {
      url.searchParams.set("start_on", startDate);
    }
    if (endDate) {
      url.searchParams.set("end_on", endDate);
    }

    fetch(change_dates_url, {
      method: "PUT",
      credentials: "include",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrf_token,
      },
      body: JSON.stringify(data),
    }).then((data) => {
      window.location.href = window.location.href;
    });
  }

  app_search(event) {
    const value = event.target.value;
    let option = document.querySelector('#apps option[value="' + value + '"]');
    if (option != null && value != "") {
      let id = option.dataset.id;
      window.location = window.location.origin + "/medicaid/applications/" + id;
    }
  }

  clear_search(event) {
    var input = document.getElementById("app");
    input.value = "";
    window.history.replaceState(null, null, window.location.pathname);
    this.stimulate("Report#app_search", "");
  }

  toggle_determinations_menu(event) {
    document.getElementById("determinations_menu").classList.toggle("show");
  }
}
