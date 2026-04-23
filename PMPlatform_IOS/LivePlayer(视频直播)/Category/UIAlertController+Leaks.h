//
//  UIAlertController+Leaks.h
//  ZegoRoomkitDemo
//
//  Created by xia on 2021/1/22.
//  Copyright © 2021 zego. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^actionHandler)(UIAlertAction *action, NSString *content);

@interface UIAlertController (Leaks)

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
              cancelAction:(actionHandler)cancelHandler
             confirmAction:(actionHandler)confirmHandler
              onController:(UIViewController *)vc
               placeHolder:(NSString *)placeHolder;

@end

NS_ASSUME_NONNULL_END
