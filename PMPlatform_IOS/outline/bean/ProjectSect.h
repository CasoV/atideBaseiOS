//
//  ProjectSect.h
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/06.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 "sectcode": "JL-3",
 "sectname": "施工监理JL-3标段",
 "orderno": "3",
 "sectno": "57"
 **/
@interface ProjectSect : NSObject
@property (nonatomic, copy) NSString *sectcode;
@property (nonatomic, copy) NSString *sectname;
@property (nonatomic, copy) NSString *orderno;
@property (nonatomic, copy) NSString *sectno;
@property (nonatomic, assign) BOOL issect;
@end
