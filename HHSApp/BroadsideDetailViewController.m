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
    // Do any additional setup after loading the view from its nib.
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
    
    NSMutableString *end = @"</body></html>";
    NSString *temp = [start stringByAppendingString:htmlString];
    NSString *temp2 = [temp stringByAppendingString:end];
    [broadsideDetailWebView loadHTMLString:temp2 baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
