//
//  UserInfo.m
//  yu
//
//  Created by apple on 14-7-10.
//  Copyright (c) 2014年 com. All rights reserved.
//

#import "StringUtils.h"
#import "SectModel.h"
#import "VxgCellData.h"


@implementation StringUtils

+ (NSString *) trimInvalidZero:(NSString *)str
{
    if (nil == str) {
        return str;
    }
    NSRange range = [str rangeOfString:@"."];
    if (range.location == NSNotFound) {
        return str;
    }
    int iDot = (int)[str rangeOfString:@"."].location;
    if ((int)[str length] < 1 || -1 == iDot) {
        return str;
    }
    int size = (int)[str length] - 1;
    if ([[str substringFromIndex:iDot + 1] length] < 1) {
        return str;
    }
    
    NSString *ret = str;
    for (int i = size; i > 0; i--) {
        if ('0' == [str characterAtIndex:i])
        {
            ret = [str substringWithRange:NSMakeRange(0, i)];
        } else if ('.' == [str characterAtIndex:i])
        {
            ret = [str substringWithRange:NSMakeRange(0, i)];
            break;
        } else {
            break;
        }
    }
    return ret;
}

+ (NSMutableArray *) VxgGetSectNewstSession:(NSMutableArray *)sourceDatas
{
    NSMutableArray *sects = [[NSMutableArray alloc]init];
    NSMutableArray *sessions = [[NSMutableArray alloc]init];
    NSMutableArray *selectorDatas = [[NSMutableArray alloc]init];
    [sects removeAllObjects];
    [sessions removeAllObjects];
    NSMutableArray *sectSessions = [[NSMutableArray alloc]init];
    for (SectModel *nsd in sourceDatas ) {
        [sectSessions addObject:nsd];
    }
    
    //获取不重复的作为group
    for (SectModel *sect in sectSessions) {
        if (![sects containsObject:sect.sectName]) {
            [sects addObject:sect.sectName];
        }
    }
    
    //添加session数据
    for(NSString *sectName in sects){
        NSMutableArray *child = [[NSMutableArray alloc]init];
        for (SectModel *sect in sectSessions) {
            if ([sectName isEqualToString:sect.sectName]) {
                [child addObject:sect];
            }
        }
        [sessions addObject:child];
    }
    
    for(int i=0;i<sects.count;i++){
        NSString *sectName = [sects objectAtIndex:i];
        for (int k =0; k<sessions.count; k++) {
            SectModel *sasData = [[sessions objectAtIndex:k]objectAtIndex:0];
            if([sectName isEqual:sasData.sectName]){
                VxgCellData *cellData = [[VxgCellData alloc]init];
                NSMutableArray *childs = [sessions objectAtIndex:i];
                SectModel *sasDataq = [childs objectAtIndex:childs.count-1];
                cellData.remark1 = sasDataq.sectNo;
                cellData.name = sectName;
                cellData.value = sasDataq.sessionCode;
                cellData.remark = [NSString stringWithFormat:@"第%@期",sasDataq.sessionCode];
                [selectorDatas addObject:cellData];
                break;
            }
        }
    }
    
    return selectorDatas;
}

+ (NSString *) VxgGetFileSizie:(NSString *)fileSize{
    NSString *result;
    long temp = [fileSize longLongValue];
    double Mb = 1024 * 1024;
    double Kb = 1024;
    
    if (temp > Mb) {
        result = [NSString stringWithFormat:@"%0.1f Mb",(temp/Mb)];
    } else {
        result = [NSString stringWithFormat:@"%0.1f Kb",(temp/Kb)];
    }
    return result;
}

+(NSString *)parserSoapResult:(NSString *)soapResult matchResult:(NSString *)match{
    if (soapResult == nil || match == nil) {
        return @"";
    }
    
    NSString *jsonRet = nil;
    NSString *matchNodeBegin = [NSString stringWithFormat:@"<%@>",match];
    NSString *matchNodeEnd = [NSString stringWithFormat:@"</%@>",match];
    soapResult = [soapResult stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\r\\n"];
    
    NSRange range = [soapResult rangeOfString:matchNodeBegin];
    if (range.location != NSNotFound) {
        NSString *tmp = [soapResult substringFromIndex:range.location + range.length];
        if (tmp == nil) {
            return tmp;
        }
        NSRange endRange = [tmp rangeOfString:matchNodeEnd];
        if (range.location == NSNotFound) {
            return nil;
        }
        jsonRet = [tmp substringToIndex:endRange.location];
    }
    
    return jsonRet;
}

+ (NSString *) getCurrentTime{
    NSString * time = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSDate *date = [NSDate  dateWithTimeIntervalSinceNow:3600*2];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    time = [formatter stringFromDate:date];
    return time;
}

+ (BOOL) isPdfFile:(NSString *)filePath{
    if (filePath == nil || [filePath length] < 1) {
        return false;
    }
    filePath = [filePath lowercaseString];
    return [filePath containsString:@".pdf"];
}

+ (NSString *)trim_n:(NSString *)src{
    if (src == nil) {
        return nil;
    }
    
    NSString *retStr = nil;
    retStr = [src stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return retStr;
}
@end
