//
//  globalCfg.h
//  TrafficMs
//
//  Created by apple on 15/10/10.
//  Copyright (c) 2015年 com. All rights reserved.
//

#ifndef TrafficMs_Config_h
#define TrafficMs_Config_h

extern const NSString *g_HOST_LOCAL_DY ;
extern const NSString *g_HOST_TEST_187;
extern const NSString *g_HOST_PRODUCATION;
extern const NSString *g_HOST_DATABASE;

extern const NSString *g_URL_PAY;
extern const NSString *g_URL_OA;
extern const NSString *g_URL_Query;
extern const NSString *g_URL_News;

extern const NSString *g_DABASE_NAME;
extern const NSString *g_DABASE_PATH;
#define URL_APPROVAL_OA @"OAWebService.asmx"
#define NAMESPACE_WAGES @"http://www.atidesoft.com/OAWebService/"
//NSString *URL_APPROVAL_OA = @"OAWebService.asmx";
//NSString *NAMESPACE_WAGES = @"http://www.atidesoft.com/OAWebService/";

//TAGS
#define VIEW_TAG_INVEST             1024
#define VIEW_TAG_OAMAIN_WATING      2000
#define VIEW_TAG_OAMAIN_BACK        2001
#define VIEW_TAG_OAMAIN_DEALED      2002

#define ATIDE_TITLE_VIEW_HEIGHT 64
#define ATIDE_DESC_VIEW_HEIGHT 30

#define OA_SEND_STATUS_WATING   1
#define OA_SEND_STATUS_BACK     2
#define OA_SEND_STATUS_DEALED   3
#define OA_RECV_STATUS_WATING   4
#define OA_RECV_STATUS_BACK     5
#define OA_RECV_STATUS_DEALED   6

#define BIZFLAG_AFFIX_MIDPAY        @"3"
#define BIZFLAG_AFFIX_SUPERVISION   @"4"

#define ZQZF @"ZQZF"
#define JLFYZF @"JLFYZF"

@interface CommCfg : NSObject {
    
}

@end

#endif
