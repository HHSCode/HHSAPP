//
//  MoreDetailViewController.m
//  HHSApp
//
//  Created by James Owens on 3/21/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import "MoreDetailViewController.h"

@interface MoreDetailViewController ()

@end

@implementation MoreDetailViewController
@synthesize moreDetailWebView, button;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    [moreDetailWebView setScalesPageToFit:YES];
}

-(void)loadWebPageWithTitle:(NSString *)title atURL:(NSURL *)url{
     NSURLRequest *myRequest = [NSURLRequest requestWithURL:url];
    [moreDetailWebView loadRequest:myRequest];
}

- (IBAction)goBack:(id)sender {
    [moreDetailWebView goBack];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
