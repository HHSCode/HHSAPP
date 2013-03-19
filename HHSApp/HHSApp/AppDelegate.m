//
//  AppDelegate.m
//  HHSApp
//
//  Created by Connor Koehler on 2/7/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import "AppDelegate.h"


//************************
//From John: Did you reset, or am i just seeing things?
//************************

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    
    tabBarItem1.title = @"Stopwatch";
    tabBarItem2.title = @"History";
    tabBarItem3.title = @"Calculator";
    tabBarItem4.title = @"More";
    
    [tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"stopwatch-silhouette-md.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"stopwatch-silhouette-mdselected.png"]];
    [tabBarItem1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    
    
    [tabBarItem2 setFinishedSelectedImage:[UIImage imageNamed:@"History_black.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"History_grey.png"]];
    [tabBarItem2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    
    
    [tabBarItem3 setFinishedSelectedImage:[UIImage imageNamed:@"calculator_black.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"calculator_grey.png"]];
    [tabBarItem3 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    
    
    [tabBarItem4 setFinishedSelectedImage:[UIImage imageNamed:@"more_black.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"more_gray.png"]];
    [tabBarItem4 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
