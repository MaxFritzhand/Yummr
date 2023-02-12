//
//  Manager.swift
//  PlopIt
//
//  Created by Raivis Olehno on 08/01/2022.
//

import UIKit

class Manager: NSObject {
    
    var consumers: NSHashTable<AnyObject>? = NSHashTable<AnyObject>.init()
    
    func addConsumer(consumer: AnyObject?) {
        if self.consumers == nil {
            self.consumers = NSHashTable.weakObjects()
        }
        
        if !(self.consumers?.contains(consumer))! {
            self.consumers?.add(consumer)
        }
    }
    
    func removeConsumer(consumer: AnyObject?) {
        self.consumers?.remove(consumer)
    }

}
