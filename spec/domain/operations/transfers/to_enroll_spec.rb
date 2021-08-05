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
      <ns10:AccountTransferRequest ns3:atVersionText="2.4" xmlns:ns1="http://niem.gov/niem/structures/2.0" xmlns:ns10="http://at.dsh.cms.gov/exchange/1.0" xmlns:ns2="http://niem.gov/niem/niem-core/2.0" xmlns:ns3="http://at.dsh.cms.gov/extension/1.0" xmlns:ns4="http://hix.cms.gov/0.1/hix-core" xmlns:ns5="http://hix.cms.gov/0.1/hix-ee" xmlns:ns6="http://niem.gov/niem/domains/screening/2.1" xmlns:ns7="http://hix.cms.gov/0.1/hix-pm" xmlns:ns8="http://niem.gov/niem/appinfo/2.0" xmlns:ns9="http://niem.gov/niem/appinfo/2.1">
        <ns3:TransferHeader>
            <ns3:TransferActivity>
               <ns2:ActivityIdentification>
                  <ns2:IdentificationID>IDC61161111111197777</ns2:IdentificationID>
               </ns2:ActivityIdentification>
               <ns2:ActivityDate>
                  <ns2:DateTime>2021-05-04T17:06:54.450-04:00</ns2:DateTime>
               </ns2:ActivityDate>
               <ns3:TransferActivityReferralQuantity>3</ns3:TransferActivityReferralQuantity>
               <ns3:RecipientTransferActivityCode>MedicaidCHIP</ns3:RecipientTransferActivityCode>
               <ns3:RecipientTransferActivityStateCode>ME</ns3:RecipientTransferActivityStateCode>
            </ns3:TransferActivity>
         </ns3:TransferHeader>
         <ns4:Sender ns1:id="Sender">
            <ns4:InformationExchangeSystemCategoryCode>Exchange</ns4:InformationExchangeSystemCategoryCode>
            <ns4:InformationExchangeSystemStateCode>ME</ns4:InformationExchangeSystemStateCode>
         </ns4:Sender>
         <ns4:Receiver ns1:id="medicaidReceiver">
            <ns4:InformationExchangeSystemCategoryCode>MedicaidAgency</ns4:InformationExchangeSystemCategoryCode>
            <ns4:InformationExchangeSystemStateCode>ME</ns4:InformationExchangeSystemStateCode>
         </ns4:Receiver>
         <ns5:InsuranceApplication>
            <ns4:ApplicationCreation>
               <ns2:ActivityDate>
                  <ns2:DateTime>2021-06-11T14:45:15.734-04:00</ns2:DateTime>
               </ns2:ActivityDate>
            </ns4:ApplicationCreation>
            <ns4:ApplicationSubmission>
               <ns2:ActivityDate>
                  <ns2:DateTime>2021-06-11T15:42:19.074-04:00</ns2:DateTime>
               </ns2:ActivityDate>
            </ns4:ApplicationSubmission>
            <ns4:ApplicationUpdate>
               <ns2:ActivityDate>
                  <ns2:DateTime>2021-06-04T17:06:52.773-04:00</ns2:DateTime>
               </ns2:ActivityDate>
            </ns4:ApplicationUpdate>
            <ns4:ApplicationIdentification>
               <ns2:IdentificationID>3927040608</ns2:IdentificationID>
               <ns2:IdentificationCategoryText>Exchange</ns2:IdentificationCategoryText>
            </ns4:ApplicationIdentification>
            <ns5:InsuranceApplicant>
               <ns4:RoleOfPersonReference ns1:ref="pe1992374604681766994"/>
               <ns5:InsuranceApplicantBlindnessOrDisabilityIndicator>false</ns5:InsuranceApplicantBlindnessOrDisabilityIndicator>
               <ns5:InsuranceApplicantFixedAddressIndicator>true</ns5:InsuranceApplicantFixedAddressIndicator>
               <ns5:InsuranceApplicantIncarceration ns1:metadata="vm2009583325215611507">
                  <ns4:IncarcerationIndicator>false</ns4:IncarcerationIndicator>
               </ns5:InsuranceApplicantIncarceration>
               <ns5:InsuranceApplicantLongTermCareIndicator>false</ns5:InsuranceApplicantLongTermCareIndicator>
               <ns5:InsuranceApplicantNonESICoverageIndicator>false</ns5:InsuranceApplicantNonESICoverageIndicator>
               <ns5:InsuranceApplicantParentCaretakerIndicator>false</ns5:InsuranceApplicantParentCaretakerIndicator>
               <ns5:ReferralActivity>
                  <ns2:ActivityIdentification>
                     <ns2:IdentificationID>IDC61058121961474610</ns2:IdentificationID>
                  </ns2:ActivityIdentification>
                  <ns2:ActivityDate>
                     <ns2:DateTime>2021-06-04T17:06:54.450-04:00</ns2:DateTime>
                  </ns2:ActivityDate>
                  <ns5:ReferralActivitySenderReference ns1:ref="Sender"/>
                  <ns5:ReferralActivityReceiverReference ns1:ref="medicaidReceiver"/>
                  <ns5:ReferralActivityStatus>
                     <ns5:ReferralActivityStatusCode>Initiated</ns5:ReferralActivityStatusCode>
                  </ns5:ReferralActivityStatus>
                  <ns5:ReferralActivityReasonCode>FullDetermination</ns5:ReferralActivityReasonCode>
               </ns5:ReferralActivity>
               <ns5:InsuranceApplicantFosterCareIndicator>false</ns5:InsuranceApplicantFosterCareIndicator>
            </ns5:InsuranceApplicant>
            <ns5:InsuranceApplicant>
               <ns4:RoleOfPersonReference ns1:ref="pe1992374604681766995"/>
               <ns5:InsuranceApplicantBlindnessOrDisabilityIndicator>false</ns5:InsuranceApplicantBlindnessOrDisabilityIndicator>
               <ns5:InsuranceApplicantFixedAddressIndicator>true</ns5:InsuranceApplicantFixedAddressIndicator>
               <ns5:InsuranceApplicantIncarceration ns1:metadata="vm2009583325215611507">
                  <ns4:IncarcerationIndicator>false</ns4:IncarcerationIndicator>
               </ns5:InsuranceApplicantIncarceration>
               <ns5:InsuranceApplicantLongTermCareIndicator>false</ns5:InsuranceApplicantLongTermCareIndicator>
               <ns5:InsuranceApplicantNonESICoverageIndicator>false</ns5:InsuranceApplicantNonESICoverageIndicator>
               <ns5:InsuranceApplicantParentCaretakerIndicator>false</ns5:InsuranceApplicantParentCaretakerIndicator>
               <ns5:ReferralActivity>
                  <ns2:ActivityIdentification>
                     <ns2:IdentificationID>IDC61058121961474610</ns2:IdentificationID>
                  </ns2:ActivityIdentification>
                  <ns2:ActivityDate>
                     <ns2:DateTime>2021-06-04T17:06:54.450-04:00</ns2:DateTime>
                  </ns2:ActivityDate>
                  <ns5:ReferralActivitySenderReference ns1:ref="Sender"/>
                  <ns5:ReferralActivityReceiverReference ns1:ref="medicaidReceiver"/>
                  <ns5:ReferralActivityStatus>
                     <ns5:ReferralActivityStatusCode>Initiated</ns5:ReferralActivityStatusCode>
                  </ns5:ReferralActivityStatus>
                  <ns5:ReferralActivityReasonCode>FullDetermination</ns5:ReferralActivityReasonCode>
               </ns5:ReferralActivity>
               <ns5:InsuranceApplicantFosterCareIndicator>false</ns5:InsuranceApplicantFosterCareIndicator>
            </ns5:InsuranceApplicant>
            <ns5:InsuranceApplicant>
               <ns4:RoleOfPersonReference ns1:ref="pe1992374604681766996"/>
               <ns5:InsuranceApplicantBlindnessOrDisabilityIndicator>false</ns5:InsuranceApplicantBlindnessOrDisabilityIndicator>
               <ns5:InsuranceApplicantFixedAddressIndicator>true</ns5:InsuranceApplicantFixedAddressIndicator>
               <ns5:InsuranceApplicantIncarceration ns1:metadata="vm2009583325215611507">
                  <ns4:IncarcerationIndicator>false</ns4:IncarcerationIndicator>
               </ns5:InsuranceApplicantIncarceration>
               <ns5:InsuranceApplicantLongTermCareIndicator>false</ns5:InsuranceApplicantLongTermCareIndicator>
               <ns5:InsuranceApplicantNonESICoverageIndicator>false</ns5:InsuranceApplicantNonESICoverageIndicator>
               <ns5:InsuranceApplicantParentCaretakerIndicator>false</ns5:InsuranceApplicantParentCaretakerIndicator>
               <ns5:ReferralActivity>
                  <ns2:ActivityIdentification>
                     <ns2:IdentificationID>IDC61058121961474610</ns2:IdentificationID>
                  </ns2:ActivityIdentification>
                  <ns2:ActivityDate>
                     <ns2:DateTime>2021-06-04T17:06:54.450-04:00</ns2:DateTime>
                  </ns2:ActivityDate>
                  <ns5:ReferralActivitySenderReference ns1:ref="Sender"/>
                  <ns5:ReferralActivityReceiverReference ns1:ref="medicaidReceiver"/>
                  <ns5:ReferralActivityStatus>
                     <ns5:ReferralActivityStatusCode>Initiated</ns5:ReferralActivityStatusCode>
                  </ns5:ReferralActivityStatus>
                  <ns5:ReferralActivityReasonCode>FullDetermination</ns5:ReferralActivityReasonCode>
               </ns5:ReferralActivity>
               <ns5:InsuranceApplicantFosterCareIndicator>false</ns5:InsuranceApplicantFosterCareIndicator>
            </ns5:InsuranceApplicant>
            <ns5:InsuranceApplicationRequestingFinancialAssistanceIndicator>true</ns5:InsuranceApplicationRequestingFinancialAssistanceIndicator>
            <ns5:InsuranceApplicationCoverageRenewalYearQuantity>5</ns5:InsuranceApplicationCoverageRenewalYearQuantity>
            <ns5:SSFSigner>
               <ns4:RoleOfPersonReference ns1:ref="pe1992374604681766994"/>
               <ns5:Signature>
                  <ns4:SignatureName>
                     <ns2:PersonFullName>Simple Transfer J</ns2:PersonFullName>
                  </ns4:SignatureName>
                  <ns4:SignatureDate>
                     <ns2:Date>2021-06-11</ns2:Date>
                  </ns4:SignatureDate>
               </ns5:Signature>
               <ns5:SSFSignerAuthorizedRepresentativeAssociation>
                <ns5:AuthorizedRepresentativeReference ns1:ref="MEPO0000000200628971"></ns5:AuthorizedRepresentativeReference>
               <ns5:Signature>
                 <ns3:SignatureDate>
                   <ns2:Date>2020-05-18-04:00</ns2:Date>
                 </ns3:SignatureDate>
                 </ns5:Signature>
                 </ns5:SSFSignerAuthorizedRepresentativeAssociation>
               <ns5:SSFAttestation>
                  <ns5:SSFAttestationCollectionsAgreementIndicator>false</ns5:SSFAttestationCollectionsAgreementIndicator>
                  <ns5:SSFAttestationNonPerjuryIndicator>true</ns5:SSFAttestationNonPerjuryIndicator>
                  <ns5:SSFAttestationNotIncarceratedIndicator ns1:metadata="vm2009583325215611507">true</ns5:SSFAttestationNotIncarceratedIndicator>
                  <ns5:SSFAttestationInformationChangesIndicator>true</ns5:SSFAttestationInformationChangesIndicator>
                  <ns5:SSFAttestationApplicationTermsIndicator>true</ns5:SSFAttestationApplicationTermsIndicator>
               </ns5:SSFAttestation>
            </ns5:SSFSigner>
            <ns5:InsuranceApplicationRequestingMedicaidIndicator>true</ns5:InsuranceApplicationRequestingMedicaidIndicator>
            <ns5:SSFPrimaryContact>
               <ns4:RoleOfPersonReference ns1:ref="pe1992374604681766994"/>
               <ns5:SSFPrimaryContactPreferenceCode>Email</ns5:SSFPrimaryContactPreferenceCode>
            </ns5:SSFPrimaryContact>
            <ns5:InsuranceApplicationTaxReturnAccessIndicator>true</ns5:InsuranceApplicationTaxReturnAccessIndicator>
         </ns5:InsuranceApplication>
         <ns5:AuthorizedRepresentative ns1:id="MEPO0000000200628971">
           <ns3:RolePlayedByPerson xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
             <ns2:PersonBirthDate xsi:nil="true"></ns2:PersonBirthDate>
           <ns2:PersonName>
              <ns2:PersonGivenName>Pat</ns2:PersonGivenName>
              <ns2:PersonSurName>test</ns2:PersonSurName>
            </ns2:PersonName>
            <ns2:PersonSexText xsi:nil="true"></ns2:PersonSexText>
            </ns3:RolePlayedByPerson>
         </ns5:AuthorizedRepresentative>
         <ns5:MedicaidHousehold ns1:id="mh2009521689331128940">
            <ns5:HouseholdIncome>
               <ns4:IncomeFrequency>
                  <ns4:FrequencyCode>Annually</ns4:FrequencyCode>
               </ns4:IncomeFrequency>
               <ns4:IncomeAmount>33628.00</ns4:IncomeAmount>
               <ns4:IncomeCategoryCode>Unspecified</ns4:IncomeCategoryCode>
            </ns5:HouseholdIncome>
            <ns5:HouseholdMemberReference ns1:ref="pe1992374604681766994"/>
            <ns5:HouseholdMemberReference ns1:ref="pe1992374604681766995"/>
            <ns5:HouseholdMemberReference ns1:ref="pe1992374604681766996"/>
            <ns5:MedicaidHouseholdEffectivePersonQuantity>3</ns5:MedicaidHouseholdEffectivePersonQuantity>
            <ns5:MedicaidHouseholdIncomeAboveHighestApplicableMAGIStandardIndicator>true</ns5:MedicaidHouseholdIncomeAboveHighestApplicableMAGIStandardIndicator>
         </ns5:MedicaidHousehold>
         <ns4:Person ns1:id="pe1992374604681766994">
            <ns2:PersonAgeMeasure>
               <ns2:MeasurePointValue>23</ns2:MeasurePointValue>
            </ns2:PersonAgeMeasure>
            <ns2:PersonBirthDate>
               <ns2:Date>1998-01-01</ns2:Date>
            </ns2:PersonBirthDate>
            <ns2:PersonLivingIndicator>true</ns2:PersonLivingIndicator>
            <ns2:PersonName>
               <ns2:PersonGivenName>Simple</ns2:PersonGivenName>
               <ns2:PersonMiddleName>Transfer</ns2:PersonMiddleName>
               <ns2:PersonSurName>J</ns2:PersonSurName>
            </ns2:PersonName>
            <ns2:PersonRaceText>White</ns2:PersonRaceText>
            <ns2:PersonSexText>Female</ns2:PersonSexText>
            <ns2:PersonSSNIdentification ns1:metadata="vm2009583325215611505">
               <ns2:IdentificationID>222677169</ns2:IdentificationID>
            </ns2:PersonSSNIdentification>
            <ns2:PersonUSCitizenIndicator ns1:metadata="vm2009583325215611506">true</ns2:PersonUSCitizenIndicator>
            <ns4:TribalAugmentation>
               <ns4:PersonAmericanIndianOrAlaskaNativeIndicator>false</ns4:PersonAmericanIndianOrAlaskaNativeIndicator>
            </ns4:TribalAugmentation>
            <ns4:PersonAugmentation>
            <ns4:PersonAssociation>
               <ns2:AssociationBeginDate>
                 <ns2:Date>2018-01-01</ns2:Date>
               </ns2:AssociationBeginDate>
               <ns2:PersonReference ns1:ref="pe1992374604681766995"/>
               <ns4:FamilyRelationshipCode>01</ns4:FamilyRelationshipCode>
             </ns4:PersonAssociation>
             <ns4:PersonAssociation>
               <ns2:AssociationBeginDate>
                 <ns2:Date>2021-06-01</ns2:Date>
               </ns2:AssociationBeginDate>
               <ns2:PersonReference ns1:ref="pe1992374604681766996"/>
               <ns4:FamilyRelationshipCode>19</ns4:FamilyRelationshipCode>
             </ns4:PersonAssociation>
               <ns4:PersonContactInformationAssociation>
                  <ns2:ContactInformationIsPrimaryIndicator>true</ns2:ContactInformationIsPrimaryIndicator>
                  <ns4:ContactInformation>
                     <ns2:ContactTelephoneNumber>
                        <ns2:FullTelephoneNumber>
                           <ns2:TelephoneNumberFullID>2021111341</ns2:TelephoneNumberFullID>
                        </ns2:FullTelephoneNumber>
                     </ns2:ContactTelephoneNumber>
                  </ns4:ContactInformation>
                  <ns4:ContactInformationCategoryCode>Mobile</ns4:ContactInformationCategoryCode>
               </ns4:PersonContactInformationAssociation>
               <ns4:PersonContactInformationAssociation>
                  <ns2:ContactInformationIsPrimaryIndicator>false</ns2:ContactInformationIsPrimaryIndicator>
                  <ns4:ContactInformation>
                     <ns2:ContactMailingAddress>
                        <ns2:StructuredAddress>
                           <ns2:LocationStreet>
                              <ns2:StreetFullText>511 Test Street</ns2:StreetFullText>
                           </ns2:LocationStreet>
                           <ns2:LocationCityName>Augusta</ns2:LocationCityName>
                           <ns2:LocationCountyName>KENNEBEC</ns2:LocationCountyName>
                           <ns2:LocationCountyCode>011</ns2:LocationCountyCode>
                           <ns2:LocationStateUSPostalServiceCode>ME</ns2:LocationStateUSPostalServiceCode>
                           <ns2:LocationPostalCode>04330</ns2:LocationPostalCode>
                        </ns2:StructuredAddress>
                     </ns2:ContactMailingAddress>
                  </ns4:ContactInformation>
                  <ns4:ContactInformationCategoryCode>Home</ns4:ContactInformationCategoryCode>
               </ns4:PersonContactInformationAssociation>
               <ns4:PersonContactInformationAssociation>
                  <ns2:ContactInformationIsPrimaryIndicator>false</ns2:ContactInformationIsPrimaryIndicator>
                  <ns4:ContactInformation>
                     <ns2:ContactMailingAddress>
                        <ns2:StructuredAddress>
                           <ns2:LocationStreet>
                              <ns2:StreetFullText>37 Malta Street</ns2:StreetFullText>
                           </ns2:LocationStreet>
                           <ns2:LocationCityName>Augusta</ns2:LocationCityName>
                           <ns2:LocationCountyName>KENNEBEC</ns2:LocationCountyName>
                           <ns2:LocationCountyCode>011</ns2:LocationCountyCode>
                           <ns2:LocationStateUSPostalServiceCode>ME</ns2:LocationStateUSPostalServiceCode>
                           <ns2:LocationPostalCode>04330</ns2:LocationPostalCode>
                        </ns2:StructuredAddress>
                     </ns2:ContactMailingAddress>
                  </ns4:ContactInformation>
                  <ns4:ContactInformationCategoryCode>Mailing</ns4:ContactInformationCategoryCode>
               </ns4:PersonContactInformationAssociation>
               <ns4:PersonContactInformationAssociation>
                  <ns2:ContactInformationIsPrimaryIndicator>false</ns2:ContactInformationIsPrimaryIndicator>
                  <ns4:ContactInformation>
                     <ns2:ContactMailingAddress>
                        <ns2:StructuredAddress>
                           <ns2:LocationStreet>
                              <ns2:StreetFullText>37 Malta Street</ns2:StreetFullText>
                           </ns2:LocationStreet>
                           <ns2:LocationCityName>Augusta</ns2:LocationCityName>
                           <ns2:LocationCountyName>KENNEBEC</ns2:LocationCountyName>
                           <ns2:LocationCountyCode>011</ns2:LocationCountyCode>
                           <ns2:LocationStateUSPostalServiceCode>ME</ns2:LocationStateUSPostalServiceCode>
                           <ns2:LocationPostalCode>04330</ns2:LocationPostalCode>
                        </ns2:StructuredAddress>
                     </ns2:ContactMailingAddress>
                  </ns4:ContactInformation>
                  <ns4:ContactInformationCategoryCode>Residency</ns4:ContactInformationCategoryCode>
               </ns4:PersonContactInformationAssociation>
               <ns4:PersonContactInformationAssociation>
                  <ns2:ContactInformationIsPrimaryIndicator>false</ns2:ContactInformationIsPrimaryIndicator>
                  <ns4:ContactInformation>
                     <ns2:ContactEmailID>BCurtis23@gmail.com</ns2:ContactEmailID>
                  </ns4:ContactInformation>
                  <ns4:ContactInformationCategoryCode>Home</ns4:ContactInformationCategoryCode>
               </ns4:PersonContactInformationAssociation>
               <ns4:PersonEmploymentAssociation>
                  <ns4:Employer ns1:id="em2009481180751485381">
                     <ns2:OrganizationName>Test Bank</ns2:OrganizationName>
                  </ns4:Employer>
               </ns4:PersonEmploymentAssociation>
               <ns4:PersonEmploymentAssociation>
                  <ns4:Employer ns1:id="em2009481180751485382">
                     <ns2:OrganizationName>City of Augusta Bank</ns2:OrganizationName>
                  </ns4:Employer>
               </ns4:PersonEmploymentAssociation>
               <ns4:PersonPregnancyStatus>
                  <ns4:StatusIndicator>false</ns4:StatusIndicator>
               </ns4:PersonPregnancyStatus>
               <ns4:PersonIncome>
                  <ns4:IncomeFrequency>
                     <ns4:FrequencyCode>Annually</ns4:FrequencyCode>
                  </ns4:IncomeFrequency>
                  <ns4:IncomeAmount>23628.00</ns4:IncomeAmount>
                  <ns4:IncomeCategoryCode>Wages</ns4:IncomeCategoryCode>
                  <ns4:IncomeSourceOrganizationReference ns1:ref="em2009481180751485382"/>
               </ns4:PersonIncome>
               <ns4:PersonPreferredLanguage>
                  <ns2:LanguageName>English</ns2:LanguageName>
                  <ns2:PersonSpeaksLanguageIndicator>true</ns2:PersonSpeaksLanguageIndicator>
                  <ns2:PersonWritesLanguageIndicator>true</ns2:PersonWritesLanguageIndicator>
               </ns4:PersonPreferredLanguage>
               <ns4:USNaturalizedCitizenIndicator>false</ns4:USNaturalizedCitizenIndicator>
               <ns4:PersonMarriedIndicator>true</ns4:PersonMarriedIndicator>
            </ns4:PersonAugmentation>
         </ns4:Person>
         <ns4:Person ns1:id="pe1992374604681766995">
           <ns2:PersonAgeMeasure>
              <ns2:MeasurePointValue>23</ns2:MeasurePointValue>
           </ns2:PersonAgeMeasure>
           <ns2:PersonBirthDate>
              <ns2:Date>1998-01-01</ns2:Date>
           </ns2:PersonBirthDate>
           <ns2:PersonLivingIndicator>true</ns2:PersonLivingIndicator>
           <ns2:PersonName>
              <ns2:PersonGivenName>Dwayne</ns2:PersonGivenName>
              <ns2:PersonSurName>Curtis</ns2:PersonSurName>
           </ns2:PersonName>
           <ns2:PersonRaceText>White</ns2:PersonRaceText>
           <ns2:PersonSexText>Male</ns2:PersonSexText>
           <ns2:PersonSSNIdentification ns1:metadata="vm2009583325215611505">
              <ns2:IdentificationID>247893779</ns2:IdentificationID>
           </ns2:PersonSSNIdentification>
           <ns2:PersonUSCitizenIndicator ns1:metadata="vm2009583325215611506">true</ns2:PersonUSCitizenIndicator>
           <ns4:TribalAugmentation>
              <ns4:PersonAmericanIndianOrAlaskaNativeIndicator>false</ns4:PersonAmericanIndianOrAlaskaNativeIndicator>
           </ns4:TribalAugmentation>
           <ns4:PersonAugmentation>
           <ns4:PersonAssociation>
               <ns2:AssociationBeginDate>
                 <ns2:Date>2018-01-01</ns2:Date>
               </ns2:AssociationBeginDate>
               <ns2:PersonReference ns1:ref="pe1992374604681766994"/>
               <ns4:FamilyRelationshipCode>01</ns4:FamilyRelationshipCode>
             </ns4:PersonAssociation>
             <ns4:PersonAssociation>
               <ns2:AssociationBeginDate>
                 <ns2:Date>2021-06-01</ns2:Date>
               </ns2:AssociationBeginDate>
               <ns2:PersonReference ns1:ref="pe1992374604681766996"/>
               <ns4:FamilyRelationshipCode>19</ns4:FamilyRelationshipCode>
             </ns4:PersonAssociation>
              <ns4:PersonContactInformationAssociation>
                 <ns2:ContactInformationIsPrimaryIndicator>false</ns2:ContactInformationIsPrimaryIndicator>
                 <ns4:ContactInformation>
                    <ns2:ContactTelephoneNumber>
                       <ns2:FullTelephoneNumber>
                          <ns2:TelephoneNumberFullID>2021668341</ns2:TelephoneNumberFullID>
                       </ns2:FullTelephoneNumber>
                    </ns2:ContactTelephoneNumber>
                 </ns4:ContactInformation>
                 <ns4:ContactInformationCategoryCode>Mobile</ns4:ContactInformationCategoryCode>
              </ns4:PersonContactInformationAssociation>
              <ns4:PersonContactInformationAssociation>
                 <ns2:ContactInformationIsPrimaryIndicator>false</ns2:ContactInformationIsPrimaryIndicator>
                 <ns4:ContactInformation>
                    <ns2:ContactMailingAddress>
                       <ns2:StructuredAddress>
                          <ns2:LocationStreet>
                             <ns2:StreetFullText>511 Test Street</ns2:StreetFullText>
                          </ns2:LocationStreet>
                          <ns2:LocationCityName>Augusta</ns2:LocationCityName>
                          <ns2:LocationCountyName>KENNEBEC</ns2:LocationCountyName>
                          <ns2:LocationCountyCode>011</ns2:LocationCountyCode>
                          <ns2:LocationStateUSPostalServiceCode>ME</ns2:LocationStateUSPostalServiceCode>
                          <ns2:LocationPostalCode>04330</ns2:LocationPostalCode>
                       </ns2:StructuredAddress>
                    </ns2:ContactMailingAddress>
                 </ns4:ContactInformation>
                 <ns4:ContactInformationCategoryCode>Home</ns4:ContactInformationCategoryCode>
              </ns4:PersonContactInformationAssociation>
              <ns4:PersonContactInformationAssociation>
                 <ns2:ContactInformationIsPrimaryIndicator>false</ns2:ContactInformationIsPrimaryIndicator>
                 <ns4:ContactInformation>
                    <ns2:ContactMailingAddress>
                       <ns2:StructuredAddress>
                          <ns2:LocationStreet>
                             <ns2:StreetFullText>37 Malta Street</ns2:StreetFullText>
                          </ns2:LocationStreet>
                          <ns2:LocationCityName>Augusta</ns2:LocationCityName>
                          <ns2:LocationCountyName>KENNEBEC</ns2:LocationCountyName>
                          <ns2:LocationCountyCode>011</ns2:LocationCountyCode>
                          <ns2:LocationStateUSPostalServiceCode>ME</ns2:LocationStateUSPostalServiceCode>
                          <ns2:LocationPostalCode>04330</ns2:LocationPostalCode>
                       </ns2:StructuredAddress>
                    </ns2:ContactMailingAddress>
                 </ns4:ContactInformation>
                 <ns4:ContactInformationCategoryCode>Mailing</ns4:ContactInformationCategoryCode>
              </ns4:PersonContactInformationAssociation>
              <ns4:PersonContactInformationAssociation>
                 <ns2:ContactInformationIsPrimaryIndicator>false</ns2:ContactInformationIsPrimaryIndicator>
                 <ns4:ContactInformation>
                    <ns2:ContactMailingAddress>
                       <ns2:StructuredAddress>
                          <ns2:LocationStreet>
                             <ns2:StreetFullText>37 Malta Street</ns2:StreetFullText>
                          </ns2:LocationStreet>
                          <ns2:LocationCityName>Augusta</ns2:LocationCityName>
                          <ns2:LocationCountyName>KENNEBEC</ns2:LocationCountyName>
                          <ns2:LocationCountyCode>011</ns2:LocationCountyCode>
                          <ns2:LocationStateUSPostalServiceCode>ME</ns2:LocationStateUSPostalServiceCode>
                          <ns2:LocationPostalCode>04330</ns2:LocationPostalCode>
                       </ns2:StructuredAddress>
                    </ns2:ContactMailingAddress>
                 </ns4:ContactInformation>
                 <ns4:ContactInformationCategoryCode>Residency</ns4:ContactInformationCategoryCode>
              </ns4:PersonContactInformationAssociation>
              <ns4:PersonContactInformationAssociation>
                 <ns2:ContactInformationIsPrimaryIndicator>false</ns2:ContactInformationIsPrimaryIndicator>
                 <ns4:ContactInformation>
                    <ns2:ContactEmailID>DCurtis23@gmail.com</ns2:ContactEmailID>
                 </ns4:ContactInformation>
                 <ns4:ContactInformationCategoryCode>Home</ns4:ContactInformationCategoryCode>
              </ns4:PersonContactInformationAssociation>
              <ns4:PersonPregnancyStatus>
                 <ns4:StatusIndicator>false</ns4:StatusIndicator>
              </ns4:PersonPregnancyStatus>
              <ns4:PersonIncome>
                  <ns4:IncomeFrequency>
                     <ns4:FrequencyCode>Annually</ns4:FrequencyCode>
                  </ns4:IncomeFrequency>
                  <ns4:IncomeAmount>10000.00</ns4:IncomeAmount>
                  <ns4:IncomeCategoryCode>Wages</ns4:IncomeCategoryCode>
                  <ns4:IncomeSourceOrganizationReference ns1:ref="em2009481180751485382"/>
               </ns4:PersonIncome>
               <ns4:PersonPreferredLanguage>
                 <ns2:LanguageName>English</ns2:LanguageName>
                 <ns2:PersonSpeaksLanguageIndicator>true</ns2:PersonSpeaksLanguageIndicator>
                 <ns2:PersonWritesLanguageIndicator>true</ns2:PersonWritesLanguageIndicator>
              </ns4:PersonPreferredLanguage>
              <ns4:USNaturalizedCitizenIndicator>false</ns4:USNaturalizedCitizenIndicator>
              <ns4:PersonMarriedIndicator>true</ns4:PersonMarriedIndicator>
           </ns4:PersonAugmentation>
        </ns4:Person>
        <ns4:Person ns1:id="pe1992374604681766996">
           <ns2:PersonAgeMeasure>
              <ns2:MeasurePointValue>0</ns2:MeasurePointValue>
           </ns2:PersonAgeMeasure>
           <ns2:PersonBirthDate>
              <ns2:Date>2021-06-01</ns2:Date>
           </ns2:PersonBirthDate>
           <ns2:PersonLivingIndicator>true</ns2:PersonLivingIndicator>
           <ns2:PersonName>
              <ns2:PersonGivenName>Baby</ns2:PersonGivenName>
              <ns2:PersonSurName>Curtis</ns2:PersonSurName>
           </ns2:PersonName>
           <ns2:PersonRaceText>White</ns2:PersonRaceText>
           <ns2:PersonSexText>Male</ns2:PersonSexText>
           <ns2:PersonSSNIdentification ns1:metadata="vm2009583325215611505">
              <ns2:IdentificationID>285427119</ns2:IdentificationID>
           </ns2:PersonSSNIdentification>
           <ns2:PersonUSCitizenIndicator ns1:metadata="vm2009583325215611506">true</ns2:PersonUSCitizenIndicator>
           <ns4:TribalAugmentation>
              <ns4:PersonAmericanIndianOrAlaskaNativeIndicator>false</ns4:PersonAmericanIndianOrAlaskaNativeIndicator>
           </ns4:TribalAugmentation>
           <ns4:PersonAugmentation>
           <ns4:PersonAssociation>
               <ns2:AssociationBeginDate>
                 <ns2:Date>2021-06-01</ns2:Date>
               </ns2:AssociationBeginDate>
               <ns2:PersonReference ns1:ref="pe1992374604681766994"/>
               <ns4:FamilyRelationshipCode>03</ns4:FamilyRelationshipCode>
             </ns4:PersonAssociation>
           <ns4:PersonAssociation>
               <ns2:AssociationBeginDate>
                 <ns2:Date>2021-06-01</ns2:Date>
               </ns2:AssociationBeginDate>
               <ns2:PersonReference ns1:ref="pe1992374604681766995"/>
               <ns4:FamilyRelationshipCode>03</ns4:FamilyRelationshipCode>
             </ns4:PersonAssociation>
              <ns4:PersonContactInformationAssociation>
                 <ns2:ContactInformationIsPrimaryIndicator>false</ns2:ContactInformationIsPrimaryIndicator>
                 <ns4:ContactInformation>
                    <ns2:ContactTelephoneNumber>
                       <ns2:FullTelephoneNumber>
                          <ns2:TelephoneNumberFullID>2021668341</ns2:TelephoneNumberFullID>
                       </ns2:FullTelephoneNumber>
                    </ns2:ContactTelephoneNumber>
                 </ns4:ContactInformation>
                 <ns4:ContactInformationCategoryCode>Mobile</ns4:ContactInformationCategoryCode>
              </ns4:PersonContactInformationAssociation>
              <ns4:PersonContactInformationAssociation>
                 <ns2:ContactInformationIsPrimaryIndicator>false</ns2:ContactInformationIsPrimaryIndicator>
                 <ns4:ContactInformation>
                    <ns2:ContactMailingAddress>
                       <ns2:StructuredAddress>
                          <ns2:LocationStreet>
                             <ns2:StreetFullText>511 Test Street</ns2:StreetFullText>
                          </ns2:LocationStreet>
                          <ns2:LocationCityName>Augusta</ns2:LocationCityName>
                          <ns2:LocationCountyName>KENNEBEC</ns2:LocationCountyName>
                          <ns2:LocationCountyCode>011</ns2:LocationCountyCode>
                          <ns2:LocationStateUSPostalServiceCode>ME</ns2:LocationStateUSPostalServiceCode>
                          <ns2:LocationPostalCode>04330</ns2:LocationPostalCode>
                       </ns2:StructuredAddress>
                    </ns2:ContactMailingAddress>
                 </ns4:ContactInformation>
                 <ns4:ContactInformationCategoryCode>Home</ns4:ContactInformationCategoryCode>
              </ns4:PersonContactInformationAssociation>
              <ns4:PersonContactInformationAssociation>
                 <ns2:ContactInformationIsPrimaryIndicator>false</ns2:ContactInformationIsPrimaryIndicator>
                 <ns4:ContactInformation>
                    <ns2:ContactMailingAddress>
                       <ns2:StructuredAddress>
                          <ns2:LocationStreet>
                             <ns2:StreetFullText>37 Malta Street</ns2:StreetFullText>
                          </ns2:LocationStreet>
                          <ns2:LocationCityName>Augusta</ns2:LocationCityName>
                          <ns2:LocationCountyName>KENNEBEC</ns2:LocationCountyName>
                          <ns2:LocationCountyCode>011</ns2:LocationCountyCode>
                          <ns2:LocationStateUSPostalServiceCode>ME</ns2:LocationStateUSPostalServiceCode>
                          <ns2:LocationPostalCode>04330</ns2:LocationPostalCode>
                       </ns2:StructuredAddress>
                    </ns2:ContactMailingAddress>
                 </ns4:ContactInformation>
                 <ns4:ContactInformationCategoryCode>Mailing</ns4:ContactInformationCategoryCode>
              </ns4:PersonContactInformationAssociation>
              <ns4:PersonContactInformationAssociation>
                 <ns2:ContactInformationIsPrimaryIndicator>false</ns2:ContactInformationIsPrimaryIndicator>
                 <ns4:ContactInformation>
                    <ns2:ContactMailingAddress>
                       <ns2:StructuredAddress>
                          <ns2:LocationStreet>
                             <ns2:StreetFullText>37 Malta Street</ns2:StreetFullText>
                          </ns2:LocationStreet>
                          <ns2:LocationCityName>Augusta</ns2:LocationCityName>
                          <ns2:LocationCountyName>KENNEBEC</ns2:LocationCountyName>
                          <ns2:LocationCountyCode>011</ns2:LocationCountyCode>
                          <ns2:LocationStateUSPostalServiceCode>ME</ns2:LocationStateUSPostalServiceCode>
                          <ns2:LocationPostalCode>04330</ns2:LocationPostalCode>
                       </ns2:StructuredAddress>
                    </ns2:ContactMailingAddress>
                 </ns4:ContactInformation>
                 <ns4:ContactInformationCategoryCode>Residency</ns4:ContactInformationCategoryCode>
              </ns4:PersonContactInformationAssociation>
              <ns4:PersonPregnancyStatus>
                 <ns4:StatusIndicator>false</ns4:StatusIndicator>
              </ns4:PersonPregnancyStatus>
               <ns4:PersonPreferredLanguage>
                 <ns2:LanguageName>English</ns2:LanguageName>
                 <ns2:PersonSpeaksLanguageIndicator>false</ns2:PersonSpeaksLanguageIndicator>
                 <ns2:PersonWritesLanguageIndicator>false</ns2:PersonWritesLanguageIndicator>
              </ns4:PersonPreferredLanguage>
              <ns4:USNaturalizedCitizenIndicator>false</ns4:USNaturalizedCitizenIndicator>
              <ns4:PersonMarriedIndicator>false</ns4:PersonMarriedIndicator>
           </ns4:PersonAugmentation>
        </ns4:Person>
        <ns5:TaxReturn>
            <ns5:TaxHousehold>
               <ns5:HouseholdIncome>
                  <ns4:IncomeAmount>33628.00</ns4:IncomeAmount>
                  <ns4:IncomeFederalPovertyLevelPercent>195</ns4:IncomeFederalPovertyLevelPercent>
               </ns5:HouseholdIncome>
               <ns5:HouseholdSizeQuantity>3</ns5:HouseholdSizeQuantity>
               <ns5:PrimaryTaxFiler>
                  <ns4:RoleOfPersonReference ns1:ref="pe1992374604681766994"/>
               </ns5:PrimaryTaxFiler>
               <ns5:SpouseTaxFiler>
                   <ns4:RoleOfPersonReference ns1:ref="pe1992374604681766995"/>
               </ns5:SpouseTaxFiler>
               <ns5:TaxDependent>
                   <ns4:RoleOfPersonReference ns1:ref="pe1992374604681766996"/>
               </ns5:TaxDependent>
            </ns5:TaxHousehold>
            <ns5:TaxReturnIncludesDependentIndicator>false</ns5:TaxReturnIncludesDependentIndicator>
         </ns5:TaxReturn>
         <ns4:VerificationMetadata ns1:id="vm2009583325215611506">
            <ns4:VerificationAuthorityTDS-FEPS-AlphaCode>SSA</ns4:VerificationAuthorityTDS-FEPS-AlphaCode>
            <ns4:VerificationDate>
               <ns2:DateTime>2021-06-11T14:47:30.213-04:00</ns2:DateTime>
            </ns4:VerificationDate>
            <ns4:VerificationRequestingSystem>
               <ns4:InformationExchangeSystemCategoryCode>Exchange</ns4:InformationExchangeSystemCategoryCode>
            </ns4:VerificationRequestingSystem>
            <ns4:VerificationIndicator>true</ns4:VerificationIndicator>
            <ns4:VerificationDescriptionText>Citizenship Status</ns4:VerificationDescriptionText>
            <ns4:VerificationStatus>
               <ns4:VerificationStatusCode>5</ns4:VerificationStatusCode>
            </ns4:VerificationStatus>
            <ns4:VerificationCategoryCode>Citizenship</ns4:VerificationCategoryCode>
            <ns4:ResponseCode>HS000000</ns4:ResponseCode>
         </ns4:VerificationMetadata>
         <ns4:VerificationMetadata ns1:id="vm2009583325215611505">
            <ns4:VerificationAuthorityTDS-FEPS-AlphaCode>SSA</ns4:VerificationAuthorityTDS-FEPS-AlphaCode>
            <ns4:VerificationDate>
               <ns2:DateTime>2021-06-11T14:47:30.213-04:00</ns2:DateTime>
            </ns4:VerificationDate>
            <ns4:VerificationRequestingSystem>
               <ns4:InformationExchangeSystemCategoryCode>Exchange</ns4:InformationExchangeSystemCategoryCode>
            </ns4:VerificationRequestingSystem>
            <ns4:VerificationIndicator>true</ns4:VerificationIndicator>
            <ns4:VerificationDescriptionText>SSN</ns4:VerificationDescriptionText>
            <ns4:VerificationStatus>
               <ns4:VerificationStatusCode>5</ns4:VerificationStatusCode>
            </ns4:VerificationStatus>
            <ns4:VerificationCategoryCode>SSN</ns4:VerificationCategoryCode>
            <ns4:ResponseCode>HS000000</ns4:ResponseCode>
         </ns4:VerificationMetadata>
         <ns4:VerificationMetadata ns1:id="vm2009583325215611507">
            <ns4:VerificationAuthorityTDS-FEPS-AlphaCode>SSA</ns4:VerificationAuthorityTDS-FEPS-AlphaCode>
            <ns4:VerificationDate>
               <ns2:DateTime>2021-06-11T14:47:30.213-04:00</ns2:DateTime>
            </ns4:VerificationDate>
            <ns4:VerificationRequestingSystem>
               <ns4:InformationExchangeSystemCategoryCode>Exchange</ns4:InformationExchangeSystemCategoryCode>
            </ns4:VerificationRequestingSystem>
            <ns4:VerificationIndicator>false</ns4:VerificationIndicator>
            <ns4:VerificationDescriptionText>Incarceration</ns4:VerificationDescriptionText>
            <ns4:VerificationStatus>
               <ns4:VerificationStatusCode>5</ns4:VerificationStatusCode>
            </ns4:VerificationStatus>
            <ns4:VerificationCategoryCode>IncarcerationStatus</ns4:VerificationCategoryCode>
            <ns4:ResponseCode>HS000000</ns4:ResponseCode>
         </ns4:VerificationMetadata>
         <ns3:PhysicalHousehold>
            <ns5:HouseholdMemberReference ns1:ref="pe1992374604681766994"/>
            <ns5:HouseholdMemberReference ns1:ref="pe1992374604681766995"/>
            <ns5:HouseholdMemberReference ns1:ref="pe1992374604681766996"/>
         </ns3:PhysicalHousehold>
      </ns10:AccountTransferRequest>
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