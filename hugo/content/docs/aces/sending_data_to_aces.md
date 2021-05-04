---
title: Sending Data to ACES

---

ACES accepts inbound data using the CMS Account Transfer Protocol over SOAP.

The current WSDL for the inbound service can be found [here](https://portal.maine.gov/ACA/AccountTransferService?WSDL).

ACES performs authentication using the SOAP UsernameToken structure.

**Currently all notes and information located here reference the ATP endpoint only.**

## Caveats and Implementation Notes

There are certain issues to be aware of when transmitting data to ACES.

In the below examples, any elements mentioned are identified using namespace-free XPath syntax.

1. As of right now, it only accepts `http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText` encoding for the `UsernameToken` structure.  This means that as long as the `Created` value is fairly recent and the `Nonce` value is a valid base-64 encoded value, 16 bytes long, it doesn't matter what the nonce actually **is**.
2. ACES enforces and will return an exception in the case of a submission for which certain values are not unique to the request.  The error message will not indicate which one, it seems to return a generic program exception.  These values are:
   1. The payload `AccountTransferRequest/TransferHeader/TransferActivity/ActivityIdentification/IdentificationID` element
   2. The payload `AccountTransferRequest/InsuranceApplication/ReferralActivity/ActivityIdentification/IdentificationID` element

## General Flow

We submit data to ACES beginning with the `Aces::PublishRawPayload` action.

It performs the following actions:
1. Create a SOAP security header with the authorization information ACES needs
2. Build the account transfer request in a format ACES accepts
3. Post the SOAP payload to the ACES endpoint and return the Faraday response object

**The current flow accepts a raw payload and does not accept nor properly transform any kind of ATP object from aca_entities**.

For the purposes of connectivity testing, there is a controller available to post 'raw' body payloads to ACES.
1. The controller is the `Aces::PublishingConnectivityTestsController` class.
2. Only a 'new' action is supported, so visiting `/aces/publishing_connectivity_tests/new` takes you to the utility.
3. Here you can post the body of an `AccountTransferRequest` element, as raw xml.  **Do not include the SOAP wrapper or body in your input.**
4. The controller will submit the body wrapped in a SOAP envelope to ACES and return an inspection of the result, it's fairly bare-bones with little other capability.