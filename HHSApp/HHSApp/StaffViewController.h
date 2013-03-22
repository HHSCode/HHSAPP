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

@interface StaffViewController : UIViewController<NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
    NSXMLParser *rssParser;
    NSMutableArray *articles;
    NSMutableDictionary *item;
    NSString *currentElement;
    NSMutableString *ElementValue;
    BOOL errorParsing;
    NSMutableArray * stories;
    NSMutableDictionary *departmentDict;
    NSArray *sortedDepartments;
    
    NSMutableString * currentFirstName, * currentLastName, * currentDept, * currentTitle, *currentEmail, *currentSite, *currentPhone;
    UIView *disableViewOverlay;
	
	UISearchBar *theSearchBar;
    
    
}
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITableView *staffTableView;

@property (nonatomic, retain) IBOutlet NSXMLParser * rssParser;
@property(retain) UIView *disableViewOverlay;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorStaff;

@property (nonatomic, retain) IBOutlet UISearchBar *theSearchBar;

- (void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active;

-(void)parseStoryArray;
- (void)parseXMLFileAtURL:(NSString *)URL;
@end
