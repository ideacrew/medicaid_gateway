# frozen_string_literal: true

# require 'dry/monads'
# require 'dry/monads/do'

# module MitcService
#   # This class is for adding APTC and CSR values and other determinations
#   # for each TaxHousehold of MagiMedicaidApplication and returns
#   # MagiMedicaidApplication with added determinations
#   # This class is PRIVATE to ::MitcService::DetermineFullEligibility
#   class DetermineAptcCsrEligibility
#     include Dry::Monads[:result, :do]

#     # @param [Hash] opts The options to add APTC, CSR and additional determinations
#     # @option opts [::AcaEntities::MagiMedicaid::Application] :magi_medicaid_application
#     # @option opts [::AcaEntities::MagiMedicaid::TaxHousehold] :magi_medicaid_tax_household
#     # @return [Dry::Monads::Result]
#     def call(params)
#       # { magi_medicaid_application: @result_mm_application, magi_medicaid_tax_household: mm_thh }
#       _aptc_csr = yield calculate_aptc_csr(params)
#       Success(params[:magi_medicaid_application])
#     end

#     private

#     def calculate_aptc_csr(params)
#       ::MitcService::CalculateAptcAndCsr.new.call(params)
#     end

#     # def test_method(mm_application)
#     #   mm_application.tax_households.each do |thh|
#     #     fpl_percent = calculate_fpl(thh, mm_application)
#     #     ::MitcService::CalculateAptcAndCsr.new.call({ tax_household: thh, fpl_percent: fpl_percent })
#     #   end

#     #   Success(mm_application)
#     # end
#   end
# end
