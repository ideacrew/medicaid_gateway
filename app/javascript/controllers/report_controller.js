import { Controller } from 'stimulus'
import StimulusReflex from 'stimulus_reflex'

export default class extends Controller {
  static targets = ["startDate", "endDate"]
  
  connect() {
    StimulusReflex.register(this)
  }

  change_date(event) {
    const date = event.target.value,
          input_name = event.target.name,
          session_name = event.target.dataset.session
          
    this.stimulate('Report#change_date', session_name, date)
  }

  change_dates(event) {
    const startDate = this.startDateTarget.value,
          endDate = this.endDateTarget.value,
          sessionName = event.target.dataset.session
    window.history.replaceState(null, null, window.location.pathname)
    this.stimulate('Report#change_dates', sessionName, startDate, endDate)
  }

  app_search(event) {
    const value = event.target.value
    window.history.replaceState(null, null, window.location.pathname)
    this.stimulate('Report#app_search', value)
  }

  clear_search(event) {
    var input = document.getElementById("app");
    input.value = ""
    window.history.replaceState(null, null, window.location.pathname)
    this.stimulate('Report#app_search', "")
  }
}