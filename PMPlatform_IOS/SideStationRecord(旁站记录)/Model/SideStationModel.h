//
//  SideStationModel.h
//  ycxm
//
//  Created by 高小伟 on 2021/4/19.
//  Copyright © 2021 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SideStationModel : NSObject

@property(nonatomic,copy)NSString * id;
@property(nonatomic,copy)NSString * code;
@property(nonatomic,copy)NSString * projectName;
@property(nonatomic,copy)NSString * constructionUnitsId;
@property(nonatomic,copy)NSString * constructionUnitsName;
@property(nonatomic,copy)NSString * supervisingUnitId;
@property(nonatomic,copy)NSString * supervisingUnitName;
@property(nonatomic,copy)NSString * projectId;
@property(nonatomic,copy)NSString * sectionId;
@property(nonatomic,copy)NSString * contractSection;
@property(nonatomic,copy)NSString * ssUserId;
@property(nonatomic,copy)NSString * ssUserName;
@property(nonatomic,copy)NSString * auditorId;
@property(nonatomic,copy)NSString * auditorName;
@property(nonatomic,assign)NSInteger  ssTime;
@property(nonatomic,copy)NSString * ssProjectNames;
@property(nonatomic,copy)NSString * workProgressDes;
@property(nonatomic,copy)NSString * ssWorkingCondition;
@property(nonatomic,copy)NSString * mainDataRecode;
@property(nonatomic,copy)NSString * problemAndResult;
@property(nonatomic,assign)int  status;
@property(nonatomic,copy)NSString * ssProjectIds;
@property(nonatomic,copy)NSString * categoryId;
@property(nonatomic,copy)NSString * userId;
@property(nonatomic,copy)NSString * userName;
@property(nonatomic,copy)NSString * functionCode;
@property(nonatomic,copy)NSString * partCode;
@property(nonatomic,copy)NSString * createDate;
@property(nonatomic,copy)NSString * remarks;


@property(nonatomic,assign)NSInteger  piTime;
@property(nonatomic,copy)NSString * piScopeName;
@property(nonatomic,copy)NSString * mainWorkDes;
@property(nonatomic,copy)NSString * piUserName;


@property(nonatomic,copy)NSString * instId;

@end

NS_ASSUME_NONNULL_END
