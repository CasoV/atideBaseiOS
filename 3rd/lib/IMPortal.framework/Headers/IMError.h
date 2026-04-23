//
//  IMError.h
//  IMPortal
//
//  Created by infosec2013 on 16/6/29.
//  Copyright © 2016年 IF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMError : NSObject

//ERROR
#define IM_ER_SUCCESS                      0x0000
#define IM_ER_USER_OR_SIGNCODE             0X0001
#define IM_ER_INVALID_PARAM                0X0002 //参数错误
#define IM_ER_USER_NOT_FOUND               0x0003
#define IM_ER_REGIST_INFO_INVALID          0X0004
#define IM_ER_USER_NOT_REVIEWD             0x0005
#define IM_ER_USER_FORMAT_INVALID          0x0006
#define IM_ER_USER_NAME_NULL               0x0007
#define IM_ER_LOCKTRADE_NULL               0x0008
#define IM_ER_LOCKTRADE_FORMAT             0x0009

#define IM_ER_TOKEN_HAS_BEEN_FREEZE        0x0010
#define IM_ER_TOKEN_HAS_BEEN_INVALID       0x0011
#define IM_ER_TOKEN_GET_SEED_FAILED        0x0012
#define IM_ER_TOKEN_GENERATE_FAILED        0x0013
#define IM_ER_TOKEN_SEED_IMPORT_FAILED     0X0014
#define IM_ER_GET_AUTHORIZE_CODE_FAILED    0x0015
#define IM_ER_GET_CERT_FAILED              0x0016
#define IM_ER_GET_RANDOM_FAILED            0X0017
#define IM_ER_CERT_HAS_EXIST               0x0018 //证书已存在，需要使用更新操作
#define IM_ER_CERT_NOT_EXIST               0x0019
#define IM_ER_CERT_SIGN_FAIL               0x001A

#define IM_ER_DN_NULL                      0X0020
#define IM_ER_P10_NULL                     0x0021
#define IM_ER_CERT_STATUS_ERROR            0x0022
#define IM_ER_CERT_HAS_BEEN_INVALID        0x0023
#define IM_ER_CERT_HAS_REVIEW_RECORD       0x0024
#define IM_ER_RANDOM_NULL                  0x0025
#define IM_ER_NETSIGN_INIT_FAILD           0x0026
#define IM_ER_BUSINESS_ID_NULL             0x0027
#define IM_ER_APPLY_TIME_NULL              0x0028
#define IM_ER_SIGN_CONTEXT_NULL            0x0029

#define IM_ER_APPLY_TIME_OUT               0x0030
#define IM_ER_APPLY_TIME_PARSE_FAILED      0x0031
#define IM_ER_PARSE_P7B_FAILD              0x0032
#define IM_ER_LOGIN_WITH_QRCODE_FAILED     0x0033
#define IM_ER_CERT_AUTH_FAILED             0x0034
#define IM_ER_VERIFY_PIN                   0x0035
#define IM_ER_CHANGE_PIN                   0x0036
#define IM_ER_CERT_HAS_BEEN_FREEZE         0x0037
#define IM_ER_CERT_NOT_APPLY               0x0038
#define IM_ER_IMEI_NULL                    0x0039

#define IM_ER_SM2_PUB                      0x0040
#define IM_ER_OPT_FAILD                    0X0041
#define IM_ER_DEVICE_HAS_BEEN_REGIST       0x0042
#define IM_ER_LOCK_TRADE_NVALID            0x0043
#define IM_ER_USER_HAS_BEEN_RESET          0X0044
#define IM_ER_NOT_SUPPORT_USER_TYPE        0x0045
#define IM_ER_VERIFY_SIGN_FAILED           0x0046
#define IM_ER_UNDEFINED_DATA               0X0047
#define IM_ER_GET_TOKEN_STATE_FAILD        0x0048
#define IM_ER_LOCK_USER_FAILED             0x0049

#define IM_ER_IMPORT_CERT_FAILED           0x0050
#define IM_ER_GET_CERT_STATE_FAILED        0x0051
#define IM_ER_GET_SYS_APP_VERSION          0x0052
#define IM_ER_OTPNUM                       0x0053
#define IM_ER_REGISTER_DEVICE_FAILED       0x0054
#define IM_ER_REQUEST_INTERFACE_FAIL       0x0055
#define IM_ER_OAUTH2_IDENTIFICATION_FAIL   0x0056
#define IM_ER_OAUTH2_IDENTIFICATION_FAIL_1 0x0057
#define IM_ER_TOKEN_BIND_FAIL              0x0058
#define IM_ER_TOKEN_UNBIND_FAIL            0x0059

#define IM_ER_GET_LOGINTYPELIST_FAILED     0x0060
#define IM_ER_LOGOUT_FAILED                0x0061
#define IM_ER_NETAUTH_LOGIN_FAILED         0x0062
#define IM_ER_SIGNIN_FAILED                0x0063
#define IM_ER_GET_TOKEN_FAIL               0x0064
#define IM_ER_GET_OPENID_FAIL              0x0065


#define IM_ER_NETWORK                      0x1000
#define IM_ER_ANALYSIS_RESP_FAILURE        0x1001
#define IM_ER_UNKONWN_EXCEPTION            0x1002

+ (NSString *)getMsgWithErr:(NSInteger)err;
@end

