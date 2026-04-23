//
//  FlowApprovalCommentView.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/11.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowApprovalCommentView : UIView

- (void)request:(NSString *)ID type:(NSInteger)type callback:(void (^)(CGFloat height))callback;

@end
