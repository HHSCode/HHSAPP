//
//  BroadsideViewController.m
//  HHSApp
//
//  Created by Sudikoff Lab iMac on 3/19/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import "BroadsideViewController.h"

@interface BroadsideViewController ()

@end

@implementation BroadsideViewController
@synthesize broadsideTableView, rssParser, activityIndicator;

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
    [self refreshBroadside];
    [super viewDidLoad];
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self
    action:@selector(refreshView:)
    forControlEvents:UIControlEventValueChanged];
    UITableViewController *tableViewController = [[UITableViewController alloc]init];
    [tableViewController setTableView:broadsideTableView];
    tableViewController.refreshControl = refresh;
}

-(void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Updating Broadside..."];
    //custom refresh logic
    [self refreshBroadside];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
    [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        //NSLog(@"REACHABLE!");
        if([stories count]==0){
            [self performSelectorInBackground:@selector(parseXMLFileAtURL:) withObject:@"http://feeds.feedburner.com/HHSBroadside"];
            [activityIndicator setHidden:NO];
            [activityIndicator startAnimating];
            
        }
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        //NSLog(@"UNREACHABLE!");
        [activityIndicator setHidden:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"No internet connection! Please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        
    };
    
    // start the notifier which will cause the reachability object to retain itself!
    
	// Do any additional setup after loading the view.
}

- (void)refreshBroadside{
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    // set the blocks
    NSLog(@"Ran");
    reach.reachableBlock = ^(Reachability*reach)
    {
        NSLog(@"Reachable");
        stories = [[NSMutableArray alloc] init];
        [broadsideTableView reloadData];
        [self performSelectorInBackground:@selector(parseXMLFileAtURL:) withObject:@"http://feeds.feedburner.com/HHSBroadside"];
        [activityIndicator setHidden:NO];
        [activityIndicator startAnimating];
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"UNREACHABLE!");
        [activityIndicator setHidden:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"No internet connection! Please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        
    };
    [reach startNotifier];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (IBAction)showActionsheetButton:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Safari", @"Chrome", nil];
    [actionSheet showInView:self.broadsideTableView];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
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
}

//PARSING AREA//

- (void)parseXMLFileAtURL:(NSString *)URL {
    
    stories = [[NSMutableArray alloc] init];
    
	//you must then convert the path to a proper NSURL or it won't work
	NSURL *xmlURL = [NSURL URLWithString:URL];
    
	// here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
	// this may be necessary only for the toolchain
	rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
	// Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	[rssParser setDelegate:self];
    
	// Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
	[rssParser setShouldProcessNamespaces:NO];
    
	[rssParser setShouldReportNamespacePrefixes:NO];
    
	[rssParser setShouldResolveExternalEntities:NO];
    
    
	[rssParser parse];
    
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	// (@"found file and started parsing");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i ). Please try again later.", [parseError code]];
	//NSLog(@"error parsing XML: %@", errorString);
    
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	currentElement = [elementName copy];
    //NSLog(@"Current Element: %@", currentElement);
	if ([elementName isEqualToString:@"item"]) {  
		item = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		currentAuthor = [[NSMutableString alloc] init];
		currentSummary = [[NSMutableString alloc] init];
		currentLink = [[NSMutableString alloc] init];
        currentURL = [[NSMutableString alloc]init];
        currentHTML = [[NSMutableString alloc]init];
        currentDate = [[NSMutableString alloc]init];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
	//NSLog(@"ended element: %@", elementName);
    
	if ([elementName isEqualToString:@"item"]) { //change this back to id
		// save values to an item, then store that item into the array...
        //NSLog(@"item: %@", item);
        [item setObject:currentTitle forKey:@"title"];
		[item setObject:currentLink forKey:@"link"];
		[item setObject:currentAuthor forKey:@"author"];
        [item setObject:currentHTML forKey:@"HTML"];
        [item setObject:currentDate forKey:@"date"];
        
        
		[stories addObject:[item copy]];
    }
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if ([currentElement isEqualToString:@"feedburner:origLink"]){
        [currentLink appendString:string];
    }else if ([currentElement isEqualToString:@"title"]) {
		[currentTitle appendString:string];
    }else if ([currentElement isEqualToString:@"dc:creator"]) {
		[currentAuthor appendString:string];
    }else if ([currentElement isEqualToString:@"content:encoded"]){
        [currentHTML appendString:string];
    }else if ([currentElement isEqualToString:@"pubDate"]){
        [currentDate appendString:string];
    }
	// save the characters for the current item...
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
    
    //NSLog(@"Stories: %@", stories);
    [activityIndicator stopAnimating];
    [activityIndicator setHidden:YES];
    [broadsideTableView reloadData];
    
    
}

//TABLEVIEW AREA//

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"Updating table view, stories count: %i", [stories count]);
    
    return [stories count];
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    static NSString *CellIdentifier = @"broadside";
    
    BroadsideCell *cell = (BroadsideCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BroadsideCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    //NSLog(@"Title: %@", [[stories objectAtIndex:[indexPath row]]objectForKey:@"title"]);
    NSMutableString *title = [[NSMutableString alloc]initWithString:[[stories objectAtIndex:[indexPath row]]objectForKey:@"title"]];
    NSMutableString *date = [[NSMutableString alloc]initWithString:[[stories objectAtIndex:[indexPath row]]objectForKey:@"date"]];
    NSMutableString *author2 = [[NSMutableString alloc]initWithString:@"by "];
    
    NSMutableString *author = [[NSMutableString alloc]initWithString:[[stories objectAtIndex:[indexPath row]]objectForKey:@"author"]];
    [author2 appendString:author];
    
    NSArray *theArray = [[NSArray alloc]init];
    theArray = [date componentsSeparatedByString:@"+"];
    date = [theArray objectAtIndex:0];
    //NSString *author = [[stories objectAtIndex:[indexPath row]]objectForKey:@"author"];
    //[label appendString:[NSString stringWithFormat:@" - %@", author]];
    //NSLog(@"Author: %@", author);
    
    
    
    [cell.title setText:title];
    [cell.author setText:author2];
    [cell.date setText:date];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BroadsideDetailViewController *detail = [[BroadsideDetailViewController alloc]initWithNibName:@"BroadsideDetailViewController" bundle:nil];
    [self.navigationController pushViewController:detail animated:YES];
    [detail setWebView:[indexPath row] :stories];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    // Navigation logic may go here. Create and push another view controller.
    /*
      *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
}
@end


