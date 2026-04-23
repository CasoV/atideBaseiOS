//
//  UserAgent.m
//  ycxm
//
//  Created by 末末班车 on 2018/9/17.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "UserAgent.h"
#import "CacheFileManager.h"
static UserAgent *sharedInstance = nil;

@implementation UserAgent {
    NSTimer *_timer;
}

+ (UserAgent *)defaultUser {
    UserAgent *agent = [[UserAgent alloc] init];
    agent.projectId = @"-1";
    agent.sectionId = @"-1";
    agent.projectCode = @"-1";
    agent.sectionCode = @"-1";
    agent.prjName = @"";
    agent.sectionName = @"";
    return agent;
}

+ (UserAgent *)DefaultAgent
{
    if(!sharedInstance){
        NSString *path = [CacheFileManager userCacheConfigFilePath];
        sharedInstance = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (sharedInstance == nil) {
            sharedInstance = [[self class] defaultUser];
        }
    }
    return sharedInstance;
}

- (NSString *)projectId {
    if (!_projectId) {
        _projectId = @"";
    }
    return _projectId;
}

- (NSString *)sectionId {
    if (!_sectionId) {
        _sectionId = @"";
    }
    return _sectionId;
}
/**
 *  将某个对象写入文件时会调用
 *  在这个方法中说清楚哪些属性需要存储
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.projectId forKey:@"projectId"];
    [encoder encodeObject:self.sectionId forKey:@"sectionId"];
}

/**
 *  从文件中解析对象时会调用
 *  在这个方法中说清楚哪些属性需要存储
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [self init]) {
        // 读取文件的内容
        self.projectId = [decoder decodeObjectForKey:@"projectId"];
        self.sectionId = [decoder decodeObjectForKey:@"sectionId"];
        
    }
    return self;
}

- (void)saveValuesToCache {
    NSString *path = [CacheFileManager userCacheConfigFilePath];
    // 将对象归档
    [NSKeyedArchiver archiveRootObject:self toFile:path];
}

- (NSString *)projectCode {
    if (!self.projectInfos || self.projectInfos.count<1) {
        return _projectCode == nil ? @"" : _projectCode;
    }
    
    for (ProjectInfo *info in self.projectInfos) {
        if ([info.id isEqualToString:self.projectId]) {
            _projectCode = info.otherInfo[@"projectCode"];
            break;
        }
    }
    
    return _projectCode ? _projectCode : @"";
}

- (NSString *)sectionCode {
    if (!self.sectionInfos || self.sectionInfos.count<1) {
        return _sectionCode == nil ? @"" : _sectionCode;
    }
    
    for (ProjectInfo *info in self.sectionInfos) {
        if ([info.id isEqualToString:self.sectionId]) {
            _sectionCode = info.otherInfo[@"sectCode"];
            break;
        }
    }
    
    return _sectionCode ? _sectionCode : @"";
}


- (NSString *)sectMajor {
    if (!self.sectionInfos || self.sectionInfos.count<1) {
        return _sectMajor == nil ? @"" : _sectMajor;
    }
    
    for (ProjectInfo *info in self.sectionInfos) {
        if ([info.id isEqualToString:self.sectionId]) {
            _sectMajor = info.otherInfo[@"sectMajor"];
            break;
        }
    }
    
    return _sectMajor ? _sectMajor : @"";
}



- (NSString *)prjName{
    if (!self.projectInfos || self.projectInfos.count<1) {
        return _prjName == nil ? @"" : _prjName;
    }
    
    for (ProjectInfo *info in self.projectInfos) {
        if ([info.id isEqualToString:self.projectId]) {
            _prjName = info.text;
            break;
        }
    }
    
    return _prjName ? _prjName : @"";
}

- (NSString *)sectionName{
    if (!self.sectionInfos || self.sectionInfos.count<1) {
        return _sectionName == nil ? @"" : _sectionName;
    }
    
    for (ProjectInfo *info in self.sectionInfos) {
        if ([info.id isEqualToString:self.sectionId]) {
            _sectionName = info.text;
            break;
        }
    }
    
    return _sectionName ? _sectionName : @"";
}

- (NSArray<NSString *> *)resourceKeys {
    if (!_resourceKeys) {
        _resourceKeys = @[];
    }
    return _resourceKeys;
}

- (void)setApprovalPartModel:(ApprovalPartModel *)approvalPartModel {
    _approvalPartModel = approvalPartModel;
    
    if (_timer) {
        [_timer invalidate];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1800 target:self selector:@selector(removeApprovalPartModel) userInfo:nil repeats:YES];
}

- (void)removeApprovalPartModel {
    _approvalPartModel = nil;
}

-(BOOL)authorityChangeProAndSect:(PermissionModel *)perModel{
    ProjectInfo *prjModel;
    NSArray *arr = self.projectInfos;
    for (ProjectInfo *info in arr) {
        if ([info.id isEqualToString:[UserAgent DefaultAgent].projectId]) {
            prjModel = info;
            break;
        }
    }
    if (perModel.proType && self.sectionId) {
        if ([perModel.proType rangeOfString:self.sectMajor].location == NSNotFound)  {
            //需要变换项目-标段
            for ( ProjectInfo *sect in prjModel.tempChildren) {
                if ([perModel.proType rangeOfString:sect.otherInfo [@"sectMajor"]].location != NSNotFound) {
                    
                    self.projectId = prjModel.id;
                    self.projectCode = prjModel.code;
                   self
                    .sectionId = sect.id;
                    [[NSUserDefaults standardUserDefaults]setObject:sect.id forKey:@"sectId"];
                    self.sectionCode = sect.otherInfo[@"sectCode"];
                    self.sectionInfos = prjModel.tempChildren;
                    [self saveValuesToCache];
                    [self setSeviceProjectInfo:prjModel section:sect];
                    return YES;
                }
            }
        }
    }
    return NO;
}
-(void)setSeviceProjectInfo:(ProjectInfo *)project section:(ProjectInfo *)sectionInfo{
    //切换服务器项目
    [[HttpManager manager]post:[UrlConfig URL:setPrjInfo] param:@{
        @"typeKey":project.attributes[@"key"],
        @"projectId": project.id,
        @"mainPrjName": project.text,
        @"mainPrjCode": project.otherInfo[@"projectCode"],
        @"projectPlanSn": project.otherInfo[@"projectPlanSn"],
        @"mainSectionId": sectionInfo.id,
        @"mainSectionName":sectionInfo.text,
        @"mainSectionCode": sectionInfo.otherInfo[@"sectCode"],
        @"stdVersion": sectionInfo.otherInfo[@"stdVersion"],
        @"sectionMajor":sectionInfo.otherInfo[@"sectMajor"]
    } success:^(NSData *data) {
        
    } faild:^(NSString *msg) {
        
    }];
}

#pragma mark - 新 功能权限处理方法
- (void)authorityChangeProAndSect:(PermissionModel *)perModel callBack:(void (^)(Boolean isChange))callBack {
    if (perModel && (perModel.linkType || perModel.proType)) {
        ProjectInfo *proBean = nil;
        ProjectInfo *sectBean = nil;

        for (ProjectInfo *project in self.projectInfos) {
            if ([project.id isEqualToString:self.projectId]) {
                proBean = project;
                for (ProjectInfo *sect in project.tempChildren) {
                    if ([sect.id isEqualToString:self.sectionId]) {
                        sectBean = sect;
                        break;
                    }
                }
                break;
            }
        }

        if (perModel.linkType && [perModel.linkType isEqualToString:MENU_LINK_TYPE_PRO_ID] && sectBean) {
            [self changeProAndSect:perModel project:proBean section:nil callBack:callBack];
            return;
        } else if (proBean && perModel.proType) {
            if (sectBean == nil || sectBean.otherInfo[@"sectMajor"] == nil || ![[perModel.proType componentsSeparatedByString:@","] containsObject:sectBean.otherInfo[@"sectMajor"]]) {
                for (ProjectInfo *sect in proBean.tempChildren) {
                    if (sect.otherInfo[@"sectMajor"] != nil && [[perModel.proType componentsSeparatedByString:@","] containsObject:sect.otherInfo[@"sectMajor"]]) {
                        [self changeProAndSect:perModel project:proBean section:sect callBack:callBack];
                        return;
                    }
                }
            }
        }
    }
    callBack(NO);
}

- (void)changeProAndSect:(PermissionModel *)model project:(ProjectInfo *)project section:(ProjectInfo *)section callBack:(void (^)(Boolean isChange))callBack {
    [[NSUserDefaults standardUserDefaults] setObject:project.id forKey:@"projectId"];
    self.projectId = project.id;
    self.typeKey =  project.attributes[@"key"];

    if (section) {
        [[NSUserDefaults standardUserDefaults] setObject:section.id forKey:@"sectId"];
        self.sectionId = section.id;
        self.sectionName = section.text;
        self.stdVersion = section.otherInfo[@"stdVersion"];
        self.sectionMajor = section.otherInfo[@"sectMajor"];
    } else {
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"sectId"];
        self.sectionId = @"";
        self.sectionName = @"";
        self.stdVersion = @"";
        self.sectionMajor = @"";
    }
    self.sectionInfos = project.tempChildren;
    [self saveValuesToCache];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //切换服务器项目
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
        @"typeKey": project.attributes[@"key"],
        @"projectId": project.id,
        @"mainPrjName": project.text,
        @"mainPrjCode": project.otherInfo[@"projectCode"],
        @"projectPlanSn": project.otherInfo[@"projectPlanSn"]
    }];
    if (section) {
        [param setObject:section.id forKey:@"mainSectionId"];
        [param setObject:section.text forKey:@"mainSectionName"];
        [param setObject:section.otherInfo[@"sectCode"] forKey:@"mainSectionCode"];
        [param setObject:section.otherInfo[@"stdVersion"] forKey:@"stdVersion"];
        [param setObject:section.otherInfo[@"sectMajor"] forKey:@"sectionMajor"];
    }
    [[HttpManager manager] post:[UrlConfig URL:setPrjInfo] param:param success:^(NSData *data) {
        callBack(YES);
    } faild:^(NSString *msg) {}];
}

@end
