//
//  VxgDatabase.m
//  TrafficMs
//
//  Created by apple on 2015/10/20.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "VxgDatabase.h"

@implementation VxgDatabase{
    sqlite3 * m_db ;
}

-(sqlite3 *)DBOpen{
    if(m_db){
        return m_db;
    }else{
//        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
//        NSString *destinationPath = [path stringByAppendingPathComponent:ATIDE_DATABASE_NAME];
        if(SQLITE_OK == sqlite3_open([SQL_PATH UTF8String], &m_db)){
            [self DBClose];
        }
        return m_db;
    }
}

-(void)DBClose{
    sqlite3_close(m_db);
}

-(void)execNoReturn:(NSString *)sql{
    char *ERROR;
    if (SQLITE_OK != sqlite3_exec(m_db, [sql UTF8String], NULL, NULL, &ERROR)) {
    }
}

+(void)execSqlNoRetur:(NSString *)sql{
    
    char *ERROR;
    sqlite3* db;
    NSString *path = SQL_PATH ;
    if(SQLITE_OK == sqlite3_open([path UTF8String], &db)){
        if (SQLITE_OK != sqlite3_exec(db, [sql UTF8String], NULL, NULL, &ERROR)) {
        }
    }else{
    }
    sqlite3_close(db);
    
}

+(void)execTransactionSql:(NSMutableArray *)sqls{

    sqlite3* db;
    if(SQLITE_OK != sqlite3_open([SQL_PATH UTF8String], &db)){
        return;
    }
    
    //使用事务，提交插入sql语句
    @try{
        char *errorMsg;
        if (sqlite3_exec(db, "BEGIN", NULL, NULL, &errorMsg)==SQLITE_OK)
        {
            sqlite3_free(errorMsg);
            sqlite3_stmt *statement;
            for (int i = 0; i<sqls.count; i++)
            {
                if (sqlite3_prepare_v2(db,[[sqls objectAtIndex:i] UTF8String], -1, &statement,NULL)==SQLITE_OK)
                {
                    if (sqlite3_step(statement)!=SQLITE_DONE)
                        sqlite3_finalize(statement);
                }
            }
            if (sqlite3_exec(db, "COMMIT", NULL, NULL, &errorMsg)==SQLITE_OK){
            }
            sqlite3_free(errorMsg);
        }
        else sqlite3_free(errorMsg);
    }
    @catch(NSException *e)
    {
        char *errorMsg;
        if (sqlite3_exec(db, "ROLLBACK", NULL, NULL, &errorMsg)==SQLITE_OK){
        }

        sqlite3_free(errorMsg);
    }
    
    @finally{}
    
    sqlite3_close(db);
}

-(void)deleteByParams:(NSString*)tableName whereCondition:(NSString*)condition{
    
    if(![self isTableExist:tableName]){
        return;
    }
    
    if (condition==nil) {
        return;
    }
    
    NSString* sql = [NSString stringWithFormat:@"delete from %@ where %@",tableName,condition];
    
    [self execNoReturn:sql];
    
}

-(BOOL)isTableExist:(NSString*)table{
    
    char *err;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM sqlite_master where type='table' and name='%@';",table];
    
    
    if(sqlite3_exec(m_db, [sql UTF8String], NULL, NULL, &err) == 1){
        
        return YES;
        
    }else{
        
        return NO;
        
    }
}

+(BOOL)isTableExist:(NSString*)table{
    sqlite3* db = nil;
    sqlite3_stmt* statement = nil;
    BOOL bRet = FALSE ;
    if(SQLITE_OK == sqlite3_open([SQL_PATH UTF8String], &db)){
        
        NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM sqlite_master where type='table' and name='%@';",table];
        
        
        if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK){
            if ((sqlite3_step(statement) == SQLITE_ROW)) {
                if([[NSString stringWithFormat:@"%s",sqlite3_column_text(statement,0)] intValue]>0){
                    bRet = YES;
                }
            }
        }
        
    }else{
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return bRet;
}

+(void)dropTable:(NSString*)table{
    NSString * sql = [NSString stringWithFormat:@"drop table %@;",table];
    [self execSqlNoRetur:sql];
}

@end
