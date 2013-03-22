//
//  ActivityViewCustomProvider.m
//  HHSApp
//
//  Created by Sudikoff Lab iMac on 3/22/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import "ActivityViewCustomProvider.h"

@implementation ActivityViewCustomProvider

#pragma mark - UIActivityItemSource

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@", activityType);
    return [super activityViewController:activityViewController itemForActivityType:activityType];
}

@end