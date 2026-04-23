//
//  TLLoginView.h
//  ZegoRoomkitDemo
//
//  Created by KaelDing on 2020/7/15.
//  Copyright © 2020 zego. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface TLLoginView : UIView

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, strong) RACSubject *loginAction;

@end

NS_ASSUME_NONNULL_END
