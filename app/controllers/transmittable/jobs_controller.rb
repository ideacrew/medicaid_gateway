# frozen_string_literal: true

module Transmittable
  # Transmittable Jobs controller
  class JobsController < ApplicationController

    def show
      @job = Transmittable::Job.where(id: params[:id]).last

      render json: "Job not found", status: 404 unless @job
    end

    def index
      @jobs = Transmittable::Job.latest.page params[:page]
    end

  end
end