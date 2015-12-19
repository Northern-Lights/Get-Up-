//
//  AppDelegate.swift
//  Get Up!
//
//  Created by user on 12/6/15.
//  Copyright (c) 2015 northernlights. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!

	var activityMonitor = ActivityMonitor(
		_actionInterval: 40,
		_monitorInterval: 1,
		_inactivityThreshold: 3)
	var notificationAlerter = NotificationAlerter()
	
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		activityMonitor.registerNewActionable(notificationAlerter)
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		activityMonitor.disable()
	}


}

