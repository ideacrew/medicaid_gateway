---
title: Receiving Data from ACES

---

ACES transmits outbound data using the CMS Account Transfer Protocol over SOAP.

This data is intended for eventual destination to OpenHBX systems, such as Enroll.

The primary reason for transmission of data out of ACES to OpenHBX systems is to communicate that a group or individual has been determined ineligible for Medicaid.

Currently we perform authentication using the SOAP UsernameToken structure.  We currently support:
1. `http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText`
2. `http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest`