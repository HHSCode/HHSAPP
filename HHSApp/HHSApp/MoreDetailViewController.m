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

-(void)localPDFdisplay:(NSString *)title atURL:(NSURL *)url{
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        
        NetworkStatus status = [reach currentReachabilityStatus];
        
        if(status == NotReachable)
        {
            //No internet
        }
        else if (status == ReachableViaWiFi)
        {
            NSLog(@"Wifi");
            //if connected to wifi, download latest copy of the documents
            if ([title isEqualToString:@"Handbook"]) {
                NSLog(@"Handbook");
                NSLog(@"%@", url);

                NSString* fileToSaveTo = @"handbook";
                NSArray* path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString* documentsDirectory = [path objectAtIndex:0];
                NSData* data = [NSData dataWithContentsOfURL:url];
                NSLog(@"Downloaded Handbook");
                [data writeToFile:[NSString stringWithFormat:@"%@/%@.pdf",documentsDirectory,fileToSaveTo] atomically:YES];
                NSLog(@"Downloaded and saved Handbook");
            }else if ([title isEqualToString:@"Program of Studies"]){
                NSString* fileToSaveTo = @"programofstudies";
                NSArray* path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString* documentsDirectory = [path objectAtIndex:0];
                NSData* data = [NSData dataWithContentsOfURL:url];
                [data writeToFile:[NSString stringWithFormat:@"%@/%@.pdf",documentsDirectory,fileToSaveTo] atomically:YES];
                NSLog(@"Downloaded and saved Program of Studies");

            }
            
        }
        else if (status == ReachableViaWWAN)
        {
                       
        }
        
                
        
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        
    };
    
    [reach startNotifier];
    if ([title isEqualToString:@"Handbook"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"handbook.pdf"];
        
        NSURL *url = [NSURL URLWithString:filePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.moreDetailWebView loadRequest:request];
        NSLog(@"Displaying Handbook");
    }else if ([title isEqualToString:@"Program of Studies"]){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"programofstudies.pdf"];
        
        NSURL *url = [NSURL URLWithString:filePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.moreDetailWebView loadRequest:request];
        NSLog(@"Displaying Program of Studies");

    }
    
    
}

-(void)loadWebPageWithTitle:(NSString *)title atURL:(NSURL *)url{
    self.URL = url;
     NSURLRequest *myRequest = [NSURLRequest requestWithURL:url];
    /*if ([title isEqualToString:@"Handbook"]||[title isEqualToString:@"Program of Studies"]) {
        [self localPDFdisplay:title atURL:url];
    }else{
        [self.moreDetailWebView loadRequest:myRequest];

    }*/ //code to display local pdfs
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
