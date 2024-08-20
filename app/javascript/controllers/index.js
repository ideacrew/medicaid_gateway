// Load all the controllers within this directory and all subdirectories. 
// Controller files must be named *_controller.js.

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
import StimulusReflex from 'stimulus_reflex'
import consumer from '../channels/consumer'
import controller from '../controllers/application_controller'
import ApplicationController from '../controllers/application_controller.js'
import InboundTransfersController from '../controllers/inbound_transfers_controller.js'
import ReportController from '../controllers/report_controller.js'

const application = Application.start()
application.register('application', ApplicationController)
application.register('inbound_transfers', InboundTransfersController)
application.register('report', ReportController)
application.consumer = consumer
StimulusReflex.initialize(application, { controller, isolate: true })
StimulusReflex.debug = false //process.env.RAILS_ENV === 'development'
