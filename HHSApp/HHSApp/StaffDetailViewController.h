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
    UITableView *staffDetailTableView;
    NSDictionary *theDictionary;
    NSIndexPath *indexP;
    NSString *firstName;
    NSString *lastName;
    NSString *department;
    NSString *email;
    NSString *title;
    NSString *url;
    NSString *phone;
    NSString *phoneOrig;
}

@property (nonatomic, retain) IBOutlet UITableView *staffDetailTableView;

-(void)setTableViewObjects:(NSDictionary *)dict :(NSIndexPath *)index :(NSArray *)sortedDepartments;

@end
