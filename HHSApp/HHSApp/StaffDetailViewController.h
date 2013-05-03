//
//  StaffDetailViewController.h
//  HHSApp
//
//  Created by Max Greenwald on 3/21/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface StaffDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>{
    
}

@property (nonatomic, strong) IBOutlet UITableView *staffDetailTableView;

-(void)setTableViewObjects:(NSDictionary *)dict :(NSIndexPath *)index :(NSArray *)sortedDepartments;

@end
