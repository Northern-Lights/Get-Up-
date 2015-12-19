//
//  NotificationAlerter.swift
//  Get Up!
//
//  Created by user on 12/17/15.
//  Copyright (c) 2015 northernlights. All rights reserved.
//

import Foundation

/*
 * The NotificationAlerter will send alerts via the Notification Center.
 * It conforms to MonitorActionable so that its actions can be controlled
 * by a monitoring class.
 */
class NotificationAlerter: NSObject, MonitorActionable {
	
	var notificationCenter = NSUserNotificationCenter.defaultUserNotificationCenter()
	private var delegate = NotificationCenterDelegate()
	
	override init() {
		notificationCenter.delegate = delegate
	}
	
	/*
	 * Action: Send the user a notification.
	 */
	func action() -> Void {
		NSLog("action()")
		var notification = NSUserNotification();
		notification.title = "Get up!"
		notification.informativeText = "Get your fat ass moving!"
		notification.hasActionButton = false
		notificationCenter.deliverNotification(notification)
	}
	
	/*
	 * If we are no longer using this MonitorActionable, then
	 * invoke this method to unschedule any queued notifications.
	 */
	func destroy() -> Void {
		NSLog("destroy()")
		notificationCenter.scheduledNotifications = []
	}
	
	//The delegate to perform actions if/when any notification buttons are pressed.
	private
	class NotificationCenterDelegate:
		NSObject, NSUserNotificationCenterDelegate {
		
		//Why is the default for these methods private?
		func userNotificationCenter(center: NSUserNotificationCenter, didActivateNotification notification: NSUserNotification) {
			NSLog("delegate: activate")
		}
		
		func userNotificationCenter(center: NSUserNotificationCenter, didDeliverNotification notification: NSUserNotification) {
			NSLog("delegate: did deliver")
		}
		
		func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
			NSLog("delegate: should deliver")
			return true
		}
	}
}