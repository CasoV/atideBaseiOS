//
//  ApprovalPartModel.h
//  ycxm
//
//  Created by 末末班车 on 2019/3/5.
//  Copyright © 2019 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApprovalPartModel : NSObject

@property (nonatomic, copy) NSString *NAME_;

@property (nonatomic, copy) NSString *CODE_;

@property (nonatomic, copy) NSString *TYPE_;

@property (nonatomic, copy) NSString *SECTION_ID;

@property (nonatomic, copy) NSString *PRJID;

@property (nonatomic, assign) CGFloat X_POINT;
@property (nonatomic, assign) CGFloat Y_POINT;

@end

NS_ASSUME_NONNULL_END
