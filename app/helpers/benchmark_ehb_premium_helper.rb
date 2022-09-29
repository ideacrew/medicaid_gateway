# frozen_string_literal: true

# Module which includes helper methods to support the Benchmark Ehb Premiums with Pediatric Dental Values.
module BenchmarkEhbPremiumHelper
  # Return false if the registry is not found
  # We are only supporting this feature effective 2022
  def slcsapd_enabled?(effective_year)
    return unless MedicaidGatewayRegistry.feature_enabled?(:atleast_one_silver_plan_donot_cover_pediatric_dental_cost)
    MedicaidGatewayRegistry[:atleast_one_silver_plan_donot_cover_pediatric_dental_cost]&.settings(effective_year.to_s.to_sym)&.item
  end

  # Non-dynamic calculation of SLCSP:
  #   In states where all health plans cover pediatric dental benefits,
  #   or in households that do not include children under 19 who qualify for APTC,
  #   the SLCSP is the second lowest cost silver plan offered in the account holder's rating area.
  #   Because health plan rates following a sliding scale, the SLCSP is the same regardless of ages or household composition.
  # Dynamic Calculation of SLCSP:
  #   In states where not all silver plans cover pediatric dental benefits,
  #  for tax households that include one or more children under the age of 19 who qualify for APTC,
  #  call external system(Enroll) to find the SLCSP value.

  # SLCEPWPDC: Second Lowest Cost Ehb Premiums With Pediatric Dental Costs
  # def call_external_system_for_slcsepwpdc?(effective_date, members)
  #   return false unless effective_date.is_a?(Date)

  #   slcsapd_enabled?(effective_date.year) && all_members_aged_19_or_above?(members)
  # end

  # def all_members_aged_19_or_above?(members)
  # end
end
