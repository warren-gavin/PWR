//
//  ParserDelegate.swift
//  PWR
//
//  Created by Amber Spadafora on 10/3/17.
//  Copyright © 2017 Amber Spadafora. All rights reserved.
//

import Foundation

// 1: Maybe rename to XMLParserDelegate so it is more obvious elsewhere in the code what kind of parser this is?
// You might think that's not possible seeing as there is already an XMLParserDelegate protocol, but we can get around
// that like this:
//
//    class XMLParserDelegate: NSObject, Foundation.XMLParserDelegate {
//
class ParserDelegate: NSObject, XMLParserDelegate {
    
    // 1: This is unnecessary
    override init(){
        super.init()
    }
    
    private var currentString =  String()
    private var currentElement = String()
    private var object: [String: String] = [:]
    private var objArray: [[String: String]] = []
    var senators: [Senator] = []
    var finishedParsing: Bool = false
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName != "member" {
            // 1: Style discussion
            //
            // You don't need to use 'self.' everywhere. I used to use it and it was find, but recently
            // stopped using it and I'm much happier with my code. But it's all about what you're happy with.
            //
            // However, in closures you need to use 'self.', so if you get into the habit of leaving out the
            // self then the compiler will remind you to use them in closures, which in turn will remind you
            // to make sure you're using either [unowned self] or [weak self] to avoid retain cycles where necessary
            self.currentElement = elementName
            self.object[self.currentElement] = String()
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "member" {
            self.objArray.append(self.object)
            self.object = [:]
        }
        if elementName == self.currentElement {
            self.object[self.currentElement] = self.currentString.trimmingCharacters(in: .whitespacesAndNewlines)
            self.currentString = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.currentString += string
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("finished parsing documnet") // 0: Typo "document"
        print(self.objArray.count)
        
        // 3: You can do this all in one line using some functional programming swifty wizardy
        //
        //    self.senators = objArray.flatMap(Senator.init)
        //
        var tempArr: [Senator] = []
        for obj in objArray {
            guard let sen = Senator(dict: obj) else { return }
            tempArr.append(sen)
        }
        self.senators = tempArr
        self.finishedParsing = true
    }
}


