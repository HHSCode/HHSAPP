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

/*NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com/"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];

// create the connection with the request

// and start loading the data

NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];

if (theConnection) {
    
    // Create the NSMutableData to hold the received data.
    
    // receivedData is an instance variable declared elsewhere.
    
    receivedData = [[NSMutableData data] retain];
    
} else {
    
    // Inform the user that the connection failed.
    
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
