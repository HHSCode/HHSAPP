//
//  ActivityViewCustomProvider.m
//  HHSApp
//
//  Created by Connor Koehler on 3/19/13.
//  Copyright (c) 2013 Hanover High School. All rights reserved.
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