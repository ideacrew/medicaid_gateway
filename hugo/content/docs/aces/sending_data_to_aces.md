---
title: Sending Data to ACES

---

ACES accepts inbound data using the CMS Account Transfer Protocol over SOAP.

The current WSDL for the inbound service can be found [here](https://portal.maine.gov/ACA/AccountTransferService?WSDL).

Currently ACES performs authentication using the SOAP Usernametoken structure.  As of right now, it only accepts `http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText` encoding.
