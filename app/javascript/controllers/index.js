// Load all the controllers within this directory and all subdirectories. 
// Controller files must be named *_controller.js.

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
import StimulusReflex from 'stimulus_reflex'
import consumer from '../channels/consumer'
import controller from '../controllers/application_controller'

const application = Application.start()
const context = require.context("controllers", true, /_controller\.js$/)
const debug_mode = process.env.MG_DEBUG
application.load(definitionsFromContext(context))

if (debug_mode === 'true') {
    // Enable debugging in prod-like lower envs
    StimulusReflex.initialize(application, { consumer, controller, isolate: true, debug: true })
} else {
    StimulusReflex.debug = process.env.RAILS_ENV === 'development'
}