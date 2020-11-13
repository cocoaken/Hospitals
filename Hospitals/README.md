#  ReadMe.md

## Instructions

Developed using macOS 10.15.7 (build 19H15) / Xcode 12.1 (build 12A7403).

The project has no pods / package dependencies, it's been written from scratch. Therefore to build and run this in the iOS Simulator, from within Xcode select the appropriate architecture you want the Simulator to use (eg. Product -> Destination -> iPhone 12 mini) and run it (Product -> Run). The app has a minimum OS of iOS 14.1.

Within the Swift files I've made copious use of "//MARK: - Some code heading here", so that you can quickly navigate Xcode's popup menu (in the code editor, just above the actual code) to jump to, for instance, the tableview delegate functions, or the app lifecycle functions etc.

## Approach Taken

### Connection to Remote URL

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

I'll assume a row is a header row if it contains "OrganisationID"

Some of the data is clearly missing for some of the rows (eg. not all hospital rows have an Address2 field populated). Therefore in my Hospital.swift I'll assume only the following fields are mandatory (the rest will be optional in the Hospital class, using Swift optionals):

Organisation ID
Organisation Code
Organisation Name

IsPimsManaged is clearly a Boolean so I'll store it as such.

The Latitude / Longitude I've stored as a Double, which in iOS is typealiased to Core Location's CLLocationDegrees. Therefore storing it as a Double would assist if we ever wanted to get MapKit / Core Location to show a map of where the hospital is, or a route there etc.

In terms of the other data, I've performed next to no data validation eg. I haven't checked that the "website" is a valid URL or that the phone/fax numbers are valid numbers, or that the postcode is a valid format. All of this could be done with regexes.

I've opted to store the rows in Hospital objects (i.e. in my app, Hospital is a class, not a Struct or a Dictionary). Whilst in theory any of them would work, class objects in Swift are copy by reference (akin to C / C++ / Objective-C's pointers), whereas structs and dictionaries are copy by index (akin to C etc. scalar values). So, looking forward, if we ever wanted to group hospitals or have references from one hospital to others, class objects wouldn't necessitate duplicating a given hospital, they'd act more like a traditional database, using references to other objects without needing their own copy of it. Not only does this end up meaning less duplication in memory, but it means that if ever a hospital's details changed during the app lifetime, it would instantly change in every part of the app, rather than needing to know that there are 72 copies of this hospital being referenced, and then needing to hunt down and update each duplicate of it. We could have instead used Core Data, and instead of defining a Hospital class, have used attributes in a Hospital (Core Data) managed object, but as there's no requirement to persist the data, it seems like using a sledgehammer to crack a nut.

Aside from the data coming in from the file (including a "sector" String as per the csv column), the Hospital class has a "hospitalSector" variable pointing to a HospitalSector enum (which consists of "All", "NHS" and "Independent"). This is so that, later on, we'll be able to filter the hospitals by their sectors (eg. show just NHS hospitals). For a given hospital I'm setting this variable at import, based on whether the "sector" String, when lowercased, contains "nhs" in it. If so, it's NHS. If not, it's independent (in my definition, for the sake of this sample app!).

## Known Bugs

- In the Xcode Simulator when running the app, it occasionally logs "nw_protocol_get_quic_image_block_invoke dlopen libquic failed" after having finished downloading the file. It doesn't do this when running on device (iPhone or iPad) so I'm guessing it's a Simulator issue in Xcode 12.1.

- In the Xcode Simulator when running the app, it logs "[connection] nw_proxy_resolver_create_parsed_array [C1 proxy pac] Evaluation error: NSURLErrorDomain: -1003" to the console, but doesn't do this when running on device. So again I'm assuming this is a Simulator bug in Xcode 12.1. Of note, error -1003 is a DNS error (can't find the remote host), so it's possible the DNS records for the remote server aren't entirely healthy, but considering it isn't doing it when running on device (and it still goes and gets the data anyway so can clearly find the host) I'm more inclined to think it's a Simulator issue. 

- On small iPhones in any orientation, and on big iPhones and any iPads when in portrait mode, the app starts in Detail view with no selected hospital shown (because the hospitals are only loaded by the Master view controller, which hasn't loaded yet). A solution would be to refactor the loading of remote data out of the Master VC and either into a singleton custom object that both the Master and Detail VCs can call upon, so that it doesn't matter which VC the app starts in, or into the App Delegate / Scene Delegate. In a "real" app you'd probably want to remember the last selected object in any case (and persist the objects rather than reloading them every time the app launches)
