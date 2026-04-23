//
//  CaLoginUtil.m
//  ycxm
//
//  Created by 高小伟 on 2020/4/17.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "CaLoginUtil.h"
#import "GTMBase64.h"
@implementation CaLoginUtil{
    NSString *_username;
    NSString *_pin;
    
    NSString *_fileId;
    NSArray<NSDictionary *> *_processdata;
    int scount;
    NSString *_instanceId;
    NSArray <OpinionsModel *>*_opinionsData;
    NSDictionary *_params;
    BOOL useJsonParams;
}
-(void)loginByPin:(NSString *)pinText openId: (void (^)(NSString *openId)) openId{
    _pin = pinText;
    _username = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_USER_NAME];
    IMUser *user = [IMUser userWithUserName:_username];
    
    if (!user) {
        [SVProgressHUD showErrorWithStatus:@"请先下载证书"];
        return;
    }else{
        openId(@"1");
        //           [user verifyPIN:pinText loginType:@"certificate" completionBlock:^(int errcode, NSString *msg) {
        //               if (errcode != IM_ER_SUCCESS) {
        //                   [SVProgressHUD showErrorWithStatus:@"msg"];
        //               }else{
        //                   openId(user.open_id);
        //               }
        //           }];
        
        //           [user apploginauthenCompletionBlock:^(int resultCode, NSString *random) {
        //               NSString *result = [NSString stringWithFormat:@"%@", random];
        //               if (result.length != 0) {
        //                   [self getAuthorizationCode:result openId:openId];
        //               }else{
        //                   NSString *strMsg = [IMError getMsgWithErr:resultCode];
        //                   [SVProgressHUD showErrorWithStatus:strMsg];
        //               }
        //           }];
    }
}

#pragma mark 获取Authorization Code
- (void)getAuthorizationCode:(NSString *)randomStr openId: (void (^)(NSString *openId)) openId{
    //    IMUser *user = [IMUser userWithUserName:_username];
    //    [user authorizeWithUsername:_username pin:_pin credential:randomStr loginType:@"certificate" completionBlock:^(int resultCode, NSString *AuthorizationCode, NSString *msg){
    //        if (resultCode == IM_ER_NETWORK) {
    //            [SVProgressHUD showErrorWithStatus:@"无法连接到服务器"];
    //        }else if (resultCode == IM_ER_GET_OUTHORIZE_CODE_FAILED || AuthorizationCode.intValue == 6900) {
    //            if (!msg) {
    //                [SVProgressHUD showErrorWithStatus:@"用户账号状态异常，请联系管理员"];
    //                return;
    //            }else{
    //                [SVProgressHUD showErrorWithStatus:msg];
    //                return;
    //            }
    //
    //        }else{
    //            if (AuthorizationCode.length != 0) {
    //                [self getToken:AuthorizationCode openId:openId];
    //            }else{
    //                NSString *strMsg = [IMError getMsgWithErr:resultCode];
    //                [SVProgressHUD showErrorWithStatus:strMsg];
    //            }
    //        }
    //
    //    }];
}

#pragma mark -
#pragma mark 获取Token
- (void)getToken:(NSString *)authCode openId: (void (^)(NSString *openId)) openId{
    //    IMUser *user = [IMUser userWithUserName:_username];
    //    [user accessTokenWithAuthorize_code:authCode completionBlock:^(int resultCode, NSString *token) {
    //        if (token.length != 0) {
    //            [self getOpenId:token openId:openId];
    //        }else{
    //            NSString *strMsg = [IMError getMsgWithErr:resultCode];
    //            [SVProgressHUD showErrorWithStatus:strMsg];
    //        }
    //    }];
}

#pragma mark -
#pragma mark 获取openid
- (void)getOpenId:(NSString *)accessToken openId: (void (^)(NSString *openId)) openId{
    
    //    IMUser *user = [IMUser userWithUserName:_username];
    //    [user openidWithToken:accessToken completionBlock:^(int resultCode, NSString *openid) {
    //        if (openid.length != 0) {
    //            if (openId) {
    //                openId(openid);
    //            }
    //        }else{
    //            NSString *strMsg = [IMError getMsgWithErr:resultCode];
    //            [SVProgressHUD showErrorWithStatus:strMsg];
    //        }
    //    }];
}

-(void)signByParams:(NSDictionary *)params viewController:(UIViewController *)vc opinionsData:(NSArray<OpinionsModel *>*)opinionsData useJsonParams:(BOOL)useJsonParams  success: (void (^)(BOOL isSuccess))success{
    [SVProgressHUD showWithStatus:@"加载中..."];
    self->useJsonParams = useJsonParams;
    self->_params = params;
    self->_opinionsData = opinionsData;
    self->_instanceId = params[@"bizPk"];
    [[HttpManager manager] post:[NSString stringWithFormat:@"%@/%@",[UrlConfig URL:genClientSignDigestInfo],params[@"bizPk"]] data:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingWithoutEscapingSlashes error:nil]  success:^(NSData *data) {
        
        if ([ResponseUtils success:data]) {
            NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self->scount = 0;
            self->_processdata = dictData[@"data"];
            self->_fileId = self->_processdata[self->scount][@"fileId"];
            NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_USER_NAME];
            if([IMUser userWithUserName:userName]){
                NSString *PIN = [[NSUserDefaults standardUserDefaults] objectForKey:@"PIN"];
                if(PIN){
                    //登录
                    [[IMUser userWithUserName:userName].cert verifyPIN:PIN  andCompleteBlock:^(int nResult, int completeBlock){
                        if(nResult == IM_ER_SUCCESS){
                            NSString *certsn = [[IMUser userWithUserName:userName].cert exportCert];
                            NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:self->_processdata[self->scount]];
                            item[@"fileId"] = self->_fileId;
                            item[@"signCert"] = certsn;
                            [self genClientSignDigestByContent:PIN fileId:self->_fileId item:item success:success];
                        }else{
                        }
                    }];
                    
                    return;
                }
                [SVProgressHUD dismiss];
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:
                                              UIAlertControllerStyleAlert];
                [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"请输入PIN码";
                }];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    //登录
                    [SVProgressHUD showWithStatus:@"加载中..."];
                    NSString *pinCode = [[alertVc textFields] objectAtIndex:0].text;
                    [[IMUser userWithUserName:userName].cert verifyPIN:pinCode  andCompleteBlock:^(int nResult, int completeBlock){
                        [SVProgressHUD dismiss];
                        if(nResult == IM_ER_SUCCESS){
                            [[NSUserDefaults standardUserDefaults]setValue:pinCode forKey:@"PIN"];
                            NSString *certsn = [[IMUser userWithUserName:userName].cert exportCert];
                            NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:self->_processdata[self->scount]];
                            item[@"fileId"] = self->_fileId;
                            item[@"signCert"] = certsn;
                            [self genClientSignDigestByContent:pinCode fileId:self->_fileId item:item success:success];
                        }else{
                        }
                    }];
                    
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alertVc addAction:action2];
                [alertVc addAction:action1];
                [vc presentViewController:alertVc animated:YES completion:nil];
            }else{
                [SVProgressHUD showErrorWithStatus:@"未下载证书！"];
                success(NO);
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"获取流程信息失败"];
            success(NO);
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:@"获取流程信息失败"];
        success(NO);
    }];
}
//生成摘要 hash签名
-(void)genClientSignDigestByContent:(NSString *)content fileId:(NSString *)fileId item:(NSMutableDictionary *)item success: (void (^)(BOOL isSuccess))success{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[HttpManager manager]post:[NSString stringWithFormat:@"%@/%@",[UrlConfig URL:signDigest],self->_instanceId] data:[NSJSONSerialization dataWithJSONObject:item options:NSJSONWritingWithoutEscapingSlashes error:nil] success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary *digestMessages = [NSMutableDictionary dictionaryWithDictionary: [dictData[@"data"] mj_JSONObject]];
            NSMutableArray *digestMessageslist = digestMessages[@"digestMessages"];
            if(digestMessageslist && digestMessageslist.count > 0){
                NSMutableDictionary *hashDic = [NSMutableDictionary dictionaryWithDictionary:digestMessageslist.firstObject];
                NSString *hashData = hashDic[@"hashData"];
                NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_USER_NAME];
                IMCert *cert =[IMUser userWithUserName:userName].cert;

                
                //iOS代码 hashData为原文
                NSData *xmlData = [[NSData alloc] initWithBase64EncodedString:hashData options:NSDataBase64DecodingIgnoreUnknownCharacters];
                NSString *signResult = [cert signWithoutIDWithAlg:CertAlgTypeRSAWithSHA256 PIN:content data:xmlData mode:SignModeRaw];
                
                if(signResult){
                    [hashDic setValue:signResult forKey:@"clientSignData"];
                    [digestMessages setValue:[NSArray arrayWithObject:hashDic] forKey:@"digestMessages"];
                    [self genClientSignByContent:content fileId:fileId digestMessages:digestMessages success:success];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"hash签名失败！"];
                }
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"生成摘失败"];
            success(NO);
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:@"生成摘失败"];
        success(NO);
    }];
}

//    pdf签名
-(void)genClientSignByContent:(NSString *)content fileId:(NSString *)fileId digestMessages:(NSMutableDictionary *)digestMessages success: (void (^)(BOOL isSuccess))success{
    
    


    [[HttpManager manager]post:[NSString stringWithFormat:@"%@/%@/%@",[UrlConfig URL:clientSign],self->_instanceId,fileId] data:[NSJSONSerialization dataWithJSONObject:digestMessages options:NSJSONWritingWithoutEscapingSlashes error:nil]  success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            self->scount++;
            if(self->scount < self->_opinionsData.count){
                NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_USER_NAME];
                [[CaLoginUtil alloc]loginByPin:content openId:^(NSString * _Nonnull openId) {
                    NSString *certsn = [[IMUser userWithUserName:userName].cert exportCert];
                    NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:self->_processdata[self->scount]];
                    self->_fileId = self->_processdata[self->scount][@"fileId"];
                    item[@"fileId"] = self->_fileId;
                    item[@"signCert"] = certsn;
                    [self genClientSignDigestByContent:content fileId:self->_fileId item:item success:success];
                }];
            }else{
                NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSData *jsonData = [dictData[@"data"] dataUsingEncoding:NSUTF8StringEncoding];

                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                self->_fileId = dic[@"id"];
                [self submit1Success:success];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"验证签名失败"];
            success(NO);
        }
    } faild:^(NSString *msg) {
          [SVProgressHUD showErrorWithStatus:@"验证签名失败"];
          success(NO);
    }];
}
#pragma mark - 签章
-(void)sealByParams:(NSDictionary *)params viewController:(UIViewController *)vc opinionsData:(NSArray<OpinionsModel *>*)opinionsData useJsonParams:(BOOL)useJsonParams success: (void (^)(BOOL isSuccess))success{
    [SVProgressHUD showWithStatus:@"加载中..."];
    self->useJsonParams = useJsonParams;
    self->_params = params;
    self->_opinionsData = opinionsData;
    self->_instanceId = params[@"bizPk"];
    [[HttpManager manager]post:[NSString stringWithFormat:@"%@/%@/%@",[UrlConfig URL:bjcaGenSign],self->_instanceId,[[NSUserDefaults standardUserDefaults]valueForKey:@"actionVar"]] param:nil success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSData *jsonData = [dictData[@"data"] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            if (dic&&dic[@"id"]) {
                self->_fileId = dic[@"id"];
                [self submit1Success:success];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"签章失败"];
            success(NO);
        }
    } faild:^(NSString *msg) {

    }];
}

- (void)submit1Success: (void (^)(BOOL isSuccess))success {
    NSString *url= [NSString stringWithFormat:[UrlConfig URL:caServiceInstanceByCa], self->_instanceId];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self->_params];
    [params setValue:self->_fileId forKey:@"fileId"];
    [SVProgressHUD showWithStatus:nil];
    [self submit2:url params:params success:success];
    
}
- (void)submit2:(NSString *)url params:(NSDictionary *)params success: (void (^)(BOOL isSuccess))success{
    if (!self->useJsonParams) {
        [[HttpManager manager] post:url param:params success:^(NSData *data) {
            if ([ResponseUtils success:data]) {
                [SVProgressHUD showSuccessWithStatus:@"办理成功"];
                success(YES);
            } else {
                [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
            }
        } faild:^(NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        } headers:@{
            @"flow-token": @"COMPLETE"
        }];
    } else {
        [[HttpManager manager] jsonPost:url param:params success:^(NSData *data) {
            if ([ResponseUtils success:data]) {
                [SVProgressHUD showSuccessWithStatus:@"办理成功"];
                success(YES);
            } else {
                [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
            }
        } faild:^(NSString *msg) {
            success(NO);
            [SVProgressHUD showErrorWithStatus:msg];
        } headers:@{
            @"flow-token": @"COMPLETE"
        }];
    }
}
@end
