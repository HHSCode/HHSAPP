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
@synthesize staffTableView, rssParser, activityIndicator;
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
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    // set the blocks
   
    reach.reachableBlock = ^(Reachability*reach)
    {
        NSLog(@"Reachable");
        
        
        [self performSelectorInBackground:@selector(parseXMLFileAtURL:) withObject:@"http://www.lordtechyproductions.com/hhsapp/index.php"];
        //[self performSelectorInBackground:@selector(parseXMLFileAtURL:) withObject:@"http://feeds.feedburner.com/HHSBroadside"];

        
        [activityIndicator setHidden:NO];
        

        [activityIndicator startAnimating];
        

    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        //NSLog(@"UNREACHABLE!");
        [activityIndicator setHidden:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"No internet connection! Please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        //[alert performSelectorOnMainThread:@selector(parsef) withObject:nil waitUntilDone:YES];
        
    };
    [reach startNotifier];
   
}

- (void)parseXMLFileAtURL:(NSString *)URL {
    NSLog(@"Parsing");
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
	//NSLog(@"found file and started parsing");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i ). Please try again later.", [parseError code]];
	//NSLog(@"error parsing XML: %@", errorString);
    
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	//[errorAlert show];
    NSLog(@"Error");
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	currentElement = [elementName copy];
    //NSLog(@"Current Element: %@", currentElement);
	if ([elementName isEqualToString:@"firstname"]) {
		item = [[NSMutableDictionary alloc] init];
        //currentFirstName, * currentLastName, * currentDept, * currentTitle, *currentEmail, *currentSite
		currentFirstName = [[NSMutableString alloc] init];
		currentLastName = [[NSMutableString alloc] init];
		currentDept = [[NSMutableString alloc] init];
		currentTitle = [[NSMutableString alloc] init];
        currentEmail = [[NSMutableString alloc]init];
        currentSite = [[NSMutableString alloc]init];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
	//NSLog(@"ended element: %@", elementName);
    
	if ([elementName isEqualToString:@"firstname"]) { //change this back to id
		// save values to an item, then store that item into the array...
        //NSLog(@"item: %@", item);
        [item setObject:currentFirstName forKey:@"first"];
		[item setObject:currentLastName forKey:@"last"];
		[item setObject:currentDept forKey:@"dept"];
        [item setObject:currentTitle forKey:@"title"];
        [item setObject:currentEmail forKey:@"email"];
        [item setObject:currentSite forKey:@"site"];
        
        
		[stories addObject:[item copy]];
    }
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    //NSLog(@"%@: %@", currentElement, string);
    if ([currentElement isEqualToString:@"firstname"]){
        [currentFirstName appendString:string];
    }else if ([currentElement isEqualToString:@"lastname"]) {
		[currentLastName appendString:string];
    }else if ([currentElement isEqualToString:@"dept"]) {
		[currentDept appendString:string];
    }else if ([currentElement isEqualToString:@"title"]){
        [currentTitle appendString:string];
    }else if ([currentElement isEqualToString:@"email"]){
        [currentEmail appendString:string];
    }else if ([currentElement isEqualToString:@"site"]){
        [currentSite appendString:string];
    }
	// save the characters for the current item...
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
	//NSLog(@"all done!");
	//NSLog(@"stories array has %d items", [stories count]);
    
    //NSLog(@"Stories: %@", stories);
    [activityIndicator stopAnimating];
    [activityIndicator setHidden:YES];
    [staffTableView reloadData];
    //NSLog(@"Stories: %@", stories);
    [self parseStoryArray];
    [staffTableView reloadData];
}


-(void)parseStoryArray{
    departmentDict = [[NSMutableDictionary alloc]init];
    for (NSDictionary *person in  stories) {
        
        NSMutableDictionary *singleDepartment = [[NSMutableDictionary alloc]init];

        NSString *department = [person objectForKey:@"dept"];
        if ([departmentDict objectForKey:department]) {
            singleDepartment = [[NSMutableDictionary alloc]initWithDictionary:[departmentDict objectForKey:department]];
            [singleDepartment setObject:person forKey:[person objectForKey:@"last"]];
            [departmentDict setObject:singleDepartment forKey:department];
        }else{
            singleDepartment = [[NSMutableDictionary alloc]init];
            [singleDepartment setObject:person forKey:[person objectForKey:@"last"]];
            [departmentDict setObject:singleDepartment forKey:department];
        }
        
        /*if ([departmentArray containsObject:department]) {
            
            NSMutableArray *singleDepartment = [[NSMutableArray alloc]initWithArray:[departmentArray objectAtIndex:index]];
            
            
            
     
        }else{
            NSMutableArray *singleDepartment = [[NSMutableArray alloc]init];
            departmentArray addObject:
        }*/
    }
    
    
    NSMutableArray *sortedKeys = [NSMutableArray array];
    
    NSArray *objs = [departmentDict allKeys];
    sortedDepartments =[objs sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    
    
    //NSLog(@"Dep: %@", departmentDict);
    //NSLog(@"sorted: %@", sortedDepartments);

}


//TABLEVIEW

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [departmentDict count];
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"Updating table view, stories count: %i", [stories count]);
    //NSLog(@"Section: %i", section);
    //NSLog(@"%@: %i", [sortedDepartments objectAtIndex:section],[[departmentDict objectForKey:[sortedDepartments objectAtIndex:section]]count]);
    return [[departmentDict objectForKey:[sortedDepartments objectAtIndex:section]]count];
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sortedDepartments objectAtIndex:section];
}

/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 200, 40)];
    sectionHeader.backgroundColor = [UIColor clearColor];
    sectionHeader.font = [UIFont boldSystemFontOfSize:20];
    sectionHeader.textColor = [UIColor blackColor];
    sectionHeader.text = [sortedDepartments objectAtIndex:section];
    return sectionHeader;
}*/



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifer = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifer];
    }
    NSString *department = [sortedDepartments objectAtIndex:indexPath.section];
    NSDictionary *names = [departmentDict objectForKey:department];
    NSArray *list = [names allKeys];
    NSArray *sortedList = [list sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSString *staffName = [NSString stringWithFormat:@"%@%@",[[names objectForKey:[sortedList objectAtIndex:[indexPath row]]]objectForKey:@"first"], [[names objectForKey:[sortedList objectAtIndex:[indexPath row]]]objectForKey:@"last"]];
    cell.textLabel.text = staffName;
    cell.detailTextLabel.text = [[names objectForKey:[sortedList objectAtIndex:[indexPath row]]]objectForKey:@"title"];
    
    
    
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

@end
