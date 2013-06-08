//
//  HomeParser.m
//  HHSApp
//
//  Created by Max Greenwald on 6/7/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import "HomeParser.h"

@interface HomeParser ()
@property (strong, nonatomic) NSMutableArray *articles;
@property (strong, nonatomic) NSMutableDictionary *item;
@property (strong, nonatomic) NSString *currentElement;
@property (strong, nonatomic) NSString *ElementValue;
@property (nonatomic) BOOL errorParsing;
@property (strong, nonatomic) NSMutableArray *stories;
@property (strong, nonatomic) NSMutableString * currentTitle, * currentURL;
//@property (nonatomic) BOOL urlLoaded;
@end

@implementation HomeParser

@synthesize rssParser;

//PARSING AREA//
//the following line of code makes the parsing area easier to find in the menu above
#pragma mark - PARSING AREA

-(NSMutableArray *)parse:(NSString *)URL{
    [self performSelectorOnMainThread:@selector(parseXMLFileAtURL:) withObject:URL waitUntilDone:YES];
    //NSLog(@"Stories: %@", self.stories);
    return self.stories;
}


- (void)parseXMLFileAtURL:(NSString *)URL {
    
    self.stories = [[NSMutableArray alloc] init];
    
	//you must then convert the path to a proper NSURL or it won't work
	NSURL *xmlURL = [NSURL URLWithString:URL];
    
	// here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
	// this may be necessary only for the toolchain
	self.rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
	// Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	[self.rssParser setDelegate:self];
    
	// Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
	[self.rssParser setShouldProcessNamespaces:YES];
    
	[self.rssParser setShouldReportNamespacePrefixes:YES];
    
	[self.rssParser setShouldResolveExternalEntities:YES];
    
    
	[self.rssParser parse];
    
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
	self.currentElement = [elementName copy];
    //NSLog(@"Current Element: %@", self.currentElement);
	if ([elementName isEqualToString:@"contact-info"]) {
		self.item = [[NSMutableDictionary alloc] init];
		self.currentTitle = [[NSMutableString alloc] init];
        self.currentURL = [[NSMutableString alloc]init];
       
        
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
	//NSLog(@"ended element: %@", elementName);
    
	if ([elementName isEqualToString:@"contact-info"]) { //change this back to id
		// save values to an item, then store that item into the array...
        //NSLog(@"item: %@", item);
        [self.item setObject:self.currentTitle forKey:@"title"];
        NSString *string = [self.currentURL stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		[self.item setObject:string forKey:@"url"];
		
        //NSLog(@"Item: %@", self.item);
        
		[self.stories addObject:[self.item copy]];
    }
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    //NSLog(@"%@: %@", self.currentElement, string);
    if ([string isEqualToString:@" "]) {
        
    }else{
    if ([self.currentElement isEqualToString:@"Name"]){
        [self.currentTitle appendString:string];
    }else if ([self.currentElement isEqualToString:@"url"]) {
		[self.currentURL appendString:string];
        NSLog(@"Appending url");
    }
    }
	// save the characters for the current item...
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
	//NSLog(@"all done!");
	//NSLog(@"stories array has %d items", [stories count]);
    
    //NSLog(@"Stories: %@", self.stories);
    
    
}

@end
