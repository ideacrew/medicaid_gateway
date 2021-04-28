# Environment Variables

The following environment variables must be set for the application to work:
1. `ACES_ATP_SERVICE_URI` - the uri of the endpoint to which medicaid_gateway will submit ATP requests, should be something like: `https://portal.maine.gov:443/ACA/AccountTransferService`
2. `ACES_ATP_SERVICE_USERNAME` - the username to use for the above service
3. `ACES_ATP_SERVICE_PASSWORD` - the password to use for the above service