//
//  StaffViewController.h
//  HHSApp
//
//  Created by Connor Koehler on 3/18/13.
//  Copyright (c) 2013 Hanover High School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "StaffDetailViewController.h"
#import "StaffViewCell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface StaffViewController : UITableViewController <NSXMLParserDelegate, UISearchBarDelegate>

//all instance variables should be used only as properties. private instance variables have been moved to the .m file's private interface

@property (nonatomic, strong) IBOutlet NSXMLParser * rssParser;

//I think the tableview should always be active
//@property(strong) UIView *disableViewOverlay;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorStaff;

@property (nonatomic, strong) IBOutlet UISearchBar *theSearchBar;

//- (void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active;

-(void)parseStoryArray;
- (void)parseXMLFileAtURL:(NSString *)URL;
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;
//-(void)reachChanged;

@end
