//
//  HomeParser.h
//  HHSApp
//
//  Created by Max Greenwald on 6/7/13.
//  Copyright (c) 2013 Hanover High School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeParser : NSObject <NSXMLParserDelegate>{
    

}
@property (nonatomic, strong)  NSXMLParser * rssParser;

- (void)parseXMLFileAtURL:(NSString *)URL;
-(NSMutableArray *)parse:(NSString *)URL;

@end
