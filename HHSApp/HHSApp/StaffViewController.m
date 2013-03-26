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
@synthesize staffTableView, rssParser, activityIndicator, disableViewOverlay, theSearchBar, activityIndicatorStaff;
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
    theSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 320.0, 44.0)];
    theSearchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 44.0)];
    searchBarView.autoresizingMask = 0;
    theSearchBar.delegate = self;
    [searchBarView addSubview:theSearchBar];
    self.navigationItem.titleView = searchBarView;
    
    self.disableViewOverlay = [[UIView alloc]
                               initWithFrame:CGRectMake(0.0f,44.0f,320.0f,416.0f)];
    self.disableViewOverlay.backgroundColor=[UIColor blackColor];
    self.disableViewOverlay.alpha = 0;

   
    reach.reachableBlock = ^(Reachability*reach)
    {
        NSLog(@"Reachable");
        
        if(stories){
            
        }else{
            
        
        [self performSelectorInBackground:@selector(parseXMLFileAtURL:) withObject:@"http://www.lordtechyproductions.com/hhsapp/staff.php"];
        //[self performSelectorInBackground:@selector(parseXMLFileAtURL:) withObject:@"http://feeds.feedburner.com/HHSBroadside"];

        
        [activityIndicatorStaff setHidden:NO];
        

        [activityIndicatorStaff startAnimating];
        }
        
        

    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        //NSLog(@"UNREACHABLE!");
        [activityIndicator setHidden:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"No internet connection! Please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [activityIndicatorStaff setHidden:YES];

        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        //[self.tabBarController setSelectedIndex:0];
        
    };
    [reach startNotifier];
   
}

//SEARCH BAR


/*
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    // We don't want to do anything until the user clicks
    // the 'Search' button.
    // If you wanted to display results as the user types
    // you would do that here.
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // searchBarTextDidBeginEditing is called whenever
    // focus is given to the UISearchBar
    // call our activate method so that we can do some
    // additional things when the UISearchBar shows.
    [self searchBar:searchBar activate:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    // searchBarTextDidEndEditing is fired whenever the
    // UISearchBar loses focus
    // We don't need to do anything here.
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // Clear the search text
    // Deactivate the UISearchBar
    searchBar.text=@"";
    [self searchBar:searchBar activate:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // Do the search and show the results in tableview
    // Deactivate the UISearchBar
	
    // You'll probably want to do this on another thread
    // SomeService is just a dummy class representing some
    // api that you are using to do the search
    NSArray *results = [SomeService doSearch:searchBar.text];
	
    [self searchBar:searchBar activate:NO];
	
    [self.tableData removeAllObjects];
    [self.tableData addObjectsFromArray:results];
    [self.staffTableView reloadData];
}

// We call this when we want to activate/deactivate the UISearchBar
// Depending on active (YES/NO) we disable/enable selection and
// scrolling on the UITableView
// Show/Hide the UISearchBar Cancel button
// Fade the screen In/Out with the disableViewOverlay and
// simple Animations
- (void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active{
    self.staffTableView.allowsSelection = !active;
    self.staffTableView.scrollEnabled = !active;
    if (!active) {
        [disableViewOverlay removeFromSuperview];
        [searchBar resignFirstResponder];
    } else {
        self.disableViewOverlay.alpha = 0;
        [self.view addSubview:self.disableViewOverlay];
		
        [UIView beginAnimations:@"FadeIn" context:nil];
        [UIView setAnimationDuration:0.5];
        self.disableViewOverlay.alpha = 0.6;
        [UIView commitAnimations];
		
        // probably not needed if you have a details view since you
        // will go there on selection
        NSIndexPath *selected = [self.staffTableView
                                 indexPathForSelectedRow];
        if (selected) {
            [self.staffTableView deselectRowAtIndexPath:selected
                                             animated:NO];
        }
    }
    [searchBar setShowsCancelButton:active animated:YES];
}*/



//PARSE

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
	[errorAlert show];
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
        currentPhone = [[NSMutableString alloc]init];
        
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
        [item setObject:currentPhone forKey:@"phone"];
        
        
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
    }else if ([currentElement isEqualToString:@"phone"]){
        [currentPhone appendString:string];
    }
	// save the characters for the current item...
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
	//NSLog(@"all done!");
	//NSLog(@"stories array has %d items", [stories count]);
    
    //NSLog(@"Stories: %@", stories);
    [activityIndicatorStaff stopAnimating];
    [activityIndicatorStaff setHidden:YES];
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
    
    sortedDepartments = [objs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *s1 = [obj1 substringToIndex:1];
        NSString *s2 = [obj2 substringToIndex:1];
        BOOL b1 = [s1 canBeConvertedToEncoding:NSISOLatin1StringEncoding];
        BOOL b2 = [s2 canBeConvertedToEncoding:NSISOLatin1StringEncoding];
        
        if ((b1 == b2) && b1) {//both number or latin char
            NSRange r1 = [s1 rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
            NSRange r2 = [s2 rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
            if (r1.location == r2.location ) { // either both start with a number or both with a letter
                return [obj1 compare:obj2 options:NSDiacriticInsensitiveSearch|NSCaseInsensitiveSearch];
            } else {  // one starts wit a letter, the other with a number
                if ([s1 rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location == NSNotFound) {
                    return NSOrderedAscending;
                }
                return NSOrderedDescending;
            }
        } else if((b1 == b2) && !b1){ // neither latin char
            return [obj1 compare:obj2 options:NSDiacriticInsensitiveSearch|NSCaseInsensitiveSearch];
        } else { //one is latin char, other not
            if (b1) return NSOrderedAscending;
            return NSOrderedDescending;
        }
        
    }];
    //sortedDepartments =[objs sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 77;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StaffView";
    
    StaffViewCell *cell = (StaffViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StaffViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSString *department = [sortedDepartments objectAtIndex:indexPath.section];
    NSDictionary *names = [departmentDict objectForKey:department];
    NSArray *list = [names allKeys];
    NSArray *sortedList = [list sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableString *staffName = [NSMutableString stringWithFormat:@"%@%@",[[names objectForKey:[sortedList objectAtIndex:[indexPath row]]]objectForKey:@"first"], [[names objectForKey:[sortedList objectAtIndex:[indexPath row]]]objectForKey:@"last"]];
    //NSLog(@"%@",staffName);
    NSMutableString *detailString = [NSMutableString stringWithFormat:@"%@",[[names objectForKey:[sortedList objectAtIndex:[indexPath row]]]objectForKey:@"title"]];
    //NSLog(@"%@",detailString);
    //NSLog(@"%@",cell.title.text);
    //NSLog(@"%@",cell.detail.text);
    cell.topLabel.text = staffName;
    cell.bottomLabel.text = detailString;
    //NSLog(@"%@",cell.title.text);
    //NSLog(@"%@",cell.detail.text);
    
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
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
    StaffDetailViewController *staffDetail = [[StaffDetailViewController alloc]initWithNibName:@"StaffDetailViewController" bundle:nil];
    [staffDetail setTitle:@"Info"];
    [self.navigationController pushViewController:staffDetail animated:YES];
    [staffDetail setTableViewObjects:departmentDict :indexPath :sortedDepartments];
    
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
