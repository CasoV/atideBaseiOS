//
//  FDBaseViewController.m
//  ycxm
//
//  Created by 末末班车 on 2018/9/26.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "FDBaseViewController.h"

@interface FDBaseViewController ()

@end

@implementation FDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.iflyHelper = [[IFlyHelper alloc] initWithView:self.view delegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - 语音协议
//- (void)onError:(IFlySpeechError *)error {
//    NSString *result = [self.iflyHelper onError:error];
//    NSString *str = self.textView.text;
//    if (str.length > 3) {
//        if ([[str substringToIndex:3] isEqualToString:@"请输入"]) {
//            str = @"";
//        }
//    }
//    self.textView.text = [NSString stringWithFormat:@"%@%@", str, result];
//}
//
//- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast {
////    [self.iflyHelper onResult:resultArray isLast:isLast];
//}

@end
