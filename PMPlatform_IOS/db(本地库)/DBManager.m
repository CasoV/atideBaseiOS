//
//  DBManager.m
//  ConstructionApp
//
//  Created by vxg on 2018/01/31.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "DBManager.h"
//#import <FMDB/FMDB.h>
#import "ApiVideoUpload.h"
#import <YTKNetwork/YTKNetwork.h>
//#import <AFNetworking/AFNetworking.h>
//#import "NewUploadManagerController.h"

@implementation DBManager

+ (NSString *)fileName{
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *fileName = [doc stringByAppendingPathComponent:@"uploadTask.sqlite"];
    return fileName;
}

+ (void)createDatabase{
    
//    FMDatabase *database = [FMDatabase databaseWithPath:[self fileName]];
//    if ([database open])
//    {
//        //创建待上传文件表单
//        [database executeUpdate:@"CREATE TABLE IF NOT EXISTS t_upload (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, formId text NOT NULL, path text NOT NULL, actionId text NOT NULL, taskId text NOT NULL, createDate text NOT NULL);"];
//        [database executeUpdate:@"CREATE TABLE IF NOT EXISTS t_videomaterial (id integer PRIMARY KEY AUTOINCREMENT, mainId text NOT NULL, title text NOT NULL, remark text NOT NULL, userId text NOT NULL, partCode text NOT NULL);"];
//    }
//    [database close];database = nil;
}

+ (BOOL)saveVideoMaterial:(NSString *)mainId title:(NSString *)title remark:(NSString *)remark partCode:(NSString *)partCode{
    if (!mainId || mainId.length<1) {
        return NO;
    }
    if (!title || title.length<1) {
        return NO;
    }
    if (!partCode || partCode.length<1) {
        return NO;
    }
    if (!remark) {
        return NO;
    }

//    FMDatabase *database = [FMDatabase databaseWithPath:[self fileName]];
    
    BOOL success = NO;
//    if ([database open])
//    {
//        FMResultSet *result = [database executeQuery:@"select * from 't_videomaterial' where mainId = ? and userId = ?" withArgumentsInArray:@[mainId, [AppUser sharedInstance].id]];
//        while ([result next]) {
//            BOOL res = [database executeUpdate:@"delete from 't_videomaterial' where id = ?" withArgumentsInArray:@[[NSNumber numberWithInteger:[result intForColumn:@"id"]]]];
//            if (res) {
//            }else {
//            }
//        }
//
//        success = [database executeUpdate:@"insert into t_videomaterial(mainId,title,remark,userId,partCode) values(?,?,?,?,?);" withArgumentsInArray:@[mainId,title,remark,[AppUser sharedInstance].id,partCode]];
//    }
//    [database close];database = nil;
    return success;
}

+ (BOOL)save:(UIImage *)image fileName:(NSString *)fileName formId:(NSString *)formId actionId:(NSString *)actionId taskId:(NSString *)taskId{
    if (!formId || formId.length<1) {
        return NO;
    }
    if (!image) {
        return NO;
    }
    if (!fileName || fileName.length<1) {
        fileName = [NSString stringWithFormat:@"%f.jpg",[NSDate date].timeIntervalSince1970];
    }
    if (!actionId) {
        actionId = @"";
    }
    if (!taskId) {
        taskId = @"";
    }
    NSString *path = [self saveFile:image name:fileName];
    if (!path) {
        return NO;
    }
//    FMDatabase *database = [FMDatabase databaseWithPath:[self fileName]];
    BOOL success = NO;
//    if ([database open])
//    {
//        success = [database executeUpdate:@"insert into t_upload(name,formId,path,actionId,taskId,createDate) values(?,?,?,?,?,?);" withArgumentsInArray:@[fileName,formId,path,actionId,taskId,[NSDate nowDateStringYYMMddHHmmss]]];
//
//    }
//    [database close];database = nil;
    return success;
}

+ (NSString *)saveFile:(UIImage *)image name:(NSString *)name{
    NSData *imgData = UIImagePNGRepresentation(image);
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *fileName = [NSString stringWithFormat:@"%f_%@",[NSDate date].timeIntervalSince1970,name];
    NSString *filePath = [doc stringByAppendingPathComponent:fileName];
    BOOL isSuccess = [imgData writeToFile:filePath atomically:YES];
    return isSuccess ? fileName : nil;
}

+ (NSString *)saveData:(NSData *)data name:(NSString *)name{
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *fileName = [NSString stringWithFormat:@"%f_%@",[NSDate date].timeIntervalSince1970,name];
    NSString *filePath = [doc stringByAppendingPathComponent:fileName];
    BOOL isSuccess = [data writeToFile:filePath atomically:YES];
    return isSuccess ? fileName : nil;
}

+ (BOOL)saveVideo:(NSData *)data fileName:(NSString *)fileName formId:(NSString *)formId {
    if (!formId || formId.length<1) {
        return NO;
    }
    if (!data) {
        return NO;
    }
    if (!fileName || fileName.length<1) {
        fileName = [NSString stringWithFormat:@"%f.mp4",[NSDate date].timeIntervalSince1970];
    }
    NSString *path = [self saveData:data name:fileName];
    if (!path) {
        return NO;
    }
//    FMDatabase *database = [FMDatabase databaseWithPath:[self fileName]];
    BOOL success = NO;
//    if ([database open])
//    {
//        success = [database executeUpdate:@"insert into t_upload(name,formId,path,actionId,taskId,createDate) values(?,?,?,?,?,?);" withArgumentsInArray:@[fileName,formId,path,[AppUser sharedInstance].id,@"video",@""]];
//
//    }
//    [database close];database = nil;
    return success;
}

+ (BOOL)saveImage:(NSData *)data fileName:(NSString *)fileName formId:(NSString *)formId {
    if (!formId || formId.length<1) {
        return NO;
    }
    if (!data) {
        return NO;
    }
    if (!fileName || fileName.length<1) {
        fileName = [NSString stringWithFormat:@"%f.jpeg",[NSDate date].timeIntervalSince1970];
    }
    NSString *path = [self saveData:data name:fileName];
    if (!path) {
        return NO;
    }
//    FMDatabase *database = [FMDatabase databaseWithPath:[self fileName]];
    BOOL success = NO;
//    if ([database open])
//    {
//        success = [database executeUpdate:@"insert into t_upload(name,formId,path,actionId,taskId,createDate) values(?,?,?,?,?,?);" withArgumentsInArray:@[fileName,formId,path,[AppUser sharedInstance].id,@"image",@""]];
//    }
//    [database close];database = nil;
    return success;
}

+ (NSMutableArray *)queryUpload{
//    FMDatabase *database = [FMDatabase databaseWithPath:[self fileName]];
    NSMutableArray *results = [[NSMutableArray alloc] init];
//    if ([database open])
//    {
//        FMResultSet *resultSet = [database executeQuery:@"select *from t_upload"];
//
//        while ([resultSet next]) {
//            [results addObject:resultSet.resultDictionary];
//        }
//
//    }
//    [database close];database = nil;
    return results;
}

+ (void)deleteUpload:(int)rowId{
//    FMDatabase *database = [FMDatabase databaseWithPath:[self fileName]];
//
//    if ([database open]){
//        BOOL isSuccess = [database executeUpdateWithFormat:@"delete from t_upload where id=%d",rowId];
//        if (isSuccess) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"delete_t_upload" object:nil];
//        }
//    }
//    [database close];database = nil;
}

+ (void)deleteUploadFiles:(NSArray <UnUploadFile *>*)files{
//    FMDatabase *database = [FMDatabase databaseWithPath:[self fileName]];
//
//    if ([database open]){
//        for (UnUploadFile *file in files) {
//            BOOL isSuccess = [database executeUpdateWithFormat:@"delete from t_upload where path=%@",file.path];
//            if (isSuccess) {
//                NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
//                NSString *path = [doc stringByAppendingPathComponent:file.path];
//                NSFileManager *fileManager = [NSFileManager defaultManager];
//                BOOL isExistence = [fileManager fileExistsAtPath:path];
//                if (isExistence) {
//                    NSError * error ;
//                    BOOL isRemove = [fileManager removeItemAtPath:path error:&error];
//                    if (isRemove) {
//                    }else{
//                    }
//                }else{
//                }
//            }
//        }
//    }
//    [database close];database = nil;
}

+ (void)deleteVideoMaterial:(NSString *)mainId {
//    FMDatabase *database = [FMDatabase databaseWithPath:[self fileName]];
//
//    if ([database open]){
//        FMResultSet *result = [database executeQuery:@"select * from 't_videomaterial' where mainId = ? and userId = ?" withArgumentsInArray:@[mainId, [AppUser sharedInstance].id]];
//        while ([result next]) {
//            BOOL res = [database executeUpdate:@"delete from 't_videomaterial' where id = ?" withArgumentsInArray:@[[NSNumber numberWithInteger:[result intForColumn:@"id"]]]];
//            if (res) {
//            }else {
//            }
//        }
//    }
//
//    [database close];database = nil;
}

+ (void)handleUnUploadData:(UIViewController *)viewController {
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
//        FMDatabase *database = [FMDatabase databaseWithPath:[self fileName]];
//
        BOOL haveUnUploadfile = NO;
//        if ([database open]){
//            FMResultSet *result = [database executeQuery:@"select * from 't_upload' where actionId = ?" withArgumentsInArray:@[[AppUser sharedInstance].id]];
//
//            while ([result next]) {
//                haveUnUploadfile = YES;
//                break;
//            }
//        }
//        [database close];[database close];database = nil;
        
        if (haveUnUploadfile) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"有尚未上传文件！" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                NewUploadManagerController *vc = [[NewUploadManagerController alloc] initWithNibName:@"NewUploadManagerController" bundle:nil];
//                vc.hidesBottomBarWhenPushed = YES;
//                [viewController.navigationController pushViewController:vc animated:YES];
            }]];
            [viewController presentViewController:alert animated:YES completion:nil];
        }
    }
}

+ (void)uploadFiles:(NSArray <UnUploadFile *>*)files {
    NSMutableArray <YTKRequest *>*requests = [NSMutableArray array];
    for (UnUploadFile *file in files) {
        NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSData *data = [NSData dataWithContentsOfFile:[doc stringByAppendingPathComponent:file.path]];
        
        if (data) {
            ApiVideoUpload *api = [[ApiVideoUpload alloc] initWithVideoData:data fileName:file.name markId:file.formId];
            [requests addObject:api];
        }
    }
    
    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:requests];
    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
        [self deleteUploadFiles:files];
    } failure:nil];
}

+ (NSArray<UnUploadFile *> *)getUnUploadFiles:(NSString *)mainId {
//    FMDatabase *database = [FMDatabase databaseWithPath:[self fileName]];
//
//    if ([database open]){
//        BOOL haveVideomaterial = NO;
//        FMResultSet *result = [database executeQuery:@"select * from 't_videomaterial' where mainId = ? and userId = ?" withArgumentsInArray:@[mainId, [AppUser sharedInstance].id]];
//        while ([result next]) {
//            haveVideomaterial = YES;
//        }
//
//        if (haveVideomaterial) {
//            NSMutableArray <UnUploadFile *>*files = [NSMutableArray array];
//
//            result = [database executeQuery:@"select * from 't_upload' where formId = ? and actionId = ?" withArgumentsInArray:@[mainId, [AppUser sharedInstance].id]];
//
//            while ([result next]) {
//                UnUploadFile *file = [[UnUploadFile alloc] init];
//                file.name =  [result stringForColumn:@"name"];
//                file.path =  [result stringForColumn:@"path"];
//                file.formId =  [result stringForColumn:@"formId"];
//                file.userId =  [result stringForColumn:@"actionId"];
//                file.type =  [result stringForColumn:@"taskId"];
//
//                [files addObject:file];
//            }
//
//            if (files.count > 0) {
//                [database close];[database close];database = nil;
//                return [files copy];
//            }
//        }
//    }
//
//    [database close];database = nil;
    return nil;
}

@end
