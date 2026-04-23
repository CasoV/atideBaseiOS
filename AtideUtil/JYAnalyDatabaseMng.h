//
//  JYAnalyDatabaseMng.h
//  TrafficMs
//
//  Created by apple on 2015/11/04.
//  Copyright © 2015年 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VxgDatabase.h"
#import "JYAnalyData.h"

@interface JYAnalyDatabaseMng : NSObject

-(void)createTables;
-(void)createTableGather;
-(void)createTableMonth;
-(void)createTableSession;

-(void)update:(NSObject *)data type:(NSInteger)type;
//-(void)insert:(NSObject *)object type:(NSInteger)type;
-(void)addList:(NSMutableArray *)list type:(NSInteger)type;
-(void)deleteAll;
-(NSMutableArray *)query:(NSString*)sect session:(NSString*)session type:(NSInteger)type;
@end
