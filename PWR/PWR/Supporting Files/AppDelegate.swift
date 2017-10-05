//
//  AppDelegate.swift
//  PWR
//
//  Created by Amber Spadafora on 10/3/17.
//  Copyright © 2017 Amber Spadafora. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // 3: It might happen in the future that you will change from an XML file to JSON. (for a
        // start, JSON is a lot easier to parse than XML).
        //
        // Or maybe you'll download it instead of reading it directly from the bundle. There are a number
        // of things that might change.
        //
        // I would be more in favour of having a general solution where you keep the details that it's an
        // XML file hidden from the rest of the code. 
        
        if let senatorXMLFile = getSenatorXMLUrl() {
            // 0: You're not using `senators`, you can replace it with '_'.
            // In fact, if you're not using it at all, there's no need for the method to return it
            let (senators, stateSenateMap) = getSenators(url: senatorXMLFile)
            
            if let rootView = self.window?.rootViewController as? UINavigationController {
                if let vc = rootView.viewControllers[0] as? StateCollectionViewController {
                    // 3: Golden rule time
                    //
                    // Why does the app delegate have to load this data and add it to the
                    // view controller? Couldn't the StateCollectionViewController get it
                    // itself?
                    vc.senatorStateMap = stateSenateMap
                }
            }
        }
        return true
    }

    // 0: You're not using any of these, it's safe to just delete them.
    // It'll keep your file focused on real work
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

// 2: Is this the right place for this code? Golden rule time.
func getSenatorXMLUrl() -> URL? {
    // 0: Because you're returning an optional you don't need to explicitly check for path and then
    // return a nil if there is none, you can just write
    //
    //  func getSenatorXMLUrl() -> URL? {
    //      return Bundle.main.url(forResource: "senators", withExtension: "xml")
    //  }
    //
    //
    if let path = Bundle.main.url(forResource: "senators", withExtension: "xml") {
        return path
    } else {
        return nil
    }
}

func getSenators(url: URL) -> ([Senator], [String: [Senator]]){
    let parser = XMLParser(contentsOf: url)
    let parserDelegate = ParserDelegate()
    parser?.delegate = parserDelegate
    parser?.parse()
    
    // 3: You're using Swift 3.2, so you have to do this. But in Swift 4 there's a quicker way:
    //
    //    let senators: [Senator] = parserDelegate.senators
    //    let stateSenatorMap = Dictionary(grouping: senators, by: { senator in senator.state })

    let senators: [Senator] = parserDelegate.senators
    var stateSenatorMap: [String: [Senator]] = [:]
    for senator in senators {
        if let _ = stateSenatorMap[senator.state] {
            stateSenatorMap[senator.state]?.append(senator)
        } else {
            stateSenatorMap[senator.state] = [senator]
        }
    }
    print(stateSenatorMap.count)
    return (senators, stateSenatorMap)
}

