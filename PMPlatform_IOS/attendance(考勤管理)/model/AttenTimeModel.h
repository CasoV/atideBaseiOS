//
//  AttenTimeModel.h
//  ycxm
//
//  Created by 末末班车 on 2022/4/8.
//  Copyright © 2022 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AttenTimeModel : NSObject

@property (nonatomic, copy) NSString *page;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *sectionId;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *maxStartTime;
@property (nonatomic, copy) NSString *minEndTime;
@property (nonatomic, copy) NSString *separateTime;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *startTimen;
@property (nonatomic, copy) NSString *endTimen;

@end

NS_ASSUME_NONNULL_END
