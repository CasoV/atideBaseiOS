//
//  UserInfo.h
//  yu
//
//  Created by apple on 14-7-10.
//  Copyright (c) 2014年 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommCfg.h"

#define NEWS_XWDT @"新闻动态"
#define NEWS_GSXW @"公司新闻"
#define NEWS_HYDT @"行业动态"
#define NEWS_ZCFG @"政策法规"
#define NEWS_XMZS @"项目展示"

#define NEWS_PROJECT_CHUDA      @"楚大项目"
#define NEWS_PROJECT_DAYONG     @"大永项目"
#define NEWS_PROJECT_SHANGHE    @"上鹤项目"
#define NEWS_PROJECT_DW         @"党务信息"

//大永项目
#define PROJECT_ID_DY       @"2"
#define PROJECT_ID_SH       @"3"
#define PROJECT_ID_CD       @"6"
#define CATALOG_ID_DW       @"10"
#define CATALOG_ID_CONSULT  @"11"
#define CATALOG_ID_SCROLL   @"12"

//东南绕

#define JLZF_HTJE @""



@interface StringUtils : NSObject{
   
    
}

+ (NSString *) trimInvalidZero:(NSString *)str;
+ (NSMutableArray *) VxgGetSectNewstSession:(NSMutableArray *)sourceDatas;
+ (NSString *) VxgGetFileSizie:(NSString *)fileSize;

+ (NSString *)parserSoapResult:(NSString *)soapResult matchResult:(NSString *)match;
+ (NSString *) getCurrentTime;
+ (BOOL) isPdfFile:(NSString *)filePath;
+ (NSString *)trim_n:(NSString *)src;

@end