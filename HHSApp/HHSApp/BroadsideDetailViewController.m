//
//  BroadsideDetailViewController.m
//  HHSApp
//
//  Created by Connor Koehler on 3/19/13.
//  Copyright (c) 2013 Hanover High School. All rights reserved.
//

#import "BroadsideDetailViewController.h"
#import "ActivityViewCustomProvider.h"
#import "ActivityViewCustomActivity.h"
#import "ActivityViewCustomActivityChrome.h"

@interface BroadsideDetailViewController ()

@property (nonatomic, strong) NSString *urlToShare;
@property (nonatomic, strong) NSURL *urlToOpen;
@end

@implementation BroadsideDetailViewController

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
    [self setTitle:@"Article"];
    [self.broadsideDetailWebView setDelegate:self];
    
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *activityButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActivityView)];
    self.navigationItem.rightBarButtonItem = activityButton;
}

-(void)setWebView:(int)indexPath :(NSMutableArray *)stories{
    
    self.urlToShare = [[stories objectAtIndex:indexPath]objectForKey:@"link"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.urlToShare forKey:@"url"];
    //NSLog(@"%@", [[stories objectAtIndex:indexPath]objectForKey:@"link"]);
    //NSLog(@"%@", self.urlToShare);
    NSMutableString *htmlString = [[stories objectAtIndex:indexPath]objectForKey:@"HTML"];
    NSMutableString *date = [[NSMutableString alloc]initWithString:[[stories objectAtIndex:indexPath]objectForKey:@"date"]];

    NSArray *theArray = [[NSArray alloc]init];
    theArray = [date componentsSeparatedByString:@"+"];
    date = [theArray objectAtIndex:0];
    NSMutableString *start = [NSString stringWithFormat:@"<html><body><div id=\"container\" style=\"width:300px\"><center><b>%@</b><br>by %@</center><center>%@</center>", [[stories objectAtIndex:indexPath]objectForKey:@"title"],[[stories objectAtIndex:indexPath]objectForKey:@"author"], date];
        
    NSString *end = @"</div></body></html>";
    NSString *temp = [start stringByAppendingString:htmlString];
    NSString *final = [temp stringByAppendingString:end];
    
    //Very ugly, but makes all images centered
    
    NSArray *otherArray = [final componentsSeparatedByString:@"<img class="];
    NSLog(@"Other Array Count: %i", [otherArray count]);
    if ([otherArray count]>1) {
        
    NSMutableArray *mutOther = [[NSMutableArray alloc]init];
    [mutOther addObject:[otherArray objectAtIndex:0]];
    for (int x = 1; x<[otherArray count]; x++) {
        [mutOther addObject:[NSString stringWithFormat:@"<img class=%@", [otherArray objectAtIndex:x]]];
        
    }
        
        for (int k = 1; k<[mutOther count]; k++) {
            NSString *j = [mutOther objectAtIndex:k];
            NSRange rr2 = [j rangeOfString:@"src=\""];
            NSRange rr3 = [j rangeOfString:@"\" width"];
            int lengt = rr3.location - rr2.location - rr2.length;
            int location = rr2.location + rr2.length;
            NSRange aa;
            aa.location = location;
            aa.length = lengt;
            NSString *temp123 = [j substringWithRange:aa];
           
            NSRange rr4 = [j rangeOfString:@"<img class="];
            NSRange rr5 = [j rangeOfString:@"\" />"];
            int lengt2 = rr5.location - rr4.location - rr4.length;
            int location2 = rr4.location + rr4.length;
            NSRange aa2;
            aa2.location = location2;
            aa2.length = lengt2;
            NSString *temp1234 = [j substringWithRange:aa2];
        
            
            
            
            NSString *end = [NSString stringWithFormat:@"\"\" src=\"%@\" style=\"width:100%%", temp123];
            NSString *theEnd = [j stringByReplacingOccurrencesOfString:temp1234 withString:end];

            
            
            
            [mutOther replaceObjectAtIndex:k withObject:theEnd];
        }
        
        final = [mutOther componentsJoinedByString:@""];
    }
    
    NSArray *otherArray2 = [final componentsSeparatedByString:@"<div id=\"attachment"];
    NSLog(@"Other Array 2 Count: %i", [otherArray2 count]);
    if ([otherArray2 count]>1) {
        
        NSMutableArray *mutOther = [[NSMutableArray alloc]init];
        [mutOther addObject:[otherArray2 objectAtIndex:0]];
        for (int x = 1; x<[otherArray2 count]; x++) {
            [mutOther addObject:[NSString stringWithFormat:@"<div id=\"attachment%@", [otherArray2 objectAtIndex:x]]];
            
        }
        
        for (int k = 1; k<[mutOther count]; k++) {
            NSString *j = [mutOther objectAtIndex:k];
            NSRange rr2 = [j rangeOfString:@"<div id=\"attachment"];
            NSRange rr3 = [j rangeOfString:@"\">"];
            int lengt = rr3.location - rr2.location - rr2.length;
            int location = rr2.location + rr2.length;
            NSRange aa;
            aa.location = location;
            aa.length = lengt;
            NSString *temp123 = [j substringWithRange:aa];
            NSLog(@"Temp123: %@", temp123);

            
            NSString *theEnd = [j stringByReplacingOccurrencesOfString:temp123 withString:@""];
            
            
            
            
            [mutOther replaceObjectAtIndex:k withObject:theEnd];
        }
        
        final = [mutOther componentsJoinedByString:@""];
    }

    /*
    
    for (int k = 0; k<[mutOther count]; k++) {
        NSString *j = [mutOther objectAtIndex:k];
        NSRange rr2 = [final rangeOfString:@"width=\""];
        NSRange rr3 = [final rangeOfString:@"\" height"];
        int lengt = rr3.location - rr2.location - rr2.length;
        int location = rr2.location + rr2.length;
        NSRange aa;
        aa.location = location;
        aa.length = lengt;
        NSString *temp123 = [final substringWithRange:aa];
        float w =[temp123 floatValue];
        
        NSRange rr4 = [final rangeOfString:@"height=\""];
        NSRange rr5 = [final rangeOfString:@"\" />"];
        int lengt2 = rr5.location - rr4.location - rr4.length;
        int location2 = rr4.location + rr4.length;
        NSRange aa2;
        aa2.location = location2;
        aa2.length = lengt2;
        NSString *temp1234 = [final substringWithRange:aa2];
        float h= [temp1234 floatValue];
        NSLog(@"W: %g\nH: %g", w, h);
        NSLog(@"Temp1234: %@", temp1234);
        
        
        NSString *end = [j stringByReplacingOccurrencesOfString:temp123 withString:@"300"];

        NSString *theEnd = [end stringByReplacingOccurrencesOfString:temp1234 withString:[NSString stringWithFormat:@"%g", (300*h)/w]];
        
        
        
        
        [mutOther replaceObjectAtIndex:k withObject:theEnd];
    }
    
    final = [mutOther componentsJoinedByString:@""];
    }
     
     */

    NSLog(@"HTML: %@", final);
    
    [final rangeOfString:@"<a"];
    [self.broadsideDetailWebView loadHTMLString:final baseURL:nil];
}

- (NSString *)getURL{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.urlToShare = [defaults valueForKey:@"url"];
    return self.urlToShare;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showActivityView
{
    //ActivityViewCustomProvider *customProvider = [[ActivityViewCustomProvider alloc]init];
    ActivityViewCustomActivity *ca = [[ActivityViewCustomActivity alloc]init];
    ActivityViewCustomActivityChrome *ca2 = [[ActivityViewCustomActivityChrome alloc]init];
    NSString *textToShare = @"Check out this HHS Broadside article!";
    UIImage *imageToShare = [UIImage imageNamed:@"icon_iphone.png"];
    NSArray *activityItems = [[NSArray alloc]initWithObjects:textToShare, imageToShare, self.urlToShare, nil];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:[NSArray arrayWithObjects:ca,ca2,nil]];
    activityVC.excludedActivityTypes = [[NSArray alloc]initWithObjects:UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll, nil];
    [self presentViewController:activityVC animated:TRUE completion:^{}];
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Open in browser?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Chrome", @"Safari", nil];
        self.urlToOpen = [inRequest URL];
        [alert show];
    
        //[[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 2) {
        [[UIApplication sharedApplication]openURL:self.urlToOpen];
        
        
    }else if(buttonIndex == 1){
        NSArray *array = [[self.urlToOpen absoluteString]componentsSeparatedByString:@"://"];
        
        NSString *theURL = [NSMutableString stringWithFormat:@"googlechrome://%@", [array objectAtIndex:1]];
        [[UIApplication sharedApplication ]openURL:[NSURL URLWithString:theURL]];
    }
}


@end
