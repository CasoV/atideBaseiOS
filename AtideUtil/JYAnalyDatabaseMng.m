//
//  JYAnalyDatabaseMng.m
//  TrafficMs
//
//  Created by apple on 2015/11/04.
//  Copyright © 2015年 com. All rights reserved.
//

#import "JYAnalyDatabaseMng.h"
#import "JYAnalyData.h"
#import "VxgCellData.h"

#define TABLE_FILED_SECT_NO             @"sect_no"
#define TABLE_FILED_SESSION             @"session"
#define TABLE_NAME_GATHER               @"t_jy_analy_gather"
#define TABLE_FILED_GATEHER_CODE        @"gather_code"
#define TABLE_FILED_GATEHER_HT          @"gather_ht"
#define TABLE_FILED_GATEHER_JL          @"gather_jl"
#define TABLE_FILED_GATEHER_NAME        @"gather_name"
#define TABLE_FILED_GATEHER_PERSENT     @"gather_percent"
#define TABLE_FILED_GATEHER_TYPE        @"gather_type" //0:

#define TABLE_NAME_MONTH                @"t_jy_analy_month"
#define TABLE_FILED_MONTH_ID            @"month_id"
#define TABLE_FILED_MONTH_PARENT_ID     @"parent_id"
#define TABLE_FILED_MONTH_SECT_NAME     @"sect_name"
#define TABLE_FILED_MONTH_NAME          @"month_name"
#define TABLE_FILED_MONTH_VALUE1        @"month_value1"
#define TABLE_FILED_MONTH_VALUE2        @"month_value2"
#define TABLE_FILED_MONTH_VALUE3        @"month_value3"

#define TABLE_NAME_SESSION              @"t_jy_analy_session"
#define TABLE_FILED_SESSION_ID          @"month_id"
#define TABLE_FILED_SESSION_PARENT_ID   @"parent_id"
#define TABLE_FILED_SESSION_SECT_NAME   @"sect_name"
#define TABLE_FILED_SESSION_NAME        @"month_name"
#define TABLE_FILED_SESSION_VALUE1      @"month_value1"
#define TABLE_FILED_SESSION_VALUE2      @"month_value2"
#define TABLE_FILED_SESSION_VALUE3      @"month_value3"

@implementation JYAnalyDatabaseMng


-(void)createTableGather{
    NSString * SQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ text,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text);",TABLE_NAME_GATHER,TABLE_FILED_GATEHER_CODE,TABLE_FILED_GATEHER_HT,TABLE_FILED_GATEHER_JL,TABLE_FILED_GATEHER_NAME,TABLE_FILED_GATEHER_PERSENT,TABLE_FILED_SECT_NO,TABLE_FILED_SESSION ];
    [VxgDatabase execSqlNoRetur:SQL];
}

-(void)createTableMonth{
    NSString * SQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ text,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text);",TABLE_NAME_MONTH,TABLE_FILED_MONTH_ID,TABLE_FILED_MONTH_PARENT_ID,TABLE_FILED_MONTH_SECT_NAME,TABLE_FILED_MONTH_NAME,TABLE_FILED_MONTH_VALUE1,TABLE_FILED_MONTH_VALUE2,TABLE_FILED_MONTH_VALUE3,TABLE_FILED_SECT_NO,TABLE_FILED_SESSION ];
    [VxgDatabase execSqlNoRetur:SQL];
}

-(void)createTableSession{
    NSString * SQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ text,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text);",TABLE_NAME_SESSION,TABLE_FILED_SESSION_ID,TABLE_FILED_SESSION_PARENT_ID,TABLE_FILED_SESSION_SECT_NAME,TABLE_FILED_SESSION_NAME,TABLE_FILED_SESSION_VALUE1,TABLE_FILED_SESSION_VALUE2,TABLE_FILED_SESSION_VALUE3,TABLE_FILED_SECT_NO,TABLE_FILED_SESSION ];
    [VxgDatabase execSqlNoRetur:SQL];
}

-(void)createTables{
    [self createTableGather];
    [self createTableMonth];
    [self createTableSession];
}

-(void)update:(NSObject *)data type:(NSInteger)type{
    
}

-(void)insert:(NSObject *)object type:(NSInteger)type{
    
}

-(void)addList:(NSMutableArray *)list type:(NSInteger)type{
    
    if (list==nil) {
        return;
    }
    
    NSString *sql = [NSString stringWithFormat:@"insert into "];
    NSMutableArray * sqls = [[NSMutableArray alloc]init];

    if (0==type) {
        for (Gatherdata *data in list) {
            [sqls addObject:[sql stringByAppendingString:[NSString stringWithFormat:@" %@ values('%@','%@','%@','%@','%@','%@','%@');",
                             TABLE_NAME_GATHER,data.mCode,data.mHt,data.mJl,data.mName,data.mJlPercent,data.sectNo,data.session]]];
        }
        
    }else {
        if( 1 == type){
            for (Monthdata *mdata in list) {
                [sqls addObject:[sql stringByAppendingString:[NSString stringWithFormat:@" %@ values('%@','%@','%@','%@','%@','%@','%@','%@','%@');",
                                 TABLE_NAME_SESSION,mdata.ID,mdata.parentId,mdata.sectName,mdata.name,mdata.value1,mdata.value2,mdata.value3,mdata.sectNo,mdata.session]]];
            }
        }else{
            for (Sessiondata *sdata in list) {
                [sqls addObject:[sql stringByAppendingString:[NSString stringWithFormat:@" %@ values('%@','%@','%@','%@','%@','%@','%@','%@','%@');",
                                 TABLE_NAME_MONTH,sdata.ID,sdata.parentId,sdata.sectName,sdata.name,sdata.value1,sdata.value2,sdata.value3,sdata.sectNo,sdata.session]]];
            }
        }
    }
    
    [VxgDatabase execTransactionSql:sqls];
    
}

-(void)deleteAll{
    NSMutableArray *sqls = [[NSMutableArray alloc]init];
    [sqls addObject:[NSString stringWithFormat:@"delete from %@",TABLE_NAME_GATHER]];
    [sqls addObject:[NSString stringWithFormat:@"delete from %@",TABLE_NAME_SESSION]];
    [sqls addObject:[NSString stringWithFormat:@"delete from %@",TABLE_NAME_MONTH]];
    [VxgDatabase execTransactionSql:sqls];
}

-(NSMutableArray *)query:(NSString*)sect session:(NSString*)session type:(NSInteger)type{
    
    NSString *table = nil;
    NSString *options = nil;
    if (0 == type) {
        table = [NSString stringWithFormat:@"%@",TABLE_NAME_GATHER];
        options = [NSString stringWithFormat:@"%@,%@,%@",TABLE_FILED_GATEHER_NAME,TABLE_FILED_GATEHER_HT,TABLE_FILED_GATEHER_JL];
    }else if(2 == type){
        table = [NSString stringWithFormat:@"%@",TABLE_NAME_MONTH];
        options = [NSString stringWithFormat:@"%@,%@",TABLE_FILED_MONTH_NAME,TABLE_FILED_MONTH_VALUE1];
    }else{
        table = [NSString stringWithFormat:@"%@",TABLE_NAME_SESSION];
        options = [NSString stringWithFormat:@"%@,%@",TABLE_FILED_MONTH_NAME,TABLE_FILED_MONTH_VALUE1];
    }
    
    NSString *sql = [NSString stringWithFormat:@"select %@ from %@ where sect_no = '%@' and session = '%@' ",options,table,sect,session];
    
    sqlite3 *db = nil;
    sqlite3_stmt *statement = nil;
    NSMutableArray *retArray = [[NSMutableArray alloc]init];
    
    if(SQLITE_OK == sqlite3_open([SQL_PATH UTF8String], &db)){
        if (SQLITE_OK != sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL)) {

        }else{
            while (sqlite3_step(statement) == SQLITE_ROW) {
                VxgCellData *data = [[VxgCellData alloc]init];
                data.name = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,0)];
                data.value = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,1)];
                if (0 == type) {
                    data.remark = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,2)];
                }
                [retArray addObject:data];
            }
        }
    }else{
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return retArray;
}

@end
