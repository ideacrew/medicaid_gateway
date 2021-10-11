# frozen_string_literal: true

module Medicaid
    # Determinations from MITC
    class ApplicationsController < ActionController::Base
      def show
        @application = Medicaid::Application.find(params[:id])
        # render layout: "application"
      end
    end
  end
  