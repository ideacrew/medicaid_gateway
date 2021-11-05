import { Controller } from 'stimulus'
import StimulusReflex from 'stimulus_reflex'

export default class extends Controller {
  connect() {
    StimulusReflex.register(this)
  }

  change_date(event) {
    const date = event.target.value,
      input_name = event.target.name,
      session_name = event.target.dataset.session

    this.stimulate('Report#change_date', session_name, date)
  }

  increment_counts() {
    const report = window.location.pathname.split('/').pop()
    const total = document.querySelector("#total-count").textContent
    const result = document.querySelector("tbody tr td").textContent

    let success = document.querySelector("#success-count")
    if (success) {
      success = success.textContent
    }

    let fail = document.querySelector("#fail-count")
    if (fail) {
      fail = fail.textContent
    }

    this.stimulate('Report#increment_counts', report, total, success, fail, result)
  }
}