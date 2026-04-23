//
//  TLSettingViewController.h
//  ZegoRoomkitDemo
//
//  Created by Kael Ding on 2020/7/17.
//  Copyright © 2020 zego. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLSettingViewController : UIViewController

@property (nonatomic, copy) void (^quickJoinRoomBlock)(NSString *roomID);

@end

NS_ASSUME_NONNULL_END
