#  ReadMe.md

## Instructions

Developed using macOS 10.15.7 (build 19H15) / Xcode 12.1 (build 12A7403).

The project has no pods / package dependencies, it's been written from scratch. Therefore to build and run this in the iOS Simulator, from within Xcode select the appropriate architecture you want the Simulator to use (eg. Product -> Destination -> iPhone 12 mini) and run it (Product -> Run). The app has a minimum OS of iOS 14.1.

## Approach Taken

The instructions appear to want a standard Master / Detail view app. They involve downloading data from a known URL as a .csv (http://media.nhschoices.nhs.uk/data/foi/Hospital.csv). iOS no longer supports downloading via http out of the box; instead in order to achieve that we need to add some allowances to the project's Info.plist.

I've opted to connect securely (https://same-URL-as-above) as it's best practice, and I've already checked that the server accepts secure SSL connections, by (in Terminal):

ken@UNIX-on-wheels ~ % nc -vz media.nhschoices.nhs.uk 443
Connection to media.nhschoices.nhs.uk port 443 [tcp/https] succeeded!
ken@UNIX-on-wheels ~ % nc -vz media.nhschoices.nhs.uk 80 
Connection to media.nhschoices.nhs.uk port 80 [tcp/http] succeeded!

The first nc checks it communicates over SSL (port 443), the second nc checks it communicates over standard HTTP (port 80). It responds on both ports. If the instructions were absolutely requiring http (eg. because the client is sure that security / snooping / intercepting won't be an issue, and the server doesn't respond on HTTPS / uses a self-signed or out of date SSL certificate, so won't be trusted) then I would add fields to the Info.plist (and have done, for that server). To see the necessary additions, in Xcode look at the "App Transport Security Settings" section within the Info.plist, where it allows insecure HTTP loads from media.nhschoices.nhs.uk and any subdomains. Nonetheless I'll connect securely.

## Notes

## Known Bugs

