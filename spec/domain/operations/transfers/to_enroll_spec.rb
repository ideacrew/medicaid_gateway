# frozen_string_literal: true

require "rails_helper"
require 'aca_entities/serializers/xml/medicaid/atp'
require 'aca_entities/atp/transformers/cv/family.rb'

describe Transfers::ToEnroll, "given a soap envelope with an valid xml payload, transfer it to Enroll" do
  let(:body) { StringIO.new(raw_xml) }
  let(:raw_xml) do
    <<-XMLCODE
    <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:ns="http://at.dsh.cms.gov/exchange/1.0" xmlns:ns1="http://niem.gov/niem/structures/2.0" xmlns:ns2="http://at.dsh.cms.gov/extension/1.0" xmlns:ns3="http://niem.gov/niem/niem-core/2.0" xmlns:hix="http://hix.cms.gov/0.1/hix-core" xmlns:hix1="http://hix.cms.gov/0.1/hix-ee" xmlns:ns4="http://niem.gov/niem/domains/screening/2.1" xmlns:hix2="http://hix.cms.gov/0.1/hix-pm">
    <soap:Header>
       <wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
          <wsse:UsernameToken wsu:Id="UsernameToken-73590BD4745C9F3F7814189343300461">
             <wsse:Username>SOME_SOAP_USER</wsse:Username>
             <wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">SOME SOAP PASSWORD</wsse:Password>
             <wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">aaa</wsse:Nonce>
             <wsu:Created>2014-12-18T20:25:30.037Z</wsu:Created>
          </wsse:UsernameToken>
       </wsse:Security>
    </soap:Header>
    <soap:Body>
      <ex:AccountTransferRequest xmlns:ex="http://at.dsh.cms.gov/exchange/1.0" xmlns:ext="http://at.dsh.cms.gov/extension/1.0" xmlns:hix-core="http://hix.cms.gov/0.1/hix-core" xmlns:hix-ee="http://hix.cms.gov/0.1/hix-ee" xmlns:nc="http://niem.gov/niem/niem-core/2.0" xmlns:niem-s="http://niem.gov/niem/structures/2.0" ext:atVersionText="2.4">
        <ext:TransferHeader>
          <ext:TransferActivity>
            <nc:ActivityIdentification>
              <nc:IdentificationID>234</nc:IdentificationID>
            </nc:ActivityIdentification>
            <nc:ActivityDate>
              <nc:Date>2021-08-16</nc:Date>
            </nc:ActivityDate>
            <ext:TransferActivityReferralQuantity>3</ext:TransferActivityReferralQuantity>
            <ext:RecipientTransferActivityCode>MedicaidCHIP</ext:RecipientTransferActivityCode>
            <ext:RecipientTransferActivityStateCode>ME</ext:RecipientTransferActivityStateCode>
          </ext:TransferActivity>
        </ext:TransferHeader>
        <hix-core:Sender niem-s:id="IDC1234">
          <hix-core:InformationExchangeSystemCategoryCode>Exchange</hix-core:InformationExchangeSystemCategoryCode>
          <hix-core:InformationExchangeSystemStateCode>ME</hix-core:InformationExchangeSystemStateCode>
        </hix-core:Sender>
        <hix-core:Receiver niem-s:id="IDC5678">
          <hix-core:InformationExchangeSystemCategoryCode>Exchange</hix-core:InformationExchangeSystemCategoryCode>
        </hix-core:Receiver>
        <hix-ee:InsuranceApplication>
          <hix-core:ApplicationCreation>
            <nc:ActivityDate/>
          </hix-core:ApplicationCreation>
          <hix-core:ApplicationSubmission>
            <nc:ActivityDate>
              <nc:Date>2021-08-16</nc:Date>
            </nc:ActivityDate>
          </hix-core:ApplicationSubmission>
          <hix-core:ApplicationIdentification>
            <nc:IdentificationID>IDC1000886</nc:IdentificationID>
          </hix-core:ApplicationIdentification>
          <hix-ee:InsuranceApplicant>
            <hix-core:RoleOfPersonReference niem-s:ref="IDC1003158"/>
            <hix-ee:InsuranceApplicantFixedAddressIndicator>false</hix-ee:InsuranceApplicantFixedAddressIndicator>
            <hix-ee:InsuranceApplicantIncarceration>
              <hix-core:IncarcerationDate/>
              <hix-core:IncarcerationIndicator>false</hix-core:IncarcerationIndicator>
            </hix-ee:InsuranceApplicantIncarceration>
            <hix-ee:InsuranceApplicantLawfulPresenceStatus>
              <hix-ee:LawfulPresenceStatusEligibility/>
            </hix-ee:InsuranceApplicantLawfulPresenceStatus>
          </hix-ee:InsuranceApplicant>
          <hix-ee:InsuranceApplicant>
            <hix-core:RoleOfPersonReference niem-s:ref="IDC1002699"/>
            <hix-ee:InsuranceApplicantFixedAddressIndicator>false</hix-ee:InsuranceApplicantFixedAddressIndicator>
            <hix-ee:InsuranceApplicantIncarceration>
              <hix-core:IncarcerationDate/>
              <hix-core:IncarcerationIndicator>false</hix-core:IncarcerationIndicator>
            </hix-ee:InsuranceApplicantIncarceration>
            <hix-ee:InsuranceApplicantLawfulPresenceStatus>
              <hix-ee:LawfulPresenceStatusEligibility/>
            </hix-ee:InsuranceApplicantLawfulPresenceStatus>
          </hix-ee:InsuranceApplicant>
          <hix-ee:InsuranceApplicant>
            <hix-core:RoleOfPersonReference niem-s:ref="IDC1003159"/>
            <hix-ee:InsuranceApplicantFixedAddressIndicator>false</hix-ee:InsuranceApplicantFixedAddressIndicator>
            <hix-ee:InsuranceApplicantIncarceration>
              <hix-core:IncarcerationDate/>
              <hix-core:IncarcerationIndicator>false</hix-core:IncarcerationIndicator>
            </hix-ee:InsuranceApplicantIncarceration>
            <hix-ee:InsuranceApplicantLawfulPresenceStatus>
              <hix-ee:LawfulPresenceStatusEligibility/>
            </hix-ee:InsuranceApplicantLawfulPresenceStatus>
          </hix-ee:InsuranceApplicant>
          <hix-ee:InsuranceApplicationRequestingFinancialAssistanceIndicator>true</hix-ee:InsuranceApplicationRequestingFinancialAssistanceIndicator>
          <hix-ee:InsuranceApplicationCoverageRenewalYearQuantity>5</hix-ee:InsuranceApplicationCoverageRenewalYearQuantity>
          <hix-ee:SSFSigner>
            <hix-core:RoleOfPersonReference niem-s:ref="IDC1003158"/>
            <hix-ee:Signature>
              <hix-core:SignatureName>
                <nc:PersonGivenName>Simple</nc:PersonGivenName>
                <nc:PersonSurName>L</nc:PersonSurName>
              </hix-core:SignatureName>
              <hix-core:SignatureDate>
                <nc:Date>2021-08-16</nc:Date>
              </hix-core:SignatureDate>
            </hix-ee:Signature>
            <hix-ee:SSFAttestation>
              <hix-ee:SSFAttestationCollectionsAgreementIndicator>true</hix-ee:SSFAttestationCollectionsAgreementIndicator>
              <hix-ee:SSFAttestationMedicaidObligationsIndicator>true</hix-ee:SSFAttestationMedicaidObligationsIndicator>
              <hix-ee:SSFAttestationNonPerjuryIndicator>true</hix-ee:SSFAttestationNonPerjuryIndicator>
              <hix-ee:SSFAttestationNotIncarceratedIndicator niem-s:metadata="IDC11234">true</hix-ee:SSFAttestationNotIncarceratedIndicator>
              <hix-ee:SSFAttestationPrivacyAgreementIndicator>true</hix-ee:SSFAttestationPrivacyAgreementIndicator>
              <hix-ee:SSFAttestationPendingChargesIndicator>true</hix-ee:SSFAttestationPendingChargesIndicator>
              <hix-ee:SSFAttestationInformationChangesIndicator>true</hix-ee:SSFAttestationInformationChangesIndicator>
              <hix-ee:SSFAttestationApplicationTermsIndicator>true</hix-ee:SSFAttestationApplicationTermsIndicator>
            </hix-ee:SSFAttestation>
          </hix-ee:SSFSigner>
          <hix-ee:InsuranceApplicationRequestingMedicaidIndicator>true</hix-ee:InsuranceApplicationRequestingMedicaidIndicator>
          <hix-ee:SSFPrimaryContact>
            <hix-core:RoleOfPersonReference niem-s:ref="IDC1003158"/>
            <hix-ee:SSFPrimaryContactPreferenceCode>TextMessage</hix-ee:SSFPrimaryContactPreferenceCode>
          </hix-ee:SSFPrimaryContact>
          <hix-ee:InsuranceApplicationTaxReturnAccessIndicator>true</hix-ee:InsuranceApplicationTaxReturnAccessIndicator>
        </hix-ee:InsuranceApplication>
        <hix-core:Person niem-s:id="IDC1003158">
          <nc:PersonAgeMeasure>
            <nc:MeasurePointValue>80</nc:MeasurePointValue>
          </nc:PersonAgeMeasure>
          <nc:PersonBirthDate>
            <nc:Date>1941-01-01</nc:Date>
          </nc:PersonBirthDate>
          <nc:PersonName>
            <nc:PersonGivenName>Simple</nc:PersonGivenName>
            <nc:PersonMiddleName>Transfer</nc:PersonMiddleName>
            <nc:PersonSurName>L</nc:PersonSurName>
            <nc:PersonFullName>Simple Transfer L</nc:PersonFullName>
          </nc:PersonName>
          <nc:PersonRaceText>White</nc:PersonRaceText>
          <nc:PersonSexText>male</nc:PersonSexText>
          <nc:PersonUSCitizenIndicator>true</nc:PersonUSCitizenIndicator>
          <hix-core:TribalAugmentation>
            <hix-core:PersonAmericanIndianOrAlaskaNativeIndicator>false</hix-core:PersonAmericanIndianOrAlaskaNativeIndicator>
          </hix-core:TribalAugmentation>
          <hix-core:PersonAugmentation>
            <hix-core:PersonContactInformationAssociation>
              <nc:ContactInformationIsPrimaryIndicator>false</nc:ContactInformationIsPrimaryIndicator>
              <hix-core:ContactInformation>
                <nc:ContactMailingAddress>
                  <nc:StructuredAddress>
                    <nc:LocationStreet>
                      <nc:StreetFullText>514 Test Street</nc:StreetFullText>
                    </nc:LocationStreet>
                    <nc:AddressSecondaryUnitText/>
                    <nc:LocationCityName>Augusta</nc:LocationCityName>
                    <nc:LocationCountyName>KENNEBEC</nc:LocationCountyName>
                    <nc:LocationStateUSPostalServiceCode>ME</nc:LocationStateUSPostalServiceCode>
                    <nc:LocationPostalCode>04330</nc:LocationPostalCode>
                  </nc:StructuredAddress>
                </nc:ContactMailingAddress>
                <nc:ContactTelephoneNumber>
                  <nc:FullTelephoneNumber/>
                </nc:ContactTelephoneNumber>
              </hix-core:ContactInformation>
              <hix-core:ContactInformationCategoryCode>Home</hix-core:ContactInformationCategoryCode>
            </hix-core:PersonContactInformationAssociation>
            <hix-core:PersonContactInformationAssociation>
              <nc:ContactInformationIsPrimaryIndicator>false</nc:ContactInformationIsPrimaryIndicator>
              <hix-core:ContactInformation>
                <nc:ContactMailingAddress>
                  <nc:StructuredAddress>
                    <nc:LocationStreet>
                      <nc:StreetFullText>37 ML</nc:StreetFullText>
                    </nc:LocationStreet>
                    <nc:AddressSecondaryUnitText/>
                    <nc:LocationCityName>Augusta</nc:LocationCityName>
                    <nc:LocationCountyName>KENNEBEC</nc:LocationCountyName>
                    <nc:LocationStateUSPostalServiceCode>ME</nc:LocationStateUSPostalServiceCode>
                    <nc:LocationPostalCode>04330</nc:LocationPostalCode>
                  </nc:StructuredAddress>
                </nc:ContactMailingAddress>
                <nc:ContactTelephoneNumber>
                  <nc:FullTelephoneNumber/>
                </nc:ContactTelephoneNumber>
              </hix-core:ContactInformation>
              <hix-core:ContactInformationCategoryCode>Mailing</hix-core:ContactInformationCategoryCode>
            </hix-core:PersonContactInformationAssociation>
            <hix-core:PersonContactInformationAssociation>
              <nc:ContactInformationIsPrimaryIndicator>false</nc:ContactInformationIsPrimaryIndicator>
              <hix-core:ContactInformation>
                <nc:ContactMailingAddress/>
                <nc:ContactTelephoneNumber>
                  <nc:FullTelephoneNumber>
                    <nc:TelephoneNumberFullID>3011510342</nc:TelephoneNumberFullID>
                  </nc:FullTelephoneNumber>
                </nc:ContactTelephoneNumber>
              </hix-core:ContactInformation>
              <hix-core:ContactInformationCategoryCode>Mobile</hix-core:ContactInformationCategoryCode>
            </hix-core:PersonContactInformationAssociation>
            <hix-core:PersonContactInformationAssociation>
              <nc:ContactInformationIsPrimaryIndicator>false</nc:ContactInformationIsPrimaryIndicator>
              <hix-core:ContactInformation>
                <nc:ContactEmailID>M80@gmail.com</nc:ContactEmailID>
                <nc:ContactMailingAddress/>
                <nc:ContactTelephoneNumber>
                  <nc:FullTelephoneNumber/>
                </nc:ContactTelephoneNumber>
              </hix-core:ContactInformation>
              <hix-core:ContactInformationCategoryCode>Home</hix-core:ContactInformationCategoryCode>
            </hix-core:PersonContactInformationAssociation>
            <hix-core:PersonEmploymentAssociation>
              <hix-core:Employer niem-s:id="em2009481180751485382">
                <nc:OrganizationName>City of Augusta Bank</nc:OrganizationName>
                <nc:OrganizationPrimaryContactInformation>
                  <nc:ContactMailingAddress/>
                  <nc:ContactTelephoneNumber>
                    <nc:FullTelephoneNumber/>
                  </nc:ContactTelephoneNumber>
                </nc:OrganizationPrimaryContactInformation>
              </hix-core:Employer>
            </hix-core:PersonEmploymentAssociation>
            <hix-core:PersonPregnancyStatus>
              <hix-core:StatusIndicator>false</hix-core:StatusIndicator>
            </hix-core:PersonPregnancyStatus>
            <hix-core:PersonIncome>
              <hix-core:IncomeFrequency>
                <hix-core:FrequencyCode>Annually</hix-core:FrequencyCode>
              </hix-core:IncomeFrequency>
              <hix-core:IncomeAmount>78100.0</hix-core:IncomeAmount>
              <hix-core:IncomeCategoryCode>Wages</hix-core:IncomeCategoryCode>
              <hix-core:IncomeDate>
                <nc:Date>2021-08-16</nc:Date>
              </hix-core:IncomeDate>
              <hix-core:IncomeSourceOrganizationReference niem-s:ref="em2009481180751485382"/>
              <hix-core:IncomeEarnedDateRange>
                <nc:StartDate>
                  <nc:Date>2021-08-16</nc:Date>
                </nc:StartDate>
                <nc:EndDate>
                  <nc:Date>2021-08-16</nc:Date>
                </nc:EndDate>
              </hix-core:IncomeEarnedDateRange>
            </hix-core:PersonIncome>
            <hix-core:PersonPreferredLanguage>
              <nc:LanguageName>english</nc:LanguageName>
            </hix-core:PersonPreferredLanguage>
            <hix-core:PersonMarriedIndicator>false</hix-core:PersonMarriedIndicator>
          </hix-core:PersonAugmentation>
        </hix-core:Person>
        <hix-core:Person niem-s:id="IDC1002699">
          <nc:PersonAgeMeasure>
            <nc:MeasurePointValue>24</nc:MeasurePointValue>
          </nc:PersonAgeMeasure>
          <nc:PersonBirthDate>
            <nc:Date>1997-01-01</nc:Date>
          </nc:PersonBirthDate>
          <nc:PersonName>
            <nc:PersonGivenName>Helen</nc:PersonGivenName>
            <nc:PersonSurName>test</nc:PersonSurName>
            <nc:PersonFullName>Helen test</nc:PersonFullName>
          </nc:PersonName>
          <nc:PersonRaceText>White</nc:PersonRaceText>
          <nc:PersonSexText>female</nc:PersonSexText>
          <nc:PersonUSCitizenIndicator>true</nc:PersonUSCitizenIndicator>
          <hix-core:TribalAugmentation>
            <hix-core:PersonAmericanIndianOrAlaskaNativeIndicator>false</hix-core:PersonAmericanIndianOrAlaskaNativeIndicator>
          </hix-core:TribalAugmentation>
          <hix-core:PersonAugmentation>
            <hix-core:PersonContactInformationAssociation>
              <nc:ContactInformationIsPrimaryIndicator>false</nc:ContactInformationIsPrimaryIndicator>
              <hix-core:ContactInformation>
                <nc:ContactMailingAddress>
                  <nc:StructuredAddress>
                    <nc:LocationStreet>
                      <nc:StreetFullText>514 Test Street</nc:StreetFullText>
                    </nc:LocationStreet>
                    <nc:AddressSecondaryUnitText/>
                    <nc:LocationCityName>Augusta</nc:LocationCityName>
                    <nc:LocationCountyName>KENNEBEC</nc:LocationCountyName>
                    <nc:LocationStateUSPostalServiceCode>ME</nc:LocationStateUSPostalServiceCode>
                    <nc:LocationPostalCode>04330</nc:LocationPostalCode>
                  </nc:StructuredAddress>
                </nc:ContactMailingAddress>
                <nc:ContactTelephoneNumber>
                  <nc:FullTelephoneNumber/>
                </nc:ContactTelephoneNumber>
              </hix-core:ContactInformation>
              <hix-core:ContactInformationCategoryCode>Home</hix-core:ContactInformationCategoryCode>
            </hix-core:PersonContactInformationAssociation>
            <hix-core:PersonContactInformationAssociation>
              <nc:ContactInformationIsPrimaryIndicator>false</nc:ContactInformationIsPrimaryIndicator>
              <hix-core:ContactInformation>
                <nc:ContactMailingAddress>
                  <nc:StructuredAddress>
                    <nc:LocationStreet>
                      <nc:StreetFullText>37 ML</nc:StreetFullText>
                    </nc:LocationStreet>
                    <nc:AddressSecondaryUnitText/>
                    <nc:LocationCityName>Augusta</nc:LocationCityName>
                    <nc:LocationCountyName>KENNEBEC</nc:LocationCountyName>
                    <nc:LocationStateUSPostalServiceCode>ME</nc:LocationStateUSPostalServiceCode>
                    <nc:LocationPostalCode>04330</nc:LocationPostalCode>
                  </nc:StructuredAddress>
                </nc:ContactMailingAddress>
                <nc:ContactTelephoneNumber>
                  <nc:FullTelephoneNumber/>
                </nc:ContactTelephoneNumber>
              </hix-core:ContactInformation>
              <hix-core:ContactInformationCategoryCode>Mailing</hix-core:ContactInformationCategoryCode>
            </hix-core:PersonContactInformationAssociation>
            <hix-core:PersonContactInformationAssociation>
              <nc:ContactInformationIsPrimaryIndicator>false</nc:ContactInformationIsPrimaryIndicator>
              <hix-core:ContactInformation>
                <nc:ContactMailingAddress/>
                <nc:ContactTelephoneNumber>
                  <nc:FullTelephoneNumber>
                    <nc:TelephoneNumberFullID>3012228342</nc:TelephoneNumberFullID>
                  </nc:FullTelephoneNumber>
                </nc:ContactTelephoneNumber>
              </hix-core:ContactInformation>
              <hix-core:ContactInformationCategoryCode>Mobile</hix-core:ContactInformationCategoryCode>
            </hix-core:PersonContactInformationAssociation>
            <hix-core:PersonContactInformationAssociation>
              <nc:ContactInformationIsPrimaryIndicator>false</nc:ContactInformationIsPrimaryIndicator>
              <hix-core:ContactInformation>
                <nc:ContactEmailID>H24@gmail.com</nc:ContactEmailID>
                <nc:ContactMailingAddress/>
                <nc:ContactTelephoneNumber>
                  <nc:FullTelephoneNumber/>
                </nc:ContactTelephoneNumber>
              </hix-core:ContactInformation>
              <hix-core:ContactInformationCategoryCode>Home</hix-core:ContactInformationCategoryCode>
            </hix-core:PersonContactInformationAssociation>
            <hix-core:PersonPregnancyStatus>
              <hix-core:StatusIndicator>false</hix-core:StatusIndicator>
            </hix-core:PersonPregnancyStatus>
            <hix-core:PersonPreferredLanguage>
              <nc:LanguageName>english</nc:LanguageName>
            </hix-core:PersonPreferredLanguage>
            <hix-core:PersonMarriedIndicator>false</hix-core:PersonMarriedIndicator>
          </hix-core:PersonAugmentation>
        </hix-core:Person>
        <hix-core:Person niem-s:id="IDC1003159">
          <nc:PersonAgeMeasure>
            <nc:MeasurePointValue>11</nc:MeasurePointValue>
          </nc:PersonAgeMeasure>
          <nc:PersonBirthDate>
            <nc:Date>2010-01-01</nc:Date>
          </nc:PersonBirthDate>
          <nc:PersonName>
            <nc:PersonGivenName>Robert</nc:PersonGivenName>
            <nc:PersonSurName>test</nc:PersonSurName>
            <nc:PersonFullName>Robert test</nc:PersonFullName>
          </nc:PersonName>
          <nc:PersonRaceText>White</nc:PersonRaceText>
          <nc:PersonSexText>male</nc:PersonSexText>
          <nc:PersonSSNIdentification>
            <nc:IdentificationID>212828539</nc:IdentificationID>
          </nc:PersonSSNIdentification>
          <nc:PersonUSCitizenIndicator>true</nc:PersonUSCitizenIndicator>
          <hix-core:TribalAugmentation>
            <hix-core:PersonAmericanIndianOrAlaskaNativeIndicator>false</hix-core:PersonAmericanIndianOrAlaskaNativeIndicator>
          </hix-core:TribalAugmentation>
          <hix-core:PersonAugmentation>
            <hix-core:PersonContactInformationAssociation>
              <nc:ContactInformationIsPrimaryIndicator>false</nc:ContactInformationIsPrimaryIndicator>
              <hix-core:ContactInformation>
                <nc:ContactMailingAddress>
                  <nc:StructuredAddress>
                    <nc:LocationStreet>
                      <nc:StreetFullText>510 Test Street</nc:StreetFullText>
                    </nc:LocationStreet>
                    <nc:AddressSecondaryUnitText/>
                    <nc:LocationCityName>Augusta</nc:LocationCityName>
                    <nc:LocationCountyName>KENNEBEC</nc:LocationCountyName>
                    <nc:LocationStateUSPostalServiceCode>ME</nc:LocationStateUSPostalServiceCode>
                    <nc:LocationPostalCode>04330</nc:LocationPostalCode>
                  </nc:StructuredAddress>
                </nc:ContactMailingAddress>
                <nc:ContactTelephoneNumber>
                  <nc:FullTelephoneNumber/>
                </nc:ContactTelephoneNumber>
              </hix-core:ContactInformation>
              <hix-core:ContactInformationCategoryCode>Home</hix-core:ContactInformationCategoryCode>
            </hix-core:PersonContactInformationAssociation>
            <hix-core:PersonContactInformationAssociation>
              <nc:ContactInformationIsPrimaryIndicator>false</nc:ContactInformationIsPrimaryIndicator>
              <hix-core:ContactInformation>
                <nc:ContactMailingAddress>
                  <nc:StructuredAddress>
                    <nc:LocationStreet>
                      <nc:StreetFullText>37 ML</nc:StreetFullText>
                    </nc:LocationStreet>
                    <nc:AddressSecondaryUnitText/>
                    <nc:LocationCityName>Augusta</nc:LocationCityName>
                    <nc:LocationCountyName>KENNEBEC</nc:LocationCountyName>
                    <nc:LocationStateUSPostalServiceCode>ME</nc:LocationStateUSPostalServiceCode>
                    <nc:LocationPostalCode>04330</nc:LocationPostalCode>
                  </nc:StructuredAddress>
                </nc:ContactMailingAddress>
                <nc:ContactTelephoneNumber>
                  <nc:FullTelephoneNumber/>
                </nc:ContactTelephoneNumber>
              </hix-core:ContactInformation>
              <hix-core:ContactInformationCategoryCode>Mailing</hix-core:ContactInformationCategoryCode>
            </hix-core:PersonContactInformationAssociation>
            <hix-core:PersonContactInformationAssociation>
              <nc:ContactInformationIsPrimaryIndicator>false</nc:ContactInformationIsPrimaryIndicator>
              <hix-core:ContactInformation>
                <nc:ContactMailingAddress/>
                <nc:ContactTelephoneNumber>
                  <nc:FullTelephoneNumber>
                    <nc:TelephoneNumberFullID>2021768341</nc:TelephoneNumberFullID>
                  </nc:FullTelephoneNumber>
                </nc:ContactTelephoneNumber>
              </hix-core:ContactInformation>
              <hix-core:ContactInformationCategoryCode>Mobile</hix-core:ContactInformationCategoryCode>
            </hix-core:PersonContactInformationAssociation>
            <hix-core:PersonContactInformationAssociation>
              <nc:ContactInformationIsPrimaryIndicator>false</nc:ContactInformationIsPrimaryIndicator>
              <hix-core:ContactInformation>
                <nc:ContactEmailID>RH10@gmail.com</nc:ContactEmailID>
                <nc:ContactMailingAddress/>
                <nc:ContactTelephoneNumber>
                  <nc:FullTelephoneNumber/>
                </nc:ContactTelephoneNumber>
              </hix-core:ContactInformation>
              <hix-core:ContactInformationCategoryCode>Home</hix-core:ContactInformationCategoryCode>
            </hix-core:PersonContactInformationAssociation>
            <hix-core:PersonPregnancyStatus>
              <hix-core:StatusIndicator>false</hix-core:StatusIndicator>
            </hix-core:PersonPregnancyStatus>
            <hix-core:PersonPreferredLanguage>
              <nc:LanguageName>english</nc:LanguageName>
            </hix-core:PersonPreferredLanguage>
            <hix-core:PersonMarriedIndicator>false</hix-core:PersonMarriedIndicator>
          </hix-core:PersonAugmentation>
        </hix-core:Person>
        <ext:PhysicalHousehold>
          <hix-ee:HouseholdSizeQuantity>3</hix-ee:HouseholdSizeQuantity>
          <hix-ee:HouseholdMemberReference niem-s:ref="IDC1003158"/>
          <hix-ee:HouseholdMemberReference niem-s:ref="IDC1002699"/>
          <hix-ee:HouseholdMemberReference niem-s:ref="IDC1003159"/>
        </ext:PhysicalHousehold>
      </ex:AccountTransferRequest>
    </soap:Body>
    </soap:Envelope>
    XMLCODE
  end
  let(:document) { Nokogiri::XML(raw_xml) }

  let(:process) { described_class.new }

  let(:processed) { process.call(body) }

  context 'success' do
    context 'with valid application' do
      before do
        @result = process.call(document)
      end

      it 'should return success message' do
        expect(@result).to eq('Transferred account to Enroll')
      end

    end
  end
end