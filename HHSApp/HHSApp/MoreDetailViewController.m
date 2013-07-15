//
//  MoreDetailViewController.m
//  HHSApp
//
//  Created by James Owens on 3/21/13.
//  Copyright (c) 2013 Hanover High School. All rights reserved.
//

#import "MoreDetailViewController.h"

@interface MoreDetailViewController ()
@property (nonatomic, retain) NSURL *URL;

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
    UIBarButtonItem *openInSafari = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openInSafari)];
    [self.navigationItem setRightBarButtonItem:openInSafari];
    [self.moreDetailWebView setDelegate:self];

    [self.moreDetailWebView setScalesPageToFit:YES];
}

-(void)loadWebPageWithTitle:(NSString *)title atURL:(NSURL *)url{
    self.URL = url;
    NSLog(@"Abs:%@", [url absoluteString]);
     NSURLRequest *myRequest = [NSURLRequest requestWithURL:url];
    if ([title isEqualToString:@"Handbook"]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"handbook" ofType:@"pdf"];
        NSURL *targetURL = [NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
        [self.moreDetailWebView loadRequest:request];
    }else if ([title isEqualToString:@"Program of Studies"]){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"programofstudies0" ofType:@"pdf"];
        NSURL *targetURL = [NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
        [self.moreDetailWebView loadRequest:request];
    }else{
        [self.moreDetailWebView loadRequest:myRequest];
 
    }
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

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.act startAnimating];
    [self.act setHidden:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.act stopAnimating];
    [self.act setHidden:YES];
}

-(void)openInSafari{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Open page in browser?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Chrome", @"Safari", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 2) {
        [[UIApplication sharedApplication]openURL:self.URL];
        
        
    }else if(buttonIndex == 1){
        NSArray *array = [[self.URL absoluteString]componentsSeparatedByString:@"://"];
        NSLog(@"Array: %@", array);
        
        NSString *theURL = [NSMutableString stringWithFormat:@"googlechrome://%@", [array objectAtIndex:1]];
        [[UIApplication sharedApplication ]openURL:[NSURL URLWithString:theURL]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
