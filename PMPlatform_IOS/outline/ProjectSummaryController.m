//
//  ProjectSummaryController.m
//  PMPlatform_IOS
//
//  Created by vxg on 2017/11/30.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ProjectSummaryController.h"
#import "WebServiceConfig.h"
#import "WebserviceManager.h"
#import "UserInfo.h"
#import "XMLParser.h"
#import "ProjectInfo.h"
#import "SysConfig.h"

@interface ProjectSummaryController (){
    UITextView *contentLabel;
}

@end

@implementation ProjectSummaryController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchProjects];
    // Do any additional setup after loading the view.
}

- (void)fetchProjects{
    [MBManager showLoading];
    __weak typeof(self) weakSelf = self;
    NSDictionary *config = [WebServiceConfig config:WebServiceConfig.SecurityService];
    [WebserviceManager dataTaskWithSoapRequest:[@{@"userKey":UserInfo.getInstance.ID} mutableCopy] url:config[@"url"] method:config[@"GetProjectsByUserKeys"] nameSpace:config[@"nameSpace"] completed:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBManager hideAlert];
                [MBManager showBriefAlert:[NSString stringWithFormat:@"%@", error]];
            });
        }else {
            
            [[[XMLParser alloc] init] analysisXMLData:data handleBlock:^(NSData *jsonData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBManager hideAlert];
                    if ([ResponseUtils success:jsonData]) {
                        NSArray *ps = [ProjectInfo mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
                        if (!ps || ps.count<1) {
                            return;
                        }
                        [SysConfig getInstance].projectInfos = ps;
                        ProjectInfo *info = ps[0];
                        [SysConfig getInstance].projectId = info.prjid;
                        [SysConfig getInstance].projectCode = info.prjcode;
                        [weakSelf initProjects];
                        //[weakSelf fetchProjectInvest];
                        
                    } else {
                        [MBManager showBriefAlert:[ResponseUtils getMsg]];
                    }
                });
            }];
        }
    }];
}
- (void)refresh:(BOOL)isRefresh{
    if (!isRefresh) {
        return;
    }
    [super refresh:isRefresh];
    [self fetchProjectSummary];
}
- (BOOL)isVisible{
    return self.tabBarController.selectedIndex == 0;
}

- (BOOL)sectIsHidden{
    return YES;
}
- (UIView *)childView{
    contentLabel = [[UITextView alloc] init];
    contentLabel.editable = NO;
    contentLabel.font = [UIFont systemFontOfSize:14];
    return contentLabel;
}
- (void)dealWithResponse:(NSString *)text{
    contentLabel.text = text;
    
}
- (void)fetchProjectSummary{
    if ([self isVisible]) {
        [MBManager showLoading];
    }

    __weak typeof(self) weakSelf = self;
    NSDictionary *config = [WebServiceConfig config:WebServiceConfig.SingleProjectService];
    [WebserviceManager dataTaskWithSoapRequest:[@{@"projectCode":[SysConfig getInstance].projectCode} mutableCopy] url:config[@"url"] method:config[@"GetProjectInfoDatasByPrjCode"] nameSpace:config[@"nameSpace"] completed:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dealWithResponse:@""];
                if ([self isVisible]) {
                    [MBManager hideAlert];
                    [MBManager showBriefAlert:[NSString stringWithFormat:@"%@", error]];
                }
            });
        }else {
            
            [[[XMLParser alloc] init] analysisXMLData:data handleBlock:^(NSData *jsonData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self isVisible])
                        [MBManager hideAlert];
                    if ([ResponseUtils success:jsonData]) {
                        NSArray *ps = [ResponseUtils getData:@"data"];
                        if (ps!=nil && ps.count>0) {
                            [weakSelf dealWithResponse:[ps objectAtIndex:0][@"projectsummary"]];
                        }else{
                        [weakSelf dealWithResponse:@""];
                        }
                        
                    } else {
                        [weakSelf dealWithResponse:@""];
                        if ([self isVisible])
                            [MBManager showBriefAlert:[ResponseUtils getMsg]];
                    }
                });
            }];
        }
    }];
}
@end
