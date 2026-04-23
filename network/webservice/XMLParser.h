//
//  XMLParser.h
//  Tracking
//
//  Created by 末末班车 on 2017/8/16.
//  Copyright © 2017年 atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParser : NSObject <NSXMLParserDelegate>

//解析xml数据并返回jsonData
- (void)analysisXMLData:(NSData *)xmlData handleBlock:(void(^)(NSData * jsonData))block;

@end
