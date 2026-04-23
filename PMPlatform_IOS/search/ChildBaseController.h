//
//  ChildBaseController.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/6.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchParam.h"

@interface ChildBaseController : UIViewController

@property (nonatomic, assign) BOOL autoRefresh;//不是搜索创建的都加载数据
@property (nonatomic, assign) BOOL isDestory;//是否返回
@property (nonatomic, assign) NSInteger searchType;
@property (nonatomic, strong) NSMutableDictionary *searchParam;
@property (nonatomic, copy) NSString *url;

- (void)refresh:(NSDictionary *)param;

//MARK:通用搜索格式
- (void)normalSearch:(SearchParam *)model;

- (void)setTitleKey:(NSString *)key;

@end
