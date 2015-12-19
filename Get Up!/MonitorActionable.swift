//
//  MonitorActionable.swift
//  Get Up!
//
//  Created by user on 12/17/15.
//  Copyright (c) 2015 northernlights. All rights reserved.
//

import Foundation

/*
 * A MonitorActionable implements the action() function which performs
 * some action based on an event, such as a timer.
 */
protocol MonitorActionable {
	
	/*
	 * An action to take; called by the Monitor.
	 */
	func action() -> Void
	
	/*
	 * A tear-down method when the Monitor is done with this object.
	 */
	func destroy() -> Void
}