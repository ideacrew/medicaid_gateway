# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Aces
  # Send results of a MEC check to enroll
  class PublishMecCheck
    send(:include, Dry::Monads[:result, :do])

    # @param [String] Take in the raw payload and serialize and transform it, then tranfer the result to EA.
    # @return [Dry::Result]
    def call(params)
      payload = yield create_transfer(params)
      initiate_transfer(payload)
    end

    private

    def create_transfer(input)      
      payload = input.attributes
      payload[:applicant_responses] = transform_applicant_responses(input.applicant_responses)
      Success(result)
    end

    def transform_applicant_responses(applicant_responses)
        applicant_responses.transform_values do | response |
          response = JSON.parse(response)
          xml = Nokogiri::XML(response["body"])
          response_description = xml.xpath("//xmlns:ResponseDescription", "xmlns" => "http://gov.hhs.cms.hix.dsh.ee.nonesi_mec.ext")
          response_description.text
        end        
    end

    def initiate_transfer(payload)
      transfer = Transfers::InitiateTransferToEnroll.new.call(payload)
      transfer.success? ? Success("Transferred MEC check to Enroll") : Failure(transfer)
    end
  end
end