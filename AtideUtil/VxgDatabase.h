//
//  VxgDatabase.h
//  TrafficMs
//
//  Created by apple on 2015/10/20.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define ATIDE_DATABASE_NAME @"ATIDE.sqlite"
#define ATIDE_DATABASE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES objectAtIndex:0]stringByAppendingPathComponent:@"ATIDE.sqlite"]

#define SQL_PATH  [[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory,NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"atide.sqlite"]

@interface VxgDatabase : NSObject

-(sqlite3 *)DBOpen;
-(void)DBClose;

-(void)execNoReturn:(NSString *)sql;
-(void)deleteByParams:(NSString*)tableName whereCondition:(NSString*)condition;

-(BOOL)isTableExist:(NSString*)table;

+(void)execTransactionSql:(NSMutableArray *)sqls;
+(void)execSqlNoRetur:(NSString *)sql;
+(BOOL)isTableExist:(NSString*)table;
+(void)dropTable:(NSString*)table;
@end
