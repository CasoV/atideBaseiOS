//
//  AttenanceDayModel.h
//  ycxm
//
//  Created by 高小伟 on 2020/6/11.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AttenanceDayModel : NSObject

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *projectId;
@property (nonatomic,copy) NSString *sectionId;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *xPoint;
@property (nonatomic,copy) NSString *yPoint;
@property (nonatomic,copy) NSString *dress;
@property (nonatomic,copy) NSString *cz;
@property (nonatomic,copy) NSString *mbsCz;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *imgUrl;
@property (nonatomic,copy) NSString *typeStr;
@end

NS_ASSUME_NONNULL_END
