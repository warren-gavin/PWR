//
//  Senator.swift
//  PWR
//
//  Created by Amber Spadafora on 10/3/17.
//  Copyright © 2017 Amber Spadafora. All rights reserved.
//

import Foundation

class Senator {
    // 0: Should all be 'let's!
    var firstName: String
    var lastName: String

    // 2: I would make a Party enumeration, you only have two valid values, something like this
    //
    // enum Party {
    //     case democrat
    //     case republican
    // }
    var party: String
    
    // 1: This is your State struct!
    var state: String
    var address: String
    
    // 1: There is a fantastic cocoapod called PhoneNumberKit that can help you with phone numbers
    // https://github.com/marmelroy/PhoneNumberKit
    var phone: String
    var website: Website?
    
    // 0: If you make Senator a struct you'll get this for free and you won't have to write it
    init(firstName: String, lastName: String, party: String, state: String, address: String, phone: String, website: Website?) {
        self.firstName = firstName
        self.lastName = lastName
        self.party = party
        self.state = state
        self.address = address
        self.phone = phone
        self.website = website
    }

    // 3: Golden rule time... let's pause to think about responsibilities.
    // Well, sort of golden rule. Obviously an initialiser can't be the responsibility of
    // any other class or struct. But we can use some nice Swift features to clean things up a little.
    //
    // We have a Senator class/struct, which is basically just a load of other values wrapped up. So you
    // may find it neater to just declare the class/struct with just those values.
    //
    //
    //    struct Senator {
    //        let firstName: String
    //        let lastName: String
    //        let parth: Party
    //        let state: State
    //        let address: Address
    //        let phone: String
    //        let website: Website?
    //    }
    //
    // And either in this file (or another one if you like, it's actually my preference) we can create
    // an extension on Senator that handles the express initialisation using a dictionary
    //
    //    extension Senator {
    //        init?(_ dict: [String: String]) {
    //            ...
    //        }
    //    }
    //
    // The reason I prefer this is because now the concept of initialising from a dictionary is separated
    // out from the Senator. The class/struct has no explicit knowledge of or dependency on how it's
    // created. This comes in handy later when you're making tests, you can ignore creation by dictionaries
    // when setting up data.
    //
    // 0: If you decide to make it a struct you just need to remove 'convenience'
    convenience init?(dict: [String: String]) {
        // 0: Swift lets you do all of this in one single guard...
        //    guard
        //        let fName = dict["first_name"],
        //        let lName = dict["last_name"],
        //        let state = dict["state"],
        //        let party = dict["party"],
        //        let phone = dict["phone"],
        //        let address = dict["address"],
        //        let website = dict["website"]
        //    else {
        //        return nil
        //    }

        guard let fName = dict["first_name"] else { return nil }
        guard let lName = dict["last_name"] else { return nil }
        guard let state = dict["state"] else { return nil }
        guard let party = dict["party"] else { return nil }
        guard let phone = dict["phone"] else { return nil }
        guard let address = dict["address"] else { return nil }
        guard let website = dict["website"] else { return nil }
        
        self.init(firstName: fName, lastName: lName, party: party, state: state, address: address, phone: phone, website: nil)
        self.website = Website(url: website, senator: self)
        
    // 0: Massive pedantic thing that makes me look slightly intense
    // The '}' below is indented at 5 spaces. It should be 4.
    //
    // yes, that kind of thing gets to me!
     }
    
}

//<member>
//<member_full>Barrasso (R-WY)</member_full>
//<last_name>Barrasso</last_name>
//<first_name>John</first_name>
//<party>R</party>
//<state>WY</state>
//<address>
//307 Dirksen Senate Office Building Washington DC 20510
//</address>
//<phone>(202) 224-6441</phone>
//<email>
//https://www.barrasso.senate.gov/public/index.cfm/contact-form
//</email>
//<website>http://www.barrasso.senate.gov</website>
//<class>Class I</class>
//<bioguide_id>B001261</bioguide_id>
//</member>

