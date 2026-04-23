//
//  Org.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/8.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Org : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *attributes;
@property (nonatomic, copy) NSString *checked;
@property (nonatomic, copy) NSString *superId;

@property (nonatomic, copy) NSArray <Org *>*children;

@end
