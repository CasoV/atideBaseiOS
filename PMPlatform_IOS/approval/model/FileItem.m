//
//  FileItem.m
//  TrafficMs
//
//  Created by apple on 2015/11/20.
//  Copyright © 2015年 com. All rights reserved.
//

#import "FileItem.h"
#import "StringUtils.h"

@implementation FileItem

-(void)setData:(NSDictionary *)nsd{
    self.affixName = [nsd objectForKey:@"affixName"];
    self.fileExt = [nsd objectForKey:@"fileExt"];
    self.compAffixID = [nsd objectForKey:@"compAffixID"];
    self.affixLen = [StringUtils VxgGetFileSizie:[nsd objectForKey:@"affixLen"]];
}

@end
