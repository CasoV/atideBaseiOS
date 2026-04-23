//
//  FileItem.h
//  TrafficMs
//
//  Created by apple on 2015/11/20.
//  Copyright © 2015年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileItem : NSObject
@property (nonatomic, copy) NSString * affixName;
@property (nonatomic, copy) NSString * fileExt;
@property (nonatomic, copy) NSString * compAffixID;
@property (nonatomic, copy) NSString * affixLen;


-(void)setData:(NSDictionary *)nsd;
@end
