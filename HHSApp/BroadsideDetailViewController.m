//
//  BroadsideDetailViewController.m
//  HHSApp
//
//  Created by Sudikoff Lab iMac on 3/19/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import "BroadsideDetailViewController.h"


@interface BroadsideDetailViewController ()

@end

@implementation BroadsideDetailViewController
@synthesize broadsideDetailWebView, theTextView;

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
    [broadsideDetailWebView setDelegate:self];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *activityButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActivityView:)];
    self.navigationItem.rightBarButtonItem = activityButton;
}

-(void)setWebView:(int)indexPath :(NSMutableArray *)stories{
    [self setTitle:[[stories objectAtIndex:indexPath]objectForKey:@"title"]];
    //NSLog(@"%@", [[stories objectAtIndex:indexPath]objectForKey:@"HTML"]);
    NSMutableString *htmlString = [[stories objectAtIndex:indexPath]objectForKey:@"HTML"];
    NSMutableString *date = [[NSMutableString alloc]initWithString:[[stories objectAtIndex:indexPath]objectForKey:@"date"]];

    NSArray *theArray = [[NSArray alloc]init];
    theArray = [date componentsSeparatedByString:@"+"];
    date = [theArray objectAtIndex:0];
    NSMutableString *start = [NSString stringWithFormat:@"<html><body><center>by %@</center><center>%@</center>", [[stories objectAtIndex:indexPath]objectForKey:@"author"], date];
    
    NSString *end = @"</body></html>";
    NSString *temp = [start stringByAppendingString:htmlString];
    NSString *final = [temp stringByAppendingString:end];
    NSLog(@"HTML: %@", final);
    
    [final rangeOfString:@"<a"];
    
    [broadsideDetailWebView loadHTMLString:final baseURL:nil];
}

- (IBAction)showActivityView:(id)sender
{
    NSArray *activityItems = [NSArray array];
    NSArray *applicationActivities = [NSArray array];
    UIActivityViewController *activityView = [[UIActivityViewController alloc]initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities];
//    [activityView showInView:self.broadsideDetailWebView];
}

/*-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSURL *url = [ [ NSURL alloc ] initWithString: @"http://www.facebook.com/HHSBroadside?fref=ts" ];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    if(buttonIndex == 1)
    {
        NSURL *url = [ [ NSURL alloc ] initWithString: @"http://broadside.dresden.us/" ];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    if(buttonIndex == 2)
    {
        NSURL *url = [ [ NSURL alloc ] initWithString: @"googlechrome://broadside.dresden.us/" ];
        [[UIApplication sharedApplication] openURL:url];
        
    }
}*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
