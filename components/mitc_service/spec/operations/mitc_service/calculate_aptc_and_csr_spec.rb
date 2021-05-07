# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::MitcService::CalculateAptcAndCsr do

  it 'should be a container-ready operation' do
    expect(subject.respond_to?(:call)).to be_truthy
  end

  context 'with sample MitcEligibilityResponse' do
    let(:mitc_response_payload) do
      response_hash = { "Determination Date":"2013-12-16",
                        "Applicants":[
                          {
                              "Person ID":1,
                              "Medicaid Household":{
                                "People":[
                                    1
                                ],
                                "MAGI":25608,
                                "Size":2
                              },
                              "Medicaid Eligible":"N",
                              "CHIP Eligible":"N",
                              "Ineligibility Reason":[
                                "Applicant's MAGI above the threshold for category"
                              ],
                              "Non-MAGI Referral":"Y",
                              "CHIP Ineligibility Reason":[
                                "Applicant did not meet the requirements for any CHIP category",
                                "Applicant not eligible under state health benefits rule",
                                "Applicant is incarcerated"
                              ],
                              "Category":"Pregnancy Category",
                              "Category Threshold":21403,
                              "CHIP Category":"None",
                              "CHIP Category Threshold":0,
                              "Determinations":{
                                "Residency":{
                                    "Indicator":"Y"
                                },
                                "Adult Group Category":{
                                    "Indicator":"X"
                                },
                                "Parent Caretaker Category":{
                                    "Indicator":"N",
                                    "Ineligibility Code":146,
                                    "Ineligibility Reason":"No child met all criteria for parent caretaker category"
                                },
                                "Pregnancy Category":{
                                    "Indicator":"Y"
                                },
                                "Child Category":{
                                    "Indicator":"N",
                                    "Ineligibility Code":115,
                                    "Ineligibility Reason":"Applicant is 19 years of age or older and the state does not cover young adults under age 20 or 21"
                                },
                                "Optional Targeted Low Income Child":{
                                    "Indicator":"X"
                                },
                                "CHIP Targeted Low Income Child":{
                                    "Indicator":"N",
                                    "Ineligibility Code":127,
                                    "Ineligibility Reason":"Applicant's age is not within the allowed age range"
                                },
                                "Unborn Child":{
                                    "Indicator":"X"
                                },
                                "Income Medicaid Eligible":{
                                    "Indicator":"N",
                                    "Ineligibility Code":402,
                                    "Ineligibility Reason":"Applicant's income is greater than the threshold for all eligible categories"
                                },
                                "Income CHIP Eligible":{
                                    "Indicator":"N",
                                    "Ineligibility Code":401,
                                    "Ineligibility Reason":"Applicant did not meet the requirements for any eligibility category"
                                },
                                "CHIPRA 214":{
                                    "Indicator":"X"
                                },
                                "Trafficking Victim":{
                                    "Indicator":"X"
                                },
                                "Seven Year Limit":{
                                    "Indicator":"X"
                                },
                                "Five Year Bar":{
                                    "Indicator":"X"
                                },
                                "Title II Work Quarters Met":{
                                    "Indicator":"X"
                                },
                                "Medicaid Citizen Or Immigrant":{
                                    "Indicator":"Y"
                                },
                                "Former Foster Care Category":{
                                    "Indicator":"N",
                                    "Ineligibility Code":126,
                                    "Ineligibility Reason":"Applicant's age is greater than or equal to 26"
                                },
                                "Work Quarters Override Income":{
                                    "Indicator":"N",
                                    "Ineligibility Code":340,
                                    "Ineligibility Reason":"Income is greater than 100% FPL"
                                },
                                "State Health Benefits CHIP":{
                                    "Indicator":"N",
                                    "Ineligibility Code":155,
                                    "Ineligibility Reason":"State does not provide CHIP to applicants with access to state health insurance"
                                },
                                "CHIP Waiting Period Satisfied":{
                                    "Indicator":"X"
                                },
                                "Dependent Child Covered":{
                                    "Indicator":"X"
                                },
                                "Medicaid Non-MAGI Referral":{
                                    "Indicator":"Y"
                                },
                                "Emergency Medicaid":{
                                    "Indicator":"N",
                                    "Ineligibility Code":109,
                                    "Ineligibility Reason":"Applicant does not meet the eligibility criteria for emergency Medicaid"
                                },
                                "Refugee Medical Assistance":{
                                    "Indicator":"X"
                                },
                                "APTC Referral":{
                                    "Indicator":"Y"
                                }
                              },
                              "Other Outputs":{
                                "Qualified Children List":[
                                ]
                              },
                              "cleanDets":[
                                {
                                    "item":"Residency",
                                    "indicator":"Y"
                                },
                                {
                                    "item":"Adult Group Category",
                                    "indicator":"X"
                                },
                                {
                                    "item":"Parent Caretaker Category",
                                    "indicator":"N",
                                    "code":146,
                                    "reason":"No child met all criteria for parent caretaker category"
                                },
                                {
                                    "item":"Pregnancy Category",
                                    "indicator":"Y"
                                },
                                {
                                    "item":"Child Category",
                                    "indicator":"N",
                                    "code":115,
                                    "reason":"Applicant is 19 years of age or older and the state does not cover young adults under age 20 or 21"
                                },
                                {
                                    "item":"Optional Targeted Low Income Child",
                                    "indicator":"X"
                                },
                                {
                                    "item":"CHIP Targeted Low Income Child",
                                    "indicator":"N",
                                    "code":127,
                                    "reason":"Applicant's age is not within the allowed age range"
                                },
                                {
                                    "item":"Unborn Child",
                                    "indicator":"X"
                                },
                                {
                                    "item":"Income Medicaid Eligible",
                                    "indicator":"N",
                                    "code":402,
                                    "reason":"Applicant's income is greater than the threshold for all eligible categories"
                                },
                                {
                                    "item":"Income CHIP Eligible",
                                    "indicator":"N",
                                    "code":401,
                                    "reason":"Applicant did not meet the requirements for any eligibility category"
                                },
                                {
                                    "item":"CHIPRA 214",
                                    "indicator":"X"
                                },
                                {
                                    "item":"Trafficking Victim",
                                    "indicator":"X"
                                },
                                {
                                    "item":"Seven Year Limit",
                                    "indicator":"X"
                                },
                                {
                                    "item":"Five Year Bar",
                                    "indicator":"X"
                                },
                                {
                                    "item":"Title II Work Quarters Met",
                                    "indicator":"X"
                                },
                                {
                                    "item":"Medicaid Citizen Or Immigrant",
                                    "indicator":"Y"
                                },
                                {
                                    "item":"Former Foster Care Category",
                                    "indicator":"N",
                                    "code":126,
                                    "reason":"Applicant's age is greater than or equal to 26"
                                },
                                {
                                    "item":"Work Quarters Override Income",
                                    "indicator":"N",
                                    "code":340,
                                    "reason":"Income is greater than 100% FPL"
                                },
                                {
                                    "item":"State Health Benefits CHIP",
                                    "indicator":"N",
                                    "code":155,
                                    "reason":"State does not provide CHIP to applicants with access to state health insurance"
                                },
                                {
                                    "item":"CHIP Waiting Period Satisfied",
                                    "indicator":"X"
                                },
                                {
                                    "item":"Dependent Child Covered",
                                    "indicator":"X"
                                },
                                {
                                    "item":"Medicaid Non-MAGI Referral",
                                    "indicator":"Y"
                                },
                                {
                                    "item":"Emergency Medicaid",
                                    "indicator":"N",
                                    "code":109,
                                    "reason":"Applicant does not meet the eligibility criteria for emergency Medicaid"
                                },
                                {
                                    "item":"Refugee Medical Assistance",
                                    "indicator":"X"
                                },
                                {
                                    "item":"APTC Referral",
                                    "indicator":"Y"
                                }
                              ]
                          },
                          {
                              "Person ID":2,
                              "Medicaid Household":{
                                "People":[
                                    2
                                ],
                                "MAGI":0,
                                "Size":1
                              },
                              "Medicaid Eligible":"Y",
                              "CHIP Eligible":"Y",
                              "Category":"Child Category",
                              "Category Threshold":16775,
                              "CHIP Category":"CHIP Targeted Low Income Child",
                              "CHIP Category Threshold":21831,
                              "Determinations":{
                                "Residency":{
                                    "Indicator":"Y"
                                },
                                "Adult Group Category":{
                                    "Indicator":"X"
                                },
                                "Parent Caretaker Category":{
                                    "Indicator":"N",
                                    "Ineligibility Code":146,
                                    "Ineligibility Reason":"No child met all criteria for parent caretaker category"
                                },
                                "Pregnancy Category":{
                                    "Indicator":"N",
                                    "Ineligibility Code":124,
                                    "Ineligibility Reason":"Applicant not pregnant or within postpartum period"
                                },
                                "Child Category":{
                                    "Indicator":"Y"
                                },
                                "Optional Targeted Low Income Child":{
                                    "Indicator":"X"
                                },
                                "CHIP Targeted Low Income Child":{
                                    "Indicator":"Y"
                                },
                                "Unborn Child":{
                                    "Indicator":"X"
                                },
                                "Income Medicaid Eligible":{
                                    "Indicator":"Y"
                                },
                                "Income CHIP Eligible":{
                                    "Indicator":"Y"
                                },
                                "CHIPRA 214":{
                                    "Indicator":"X"
                                },
                                "Trafficking Victim":{
                                    "Indicator":"X"
                                },
                                "Seven Year Limit":{
                                    "Indicator":"X"
                                },
                                "Five Year Bar":{
                                    "Indicator":"X"
                                },
                                "Title II Work Quarters Met":{
                                    "Indicator":"X"
                                },
                                "Medicaid Citizen Or Immigrant":{
                                    "Indicator":"Y"
                                },
                                "Former Foster Care Category":{
                                    "Indicator":"N",
                                    "Ineligibility Code":400,
                                    "Ineligibility Reason":"Applicant was not formerly in foster care"
                                },
                                "Work Quarters Override Income":{
                                    "Indicator":"N",
                                    "Ineligibility Code":338,
                                    "Ineligibility Reason":"Applicant did not meet all the criteria for income override rule"
                                },
                                "State Health Benefits CHIP":{
                                    "Indicator":"X"
                                },
                                "CHIP Waiting Period Satisfied":{
                                    "Indicator":"X"
                                },
                                "Dependent Child Covered":{
                                    "Indicator":"X"
                                },
                                "Medicaid Non-MAGI Referral":{
                                    "Indicator":"N",
                                    "Ineligibility Code":108,
                                    "Ineligibility Reason":"Applicant does not meet requirements for a non-MAGI referral"
                                },
                                "Emergency Medicaid":{
                                    "Indicator":"N",
                                    "Ineligibility Code":109,
                                    "Ineligibility Reason":"Applicant does not meet the eligibility criteria for emergency Medicaid"
                                },
                                "Refugee Medical Assistance":{
                                    "Indicator":"X"
                                },
                                "APTC Referral":{
                                    "Indicator":"N",
                                    "Ineligibility Code":406,
                                    "Ineligibility Reason":"Applicant is eligible for Medicaid"
                                }
                              },
                              "Other Outputs":{
                                "Qualified Children List":[
                                ]
                              },
                              "cleanDets":[
                                {
                                    "item":"Residency",
                                    "indicator":"Y"
                                },
                                {
                                    "item":"Adult Group Category",
                                    "indicator":"X"
                                },
                                {
                                    "item":"Parent Caretaker Category",
                                    "indicator":"N",
                                    "code":146,
                                    "reason":"No child met all criteria for parent caretaker category"
                                },
                                {
                                    "item":"Pregnancy Category",
                                    "indicator":"N",
                                    "code":124,
                                    "reason":"Applicant not pregnant or within postpartum period"
                                },
                                {
                                    "item":"Child Category",
                                    "indicator":"Y"
                                },
                                {
                                    "item":"Optional Targeted Low Income Child",
                                    "indicator":"X"
                                },
                                {
                                    "item":"CHIP Targeted Low Income Child",
                                    "indicator":"Y"
                                },
                                {
                                    "item":"Unborn Child",
                                    "indicator":"X"
                                },
                                {
                                    "item":"Income Medicaid Eligible",
                                    "indicator":"Y"
                                },
                                {
                                    "item":"Income CHIP Eligible",
                                    "indicator":"Y"
                                },
                                {
                                    "item":"CHIPRA 214",
                                    "indicator":"X"
                                },
                                {
                                    "item":"Trafficking Victim",
                                    "indicator":"X"
                                },
                                {
                                    "item":"Seven Year Limit",
                                    "indicator":"X"
                                },
                                {
                                    "item":"Five Year Bar",
                                    "indicator":"X"
                                },
                                {
                                    "item":"Title II Work Quarters Met",
                                    "indicator":"X"
                                },
                                {
                                    "item":"Medicaid Citizen Or Immigrant",
                                    "indicator":"Y"
                                },
                                {
                                    "item":"Former Foster Care Category",
                                    "indicator":"N",
                                    "code":400,
                                    "reason":"Applicant was not formerly in foster care"
                                },
                                {
                                    "item":"Work Quarters Override Income",
                                    "indicator":"N",
                                    "code":338,
                                    "reason":"Applicant did not meet all the criteria for income override rule"
                                },
                                {
                                    "item":"State Health Benefits CHIP",
                                    "indicator":"X"
                                },
                                {
                                    "item":"CHIP Waiting Period Satisfied",
                                    "indicator":"X"
                                },
                                {
                                    "item":"Dependent Child Covered",
                                    "indicator":"X"
                                },
                                {
                                    "item":"Medicaid Non-MAGI Referral",
                                    "indicator":"N",
                                    "code":108,
                                    "reason":"Applicant does not meet requirements for a non-MAGI referral"
                                },
                                {
                                    "item":"Emergency Medicaid",
                                    "indicator":"N",
                                    "code":109,
                                    "reason":"Applicant does not meet the eligibility criteria for emergency Medicaid"
                                },
                                {
                                    "item":"Refugee Medical Assistance",
                                    "indicator":"X"
                                },
                                {
                                    "item":"APTC Referral",
                                    "indicator":"N",
                                    "code":406,
                                    "reason":"Applicant is eligible for Medicaid"
                                }
                              ]
                          }
                        ] }
      response_hash.to_json
    end

    before do
      @result = subject.call(mitc_response_payload)
    end

    it '' do
    end
  end
end
