//
//  Availability Manager.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 2/29/24.
//

import Foundation
import CoreData

class AvailabilityManager {
    
    func giveFullAccess() -> Bool {
        if K.needsSubscription == false {
            return true
        } else if K.skm.subscriptionGroupStatus == .subscribed {
            return true
        } else {
            return false
        }
    }
    
    func needsSubscriptionCheck() {
        let mySub:[Subscription]
        let request: NSFetchRequest<Subscription> = Subscription.fetchRequest()
        do {
            mySub = try K.context.fetch(request)
            if mySub == [] {
                let newSub = Subscription(context: K.context)
                newSub.needsSubscription = true
                K.needsSubscription = true
                do {
                    try K.context.save()
                } catch {
                    print("Error saving Subscription Need: \(error)")
                }
            } else {
                K.needsSubscription = mySub[0].needsSubscription
            }
        } catch {
            print("Error loading Recipe: \(error)")
        }
    }
}
