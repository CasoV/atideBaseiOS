//
//  JYAnalyData.h
//  TrafficMs
//
//  Created by apple on 2015/11/04.
//  Copyright © 2015年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Monthdata,Gatherdata,Sessiondata;
@interface JYAnalyData : NSObject


@property (nonatomic, strong) NSArray<Monthdata *> *monthData;

@property (nonatomic, strong) NSArray<Gatherdata *> *gatherData;

@property (nonatomic, strong) NSArray<Sessiondata *> *sessionData;


@end
@interface Monthdata : NSObject

@property (nonatomic, assign) NSString *parentId;

@property (nonatomic, assign) NSString *value3;

@property (nonatomic, copy) NSString *value1;

@property (nonatomic, assign) NSString *ID;

@property (nonatomic, copy) NSString *value2;

@property (nonatomic, copy) NSString *sectName;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *sectNo;

@property (nonatomic, copy) NSString *session;

- (void)setData:(NSDictionary *)nsd;

@end

@interface Gatherdata : NSObject

@property (nonatomic, assign) NSString * mJlPercent;

@property (nonatomic, copy) NSString *mJl;

@property (nonatomic, copy) NSString *mCode;

@property (nonatomic, copy) NSString *mHt;

@property (nonatomic, copy) NSString *mName;

@property (nonatomic, copy) NSString *sectNo;

@property (nonatomic, copy) NSString *session;

- (void)setData:(NSDictionary *)nsd;

@end

@interface Sessiondata : NSObject

@property (nonatomic, assign) NSString * parentId;

@property (nonatomic, assign) NSString * value3;

@property (nonatomic, copy) NSString *value1;

@property (nonatomic, assign) NSString * ID;

@property (nonatomic, copy) NSString *value2;

@property (nonatomic, copy) NSString *sectName;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *sectNo;

@property (nonatomic, copy) NSString *session;

- (void)setData:(NSDictionary *)nsd;

@end

