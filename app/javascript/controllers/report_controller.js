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
    let url = new URL(window.location.href),
        d = new Date(date)
    d = d.toLocaleDateString("en-US")
    url.searchParams.set(input_name, d)
    window.location.replace(url)
  }
}