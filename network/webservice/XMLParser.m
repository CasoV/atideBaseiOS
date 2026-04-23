//
//  XMLParser.m
//  Tracking
//
//  Created by 末末班车 on 2017/8/16.
//  Copyright © 2017年 atide. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser {
    void(^_block)(NSData * jsonData);
    NSString *_dataStr;
}

- (void)analysisXMLData:(NSData *)xmlData handleBlock:(void(^)(NSData * jsonData))block{
    _block = block;
    _dataStr = @"";
    //1.创建NSXMLParser
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    //2.设置代理
    parser.delegate = self;
    //3.开始解析
    [parser parse];
}

#pragma mark - NSXMLParserDelegate
//开始解析XML文件
-(void)parserDidStartDocument:(NSXMLParser *)parser{
    
}
//XML所有元素解析完毕
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    _block([_dataStr dataUsingEncoding:NSUTF8StringEncoding]);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    _dataStr = [NSString stringWithFormat:@"%@%@", _dataStr, string];
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
}
- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{

}
@end
