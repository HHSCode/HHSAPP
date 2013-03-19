//
//  StaffViewController.m
//  HHSApp
//
//  Created by Connor Koehler on 3/18/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import "StaffViewController.h"

@interface StaffViewController ()

@end

@implementation StaffViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"app_background.png"]];
    [super viewDidLoad];
    NSString *absoluteURL = @"https://sites.google.com/a/hanovernorwichschools.org/connor/file/HHSAPP.csv?attredirects=0&d=1";
    NSURL *url = [NSURL URLWithString:absoluteURL];
    NSString *fileString = [[NSString alloc] initWithContentsOfURL:url];
    
    
    
    NSArray *contentArray = [fileString componentsSeparatedByString:@"\r"];
    //NSLog(@"%@", contentArray);
    for (NSString *item in contentArray) {
        NSArray *itemArray = [item componentsSeparatedByString:@";"];
        
        //NSLog(@"String -----> %@",[itemArray objectAtIndex:0]);

    
	// Do any additional setup after loading the view.
}
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
