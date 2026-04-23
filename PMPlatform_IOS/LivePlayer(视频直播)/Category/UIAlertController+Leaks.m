//
//  UIAlertController+Leaks.m
//  ZegoRoomkitDemo
//
//  Created by xia on 2021/1/22.
//  Copyright © 2021 zego. All rights reserved.
//

#import "UIAlertController+Leaks.h"

@implementation UIAlertController (Leaks)

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
              cancelAction:(actionHandler)cancelHandler
             confirmAction:(actionHandler)confirmHandler
              onController:(UIViewController *)vc
               placeHolder:(NSString *)placeHolder {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        textField.placeholder = placeHolder;
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelHandler) {
            cancelHandler(action, alertController.textFields[0].text);
        }
    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirmHandler) {
            confirmHandler(action, alertController.textFields[0].text);
        }
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:confirm];
    
    [vc presentViewController:alertController animated:NO completion:nil];
}

- (BOOL)willDealloc {
    return NO;
}

@end
