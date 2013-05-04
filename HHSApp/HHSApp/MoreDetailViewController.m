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
    [self.moreDetailWebView setDelegate:self];

    [self.moreDetailWebView setScalesPageToFit:YES];
}

-(void)loadWebPageWithTitle:(NSString *)title atURL:(NSURL *)url{
     NSURLRequest *myRequest = [NSURLRequest requestWithURL:url];
    [self.moreDetailWebView loadRequest:myRequest];
    [self.act startAnimating];
    [self.act setHidden:NO];
}

- (IBAction)goBack:(id)sender {
    [self.moreDetailWebView goBack];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.act stopAnimating];
    [self.act setHidden:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.act stopAnimating];
    [self.act setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
