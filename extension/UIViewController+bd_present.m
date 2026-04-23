//
//  UIViewController+bd_present.m
//  AipOcrDemo
//
//  Created by Zhang,Jian(MBD) on 2021/12/14.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import "UIViewController+bd_present.h"

@implementation UIViewController (bd_present)

- (void)bd_presentViewControllerWithFullScreen:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion {
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewControllerToPresent animated:flag completion:completion];
}


@end
