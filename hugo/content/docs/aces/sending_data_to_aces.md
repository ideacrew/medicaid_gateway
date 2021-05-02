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