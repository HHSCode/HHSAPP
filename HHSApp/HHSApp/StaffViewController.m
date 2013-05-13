//
//  StaffViewController.m
//  HHSApp
//
//  Created by Connor Koehler on 3/18/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import "StaffViewController.h"

@interface StaffViewController ()

@property (nonatomic, strong) NSMutableArray *articles;
@property (nonatomic, strong) NSMutableDictionary *item;
@property (nonatomic, strong) NSString *currentElement;
@property (nonatomic, strong) NSMutableString *ElementValue;
@property (nonatomic) BOOL errorParsing;
@property (nonatomic, strong) NSMutableArray *stories;

@property (nonatomic, strong) NSMutableDictionary *allDepartmentsDict;
@property (nonatomic, strong) NSArray *allSortedDepartments;
@property (nonatomic, strong) NSMutableDictionary *searchedDepartmentsDict;
@property (nonatomic, strong) NSArray *searchedSortedDepartments;

@property (nonatomic, strong, readonly) NSMutableDictionary *departmentDict;
@property (nonatomic, strong, readonly) NSArray *sortedDepartments;

@property (nonatomic, strong) NSMutableString * currentFirstName, * currentLastName, * currentDept, * currentTitle, *currentEmail, *currentSite, *currentPhone;

@end

@implementation StaffViewController

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
    
    self.theSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 320.0, 44.0)];
    self.theSearchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;//why would width need to be flexible?
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 44.0)];
    searchBarView.autoresizingMask = 0;
    self.theSearchBar.delegate = self;
    [searchBarView addSubview:self.theSearchBar];
    self.navigationItem.titleView = searchBarView;
    
    //self.disableViewOverlay = [[UIView alloc] initWithFrame:self.view.bounds];
    //self.disableViewOverlay.backgroundColor=[UIColor blackColor];
    //self.disableViewOverlay.alpha = 0;
    
    self.activityIndicatorStaff = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorStaff.hidden=NO;
    [self.activityIndicatorStaff startAnimating];
    self.activityIndicatorStaff.center=CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    [self.view addSubview:self.activityIndicatorStaff];

    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    // set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        NSLog(@"Reachable");
        
        if(self.stories){
            
        }else{
            
        
        [self performSelectorInBackground:@selector(parseXMLFileAtURL:) withObject:@"http://www.lordtechyproductions.com/hhsapp/staff.php"];
        //[self performSelectorInBackground:@selector(parseXMLFileAtURL:) withObject:@"http://feeds.feedburner.com/HHSBroadside"];

        
        [self.activityIndicatorStaff setHidden:NO];
        

        [self.activityIndicatorStaff startAnimating];
        }
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        //NSLog(@"UNREACHABLE!");
        [self.activityIndicatorStaff setHidden:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"No internet connection! Please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [self.activityIndicatorStaff setHidden:YES];

        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        //[self.tabBarController setSelectedIndex:0];
        
    };
    [reach startNotifier];
}

//if search is in progress, only return the search results. otherwise return all departments
- (NSMutableDictionary *)departmentDict {
    return self.searchedDepartmentsDict?self.searchedDepartmentsDict:self.allDepartmentsDict;
}
- (NSArray *)sortedDepartments {
    return self.searchedSortedDepartments?self.searchedSortedDepartments:self.allSortedDepartments;
}

//SEARCH BAR
#pragma mark - Search Bar

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    // We don't want to do anything until the user clicks
    // the 'Search' button.
    // If you wanted to display results as the user types
    // you would do that here.
    
    // I will do that now. comment this out (or delete it) if you don't like it
    [self searchForString:searchText];
    [self.tableView reloadData];
    /*if ([self numberOfSectionsInTableView:self.tableView]) {
        [self.disableViewOverlay setFrame:CGRectMake(0, 0, self.tableView.contentSize.width, self.tableView.contentSize.height)];
    }*/
    //make sure the overlay is on top
    
    //[self.tableView performSelector:@selector(addSubview:) withObject:self.disableViewOverlay afterDelay:0];
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
    //stop searching
    self.searchedDepartmentsDict=nil;
    self.searchedSortedDepartments=nil;
    [self searchBar:searchBar activate:NO];
    [self.tableView reloadData];
}

//this method searches for the given text and sets the receiver's sortedDepartmentsDict
- (void)searchForString:(NSString *)string {
    self.searchedDepartmentsDict = [NSMutableDictionary dictionaryWithCapacity:self.allDepartmentsDict.count];
    for (NSString *departmentName in self.allDepartmentsDict) {
        NSDictionary *teachers = self.allDepartmentsDict[departmentName];
        for (NSString *teacherName in teachers) {
            NSDictionary *teacherInfo = teachers[teacherName];
            for (NSString *criterion in [teacherInfo allValues]) {
                
                if ([[criterion lowercaseString] rangeOfString:[string lowercaseString]].length==string.length) {//criterion has string as a substring
                    
                    if (!self.searchedDepartmentsDict[departmentName]) self.searchedDepartmentsDict[departmentName]=[NSMutableDictionary dictionary];
                    self.searchedDepartmentsDict[departmentName][teacherName]=teacherInfo;
                }
            }
        }
    }
    self.searchedSortedDepartments=[self sortDepartments:[self.searchedDepartmentsDict allKeys]];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // Do the search and show the results in tableview
    // Deactivate the UISearchBar
	
    // You'll probably want to do this on another thread
    // SomeService is just a dummy class representing some
    // api that you are using to do the search
    
    NSString *text = searchBar.text;
    
    //create another thread
    static NSOperationQueue *searchQueue;
    if (!searchQueue) searchQueue = [[NSOperationQueue alloc] init];
    [searchQueue addOperationWithBlock:^{
        [self searchForString:text];
        
        //go back to the main thread to display results
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self searchBar:searchBar activate:NO];
            //[self.tableData removeAllObjects];
            //[self.tableData addObjectsFromArray:results];
            [self.tableView reloadData];
        }];
    }];
}

// We call this when we want to activate/deactivate the UISearchBar
// Depending on active (YES/NO) we disable/enable selection and
// scrolling on the UITableView
// Show/Hide the UISearchBar Cancel button
// Fade the screen In/Out with the disableViewOverlay and
// simple Animations
- (void)searchBar:(UISearchBar *)searchBar activate:(BOOL)active {
    //self.tableView.userInteractionEnabled=!active;
    if (!active) {
        //[self.disableViewOverlay removeFromSuperview];
        [searchBar resignFirstResponder];
    }/* else {
        self.disableViewOverlay.alpha = 0;
        CGRect frame = self.disableViewOverlay.frame;
        frame.size=self.tableView.contentSize;
        self.disableViewOverlay.frame=frame;
        [self.view addSubview:self.disableViewOverlay];
		[UIView animateWithDuration:.5 animations:^{
            self.disableViewOverlay.alpha = 0.6;
        }];
    }*/
    [searchBar setShowsCancelButton:active animated:YES];
}



//PARSE
#pragma mark - Parse

- (void)parseXMLFileAtURL:(NSString *)URL {
    NSLog(@"Parsing");
    self.stories = [[NSMutableArray alloc] init];
    
	//you must then convert the path to a proper NSURL or it won't work
	NSURL *xmlURL = [NSURL URLWithString:URL];
    
	// here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
	// this may be necessary only for the toolchain
	self.rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
	// Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	[self.rssParser setDelegate:self];
    
	// Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
	[self.rssParser setShouldProcessNamespaces:NO];
    
	[self.rssParser setShouldReportNamespacePrefixes:NO];
    
	[self.rssParser setShouldResolveExternalEntities:NO];
    
    
	[self.rssParser parse];
    
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
	self.currentElement = [elementName copy];
    //NSLog(@"Current Element: %@", currentElement);
	if ([elementName isEqualToString:@"firstname"]) {
		self.item = [[NSMutableDictionary alloc] init];
        //currentFirstName, * currentLastName, * currentDept, * currentTitle, *currentEmail, *currentSite
		self.currentFirstName = [[NSMutableString alloc] init];
		self.currentLastName = [[NSMutableString alloc] init];
		self.currentDept = [[NSMutableString alloc] init];
		self.currentTitle = [[NSMutableString alloc] init];
        self.currentEmail = [[NSMutableString alloc]init];
        self.currentSite = [[NSMutableString alloc]init];
        self.currentPhone = [[NSMutableString alloc]init];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
	//NSLog(@"ended element: %@", elementName);
    
	if ([elementName isEqualToString:@"firstname"]) { //change this back to id
		// save values to an item, then store that item into the array...
        //NSLog(@"item: %@", item);
        [self.item setObject:self.currentFirstName forKey:@"first"];
		[self.item setObject:self.currentLastName forKey:@"last"];
		[self.item setObject:self.currentDept forKey:@"dept"];
        [self.item setObject:self.currentTitle forKey:@"title"];
        [self.item setObject:self.currentEmail forKey:@"email"];
        [self.item setObject:self.currentSite forKey:@"site"];
        [self.item setObject:self.currentPhone forKey:@"phone"];
        
        
		[self.stories addObject:[self.item copy]];
    }
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    //NSLog(@"%@: %@", currentElement, string);
    if ([self.currentElement isEqualToString:@"firstname"]){
        [self.currentFirstName appendString:string];
    }else if ([self.currentElement isEqualToString:@"lastname"]) {
		[self.currentLastName appendString:string];
    }else if ([self.currentElement isEqualToString:@"dept"]) {
		[self.currentDept appendString:string];
    }else if ([self.currentElement isEqualToString:@"title"]){
        [self.currentTitle appendString:string];
    }else if ([self.currentElement isEqualToString:@"email"]){
        [self.currentEmail appendString:string];
    }else if ([self.currentElement isEqualToString:@"site"]){
        [self.currentSite appendString:string];
    }else if ([self.currentElement isEqualToString:@"phone"]){
        [self.currentPhone appendString:string];
    }
	// save the characters for the current item...
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
	//NSLog(@"all done!");
	//NSLog(@"stories array has %d items", [stories count]);
    
    //NSLog(@"Stories: %@", stories);
    [self.activityIndicatorStaff stopAnimating];
    [self.activityIndicatorStaff setHidden:YES];
    [self.tableView reloadData];
    //NSLog(@"Stories: %@", stories);
    [self parseStoryArray];
    [self.tableView reloadData];
}

//returns array of sorted departments
- (NSArray *)sortDepartments:(NSArray *)departments {
    return [departments sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
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
}

-(void)parseStoryArray{
    self.allDepartmentsDict = [[NSMutableDictionary alloc]init];
    for (NSDictionary *person in  self.stories) {
        
        NSMutableDictionary *singleDepartment = [[NSMutableDictionary alloc]init];

        NSString *department = [person objectForKey:@"dept"];
        if ([self.allDepartmentsDict objectForKey:department]) {
            singleDepartment = [[NSMutableDictionary alloc]initWithDictionary:[self.allDepartmentsDict objectForKey:department]];
            [singleDepartment setObject:person forKey:[person objectForKey:@"last"]];
            [self.allDepartmentsDict setObject:singleDepartment forKey:department];
        }else{
            singleDepartment = [[NSMutableDictionary alloc]init];
            [singleDepartment setObject:person forKey:[person objectForKey:@"last"]];
            [self.allDepartmentsDict setObject:singleDepartment forKey:department];
        }
        
        /*if ([departmentArray containsObject:department]) {
            
            NSMutableArray *singleDepartment = [[NSMutableArray alloc]initWithArray:[departmentArray objectAtIndex:index]];
            
            
            
     
        }else{
            NSMutableArray *singleDepartment = [[NSMutableArray alloc]init];
            departmentArray addObject:
        }*/
    }
    
    
    //NSMutableArray *sortedKeys = [NSMutableArray array];
    
    NSArray *objs = [self.allDepartmentsDict allKeys];
    
    self.allSortedDepartments = [self sortDepartments:objs];
    //sortedDepartments =[objs sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    
    
    //NSLog(@"Dep: %@", departmentDict);
    //NSLog(@"sorted: %@", sortedDepartments);

}


//TABLEVIEW

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.departmentDict count];
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
    return [self.departmentDict[self.sortedDepartments[section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sortedDepartments objectAtIndex:section];
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
    [cell.topLabel setHidden:NO];
    [cell.noTitleLabel setHidden:NO];
    
    NSString *department = self.sortedDepartments[indexPath.section];
    NSDictionary *names = [self.departmentDict objectForKey:department];
    NSArray *list = [names allKeys];
    NSArray *sortedList = [list sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSDictionary *info = names[sortedList[indexPath.row]];
    NSString *staffName = [info[@"first"] stringByAppendingString:info[@"last"]];
    NSString *detailString = info[@"title"];
    
    if ([detailString isEqualToString:@" "]) {
        cell.noTitleLabel.text = staffName;
        [cell.topLabel setHidden:YES];
        cell.topLabel.text = @"";
        
    }else{
        [cell.noTitleLabel setHidden:YES];
        cell.noTitleLabel.text = @"";
        cell.topLabel.text = staffName;

    }
    cell.topLabel.text = staffName;
    cell.bottomLabel.text = detailString;
    
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue.destinationViewController setTitle:@"Info"];
    [segue.destinationViewController setTableViewObjects:self.departmentDict :sender :self.sortedDepartments];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.theSearchBar resignFirstResponder];
    [self performSegueWithIdentifier:@"StaffDetail" sender:indexPath];
    
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
