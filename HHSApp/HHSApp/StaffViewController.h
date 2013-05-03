//
//  StaffViewController.h
//  HHSApp
//
//  Created by Connor Koehler on 3/18/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "StaffDetailViewController.h"
#import "StaffViewCell.h"

@interface StaffViewController : UIViewController<NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

//all instance variables should be used only as properties. private instance variables have been moved to the .m file's private interface

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITableView *staffTableView;

@property (nonatomic, strong) IBOutlet NSXMLParser * rssParser;
@property(strong) UIView *disableViewOverlay;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorStaff;

@property (nonatomic, strong) IBOutlet UISearchBar *theSearchBar;

- (void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active;

-(void)parseStoryArray;
- (void)parseXMLFileAtURL:(NSString *)URL;
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;
-(void)reachChanged;

@end
