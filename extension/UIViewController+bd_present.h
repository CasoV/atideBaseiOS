//
//  UIViewController+bd_present.h
//  AipOcrDemo
//
//  Created by Zhang,Jian(MBD) on 2021/12/14.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (bd_present)

- (void)bd_presentViewControllerWithFullScreen:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
