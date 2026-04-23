//
//  FormBase1Controller.h
//  ycxm
//
//  Created by 高小伟 on 2021/4/19.
//  Copyright © 2021 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FormBase1Controller : BaseViewController

@property (nonatomic, copy) NSString *typeUrl;
@property (nonatomic, copy) NSString *submitText;
@property (nonatomic, copy) NSString *reTitle;
@property (nonatomic, assign)BOOL hasFLow;
@property (nonatomic, assign) BOOL attachment;
@property (nonatomic, copy) NSString *bizPk;
@property (nonatomic, copy) NSString *id;
@property(nonatomic,assign)BOOL isReadOnly;
@end

NS_ASSUME_NONNULL_END
