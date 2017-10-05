//
//  State.swift
//  PWR
//
//  Created by Amber Spadafora on 10/4/17.
//  Copyright © 2017 Amber Spadafora. All rights reserved.
//

import Foundation

// 0: Hahahahahahaha, I was about to say "State" is very vaque, because models can have all sorts
// of state and you need to be precise. Then I realised this is a US State. Ignore me, I'm an idiot :)
//
// 2: Unless you want to be able to modify these state details (and I don't think you do) you should
//    make them all 'let' constants
struct State {
    var abbreviation: String
    var title: String // 0: Maybe name instead of title?

    // 2: It's possible to create a state with an empty array of senators.
    // You could use failable or thowing initializers to guard against that, or alternatively you need
    // to be prepared and handle the possiblility in your UI so you have some sort of empty state that says
    // "No senators found - the *&^%(&%ing cowards" (or something like that, maybe less rude)
    //
    // But if you read below I'll explain why I don't think you need this here at all
    var senators: [Senator]
}

// 3: Let's talk testing...
// If you think about it, there are only a fixed number of states. But I could create a state like this:
//
//   let makeyUppyState = State(abbreviation: "WZ", title: "Wazzania", senators: [])
//
// Should this be allowed? I would say no, so what can we do? (BTW if you think "Yeah, I'll allow it, it's
// no big deal" then don't bother reading everything else below here :) )
//
// Well, imagine we're writing tests (and we should be!) we need to test two things
// 1. Tests pass for NH, AZ, CA, MA etc.
// 2. Tests fail for WZ, XP, 4L etc.
//
// But we've a major problem with test 2. How can we cover all possibilities? There are millions of negative values
// we could create.
//
// Ok, we wouldn't deal with all possible negatives. We could just write a couple of negative possibilities just to
// satisfy ourselves, but it'll never be really fulfilling. At most it's just writing a test to make ourselves
// feel better and increase code coverage without really proving anything.
//
// There is a way in Swift to constrain our model to only real states, using enums
//
//    enum State {
//        case alabama
//        case alaska
//        case arizona
//        case arkansas
//        ...
//    }
//
// And we can use the abbreviations as raw values, and keep the 'abbreviation' property:
//
//    enum State: String {
//        case alabama  = "AL"
//        case alaska   = "AK"
//        case arizona  = "AZ"
//        case arkansas = "AR"
//
//        var abbreviation: String {
//            return rawValue
//        }
//    }
//
// We can create our states like this:
//
//    let state: State = .california
//
// or, from the XML:
//
//    let state: State? = State(rawVaule: dict["state"])
//
// This second example will return nil if the dictionary doesn't contain a valid state abbreviation, which is precisely
// what we want
//
// Now it's impossible to create a rogue state. Ok, you have to write out 50 cases, which is a pain, but once it's done it's
// a lot more precise. And you already did it in States.swift :)
//
// Food for thought, though. If we want the state names themselves, not the abbreviations we can just leave off the raw values.
//
//    enum State: String {
//        case alabama
//        case alaska
//        case arizona
//        case arkansas
//        
//        var title: String {
//            return rawValue.capitalized // Will return e.g. Alabama
//        }
//    }
//
// But we want both abbreviation and title... ugh, hang on.
//
//    enum State: String {
//        case alabama  = "AL"
//        case alaska   = "AK"
//        case arizona  = "AZ"
//        case arkansas = "AR"
//        ...
//
//        var abbreviation: String {
//            return rawValue
//        }
//
//        var title: String {
//            switch self {
//            case .alabama:
//                return "Alabama"
//
//            case .alaska:
//                return "Alaska"
//
//            case .arizona:
//                return "Arizona"
//
//            case .arkansas:
//                return "Arkansas"
//
//            ...
//            }
//        }
//    }
//
// Yeah, unfortunately that title is a mess now.
//
// I guess the takeaway is sometimes the "more correct" solution results in more code. It's a lot harder to get things wrong
// and that's a very Swifty thing to aim for. But there's a huge amount of switching to deal with. So, like I said, entirely up
// to you to decide if you think this is worth it.
//
// There is a cheat. It makes the code slightly smaller, and it uses an implicitly unwrapped optional (!), which we're told
// never to do.
//
//    enum State: String {
//        case alabama  = "AL"
//        case alaska   = "AK"
//        case arizona  = "AZ"
//        case arkansas = "AR"
//        ...
//
//        var abbreviation: String {
//            return rawValue
//        }
//
//        var title: String {
//            let states = [
//                "AL": "Alabama",
//                "AK": "Alaska",
//                "AZ": "Arizona",
//                "AR": "Arkanasas",
//                ....
//            ]
//
//            return states[rawValue]!
//        }
//    }
//
// If we fill out the 'states' dictionary correctly, this will never crash, so we can use "!" fine here. But if we make a mistake
// with the dictionary then we'll crash. But that would be a good thing, we want to find that kind of mistake before shipping,
// so writing a test for every state would find any missed titles.
//
// You're probably wondering "Where did the senators go?"
//
// They're removed from the State enum, you can't add a stored property to an enum. I think this is ok, because
// in our model our senators contain a state, we can easily get the list of senators for a particular state using some
// simple filter calls later.
//
// And, again, our State has a single responsibility now. It describes the state, it doesn't add any extra responsibility for
// knowing which Senators belong to it.







































