//
//  StaffDetailViewController.h
//  HHSApp
//
//  Created by Max Greenwald on 3/21/13.
//  Copyright (c) 2013 Hanover High School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>


@interface StaffDetailViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *staffDetailTableView;

-(void)setTableViewObjects:(NSDictionary *)dict :(NSIndexPath *)index :(NSArray *)sortedDepartments;

@end
