//
//  AppDelegate.h
//  HHSApp
//
//  Created by Connor Koehler on 2/7/13.
//  Copyright (c) 2013 Hanover High School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

//this makes a warning. the comments below explain how to find an exception.
#warning IN_CASE_OF_UNCAUGHT_EXCEPTION
//open menu on left. open breakpoint tab.
//at the bottom, click "+" and make an exception breakpoint. Click done.
//run again and try to crash the app. Xcode will show where the problem is.
//unfortunately, the breakpoint will not remain or be transmitted over github.