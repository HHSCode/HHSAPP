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
@synthesize moreDetailWebView, button, act;
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
    [moreDetailWebView setDelegate:self];

    [moreDetailWebView setScalesPageToFit:YES];
}

-(void)loadWebPageWithTitle:(NSString *)title atURL:(NSURL *)url{
     NSURLRequest *myRequest = [NSURLRequest requestWithURL:url];
    [moreDetailWebView loadRequest:myRequest];
    [act startAnimating];
    [act setHidden:NO];
}

- (IBAction)goBack:(id)sender {
    [moreDetailWebView goBack];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [act stopAnimating];
    [act setHidden:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [act stopAnimating];
    [act setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
