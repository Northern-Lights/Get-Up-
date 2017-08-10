//
//  ActivityMonitor.swift
//  Get Up!
//
//  Created by user on 12/15/15.
//  Copyright (c) 2015 northernlights. All rights reserved.
//

import Foundation
import AppKit

/* When we count to inactivityThreshold, we have been inactive for
 * enough minutes that we assume we have taken a break.  Therefore,
 * call off the notification until activity resumes.
 */

/*
 * ActivityMonitor class monitors the system for activity.
 * Activity is used to determine whether the user is at the
 * system to decide whether to display notifications to the
 * user.
 */
class ActivityMonitor: NSObject {
	
	var timer: Timer!					//Timer for monitoring activity
	var monitorInterval: Int
	var actionInterval: Int				//Interval at which the actions will be executed
	var activityCount: Int
	var activityInInterval: Bool		//If we saw activity during the current interval
	var inactivityCount: Int			//So that we can count consecutive inactivities
	var inactivityThreshold: Int		//Number we needed to count to determine active/inactive
	var actionable: MonitorActionable?	//The object that will be able to take an action
	
	//Types of events we consider to be "activity"
//	let eventsToWatch: EventTypeMask =
//		NSEvent.EventTypeMask.mouseMoved |
//		NSEvent.EventTypeMask.flagsChanged |	//Modifier keys only. Printing/char keys require root.
//		NSEvent.EventTypeMask.scrollWheel

	//The monitor that tracks "activity"
	var eventMonitor: AnyObject?
	
	init(_actionInterval: Int, _monitorInterval: Int, _inactivityThreshold: Int) {
		actionInterval = _actionInterval
		monitorInterval = _monitorInterval
		inactivityThreshold = _inactivityThreshold
		activityCount = 0
		activityInInterval = false		//We start off as inactive and let the handler make active.
		inactivityCount = 0
		
		super.init()
		
		setTimers()
		eventMonitor = NSEvent.addGlobalMonitorForEvents(
//			matching: eventsToWatch,
			matching: [.mouseMoved, .flagsChanged, .scrollWheel, .leftMouseDown],
			handler: globalMonitorHandler) as AnyObject
		
		NSLog("ActivityMonitor: initialized")
	}
	
	func registerNewActionable(_ _actionable: MonitorActionable) -> Void {
		if (actionable != nil) {
			actionable?.destroy() }
		actionable = _actionable
	}
	
	func unregisterActionable() -> Void {
		if (actionable != nil) {
			actionable?.destroy()
		}
		actionable = nil
	}
	
	func disable() -> Void {
		unregisterActionable()
		if (timer.isValid) {
			timer.invalidate() }
	}
	
	/*
	 * Initialize the NSTimer to our activity monitoring interval.
	 */
	fileprivate func setTimers() -> Void {
		
		//Set the activityMonitor timer
		let interval: TimeInterval = Double(monitorInterval * 60)
		timer = Timer.scheduledTimer(
			timeInterval: interval,
			target: self,
			selector: #selector(ActivityMonitor.markActivity),
			userInfo: nil,
			repeats: true)
		
		NSLog("setTimer()")
	}
	
	/*
	 * Fire the action when the actionTimer counts down.
	 */
	func fireAction() -> Void {
		NSLog("fireAction()")
		if (actionable != nil) {
			actionable?.action() }
	}
	
	/*
	 * Every monitorInterval counts, we mark if we had no activity,
	 * then we reset the global monitor to see if there is activity
	 * in the next interval.
	 */
	func markActivity() -> Void {
		
		//Activity was handled by the globalMonitorHandler.
		//Inactivity needs to be handled here.
		if (!activityInInterval) {
			inactivityCount += 1
			NSLog("markActivity() -> Inactive")
			NSLog("\tInactivity Count: %d/%d", inactivityCount, inactivityThreshold)
		}
		
		//The activityCount isn't necessarily once a minute...
		//But we will just enforce 1 minute so that 1
		//activityCount is 1 minute, therefore we can directly
		//compare it against the actionInterval
		if (activityCount >= actionInterval) {
			fireAction()
			activityCount = 0
		}
		
		//If the user is inactive, then reset these counts
		//and disable the timer. Let the handler reinstate it on
		//the next activity.
		if (inactivityCount >= inactivityThreshold) {
			NSLog("markActivity() -> passed inactivityThreshold")
			activityCount = 0
			inactivityCount = 0
			timer.invalidate()
		}
		
		//Set default to inactive again until monitor says otherwise. Reset the monitor.
		activityInInterval = false
		if (eventMonitor == nil) {
			NSLog("markActivity() -> Re-establishing monitor")
			eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved, .flagsChanged, .scrollWheel, .leftMouseDown], handler: globalMonitorHandler) as AnyObject
		}
	}
	
	/*
	 * If we detect activity, then inactivityInInterval is 
	 * false in this interval.  Set inactivityCount to zero
	 * since we had the opposite of inactivity, and remove
	 * the monitor since we are done for this interval.
	 */
	func globalMonitorHandler(_ event: NSEvent!) -> Void {
		NSLog("globalMonitorHandler()")
		activityInInterval = true
		activityCount += 1
		activityCount += inactivityCount	//If inactive for a few counts, add back when we become active again.
		inactivityCount = 0
		
		NSLog("\tActivity Count: %d/%d", activityCount, actionInterval)
		
		NSEvent.removeMonitor(eventMonitor!)
		eventMonitor = nil
		
		if (!timer.isValid) {
			setTimers() }
	}
}
