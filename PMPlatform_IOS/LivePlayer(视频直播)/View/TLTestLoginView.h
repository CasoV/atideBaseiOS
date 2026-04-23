//
//  TLTestLoginView.h
//  ZegoRoomkitDemo
//
//  Created by KaelDing on 2020/7/15.
//  Copyright © 2020 zego. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLTestLoginView : UIView

@property (nonatomic, copy) NSString *testLoginId;
@property (nonatomic, copy) NSString *testLoginName;

@property (nonatomic, copy) void(^testLoginBlock)(void);

@end

NS_ASSUME_NONNULL_END
