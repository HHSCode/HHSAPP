//
//  HomeViewController.m
//  HHSApp
//
//  Created by Connor Koehler on 3/17/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize calendarWebView, photosWebView, slideshowImageView, activityIndicatorCalendar, activityIndicatorSlideshow;

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
    [slideshowImageView setImage:[UIImage imageNamed:@"photo.png"]];
    calendarWebView.scrollView.scrollEnabled = NO;
    calendarWebView.scrollView.bounces = NO;
    [calendarWebView setDelegate:self];
    
    [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbarHHS.png"]];

    [self startupInternetBasedParts];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachChanged)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
}

-(void)reachChanged{
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        //NSLog(@"REACHABLE!");
        
        
        if([stories count]==0){
            [activityIndicatorSlideshow startAnimating];
            [activityIndicatorSlideshow setHidesWhenStopped:YES];
            [self performSelectorInBackground:@selector(parseXMLFileAtURL:) withObject:@"https://picasaweb.google.com/data/feed/base/user/108131704742682781762/albumid/5817737329195291185?alt=rss"];
        
        
        [activityIndicatorCalendar startAnimating];
        [activityIndicatorCalendar setHidesWhenStopped:YES];
        
        
        
        [calendarWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com/calendar/embed?showTitle=0&showNav=0&showDate=0&showPrint=0&showTabs=0&showCalendars=0&showTz=0&mode=AGENDA&height=185&wkst=1&bgcolor=%2393061C&src=nn2509143kmbl2jbhlofvah8fs%40group.calendar.google.com&color=%232F6309&src=vs8lb5l1ej2cukd1l0s26atv2c%40group.calendar.google.com&color=%23B1440E&src=680mj2kt8enp5minffopangeeg%40group.calendar.google.com&color=%23875509&src=4uripfc30h2e7htmr6cn38g8bo%40group.calendar.google.com&color=%23B1365F&src=ak55rjsbcjca1b6c4g1pl98a30%40group.calendar.google.com&color=%231B887A&src=v5u6pb9hmmk6vdmc5sd97r67sg%40group.calendar.google.com&color=%235F6B02&src=d4ohdnvm96jfqsrj9copecbiu8%40group.calendar.google.com&color=%23333333&src=1rank92tt12gjt2q0u3cbgemmc%40group.calendar.google.com&color=%236B3304&src=ggb1fhi1mr66bati1ct16kvc78%40group.calendar.google.com&color=%235229A3&src=en.usa%23holiday%40group.v.calendar.google.com&color=%232952A3&src=ubsv6hfmoe8n03oclu2r1a61hk%40group.calendar.google.com&color=%23182C57&ctz=America%2FNew_York"]]];
        
        
        // Do any additional setup after loading the view.
        
        }
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        //NSLog(@"UNREACHABLE!");
        [activityIndicatorCalendar setHidden:YES];
        [activityIndicatorSlideshow setHidden:YES];
    };

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"urlLoaded" ]) {
        return NO;
    }else{
        return YES;
    }
   
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"urlLoaded"];
    [activityIndicatorCalendar stopAnimating];
    [activityIndicatorCalendar setHidden:YES];
}

-(void)startupInternetBasedParts{
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        //NSLog(@"REACHABLE!");
        
        
        if([stories count]==0){
            [activityIndicatorSlideshow startAnimating];
            [activityIndicatorSlideshow setHidesWhenStopped:YES];
            [self performSelectorInBackground:@selector(parseXMLFileAtURL:) withObject:@"https://picasaweb.google.com/data/feed/base/user/108131704742682781762/albumid/5817737329195291185?alt=rss"];
        }
        
        [activityIndicatorCalendar startAnimating];
        [activityIndicatorCalendar setHidden:NO];
        
        [calendarWebView setDelegate:self];
        
        [calendarWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com/calendar/embed?showTitle=0&showNav=0&showDate=0&showPrint=0&showTabs=0&showCalendars=0&showTz=0&mode=AGENDA&height=185&wkst=1&bgcolor=%2393061C&src=nn2509143kmbl2jbhlofvah8fs%40group.calendar.google.com&color=%232F6309&src=vs8lb5l1ej2cukd1l0s26atv2c%40group.calendar.google.com&color=%23B1440E&src=680mj2kt8enp5minffopangeeg%40group.calendar.google.com&color=%23875509&src=4uripfc30h2e7htmr6cn38g8bo%40group.calendar.google.com&color=%23B1365F&src=ak55rjsbcjca1b6c4g1pl98a30%40group.calendar.google.com&color=%231B887A&src=v5u6pb9hmmk6vdmc5sd97r67sg%40group.calendar.google.com&color=%235F6B02&src=d4ohdnvm96jfqsrj9copecbiu8%40group.calendar.google.com&color=%23333333&src=1rank92tt12gjt2q0u3cbgemmc%40group.calendar.google.com&color=%236B3304&src=ggb1fhi1mr66bati1ct16kvc78%40group.calendar.google.com&color=%235229A3&src=en.usa%23holiday%40group.v.calendar.google.com&color=%232952A3&src=ubsv6hfmoe8n03oclu2r1a61hk%40group.calendar.google.com&color=%23182C57&ctz=America%2FNew_York"]]];
        
        
                // Do any additional setup after loading the view.
        
        
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        //NSLog(@"UNREACHABLE!");
        [activityIndicatorCalendar setHidden:YES];
        [activityIndicatorSlideshow setHidden:YES];
    };
    
    // start the notifier which will cause the reachability object to retain itself!
    [reach startNotifier];
}


-(void)setupImageView{
    NSMutableArray *theArray = [[NSMutableArray alloc]init];
    UIImage *theImage = [UIImage imageNamed:@"photo.png"];
    [theArray insertObject:theImage atIndex:[theArray count]];
    for (NSMutableDictionary *dic in stories) {
        //NSLog(@"Link: %@", [dic objectForKey:@"link"]);
        if ([[dic objectForKey:@"link"] isEqualToString:@""]) {
            
        }else{
            UIImage *image = [self getImageFromURL:[dic objectForKey:@"link"]];
            [theArray insertObject:image atIndex:[theArray count]];
        }
        //if ([dic objectForKey:@"link"] != nil) {
        //    UIImage *image = [self getImageFromURL:[dic objectForKey:@"link"]];
        ///    [theArray insertObject:image atIndex:[theArray count]];
//}
        [activityIndicatorSlideshow stopAnimating];
    }
slideshowImageView.animationImages = theArray;
slideshowImageView.animationDuration = 50;
slideshowImageView.animationRepeatCount = 0;

[slideshowImageView startAnimating];
}

-(UIImage *)getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    //NSLog(@"Done");
    return result;
}


// PARSE PHOTOS




-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
	[rssParser setShouldProcessNamespaces:YES];
    
	[rssParser setShouldReportNamespacePrefixes:YES];
    
	[rssParser setShouldResolveExternalEntities:YES];
    
    
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
	if ([elementName isEqualToString:@"title"]) {
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
    
	if ([elementName isEqualToString:@"title"]) { //change this back to id
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
    //NSLog(@"%@: %@", currentElement, string);
    if ([currentElement isEqualToString:@"link"]){
        //[currentLink appendString:string];
    }else if ([currentElement isEqualToString:@"title"]) {
		[currentTitle appendString:string];
    }else if ([currentElement isEqualToString:@"credit"]) {
		[currentAuthor appendString:string];
    }else if ([currentElement isEqualToString:@"content:encoded"]){
        [currentHTML appendString:string];
    }else if ([currentElement isEqualToString:@"pubDate"]){
        [currentDate appendString:string];
    }else if ([currentElement isEqualToString:@"description"]){
        if ([string length]>3) {
            
            NSString *checkImg = [string substringToIndex:3];
        if ([checkImg isEqualToString:@"img"]) {
            NSArray *url = [string componentsSeparatedByString:@"\""];
            //NSLog(@"%@", url);
            for (NSString *x in url) {
                if ([x length]>6){
                    
                    NSString *theURL = [x substringToIndex:5];
                    if ([theURL isEqualToString:@"https"]) {
                        //NSLog(@"Got here");
                        [currentLink appendString:x];
                    }
                }
            }
        }
        }
    }
	// save the characters for the current item...
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
	//NSLog(@"all done!");
	//NSLog(@"stories array has %d items", [stories count]);
    
    //NSLog(@"Stories: %@", stories);
    [self setupImageView];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
