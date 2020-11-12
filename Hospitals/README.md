#  ReadMe.md

## Instructions

Developed using macOS 10.15.7 (build 19H15) / Xcode 12.1 (build 12A7403).

The project has no pods / package dependencies, it's been written from scratch. Therefore to build and run this in the iOS Simulator, from within Xcode select the appropriate architecture you want the Simulator to use (eg. Product -> Destination -> iPhone 12 mini) and run it (Product -> Run). The app has a minimum OS of iOS 14.1.

## Approach Taken

### Connection

The instructions appear to want a standard Master / Detail view app. They involve downloading data from a known URL as a .csv (http://media.nhschoices.nhs.uk/data/foi/Hospital.csv). iOS no longer supports downloading via http out of the box; instead in order to achieve that we need to add some allowances to the project's Info.plist.

I've opted to connect securely (https://same-URL-as-above) as it's best practice, and I've already checked that the server accepts secure SSL connections, by (in Terminal):

ken@UNIX-on-wheels ~ % nc -vz media.nhschoices.nhs.uk 443
Connection to media.nhschoices.nhs.uk port 443 [tcp/https] succeeded!
ken@UNIX-on-wheels ~ % nc -vz media.nhschoices.nhs.uk 80 
Connection to media.nhschoices.nhs.uk port 80 [tcp/http] succeeded!

The first nc checks it communicates over SSL (port 443), the second nc checks it communicates over standard HTTP (port 80). It responds on both ports. If the instructions were absolutely requiring http (eg. because the client is sure that security / snooping / intercepting won't be an issue, and the server doesn't respond on HTTPS / uses a self-signed or out of date SSL certificate, so won't be trusted) then I would add fields to the Info.plist (and have done, for that server). To see the necessary additions, in Xcode look at the "App Transport Security Settings" section within the Info.plist, where it allows insecure HTTP loads from media.nhschoices.nhs.uk and any subdomains. Nonetheless I'll connect securely.

### Data import

Firstly, the file claims to be a .csv (comma separated) yet is tab separated (.tsv / .tab).

The file is encoded as ISO Western Latin 1 rather than eg. UTF-8.

Line breaks are denoted by /r/n rather than just /r, for instance.

Some of the data is clearly missing for some of the rows (eg. not all hospital rows have an Address2 field populated). Therefore in my Hospital.swift I'll assume only the following fields are mandatory (the rest will be optional in the Hospital class, using Swift optionals):

Organisation ID
Organisation Code
Organisation Name

IsPimsManaged is clearly a Boolean so I'll store it as such.

The Latitude / Longitude I've stored as a Double, which in iOS is typealiased to Core Location's CLLocationDegrees. Therefore storing it as a Double would assist if we ever wanted to get MapKit / Core Location to show a map of where the hospital is, or a route there etc.

I've opted to store the rows in Hospital objects (i.e. in my app, Hospital is a class, not a Struct or a Dictionary). Whilst in theory any of them would work, class objects in Swift are copy by reference (akin to C / C++ / Objective-C's pointers), whereas structs and dictionaries are copy by index (akin to C etc. scalar values). So, looking forward, if we ever wanted to group hospitals or have references from one hospital to others, class objects wouldn't necessitate duplicating a given hospital, they'd act more like a traditional database, using references to other objects without needing their own copy of it. Not only does this end up meaning less duplication in memory, but it means that if ever a hospital's details changed during the app lifetime, it would instantly change in every part of the app, rather than needing to know that there are 72 copies of this hospital being referenced, and then needing to hunt down and update each duplicate of it. We could have instead used Core Data, and instead of defining a Hospital class, have used attributes in a Hospital (Core Data) managed object, but as there's no requirement to persist the data, it seems like using a sledgehammer to crack a nut.

Aside from the data coming in from the file (including a "sector" String as per the csv column), the Hospital class has a "hospitalSector" variable pointing to a HospitalSector enum (which consists of "All", "NHS" and "Independent"). This is so that, later on, we'll be able to filter the hospitals by their sectors (eg. show just NHS hospitals). For a given hospital I'm setting this variable at import, based on whether the "sector" String, when lowercased, contains "nhs" in it. If so, it's NHS. If not, it's independent (in my definition, for the sake of this sample app!).  

## Notes

## Known Bugs

