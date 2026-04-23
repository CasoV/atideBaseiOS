//
//  DBManager.h
//  ConstructionApp
//
//  Created by vxg on 2018/01/31.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnUploadFile.h"

@interface DBManager : NSObject
+ (NSString *)fileName;
+ (void)createDatabase;
+ (BOOL)save:(UIImage *)image fileName:(NSString *)fileName formId:(NSString *)formId actionId:(NSString *)actionId taskId:(NSString *)taskId;
+ (BOOL)saveVideo:(NSData *)data fileName:(NSString *)fileName formId:(NSString *)formId;
+ (BOOL)saveImage:(NSData *)data fileName:(NSString *)fileName formId:(NSString *)formId;
+ (BOOL)saveVideoMaterial:(NSString *)mainId title:(NSString *)title remark:(NSString *)remark partCode:(NSString *)partCode;
+ (void)deleteVideoMaterial:(NSString *)mainId;
+ (NSMutableArray *)queryUpload;
+ (void)deleteUpload:(int)rowId;
+ (void)deleteUploadFiles:(NSArray <UnUploadFile *>*)files;
//处理未上传的文件
+ (void)handleUnUploadData:(UIViewController *)viewController;

//是否有对应ID的本地影像资料
+ (NSArray <UnUploadFile *>*)getUnUploadFiles:(NSString *)mainId;
@end
