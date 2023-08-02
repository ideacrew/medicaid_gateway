# frozen_string_literal: true

module Jobs
  # create job operation that takes params of key (required), started_at(required),
  # publish_on(required), message_id (optional) and job_id (optional)
  class FindOrCreateJob
    include Dry::Monads[:result, :do, :try]

    def call(params)
      values = yield validate_params(params)
      job = yield find_or_create_job(values)
      Success(job)
    end

    private

    def validate_params(params)
      return Failure('key required') unless params[:key].is_a?(Symbol)
      return Failure('started_at required') unless params[:started_at].is_a?(DateTime)
      return Failure('publish_on required') unless params[:publish_on].is_a?(DateTime)

      Success(params)
    end

    def find_or_create_job(values)
      if values[:job_id]
        job = Transmittable::Job.where(job_id: values[:job_id]).last

        job ? Success(job) : Failure("No job exists with the given job_id")

      elsif values[:message_id]
        job = Transmittable::Job.where(message_id: values[:message_id]).last

        job ? Success(job) : Failure("No job exists with the given message_id")
      else
        create_job(values)
      end
    end

    def create_job(values)
      result = ::Jobs::CreateJob.new.call(values)

      result.success? ? Success(result.value!) : result
    end
  end
end