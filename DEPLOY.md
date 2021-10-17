# Environment Variables

The following environment variables must be set for the application to work:

1. `ACES_ATP_SERVICE_URI` - the uri of the endpoint to which medicaid_gateway will submit ATP requests to ACES, should be something like: `https://portal.maine.gov:443/ACA/AccountTransferService`
2. `ACES_ATP_SERVICE_USERNAME` - the username to use for the above service
3. `ACES_ATP_SERVICE_PASSWORD` - the password to use for the above service
4. `ACES_ATP_CALLER_USERNAME` - the username we expect ACES to call **us** with
5. `ACES_ATP_CALLER_PASSWORD` - the password we expect ACES to call **us** with
6. `ACES_MEC_CHECK_URI` - the uri of the endpoint we will submit mec checks to
7. `CURAM_ATP_SERVICE_URI` - the uri of the endpoint to which medicaid_gateway will submit ATP requests to Curam
8. `CURAM_ATP_SERVICE_USERNAME` - the username to use for the above service
9. `CURAM_ATP_SERVICE_PASSWORD` - the password to use for the above service
10. `CURAM_ATP_CHECK_URI` - the uri of the endpoint to which medicaid_gateway will check for the status of a transfer
