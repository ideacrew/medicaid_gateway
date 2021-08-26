<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:doc="http://hix.cms.gov/0.1/documentation"
            queryBinding="xslt2">
   <sch:title>Account Transfer Constraints</sch:title>
   <sch:ns uri="http://hix.cms.gov/0.1/hix-core" prefix="hix-core"/>
   <sch:ns uri="http://hix.cms.gov/0.1/hix-ee" prefix="hix-ee"/>
   <sch:ns uri="http://hix.cms.gov/0.1/hix-pm" prefix="hix-pm"/>
   <sch:ns uri="http://niem.gov/niem/appinfo/2.0" prefix="i"/>
   <sch:ns uri="http://niem.gov/niem/niem-core/2.0" prefix="nc"/>
   <sch:ns uri="http://niem.gov/niem/structures/2.0" prefix="s"/>
   <sch:ns uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
   <sch:ns uri="http://at.dsh.cms.gov/exchange/1.0" prefix="exch"/>
   <sch:ns uri="http://at.dsh.cms.gov/extension/1.0" prefix="ext"/>
   <sch:ns uri="http://niem.gov/niem/domains/screening/2.1" prefix="scr"/>
   <sch:let name="allLetters" value="&#34;^(\p{L}|\s|'|\-|\.)+$&#34;"/>
   <sch:let name="threedigits" value="&#34;^(\d){3}$&#34;"/>
   <sch:let name="threechars" value="&#34;^([A-Z]){3}$&#34;"/>
   <sch:let name="ApplicantPersonID"
            value="/exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/hix-core:RoleOfPersonReference/@s:ref"/>
   <sch:let name="ContactPersonID"
            value="/exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:SSFPrimaryContact/hix-core:RoleOfPersonReference/@s:ref"/>
   <sch:let name="RepresentativePerson"
            value="/exch:AccountTransferRequest/hix-ee:AuthorizedRepresentative/hix-core:RolePlayedByPerson"/>
   <sch:let name="HouseholdPersonIDs"
            value="/exch:AccountTransferRequest/ext:PhysicalHousehold/hix-ee:HouseholdMemberReference/@s:ref"/>
   <sch:let name="is-inbound"
            value="/exch:AccountTransferRequest/ext:TransferHeader/ext:TransferActivity/ext:RecipientTransferActivityCode='Exchange'"/>
   <sch:let name="is-inbound-not-OBR"
            value="(/exch:AccountTransferRequest/ext:TransferHeader/ext:TransferActivity/ext:RecipientTransferActivityCode='Exchange') and (not(substring(/exch:AccountTransferRequest/ext:TransferHeader/ext:TransferActivity/nc:ActivityIdentification/nc:IdentificationID,1,3)='FFM'))"/>
   <sch:let name="ExchangeEligibilityIDs"
            value="//hix-ee:ExchangeEligibility/@s:id"/>
   <sch:pattern id="all-rules">
      <sch:rule context="*[@xsi:nil = true()]">
         <sch:assert test="$is-inbound">
            The xsi:nil attribute (on <sch:name/>) is not allowed for outbound transactions.
         </sch:assert>
      </sch:rule>
      <sch:rule context="exch:AccountTransferRequest">
         <sch:let name="quantity"
                  value="ext:TransferHeader/ext:TransferActivity/ext:TransferActivityReferralQuantity"/>
         <sch:assert test="($quantity &gt; 0)">
            The value of ext:TransferActivityReferralQuantity must be greater than 0.
            [exch:AccountTransferRequest/ext:TransferHeader/ext:TransferActivity/ext:TransferActivityReferralQuantity].  
         </sch:assert>
         <sch:assert test="$quantity = count(hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/hix-ee:ReferralActivity)">
            The value of ext:TransferActivityReferralQuantity must equal the number of hix-ee:ReferralActivity elements in the payload.
            [exch:AccountTransferRequest/ext:TransferHeader/ext:TransferActivity/ext:TransferActivityReferralQuantity].  
         </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:InsuranceApplication">
         <sch:assert test="hix-ee:SSFSigner/hix-ee:Signature/hix-core:SignatureDate">
                hix-core:SignatureDate is required
                [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:SSFSigner/hix-ee:Signature/hix-core:SignatureDate].  
                </sch:assert>
         <sch:assert test="hix-core:ApplicationSubmission[@xsi:nil=true() or nc:ActivityDate]">
            hix-core:ApplicationSubmission is required (and it must be nilled or contain an nc:ActivityDate) [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-core:ApplicationSubmission/nc:ActivityDate].  
            </sch:assert>
         <sch:assert test="hix-core:ApplicationCreation[@xsi:nil=true() or nc:ActivityDate]">
            hix-core:ApplicationCreation is required (and it must be nilled or contain an nc:ActivityDate)                [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-core:ApplicationCreation/nc:ActivityDate].  
         </sch:assert>
         <sch:assert test="hix-ee:SSFSigner/hix-ee:SSFAttestation">
                hix-ee:SSFAttestation is required in hix-ee:SSFSigner [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:SSFSigner/hix-ee:SSFAttestation].  
            </sch:assert>
         <sch:assert test="not(hix-ee:InsuranceApplicationTaxReturnAccessIndicator[not(@xsi:nil=true())] = true()) or hix-ee:InsuranceApplicationCoverageRenewalYearQuantity">
                hix-ee:InsuranceApplicationCoverageRenewalYearQuantity is required in hix-ee:InsuranceApplication if hix-ee:InsuranceApplicationTaxReturnAccessIndicator is true [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicationCoverageRenewalYearQuantity].  
                </sch:assert>
         <sch:assert test="not(count(hix-core:ApplicationIdentification) = 2) or (hix-core:ApplicationIdentification[1]/nc:IdentificationCategoryText != hix-core:ApplicationIdentification[2]/nc:IdentificationCategoryText)">
            When two hix-core:ApplicationIdentification elements are present, they must both have values for nc:IdentificationCategoryText and they must be different (to distinguish Application ID from State Application ID) [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-core:ApplicationIdentification].  
         </sch:assert>
      </sch:rule>
      <sch:rule context="ext:TransferActivity">
         <sch:assert test="nc:ActivityIdentification/nc:IdentificationID">
                nc:ActivityIdentification/nc:IdentificationID is required
                [exch:AccountTransferRequest/ext:TransferHeader/ext:TransferActivity/nc:ActivityIdentification/nc:IdentificationID].  
                </sch:assert>
         <sch:assert test="nc:ActivityDate/nc:DateTime">
                nc:ActivityDate/nc:DateTime is required
                [exch:AccountTransferRequest/ext:TransferHeader/ext:TransferActivity/nc:ActivityDate/nc:DateTime].  
                </sch:assert>
         <sch:assert test="ext:RecipientTransferActivityCode = 'Exchange' or ext:RecipientTransferActivityStateCode">
                ext:RecipientTransferActivityStateCode is required if ext:RecipientTransferActivityCode is not "Exchange" [exch:AccountTransferRequest/ext:TransferHeader/ext:TransferActivity/ext:RecipientTransferActivityStateCode].  
                    </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:ReferralActivity">
         <sch:assert test="nc:ActivityIdentification">
            nc:ActivityIdentification is required in hix-ee:ReferralActivity [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/hix-ee:ReferralActivity/nc:ActivityIdentification].  
            </sch:assert>
         <sch:assert test="nc:ActivityDate/nc:DateTime">
                nc:ActivityDate/nc:DateTime is required in hix-ee:ReferralActivity [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/hix-ee:ReferralActivity/nc:ActivityDate/nc:DateTime].  
                </sch:assert>
         <sch:assert test="hix-ee:ReferralActivityStatus/hix-ee:ReferralActivityStatusCode">
            hix-ee:ReferralActivityStatus/hix-ee:ReferralActivityStatusCode is required in hix-ee:ReferralActivity [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/hix-ee:ReferralActivity/hix-ee:ReferralActivityStatus/hix-ee:ReferralActivityStatusCode].  
                </sch:assert>
         <sch:assert test="not($is-inbound) or not(hix-ee:ReferralActivityStatus/hix-ee:ReferralActivityStatusCode = 'Initiated') or hix-ee:ReferralActivityEligibilityReasonReference">
            hix-ee:ReferralActivityEligibilityReasonReference is required in hix-ee:ReferralActivity if the hix-ee:ReferralActivityStatusCode is "Initiated" and the transfer is sent from the state to the FFE. [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/hix-ee:ReferralActivity/hix-ee:ReferralActivityEligibilityReasonReference].  
            </sch:assert>
         <sch:assert test="not($is-inbound) or not(hix-ee:ReferralActivityStatus/hix-ee:ReferralActivityStatusCode = 'Initiated') or not(hix-ee:ReferralActivityEligibilityReasonReference[not(@s:ref = $ExchangeEligibilityIDs)])">Every hix-ee:ReferralActivityEligibilityReasonReference must refer to an ExchangeEligibility element if the hix-ee:ReferralActivityStatusCode is "Initiated" and the transfer is sent from the state to the FFE.
            </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:Sender">
         <sch:assert test="hix-core:InformationExchangeSystemCategoryCode">
                hix-core:InformationExchangeSystemCategoryCode is required in hix-core:Sender [exch:AccountTransferRequest/hix-core:Sender/hix-core:InformationExchangeSystemCategoryCode].  
                </sch:assert>
         <sch:assert test="hix-core:InformationExchangeSystemCategoryCode = 'Exchange' or hix-core:InformationExchangeSystemStateCode">
                hix-core:InformationExchangeSystemStateCode is required in hix-core:Sender if hix-core:InformationExchangeSystemCategoryCode is not "Exchange". [exch:AccountTransferRequest/hix-core:Sender/hix-core:InformationExchangeSystemStateCode].  
                </sch:assert>
         <sch:assert test="not($is-inbound) or hix-core:InformationExchangeSystemStateCode">
            hix-core:InformationExchangeSystemStateCode is required in hix-core:Sender if ext:RecipientTransferActivityCode is "Exchange". [exch:AccountTransferRequest/hix-core:Sender/hix-core:InformationExchangeSystemStateCode].  
            </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:Receiver">
         <sch:assert test="hix-core:InformationExchangeSystemCategoryCode">
                hix-core:InformationExchangeSystemCategoryCode is required in hix-core:Receiver [exch:AccountTransferRequest/hix-core:Receiver/hix-core:InformationExchangeSystemCategoryCode].  
                </sch:assert>
         <sch:assert test="hix-core:InformationExchangeSystemCategoryCode = 'Exchange' or hix-core:InformationExchangeSystemStateCode">
                hix-core:InformationExchangeSystemStateCode is required in hix-core:Receiver if hix-core:InformationExchangeSystemCategoryCode is not "Exchange" [exch:AccountTransferRequest/hix-core:Receiver/hix-core:InformationExchangeSystemStateCode].  
            </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:SSFSignerAuthorizedRepresentativeAssociation">
         <sch:assert test="hix-ee:Signature/hix-core:SignatureDate">
                hix-core:SignatureDate is required for the authorized representative [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:SSFSigner/hix-ee:SSFSignerAuthorizedRepresentativeAssociation/hix-ee:Signature/hix-core:SignatureDate].  
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:AuthorizedRepresentative">
         <sch:assert test="hix-core:RolePlayedByPerson/nc:PersonName/nc:PersonSurName">
                nc:PersonSurName is required for the authorized representative [exch:AccountTransferRequest/hix-ee:AuthorizedRepresentative/hix-core:RolePlayedByPerson/nc:PersonName/nc:PersonSurName].  
            </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:InsuranceApplicationAssisterAssociation">
         <sch:assert test="nc:AssociationBeginDate">
                nc:AssociationBeginDate is required in hix-ee:InsuranceApplicationAssisterAssociation [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicationAssisterAssociation/nc:AssociationBeginDate].  
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:Assister">
         <sch:assert test="hix-core:RolePlayedByPerson/nc:PersonName/nc:PersonSurName">
                nc:PersonSurName is required for the assister [exch:AccountTransferRequest/hix-ee:Assister/hix-core:RolePlayedByPerson/nc:PersonName/nc:PersonSurName].  
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:SSFAttestation">
         <sch:assert test="not(//hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/hix-ee:MedicaidMAGIEligibility/hix-ee:EligibilityIndicator = true()) or hix-ee:SSFAttestationMedicaidObligationsIndicator">
                hix-ee:SSFAttestationMedicaidObligationsIndicator is required if MedicaidMAGIEligibility/hix-ee:EligibilityIndicator is true [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:SSFSigner/hix-ee:SSFAttestation/hix-ee:SSFAttestationMedicaidObligationsIndicator].  
                </sch:assert>
         <sch:assert test="not(//hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/hix-ee:InsuranceApplicantAbsentParentOrSpouseCode = 'Yes') or not(//hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/hix-ee:MedicaidMAGIEligibility/hix-ee:EligibilityIndicator = true()) or hix-ee:SSFAttestationCollectionsAgreementIndicator">
                hix-ee:SSFAttestationCollectionsAgreementIndicator is required in hix-ee:SSFAttestation if InsuranceApplicantAbsentParentOrSpouseCode equals 'Yes' and MedicaidMAGIEligibility/hix-ee:EligibilityIndicator is true [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:SSFSigner/hix-ee:SSFAttestation/hix-ee:SSFAttestationCollectionsAgreementIndicator].  
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:InsuranceApplicant">
         <sch:let name="ThisApplicantPersonID"
                  value="hix-core:RoleOfPersonReference/@s:ref"/>
         <sch:let name="ThisApplicantPerson"
                  value="/exch:AccountTransferRequest/hix-core:Person[@s:id = $ThisApplicantPersonID]"/>
         <sch:assert test="hix-ee:InsuranceApplicantFixedAddressIndicator">
                hix-ee:InsuranceApplicantFixedAddressIndicator is required in hix-ee:InsuranceApplicant [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/hix-ee:InsuranceApplicantFixedAddressIndicator].  
                </sch:assert>
         <sch:assert test="not($ThisApplicantPerson/nc:PersonUSCitizenIndicator[not(@xsi:nil=true())] = false()) or hix-ee:InsuranceApplicantLawfulPresenceStatus/hix-ee:LawfulPresenceStatusEligibility[@xsi:nil=true() or hix-ee:EligibilityIndicator]">
            hix-ee:LawfulPresenceStatusEligibility is required (and it must be nilled or contain hix-ee:EligibilityIndicator) if nc:PersonUSCitizenIndicator = false [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/hix-ee:InsuranceApplicantLawfulPresenceStatus/hix-ee:LawfulPresenceStatusEligibility].  
                </sch:assert>
         <sch:assert test="not(hix-ee:CHIPEligibility/hix-ee:EligibilityIndicator = false() and hix-ee:MedicaidMAGIEligibility/hix-ee:EligibilityIndicator = false()) or hix-ee:InsuranceApplicantNonESICoverageIndicator">
                hix-ee:InsuranceApplicantNonESICoverageIndicator is required if Applicant CHIP Eligible Status Indicator = N and Applicant Medicaid Eligible Status Indicator = N            [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/hix-ee:InsuranceApplicantNonESICoverageIndicator]
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:Person">
         <sch:let name="is-contact" value="@s:id=$ContactPersonID"/>
         <sch:let name="is-applicant" value="@s:id=$ApplicantPersonID"/>
         <sch:let name="is-household" value="@s:id=$HouseholdPersonIDs"/>
         <sch:let name="id" value="@s:id"/>
         <sch:let name="ThisInsuranceApplicant"
                  value="/exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant[hix-core:RoleOfPersonReference/@s:ref = $id]"/>
         <sch:let name="ThisPrimaryContact"
                  value="/exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:SSFPrimaryContact[hix-core:RoleOfPersonReference/@s:ref = $id]"/>
         <sch:assert test="(not($is-household) and not($is-contact) and not($is-applicant)) or nc:PersonName/nc:PersonGivenName[not(@xsi:nil=true())]">
                nc:PersonGivenName is required for the applicant and primary contact person [exch:AccountTransferRequest/hix-core:Person/nc:PersonName/nc:PersonGivenName].  
            </sch:assert>
         <sch:assert test="(not($is-household) and not($is-contact) and not($is-applicant)) or nc:PersonName/nc:PersonSurName[not(@xsi:nil=true())]">
                nc:PersonSurName is required (and non-nillable) for the applicant [exch:AccountTransferRequest/hix-core:Person/nc:PersonName/nc:PersonSurName].  
                </sch:assert>
         <sch:assert test="not($ThisPrimaryContact/hix-ee:SSFPrimaryContactPreferenceCode='Email') or hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation/hix-core:ContactInformation/nc:ContactEmailID">
                nc:ContactEmailID is required if the person is a primary contact whose contact preference is Email. [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation/hix-core:ContactInformation/nc:ContactEmailID].  
                </sch:assert>
         <sch:assert test="(not($is-household) and not($is-applicant)) or nc:PersonBirthDate">
                nc:PersonBirthDate is required for the applicant [exch:AccountTransferRequest/hix-core:Person/nc:PersonBirthDate].  
                </sch:assert>
         <sch:assert test="not($is-applicant) or nc:PersonSexText">
                nc:PersonSexText is required for the applicant [exch:AccountTransferRequest/hix-core:Person/nc:PersonSexText].  
                </sch:assert>
         <sch:let name="contact-info"
                  value="hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation[hix-core:ContactInformationCategoryCode = ('Home','Mailing')]/hix-core:ContactInformation"/>
         <sch:let name="PersonAddress"
                  value="$contact-info/nc:ContactMailingAddress/nc:StructuredAddress"/>
         <sch:let name="PersonHomeAddress"
                  value="hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation[hix-core:ContactInformationCategoryCode='Home']/hix-core:ContactInformation/nc:ContactMailingAddress/nc:StructuredAddress"/>
         <sch:let name="PersonOtherAddressTypes"
                  value="hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation[exists(hix-core:ContactInformation/nc:ContactMailingAddress)]/hix-core:ContactInformationCategoryCode"/>
         <sch:assert test="not($is-applicant) or not($ThisInsuranceApplicant/hix-ee:InsuranceApplicantFixedAddressIndicator[not(@xsi:nil=true())] = true()) or $PersonHomeAddress">
                A home address is required for the applicant if hix-ee:InsuranceApplicantFixedAddressIndicator is true [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation[hix-core:ContactInformationCategoryCode='Home']/hix-core:ContactInformation/nc:ContactMailingAddress/nc:StructuredAddress].  
            </sch:assert>
         <sch:assert test="not($is-applicant) or count($PersonAddress)&gt; 0">
                An address (either home or mailing) is required for the applicant [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation/hix-core:ContactInformation/nc:ContactMailingAddress/nc:StructuredAddress].  
            </sch:assert>
         <sch:assert test="not($is-contact) or count($PersonAddress)&gt; 0">
            An address (either home or mailing) is required for the Primary Contact [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation/hix-core:ContactInformation/nc:ContactMailingAddress/nc:StructuredAddress].  
            </sch:assert>
         <sch:assert test="not($is-contact) or count($PersonHomeAddress) &lt; 2">
            No more than one home address is allowed for the Primary Contact [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation[hix-core:ContactInformationCategoryCode='Home']/hix-core:ContactInformation/nc:ContactMailingAddress/nc:StructuredAddress].  
            </sch:assert>
         <sch:assert test="not($is-contact) or count($PersonOtherAddressTypes[.='Mailing']) &lt; 2">
            No more than one Mailing address is allowed for the Primary Contact [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation[hix-core:ContactInformationCategoryCode='Mailing']/hix-core:ContactInformation/nc:ContactMailingAddress/nc:StructuredAddress].  
         </sch:assert>
         <sch:assert test="not($is-contact) or count($PersonOtherAddressTypes[.='Residency']) &lt; 2">
            No more than one Residency address is allowed for the Primary Contact [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation[hix-core:ContactInformationCategoryCode='Residency']/hix-core:ContactInformation/nc:ContactMailingAddress/nc:StructuredAddress].  
         </sch:assert>
         <sch:assert test="not($is-applicant) or not($ThisInsuranceApplicant/hix-ee:InsuranceApplicantFixedAddressIndicator[not(@xsi:nil=true())] = true()) or $PersonHomeAddress/nc:LocationStreet[@xsi:nil=true() or nc:StreetFullText]">
            nc:LocationStreet is required for the applicant (and it must be nilled or contain nc:StreetFullText) if hix-ee:InsuranceApplicantFixedAddressIndicator is true [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation/hix-core:ContactInformation/nc:ContactMailingAddress/nc:StructuredAddress/nc:LocationStreet].  
            </sch:assert>
         <sch:assert test="not($is-applicant) or not($ThisInsuranceApplicant/hix-ee:InsuranceApplicantFixedAddressIndicator[not(@xsi:nil=true())] = true()) or $PersonHomeAddress/nc:LocationCityName">
            nc:LocationCityName is required for the applicant if hix-ee:InsuranceApplicantFixedAddressIndicator is true [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation/hix-core:ContactInformation/nc:ContactMailingAddress/nc:StructuredAddress/nc:LocationCityName].  
            </sch:assert>
         <sch:assert test="not($is-applicant) or not($ThisInsuranceApplicant/hix-ee:InsuranceApplicantFixedAddressIndicator[not(@xsi:nil=true())] = true()) or $PersonHomeAddress/nc:LocationStateUSPostalServiceCode">
            nc:LocationStateUSPostalServiceCode is required for the applicant if hix-ee:InsuranceApplicantFixedAddressIndicator is true [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation/hix-core:ContactInformation/nc:ContactMailingAddress/nc:StructuredAddress/nc:LocationStateUSPostalServiceCode].  
            </sch:assert>
         <sch:assert test="not($is-applicant) or not($ThisInsuranceApplicant/hix-ee:InsuranceApplicantFixedAddressIndicator[not(@xsi:nil=true())] = true()) or $PersonHomeAddress/nc:LocationPostalCode">
            nc:LocationPostalCode is required for the applicant if hix-ee:InsuranceApplicantFixedAddressIndicator is true [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation/hix-core:ContactInformation/nc:ContactMailingAddress/nc:StructuredAddress/nc:LocationPostalCode].  
            </sch:assert>
         <sch:assert test="not($is-applicant) or nc:PersonUSCitizenIndicator">
                nc:PersonUSCitizenIndicator is required for the applicant [exch:AccountTransferRequest/hix-core:Person/nc:PersonUSCitizenIndicator].  
            </sch:assert>
         <sch:let name="TaxHousehold"
                  value="/exch:AccountTransferRequest/hix-ee:TaxReturn/hix-ee:TaxHousehold[hix-ee:TaxDependent/hix-core:RoleOfPersonReference/@s:ref= $id]"/>
         <sch:let name="PrimaryTaxFilers"
                  value="$TaxHousehold/hix-ee:PrimaryTaxFiler/hix-core:RoleOfPersonReference/@s:ref"/>
         <sch:let name="RelToTaxFiler"
                  value="hix-core:PersonAugmentation/hix-core:PersonAssociation[nc:PersonReference/@s:ref = $PrimaryTaxFilers]"/>
         <sch:assert test="not($is-applicant) or not($TaxHousehold) or $RelToTaxFiler/hix-core:FamilyRelationshipCode">
                hix-core:FamilyRelationshipCode is required in the association from an applicant to a primary tax filer if the applicant is a tax dependent [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonAssociation/hix-core:FamilyRelationshipCode].  
                </sch:assert>
         <sch:assert test="not($is-applicant) or hix-core:TribalAugmentation/hix-core:PersonAmericanIndianOrAlaskaNativeIndicator">
                hix-core:PersonAmericanIndianOrAlaskaNativeIndicator is required in hix-core:TribalAugmentation [exch:AccountTransferRequest/hix-core:Person/hix-core:TribalAugmentation/hix-core:PersonAmericanIndianOrAlaskaNativeIndicator].  
                </sch:assert>
         <sch:let name="iswages"
                  value="exists(hix-core:PersonAugmentation/hix-core:PersonIncome[hix-core:IncomeCategoryCode='Wages'])"/>
         <sch:let name="Employer"
                  value="hix-core:PersonAugmentation/hix-core:PersonEmploymentAssociation/hix-core:Employer"/>
         <sch:assert test="not($is-contact) or hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation/hix-core:ContactInformationCategoryCode[not(@xsi:nil=true())]">
            hix-core:ContactInformationCategoryCode is required (and cannot be nilled) for the primary contact person [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation/hix-core:ContactInformationCategoryCode].  
            </sch:assert>
         <sch:assert test="not($is-contact) or count($PersonAddress/nc:LocationStreet/nc:StreetFullText[not(@xsi:nil=true())])=count($PersonAddress)">
            nc:LocationStreet/nc:StreetFullText is required (and cannot be nilled) in the home and/or mailing address of the primary contact person [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation/hix-core:ContactInformation/nc:ContactMailingAddress/nc:StructuredAddress/nc:LocationStreet/nc:StreetFullText].  
            </sch:assert>
         <sch:assert test="not($is-contact) or count($PersonAddress/nc:LocationCityName[not(@xsi:nil=true())])=count($PersonAddress)">
            nc:LocationCityName is required (and cannot be nilled) in the home and/or mailing address of the primary contact person [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation/hix-core:ContactInformation/nc:ContactMailingAddress/nc:StructuredAddress/nc:LocationCityName].  
                </sch:assert>
         <sch:assert test="not($is-contact) or count($PersonAddress[nc:LocationCountryISO3166Alpha3Code = 'USA' or not(nc:LocationCountryISO3166Alpha3Code)][nc:LocationStateUSPostalServiceCode[not(@xsi:nil=true())]])=count($PersonAddress[nc:LocationCountryISO3166Alpha3Code = 'USA' or not(nc:LocationCountryISO3166Alpha3Code)])">
            nc:LocationStateUSPostalServiceCode is required (and cannot be nilled) in the home and/or mailing address of the primary contact person if the country code is USA or if country code is absent [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation/hix-core:ContactInformation/nc:ContactMailingAddress/nc:StructuredAddress/nc:LocationStateUSPostalServiceCode].  
            </sch:assert>
         <sch:assert test="not($is-contact) or count($PersonAddress[(nc:LocationCountryISO3166Alpha3Code = 'USA') or not(nc:LocationCountryISO3166Alpha3Code)][nc:LocationPostalCode[not(@xsi:nil=true())]]) = count($PersonAddress[(nc:LocationCountryISO3166Alpha3Code = 'USA') or not(nc:LocationCountryISO3166Alpha3Code)])">
            nc:LocationPostalCode is required (and cannot be nilled) in the home and/or mailing address of the primary contact person if the country code is USA or if country code is absent [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation/hix-core:ContactInformation/nc:ContactMailingAddress/nc:StructuredAddress/nc:LocationPostalCode].  
            </sch:assert>
         <sch:assert test="not($is-contact) or not( hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation[hix-core:ContactInformation/nc:ContactTelephoneNumber][not(nc:ContactInformationIsPrimaryIndicator)])">
                    nc:ContactInformationIsPrimaryIndicator is required in hix-core:PersonContactInformationAssociation when it is a telephone number group of the primary contact person [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation/nc:ContactInformationIsPrimaryIndicator].  
            </sch:assert>
         <sch:assert test="not($ThisPrimaryContact/hix-ee:SSFPrimaryContactPreferenceCode='TextMessage') or  hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation/hix-core:ContactInformation/nc:ContactTelephoneNumber">
            nc:ContactTelephoneNumber is required for the primary contact person if the Contact Preference Code is TextMessage [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation/hix-core:ContactInformation/nc:ContactTelephoneNumber].  
            </sch:assert>
         <sch:assert test="(not($is-household) and not($is-contact)) or not($is-inbound) or hix-core:PersonAugmentation/hix-core:PersonMedicaidIdentification or hix-core:PersonAugmentation/hix-core:PersonCHIPIdentification">
                hix-core:PersonMedicaidIdentification or hix-core:PersonCHIPIdentification is required if sent from state to FFE [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/(hix-core:PersonMedicaidIdentification|hix-core:PersonCHIPIdentification)].                 </sch:assert>
         <sch:assert test="not($is-household) or not($is-applicant) or hix-core:PersonAugmentation/hix-core:PersonMarriedIndicator">
            nc:PersonMarriedIndicator is required for a Household Member if they are also an Applicant [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonMarriedIndicator].  
                </sch:assert>
         <sch:let name="age"
                  value="if (nc:PersonBirthDate/nc:Date) then (days-from-duration(current-date() - xs:date(nc:PersonBirthDate/nc:Date)) div 365) else ()"/>
         <sch:assert test="not($is-household) or not($age) or ($age &lt; 9) or ($age &gt; 66) or not(nc:PersonSexText='Female') or hix-core:PersonAugmentation/hix-core:PersonPregnancyStatus[@xsi:nil=true() or hix-core:StatusIndicator]">
                hix-core:PersonPregnancyStatus is required (and it must be nilled or contain hix-core:StatusIndicator) if a household member is between the ages of 9 and 66 and female [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonPregnancyStatus].  
            </sch:assert>
         <sch:assert test="not($is-household) or not(nc:PersonSexText='Male' and hix-core:PersonAugmentation/hix-core:PersonPregnancyStatus/hix-core:StatusIndicator = true())">
                The hix-core:PersonPregnancyStatus/hix-core:StatusIndicator cannot be true if the household member is male. [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonPregnancyStatus/hix-core:StatusIndicator].  
                </sch:assert>
         <sch:let name="primaryContactCount"
                  value="count(hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation/nc:ContactInformationIsPrimaryIndicator[not(@xsi:nil=true())][. = true()])"/>
         <sch:assert test="$primaryContactCount &lt;= 1">
                A Person can only have a single "ContactInformationIsPrimaryIndicator" whose value of 'true' [<value-of select="$primaryContactCount"/>].
         </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:LawfulPresenceStatusImmigrationDocument">
         <sch:assert test="not(hix-ee:LawfulPresenceDocumentCategoryCode = 'UnexpiredForeignPassport') or hix-ee:LawfulPresenceDocumentPersonIdentification[@xsi:nil=true() or nc:IdentificationJurisdictionISO3166Alpha3Code]">
                nc:IdentificationJurisdictionISO3166Alpha3Code is required in hix-ee:LawfulPresenceDocumentPersonIdentification if the document type is UnexpiredForeignPassport [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/hix-ee:InsuranceApplicantLawfulPresenceStatus/hix-ee:LawfulPresenceStatusImmigrationDocument/hix-ee:LawfulPresenceDocumentPersonIdentification/nc:IdentificationJurisdictionISO3166Alpha3Code].  
                </sch:assert>
         <sch:assert test="not(hix-ee:LawfulPresenceDocumentNumber/nc:IdentificationID) or  hix-ee:LawfulPresenceDocumentPersonIdentification">
                hix-ee:LawfulPresenceDocumentPersonIdentification is required if the document number is present [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/hix-ee:InsuranceApplicantLawfulPresenceStatus/hix-ee:LawfulPresenceStatusImmigrationDocument/hix-ee:LawfulPresenceDocumentPersonIdentification].  
                </sch:assert>
         <sch:assert test="not(hix-ee:LawfulPresenceDocumentNumber/nc:IdentificationID) or hix-ee:LawfulPresenceDocumentPersonIdentification[@xsi:nil=true() or nc:IdentificationCategoryText]">
                hix-ee:LawfulPresenceDocumentPersonIdentification/nc:IdentificationCategoryText is required if the document number is present [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/hix-ee:InsuranceApplicantLawfulPresenceStatus/hix-ee:LawfulPresenceStatusImmigrationDocument/hix-ee:LawfulPresenceDocumentPersonIdentification/nc:IdentificationCategoryText].  
                </sch:assert>
      </sch:rule>
      <sch:rule context="ext:PhysicalHousehold">
         <sch:assert test="hix-ee:HouseholdMemberReference">
                At least one reference hix-ee:HouseholdMemberReference is required in ext:PhysicalHousehold
                [exch:AccountTransferRequest/ext:PhysicalHousehold/hix-ee:HouseholdMemberReference].
            </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:PersonIncome">
         <sch:let name="is-pay-period" value="exists(hix-core:IncomeDate/nc:Date)"/>
         <sch:let name="is-SSA-verified"
                  value=".//@s:metadata = /exch:AccountTransferRequest/hix-core:VerificationMetadata[hix-core:VerificationAuthorityTDS-FEPS-AlphaCode = 'SSA']/@s:id"/>
         <sch:let name="is-current"
                  value="not(hix-core:IncomeDate) and not($is-SSA-verified)"/>
         <sch:assert test="not($is-current) or not(hix-core:IncomeAmount[not(@xsi:nil=true())] &gt; 0) or hix-core:IncomeCategoryCode">
            hix-core:IncomeCategoryCode is required if hix-core:IncomeAmount is not null for payment information [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonIncome/hix-core:IncomeCategoryCode].  
                 </sch:assert>
         <sch:assert test="not($is-current) or not(hix-core:IncomeAmount[not(@xsi:nil=true())] &gt; 0) or  hix-core:IncomeFrequency">
            hix-core:IncomeFrequency is required if hix-core:IncomeAmount is not null for payment information [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonIncome/hix-core:IncomeFrequency].  
                 </sch:assert>
         <sch:assert test="not($is-current) or not(hix-core:IncomeCategoryCode = 'Wages') or hix-core:IncomeFrequency">
            hix-core:IncomeFrequency is required if hix-core:IncomeCategoryCode is Wages for payment information [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonIncome/hix-core:IncomeFrequency].  
            </sch:assert>
         <sch:assert test="not($is-current) or not(hix-core:IncomeCategoryCode = 'Wages') or hix-core:IncomeAmount">
            hix-core:IncomeAmount is required if hix-core:IncomeCategoryCode is Wages for payment information [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonIncome/hix-core:IncomeAmount].  
            </sch:assert>
         <sch:assert test="not($is-current) or not(hix-core:IncomeCategoryCode = 'Wages') or hix-core:IncomeFrequency">
            hix-core:IncomeFrequency is required if hix-core:IncomeCategoryCode is Wages for payment information [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonIncome/hix-core:IncomeFrequency].  
            </sch:assert>
         <sch:assert test="not($is-current) or not(hix-core:IncomeCategoryCode = 'Wages') or not(hix-core:IncomeFrequency/hix-core:FrequencyCode = 'Hourly') or hix-core:IncomeHoursPerWeekMeasure">
            hix-core:IncomeHoursPerWeekMeasure is required in hix-core:PersonIncome if hix-core:IncomeCategoryCode is Wages and income frequency type name is hourly for payment information [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonIncome/hix-core:IncomeHoursPerWeekMeasure].  
                </sch:assert>
         <sch:assert test="not($is-current) or not(hix-core:IncomeCategoryCode = 'Wages') or not(hix-core:IncomeFrequency/hix-core:FrequencyCode = 'Daily') or hix-core:IncomeDaysPerWeekMeasure">
            hix-core:IncomeDaysPerWeekMeasure is required in hix-core:PersonIncome if hix-core:IncomeCategoryCode is Wages and hix-core:IncomeFrequency/hix-core:FrequencyCode is 'Daily' for payment information [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonIncome/hix-core:IncomeDaysPerWeekMeasure].  
                </sch:assert>
         <sch:assert test="not($is-pay-period) or hix-core:IncomeHoursPerPayPeriodMeasure">
            hix-core:IncomeHoursPerPayPeriodMeasure is required for Pay Period Information (i.e. PersonIncome elements that contain a hix-core:IncomeDate/nc:Date [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonIncome/hix-core:IncomeHoursPerPayPeriodMeasure].  
                </sch:assert>
         <sch:assert test="not($is-current) or not(hix-core:IncomeCategoryCode ='SelfEmployment') or hix-core:IncomeEmploymentDescriptionText">
            hix-core:IncomeEmploymentDescriptionText is required if hix-core:IncomeCategoryCode is SelfEmployment for payment information [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonIncome/hix-core:IncomeEmploymentDescriptionText].  
                </sch:assert>
         <sch:assert test="not($is-current) or not(hix-core:IncomeCategoryCode ='Unemployment') or hix-core:IncomeUnemploymentSourceText">
            hix-core:IncomeUnemploymentSourceText is required if hix-core:IncomeCategoryCode is Unemployment for payment information [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonIncome/hix-core:IncomeEmploymentDescriptionText].  
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:PersonExpense">
         <sch:assert test="not(hix-core:ExpenseAmount &gt; 0) or hix-core:ExpenseFrequency">
            hix-core:ExpenseFrequency is required if hix-core:ExpenseAmount is not null [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonExpense/hix-core:ExpenseFrequency].
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:VerificationMetadata">
         <sch:assert test="hix-core:VerificationRequestingSystem/hix-core:InformationExchangeSystemCategoryCode">
                hix-core:InformationExchangeSystemCategoryCode is required in hix-core:VerificationRequestingSystem [exch:AccountTransferRequest/hix-core:VerificationMetadata/hix-core:VerificationRequestingSystem/hix-core:InformationExchangeSystemCategoryCode].  
                </sch:assert>
         <sch:assert test="hix-core:VerificationRequestingSystem/hix-core:InformationExchangeSystemCategoryCode = 'Exchange' or hix-core:VerificationRequestingSystem/hix-core:InformationExchangeSystemStateCode">
                hix-core:InformationExchangeSystemStateCode is required in hix-core:VerificationRequestingSystem if hix-core:InformationExchangeSystemCategoryCode is not Exchange [exch:AccountTransferRequest/hix-core:VerificationMetadata/hix-core:VerificationRequestingSystem/hix-core:InformationExchangeSystemStateCode].  
                </sch:assert>
         <sch:assert test="(hix-core:DHS-SAVEVerificationCode|hix-core:DHS-G845VerificationCode) or not(hix-core:VerificationAuthorityTDS-FEPS-AlphaCode='DHS')">
            hix-core:DHS-SAVEVerificationCode or hix-core:DHS-G845VerificationCode is required in hix-core:VerificationMetadata if hix-core:VerificationAuthorityTDS-FEPS-AlphaCode is DHS  [exch:AccountTransferRequest/hix-core:VerificationMetadata/(hix-core:DHS-SAVEVerificationCode|hix-core:DHS-G845VerificationCode)].  
                </sch:assert>
         <sch:assert test="not(hix-core:DHS-SAVEVerificationCode|hix-core:DHS-G845VerificationCode) or hix-core:VerificationAuthorityTDS-FEPS-AlphaCode='DHS'">
            hix-core:VerificationAuthorityTDS-FEPS-AlphaCode in hix-core:VerificationMetadata must be DHS if hix-core:DHS-SAVEVerificationCode or hix-core:DHS-G845VerificationCode is present  [exch:AccountTransferRequest/hix-core:VerificationMetadata/hix-core:VerificationAuthorityTDS-FEPS-AlphaCode].  
            </sch:assert>
         <sch:assert test="hix-core:VerificationIndicator or not(hix-core:VerificationAuthorityTDS-FEPS-AlphaCode='SSA')">
         hix-core:VerificationIndicator is required in hix-core:VerificationMetadata if hix-core:VerificationAuthorityTDS-FEPS-AlphaCode is SSA  [exch:AccountTransferRequest/hix-core:VerificationMetadata/hix-core:VerificationIndicator].  
         </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:RefugeeMedicalAssistanceEligibility|hix-ee:EmergencyMedicaidEligibility|hix-ee:CHIPEligibility|hix-ee:CSREligibility|hix-ee:APTCEligibility|hix-ee:MedicaidNonMAGIEligibility|hix-ee:MedicaidMAGIEligibility|hix-ee:ExchangeEligibility">
         <sch:assert test="not(hix-ee:EligibilityEstablishingSystem) or  hix-ee:EligibilityEstablishingSystem/hix-core:InformationExchangeSystemCategoryCode = 'Exchange' or hix-ee:EligibilityEstablishingSystem/hix-core:InformationExchangeSystemStateCode">
                hix-core:InformationExchangeSystemStateCode is required in hix-ee:EligibilityEstablishingSystem if hix-core:InformationExchangeSystemCategoryCode is not Exchange [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/<sch:name/>/hix-ee:EligibilityEstablishingSystem/hix-core:InformationExchangeSystemStateCode].  
            </sch:assert>
         <sch:assert test="not(hix-ee:EligibilityIndicator = true()) or  hix-ee:EligibilityDateRange/nc:StartDate">
            hix-ee:EligibilityDateRange/nc:StartDate is required if hix-ee:EligibilityIndicator is true [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/<sch:name/>/hix-ee:EligibilityDateRange/nc:StartDate].  
            </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:CHIPMedicaidResidencyEligibilityBasis|hix-ee:EmergencyMedicaidResidencyEligibilityBasis|hix-ee:ExchangeQHPResidencyEligibilityBasis|hix-ee:MedicaidMAGIResidencyEligibilityBasis|hix-ee:CHIPIncomeEligibilityBasis|hix-ee:EmergencyMedicaidIncomeEligibilityBasis|hix-ee:MedicaidMAGIIncomeEligibilityBasis|hix-ee:HouseholdSizeEligibilityBasis|hix-ee:CHIPMedicaidCitizenOrImmigrantEligibilityBasis|hix-ee:EmergencyMedicaidCitizenOrImmigrantEligibilityBasis|hix-ee:MedicaidMAGICitizenOrImmigrantEligibilityBasis|hix-ee:MedicaidMAGI-CHIPRA214EligibilityBasis|hix-ee:MedicaidMAGISevenYearLimitEligibilityBasis|hix-ee:CHIPTitleIIWorkQuartersMetEligibilityBasis|hix-ee:CHIPTraffickingVictimCategoryEligibilityBasis|hix-ee:MedicaidMAGIFiveYearBarEligibilityBasis|hix-ee:CHIPPregnancyCategoryEligibilityBasis|hix-ee:CHIPTargetedLowIncomeChildEligibilityBasis|hix-ee:CHIPUnbornChildCategoryEligibilityBasis|hix-ee:CHIPStateHealthBenefitsEligibilityBasis|hix-ee:CHIPWaitingPeriodEligibilityBasis|hix-ee:CHIP-SSNVerificationEligibilityBasis|hix-ee:MedicaidMAGIParentCaretakerCategoryEligibilityBasis|hix-ee:MedicaidMAGIPregnancyCategoryEligibilityBasis|hix-ee:MedicaidMAGIChildCategoryEligibilityBasis|hix-ee:MedicaidMAGIAdultGroupCategoryEligibilityBasis|hix-ee:MedicaidMAGIAdultGroupXXCategoryEligibilityBasis|hix-ee:MedicaidMAGIOptionalTargetedLowIncomeChildEligibilityBasis|hix-ee:MedicaidMAGIFormerFosterCareCategoryEligibilityBasis|hix-ee:MedicaidMAGIDependentChildCoverageEligibilityBasis|hix-ee:MedicaidMAGISSNVerificationEligibilityBasis|hix-ee:RefugeeMedicalAssistanceEligibilityBasis|hix-ee:ExchangeVerifiedCitizenshipOrLawfulPresenceEligibilityBasis|hix-ee:ExchangeIncarcerationEligibilityBasis">
         <sch:assert test="not(hix-core:StatusIndicator) or hix-ee:EligibilityBasisStatusCode[.='Complete']">
            hix-ee:EligibilityBasisStatusCode with a value of Complete is required if hix-core:StatusIndicator is present [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/*/<sch:name/>/hix-ee:EligibilityBasisStatusCode].  
         </sch:assert>
         <sch:assert test="not(hix-ee:EligibilityBasisStatusCode[.='Complete']) or  hix-core:StatusIndicator">
            hix-core:StatusIndicator is required if hix-ee:EligibilityBasisStatusCode is Complete [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/*/<sch:name/>/hix-core:StatusIndicator].
            </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:MedicaidHouseholdSizeEligibilityBasis">
         <sch:let name="MedicaidHouseholdReference"
                  value="preceding-sibling::hix-ee:MedicaidHouseholdReference/@s:ref"/>
         <sch:assert test="not(hix-core:StatusIndicator) or /exch:AccountTransferRequest/hix-ee:MedicaidHousehold[@s:id=$MedicaidHouseholdReference]/hix-ee:MedicaidHouseholdEffectivePersonQuantity">
            hix-ee:MedicaidHouseholdEffectivePersonQuantity is required in hix-ee:MedicaidHousehold if hix-core:StatusIndicator is present in hix-ee:MedicaidHouseholdSizeEligibilityBasis [exch:AccountTransferRequest/hix-ee:MedicaidHousehold/hix-ee:MedicaidHouseholdEffectivePersonQuantity].  
                </sch:assert>
         <sch:assert test="not(hix-core:StatusIndicator) or hix-ee:EligibilityBasisStatusCode[.='Complete']">
            hix-ee:EligibilityBasisStatusCode with a value of Complete is required if hix-core:StatusIndicator is present [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/*/<sch:name/>/hix-ee:EligibilityBasisStatusCode].  
         </sch:assert>
         <sch:assert test="not(hix-ee:EligibilityBasisStatusCode[.='Complete']) or  hix-core:StatusIndicator">
            hix-core:StatusIndicator is required if hix-ee:EligibilityBasisStatusCode is Complete [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/*/<sch:name/>/hix-core:StatusIndicator].
            </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:InsuranceApplicantNonESIPolicy">
         <sch:assert test="not(hix-ee:InsurancePlan/hix-pm:InsurancePlanProgramCode = 'QHP') or hix-ee:InsurancePlan/hix-pm:ActuarialValueMetallicTierCode">
                 hix-ee:InsurancePlan/hix-pm:ActuarialValueMetallicTierCode is required in hix-ee:InsuranceApplicantNonESIPolicy if hix-pm:InsurancePlanProgramCode is QHP [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/hix-ee:InsuranceApplicantNonESIPolicy/hix-ee:InsurancePlan/hix-pm:ActuarialValueMetallicTierCode].  
                </sch:assert>
         <sch:assert test="not(hix-ee:InsurancePlan/hix-pm:InsurancePlanProgramCode = 'QHP') or hix-ee:InsurancePlan/hix-pm:Issuer/hix-pm:IssuerIdentification">
                hix-ee:InsurancePlan/hix-pm:Issuer/hix-pm:IssuerIdentification is required in hix-ee:InsuranceApplicantNonESIPolicy if hix-pm:InsurancePlanProgramCode is QHP Type  is QHP [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/hix-ee:InsuranceApplicantNonESIPolicy/hix-ee:InsurancePlan/hix-pm:Issuer/hix-pm:IssuerIdentification].  
                </sch:assert>
         <sch:assert test="not(hix-ee:InsurancePlan/hix-pm:InsurancePlanProgramCode = 'QHP') or hix-ee:InsurancePlan/hix-pm:InsurancePlanIdentification">
                hix-ee:InsurancePlan/hix-pm:InsurancePlanIdentification is required in hix-ee:InsuranceApplicantNonESIPolicy if hix-pm:InsurancePlanProgramCode is QHP [exch:AccountTransferRequest/hix-ee:InsuranceApplication/hix-ee:InsuranceApplicant/hix-ee:InsuranceApplicantNonESIPolicy/hix-ee:InsurancePlan/hix-pm:InsurancePlanIdentification].  
                </sch:assert>
      </sch:rule>
      <sch:rule context="nc:PersonGivenName">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 45">nc:PersonGivenName must be between 1 and 45 characters long. 
                </sch:assert>
         <sch:assert test="matches(.,$allLetters)">nc:PersonGivenName must contain only letters, hyphens, apostrophes and spaces.</sch:assert>
         <sch:assert test="matches(.,'\p{L}')">nc:PersonGivenName must contain at least one letter.</sch:assert>
      </sch:rule>
      <sch:rule context="nc:PersonMiddleName">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 45">nc:PersonMiddleName must be between 1 and 45 characters long. 
                </sch:assert>
         <sch:assert test="matches(.,$allLetters)">nc:PersonMiddleName must contain only letters, hyphens, apostrophes and spaces.</sch:assert>
         <sch:assert test="matches(.,'\p{L}')">nc:PersonMiddleName must contain at least one letter.</sch:assert>
      </sch:rule>
      <sch:rule context="nc:PersonSurName">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 45">nc:PersonSurName must be between 1 and 45 characters long. 
                </sch:assert>
         <sch:assert test="matches(.,$allLetters)">nc:PersonSurName must contain only letters, hyphens, apostrophes and spaces.</sch:assert>
         <sch:assert test="matches(.,'\p{L}')">nc:PersonSurName must contain at least one letter.</sch:assert>
      </sch:rule>
      <sch:rule context="nc:PersonNameSuffixText">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 18">nc:PersonNameSuffixText must be between 1 and 18 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="nc:PersonSexText">
         <sch:assert test=". = ('Male','Female')">
                Invalid value for nc:PersonSexText; valid values are: Male, Female. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="nc:StreetFullText">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 88">nc:StreetFullText must be between 1 and 88 characters long. 
            </sch:assert>
      </sch:rule>
      <sch:rule context="nc:AddressSecondaryUnitText">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 75">nc:AddressSecondaryUnitText must be between 1 and 75 characters long. 
            </sch:assert>
      </sch:rule>
      <sch:rule context="nc:LocationCityName">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 100">nc:LocationCityName must be between 1 and 100 characters long. 
            </sch:assert>
      </sch:rule>
      <sch:rule context="nc:LocationPostalCode">
         <sch:assert test="matches(.,'^\d{5}(-?\d{4})?$')">
                For a zip code (nc:LocationPostalCode), 5 digits are required but 9 are permitted. [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonContactInformationAssociation/hix-core:ContactInformation/nc:ContactMailingAddress/nc:StructuredAddress/nc:LocationPostalCode].  
            </sch:assert>
      </sch:rule>
      <sch:rule context="nc:LocationCountyName">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 256">nc:LocationCountyName must be between 1 and 256 characters long. 
            </sch:assert>
      </sch:rule>
      <sch:rule context="ext:TransferActivityReferralQuantity">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 2">ext:TransferActivityReferralQuantity must be between 1 and 2 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="nc:TelephoneNumberFullID">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 10 and $len &lt;= 20">nc:TelephoneNumberFullID must be between 10 and 20 characters long. 
            </sch:assert>
         <sch:assert test="$is-inbound or matches(., '^[\d\-]+$')">
            nc:TelephoneNumberFullID must contain only numbers and hyphens.  
            </sch:assert>
         <sch:assert test="not($is-inbound-not-OBR) or matches(., '^\d+$')">
            nc:TelephoneNumberFullID must contain only numbers.  
            </sch:assert>
      </sch:rule>
      <sch:rule context="nc:TelephoneSuffixID">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="matches(.,'^\d{1,6}$')">nc:TelephoneSuffixID must be between 1 and 6 digits long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:SignatureName/nc:PersonFullName">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 100">nc:PersonFullName must be between 1 and 100 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="nc:LanguageName">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 18">nc:LanguageName must be between 1 and 18 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="nc:ContactEmailID">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 5 and $len &lt;= 63">nc:ContactEmailID must be between 5 and 63 characters long. 
                </sch:assert>
         <sch:assert test="contains(.,'@')">An email address (nc:ContactEmailID) must contain "@".</sch:assert>
         <sch:assert test="not(contains(.,' '))">An email address may not contain spaces.</sch:assert>
         <sch:assert test="not(starts-with(.,'-') or ends-with(.,'-') or contains(.,'--'))">An email address may not start/end with a hyphen or contain two hyphens together.</sch:assert>
      </sch:rule>
      <sch:rule context="nc:OrganizationName">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 256">nc:OrganizationName must be between 1 and 256 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:TINIdentification/nc:IdentificationID">
         <sch:assert test="matches(.,'^\d{9}$')">hix-core:TINIdentification/nc:IdentificationID must be 9 digits.
            </sch:assert>
      </sch:rule>
      <sch:rule context="nc:OrganizationIdentification/nc:IdentificationID">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 20">nc:OrganizationIdentification/nc:IdentificationID must be between 1 and 20 characters long.
            </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:ApplicationIdentification/nc:IdentificationID">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 64">hix-core:ApplicationIdentification/nc:IdentificationID must be between 1 and 64 characters long. 
             </sch:assert>
      </sch:rule>
      <sch:rule context="nc:PersonSSNIdentification/nc:IdentificationID">
         <sch:assert test="matches(.,'^([1-57-8][0-9]{2}|0([1-9][0-9]|[0-9][1-9])|6([0-57-9][0-9]|[0-9][0-57-9]))([1-9][0-9]|[0-9][1-9])([1-9]\d{3}|\d[1-9]\d{2}|\d{2}[1-9]\d|\d{3}[1-9])$')">nc:PersonSSNIdentification/nc:IdentificationID must be 9 characters long and 
                - Cannot be all 0's
                - Cannot start with 000
                - Cannot start with 666
                - Cannot start with 9 (i.e. 900-999*)
                - Cannot contain XXX-00-XXXX (0's in middle piece)
                - Cannot contain XXX-XX-0000 (0's in the end piece)
                
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:InsurancePolicyIdentification/nc:IdentificationID">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 5 and $len &lt;= 100">nc:IdentificationID must be between 5 and 100 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:PersonIdentification/nc:IdentificationID">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 50">nc:IdentificationID must be between 1 and 50 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:LawfulPresenceDocumentNumber/nc:IdentificationID">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 18">nc:IdentificationID must be between 1 and 18 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:LawfulPresenceDocumentPersonIdentification/nc:IdentificationID">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 18">nc:IdentificationID must be between 1 and 18 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:MedicaidIdentification/nc:IdentificationID|hix-ee:CHIPIdentification/nc:IdentificationID">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 18">nc:IdentificationID must be between 1 and 18 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-pm:IssuerIdentification/nc:IdentificationID">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 18">nc:IdentificationID must be between 1 and 18 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-pm:InsurancePlanIdentification/nc:IdentificationID">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 18">nc:IdentificationID must be between 1 and 18 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:PersonMedicaidIdentification/nc:IdentificationID">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 30">nc:IdentificationID must be between 1 and 30 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:PersonCHIPIdentification/nc:IdentificationID">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 30">nc:IdentificationID must be between 1 and 30 characters long. 
            </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:InsuranceApplicationCoverageRenewalYearQuantity">
         <sch:assert test=". &gt;= 1 and . &lt;= 5">hix-ee:InsuranceApplicationCoverageRenewalYearQuantity must be an integer between 1 and 5. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:LawfulPresenceDocumentCategoryText">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 100">hix-ee:LawfulPresenceDocumentCategoryText must be between 1 and 100 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="nc:Year|hix-ee:TaxReturnYear|hix-core:EmploymentHistoryYearDate">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="$len = 4">
            <sch:name/> must be 4 digits long. 
            </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:StepID">
         <sch:assert test=". = ('1','2','3')">hix-core:StepID must have the value 1, 2 or 3. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:PersonTribeName">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 256">hix-core:PersonTribeName must be between 1 and 256 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-pm:InsurancePlanRateAmount">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 12">hix-pm:InsurancePlanRateAmount must be between 1 and 12 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-pm:InsurancePlanName">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 2 and $len &lt;= 100">hix-pm:InsurancePlanName must be between 2 and 100 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:VerificationInconsistencyJustificationText">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 5 and $len &lt;= 256">hix-core:VerificationInconsistencyJustificationText must be between 5 and 256 characters long. 
            </sch:assert>
      </sch:rule>
      <sch:rule context="nc:PersonRaceText">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 2 and $len &lt;= 256">nc:PersonRaceText must be between 2 and 256 characters long. 
             </sch:assert>
      </sch:rule>
      <sch:rule context="nc:PersonEthnicityText">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 5 and $len &lt;= 256">nc:PersonEthnicityText must be between 5 and 256 characters long. 
            </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:PregnancyStatusExpectedBabyQuantity">
         <sch:assert test=". &lt; 10">
                hix-core:PregnancyStatusExpectedBabyQuantity must be less than 10 [exch:AccountTransferRequest/hix-core:Person/hix-core:PersonAugmentation/hix-core:PersonPregnancyStatus/hix-core:PregnancyStatusExpectedBabyQuantity].  
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:IncomeHoursPerWeekMeasure">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 10">hix-core:IncomeHoursPerWeekMeasure must be between 1 and 10 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:InsuranceApplicantParentAverageHoursWorkedPerWeekValue">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="not($is-inbound-not-OBR) or ($len &gt;= 1 and $len &lt;= 3)">hix-ee:InsuranceApplicantParentAverageHoursWorkedPerWeekValue must be between 1 and 3 characters long. 
            </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:IncomeDaysPerWeekMeasure">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="$len = 1">hix-core:IncomeDaysPerWeekMeasure must 1 character long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:ExpenseAmount">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 12">hix-core:ExpenseAmount must be between 1 and 12 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:ExpenseCategoryText">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 5 and $len &lt;= 256">hix-core:ExpenseCategoryText must be between 5 and 256 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:IncomeEmploymentDescriptionText">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 2 and $len &lt;= 256">hix-core:IncomeEmploymentDescriptionText must be between 2 and 256 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:IncomeUnemploymentSourceText">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 50">hix-core:IncomeUnemploymentSourceText must be between 1 and 50 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:IncomeAmount">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 19">hix-core:IncomeAmount must be between 1 and 19 characters long. 
            </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:InformationExchangeSystemCountyName">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 18">hix-core:InformationExchangeSystemCountyName must be between 1 and 18 characters long. 
            </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:HouseholdSizeQuantity">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 10">hix-ee:HouseholdSizeQuantity must be between 1 and 10 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:TaxReturnTotalExemptionsQuantity">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 10">hix-ee:TaxReturnTotalExemptionsQuantity must be between 1 and 10 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="nc:FacilityName">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 60">nc:FacilityName must be between 1 and 60 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:EmploymentHistoryCreditedQuarterQuantity">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 10">hix-core:EmploymentHistoryCreditedQuarterQuantity must be between 1 and 10 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:VerificationID">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="matches(.,'^.{13}[A-Z]{2}$')">hix-core:VerificationID must be 15 characters long and the last two characters must be upper-case letters. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:VerificationDescriptionText">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 160">hix-core:VerificationDescriptionText must be between 1 and 160 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:EligibilityReasonText">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="matches(.,'^\d{3}$')">hix-ee:EligibilityReasonText must be a 3-digit number.
             </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:EligibilityBasisPendingReasonText">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="matches(.,'^\d{3}$')">hix-ee:EligibilityBasisPendingReasonText must be a 3-digit number.
              </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:EligibilityInconsistencyReasonText">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="not($is-inbound-not-OBR) or matches(.,'^\d{3}$')">hix-ee:EligibilityInconsistencyReasonText must be a 3-digit number.
            </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:EligibilityBasisIneligibilityReasonText">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="matches(.,'^\d{3}$')">hix-ee:EligibilityBasisIneligibilityReasonText must be a 3-digit number.
            </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:EligibilityBasisInconsistencyReasonText">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="matches(.,'^\d{3}$')">hix-ee:EligibilityBasisInconsistencyReasonText must be a 3-digit number.
            </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:IncomeCompatibilityInconsistencyReasonText">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len = 3">hix-ee:IncomeCompatibilityInconsistencyReasonText must be 3 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:IncomeFederalPovertyLevelPercent">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 3">hix-core:IncomeFederalPovertyLevelPercent must be between 1 and 3 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:MedicaidHouseholdEffectivePersonQuantity">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 10">hix-ee:MedicaidHouseholdEffectivePersonQuantity must be between 1 and 10 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:APTCMaximumAmount">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 12">hix-ee:APTCMaximumAmount must be between 1 and 12 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:InsuranceApplicantAgeLeftFosterCare">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 2">hix-ee:InsuranceApplicantAgeLeftFosterCare must be between 1 and 2 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="nc:PersonAgeMeasure/nc:MeasurePointValue">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 10">nc:MeasurePointValue must be between 1 and 10 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:IncomeHoursPerPayPeriodMeasure">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 7">hix-core:IncomeHoursPerPayPeriodMeasure must be between 1 and 7 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:InsurancePremiumAmount">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 12">hix-ee:InsurancePremiumAmount must be between 1 and 12 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:InsurancePremiumAPTCAmount">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 12">hix-ee:InsurancePremiumAPTCAmount must be between 1 and 12 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:InsurancePremiumSubscriberAmount">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 12">hix-ee:InsurancePremiumSubscriberAmount must be between 1 and 12 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:LawfulPresenceDocumentPersonIdentification/nc:IdentificationCategoryText">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 50">nc:IdentificationCategoryText must be
                between 1 and 50 characters long. </sch:assert>
      </sch:rule>
      <sch:rule context="ext:TransferActivity/nc:ActivityIdentification/nc:IdentificationID">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 20">nc:IdentificationID must be
                between 1 and 20 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:ReferralActivity/nc:ActivityIdentification/nc:IdentificationID">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 20">nc:IdentificationID must be
                between 1 and 20 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:DisenrollmentActivityReasonText">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 18">hix-ee:DisenrollmentActivityReasonText must be
                between 1 and 18 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:EnrollmentActivityReasonText">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 18">hix-ee:EnrollmentActivityReasonText must be
                between 1 and 18 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:ReferralActivityReasonText">
         <sch:let name="len" value="string-length(.)"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 35">hix-ee:ReferralActivityReasonText must be
                between 1 and 35 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:IncomeEligibilityBasisStateThresholdFPLPercent">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 3">hix-ee:IncomeEligibilityBasisStateThresholdFPLPercent must be
                between 1 and 3 characters long. 
                </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:VerificationAuthorityName">
         <sch:let name="len" value="string-length(normalize-space(string(.)))"/>
         <sch:assert test="$len &gt;= 1 and $len &lt;= 100">hix-core:VerificationAuthorityName must be
            between 1 and 100 characters long. 
            </sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:ResponseCode">
         <sch:let name="len" value="string-length(string(.))"/>
         <sch:assert test="$len &gt;= 1  and $len &lt;= 8">hix-core:ResponseCode must be between 1 and 8 characters long. 
            </sch:assert>
      </sch:rule>
      <sch:rule context="nc:LocationCountyCode">
         <sch:assert test="matches(.,$threedigits)">nc:LocationCountyCode must contain exactly 3 digits.</sch:assert>
      </sch:rule>
      <sch:rule context="nc:LocationCountryISO3166Alpha3Code">
         <sch:assert test="matches(.,$threechars)">nc:LocationCountryISO3166Alpha3Code must contain exactly 3 uppercase characters.</sch:assert>
      </sch:rule>
      <sch:rule context="nc:IdentificationJurisdictionISO3166Alpha3Code">
         <sch:assert test="matches(.,$threechars)">nc:IdentificationJurisdictionISO3166Alpha3Code must contain exactly 3 uppercase characters.</sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:IncarcerationDate | hix-core:PersonAdoptionDate | hix-core:SignatureDate | hix-ee:LawfulPresenceDocumentExpirationDate |  nc:AssociationBeginDate |  nc:AssociationEndDate | nc:EndDate |  nc:PersonBirthDate | nc:StartDate | scr:AdmitToDate | hix-core:ImmigrationStatusGrantDate |  hix-ee:ESIExpectedChangeDate | hix-ee:InsuranceApplicantESIEnrollmentEligibilityDate | hix-ee:SEPQualifyingEventDate">
         <sch:assert test="nc:Date">nc:Date is required in <sch:name/>.</sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:IncomeDate">
         <sch:assert test="nc:Date|nc:Year|nc:YearMonth">nc:Date or nc:Year or nc:YearMonth is required in <sch:name/>.</sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:VerificationDate | hix-ee:EligibilityDetermination/nc:ActivityDate | hix-ee:EligibilityBasisDetermination/nc:ActivityDate | hix-ee:IncomeCompatibilityDetermination/nc:ActivityDate">
         <sch:assert test="nc:DateTime">nc:DateTime is required in <sch:name/>.</sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:SignatureDate/nc:Date|hix-ee:InsuranceApplicationAssisterAssociation/nc:AssociationBeginDate/nc:Date|hix-ee:LawfulPresenceStatusEligibility/hix-ee:EligibilityDateRange/nc:StartDate/nc:Date|hix-core:PersonAdoptionDate/nc:Date">
         <sch:let name="year" value="year-from-date(xs:date(.))"/>
         <sch:let name="current-year" value="year-from-date(current-date())"/>
         <sch:assert test="$year &gt; 1912 and $year &lt;= $current-year">The year in this nc:Date must be greater than 1912 and less than or equal to the current year.
                    </sch:assert>
      </sch:rule>
      <sch:rule context="nc:PersonName">
         <sch:assert test="not(nc:PersonFullName)">nc:PersonName must not contain nc:PersonFullName.</sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:SignatureName">
         <sch:assert test="not(* except nc:PersonFullName)">hix-core:SignatureName must contain nc:PersonFullName as its only child.</sch:assert>
      </sch:rule>
      <sch:rule context="nc:ContactTelephoneNumber">
         <sch:assert test="nc:FullTelephoneNumber/nc:TelephoneNumberFullID">nc:FullTelephoneNumber/nc:TelephoneNumberFullID is required in nc:ContactTelephoneNumber.</sch:assert>
      </sch:rule>
      <sch:rule context="hix-core:RoleOfPersonReference|hix-ee:HouseholdMemberReference|nc:PersonReference|hix-ee:ESIContactPersonReference">
         <sch:let name="personref" value="@s:ref"/>
         <sch:assert test="//hix-core:Person[@s:id = $personref]">A <sch:name/> reference must have an ID that points to a hix-core:Person.
                        </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:InsuranceApplicationAssisterReference">
         <sch:let name="personref" value="@s:ref"/>
         <sch:assert test="//hix-ee:Assister[@s:id = $personref]">A <sch:name/> reference must have an ID that points to a hix-ee:Assister.
                        </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:AuthorizedRepresentativeReference">
         <sch:let name="personref" value="@s:ref"/>
         <sch:assert test="//hix-ee:AuthorizedRepresentative[@s:id = $personref]">A <sch:name/> reference must have an ID that points to a hix-ee:AuthorizedRepresentative.
                        </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:ESIReference">
         <sch:let name="esiref" value="@s:ref"/>
         <sch:assert test="//hix-ee:ESI[@s:id = $esiref]">A <sch:name/> reference must have an ID that points to a hix-ee:ESI.
                        </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:ReferralActivityReceiverReference">
         <sch:let name="sysref" value="@s:ref"/>
         <sch:assert test="//hix-core:Receiver[@s:id = $sysref]">A <sch:name/> reference must have an ID that points to a hix-core:Receiver.
                        </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:ReferralActivitySenderReference">
         <sch:let name="sysref" value="@s:ref"/>
         <sch:assert test="//hix-core:Sender[@s:id = $sysref]">A <sch:name/> reference must have an ID that points to a hix-core:Sender.
                        </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:MedicaidHouseholdReference">
         <sch:let name="hhref" value="@s:ref"/>
         <sch:assert test="//hix-ee:MedicaidHousehold[@s:id = $hhref]">A <sch:name/> reference must have an ID that points to a hix-ee:MedicaidHousehold.
                        </sch:assert>
      </sch:rule>
      <sch:rule context="nc:OrganizationReference|hix-core:IncomeSourceOrganizationReference">
         <sch:let name="orgref" value="@s:ref"/>
         <sch:assert test="//hix-core:Employer[@s:id = $orgref] or //hix-core:Organization[@s:id = $orgref] or //hix-pm:RolePlayedByOrganization[@s:id = $orgref]">A <sch:name/> reference must have an ID that points to a hix-core:Employer or hix-core:Organization or hix-pm:RolePlayedByOrganization.
                        </sch:assert>
      </sch:rule>
      <sch:rule context="hix-ee:ReferralActivityEligibilityReasonReference">
         <sch:let name="elref" value="@s:ref"/>
         <sch:assert test="//hix-ee:LawfulPresenceStatusEligibility[@s:id = $elref] or //hix-ee:APTCEligibility[@s:id = $elref] or //hix-ee:CHIPEligibility[@s:id = $elref] or //hix-ee:CSREligibility[@s:id = $elref] or //hix-ee:EmergencyMedicaidEligibility[@s:id = $elref] or //hix-ee:ExchangeEligibility[@s:id = $elref] or //hix-ee:MedicaidMAGIEligibility[@s:id = $elref] or //hix-ee:MedicaidNonMAGIEligibility[@s:id = $elref] or //hix-ee:RefugeeMedicalAssistanceEligibility[@s:id = $elref]">A <sch:name/> reference must have an ID that points to an Eligibility element.
                </sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="Generic">
      <sch:rule context="*[@s:metadata]">
         <sch:let name="metadataref"
                  value="for $m in data(@s:metadata) return tokenize($m,'\s+')"/>
         <sch:let name="metadataids"
                  value="//hix-core:VerificationMetadata/@s:id/string(.)"/>
         <sch:assert test="not($metadataref[not(. = $metadataids)])">An s:metadata attribute must reference one or more hix-core:VerificationMetadata elements <sch:value-of select="$metadataref[not(. = $metadataids)]"/> does not.
               </sch:assert>
      </sch:rule>
   </sch:pattern>
</sch:schema>
