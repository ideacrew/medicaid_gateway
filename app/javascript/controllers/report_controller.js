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

  increment() {
    const total = this.data.get("total")
    const success = this.data.get("success")
    const fail = this.data.get("fail")
    const result = document.querySelector("tbody tr td").textContent

    this.stimulate('Report#increment', total, success, fail, result)
  }
}