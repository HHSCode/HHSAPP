//
//  StaffDetailViewController.h
//  HHSApp
//
//  Created by Max Greenwald on 3/21/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaffDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    UITableView *staffDetailTableView;
    NSDictionary *theDictionary;
    NSIndexPath *indexP;
}

@property (nonatomic, retain) IBOutlet UITableView *staffDetailTableView;

-(void)setTableViewObjects:(NSDictionary *)dict :(NSIndexPath *)index;

@end
