import { Controller } from 'stimulus'
import StimulusReflex from 'stimulus_reflex'

export default class extends Controller {
  static targets = ["startDate", "endDate"]
  
  connect() {
    StimulusReflex.register(this)

    document.addEventListener('click', function(e){
      let elements = document.getElementsByClassName('dropdown')
      if (elements.length != 0 && !elements[0].contains(e.target)){
        let dropdownMenu = document.getElementsByClassName("dropdown-menu")[0]
        console.log(dropdownMenu.classList.contains("show"))
        if (dropdownMenu.classList.contains("show")) {
          dropdownMenu.classList.toggle("show")
        }        
      } 
    })
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
    let options = document.querySelector('#apps option[value="'+value+'"]')
    if (options != null && value != '') {
      window.location = window.location.origin+"/medicaid/applications/"+value
    }
  }

  clear_search(event) {
    var input = document.getElementById("app");
    input.value = ""
    window.history.replaceState(null, null, window.location.pathname)
    this.stimulate('Report#app_search', "")
  }

  toggle_determinations_menu(event) {
    document.getElementById("determinations_menu").classList.toggle("show")
  }
}