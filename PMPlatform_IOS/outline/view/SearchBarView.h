//
//  SearchBarView.h
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/05.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Block) ();
@interface SearchBarView : UIView
@property (nonatomic, assign) BOOL sectIsHidden;
- (instancetype)initWithFrame:(CGRect)frame controller:(UIViewController *)controller block:(Block)block;
- (NSString *)time;
- (NSArray *)sects;
- (void)reset;
@end
