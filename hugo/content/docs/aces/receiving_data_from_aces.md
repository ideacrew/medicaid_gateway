---
title: Receiving Data from ACES

---

## Overview

ACES transmits outbound data using the CMS Account Transfer Protocol over SOAP.

This data is intended for eventual destination to OpenHBX systems, such as Enroll.

The primary reason for transmission of data out of ACES to OpenHBX systems is to communicate that a group or individual has been determined ineligible for Medicaid.

We perform authentication using the SOAP UsernameToken structure.  We currently support:
1. `http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText`
2. `http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest`

## Caveats and Implementation Notes

There are certain issues to be aware of when accepting data from ACES.

In the below examples, any XML elements mentioned are identified using namespace-free XPath syntax.

1. Our service is based on the CMS reference implementation with which they had been previously communicating.  The [WSDL](https://impl.hub.cms.gov/Imp1/AccountTransferService?wsdl) for that service is available.
2. When responding to a request from ACES, we must be very careful about the response we send back.  The SOAP toolkit the ACES application is using is rather sensitive.  If the returned response is not schema valid, the ACES client will simply roll back it's entire transaction and give their developers no chance to examine the response payload.
3. ACES uses a fairly recent SOAP standard, therefore the response type for our services needs to be `application/soap+xml`, **not** `text/xml`.
4. They seem to have some trouble reaching our WSDL.
5. ACES currently has two desired requirements for submission that we do not properly support:
   1. Client-side SSL certificates (we provide server certificate based end-to-end transport encryption)
   2. We should enforce the uniqueness of, and return errors for:
      1. The payload `AccountTransferRequest/TransferHeader/TransferActivity/ActivityIdentification/IdentificationID` element
      2. The payload `AccountTransferRequest/InsuranceApplication/ReferralActivity/ActivityIdentification/IdentificationID` element

## General Flow

We accept data from ACES in the `Aces::Soap::AtpRequestsController`.

It contains two endpoints, with corresponding controller methods:
1. `wsdl` - a GET endpoint which exposes the service definition of the endpoint
2. `service` - a POST endpoint where ACES sends the data

The service endpoint currently performes the following tasks:
1. Validation of the SOAP security header
2. XML Validation of the body payload against the schemas for the data (currently located in `artifacts/aces`)
3. Recording the sent and response payloads

**Right now the endpoint service does not parse nor submit the data we receive from ACES to anywhere else, it just stores it in the database as opaque XML**.