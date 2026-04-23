//
//  WebFlowBaseViewController.h
//  ycxm
//
//  Created by 高小伟 on 2020/11/25.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebFlowBaseViewController : BaseViewController
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *bizPk;
@property(nonatomic,copy)NSString *partCode;
@property(nonatomic,copy)NSString *navTitle;
@property(nonatomic,copy)NSString *typeUrl;
@property(nonatomic,copy)NSString *entityName;
@property(nonatomic,copy)NSString *mid;
@end

NS_ASSUME_NONNULL_END
