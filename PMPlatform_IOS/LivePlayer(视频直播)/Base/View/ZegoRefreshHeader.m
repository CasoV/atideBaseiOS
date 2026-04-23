//
//  ZegoRefreshHeader.m
//  ZegoEducation
//
//  Created by MrLQ  on 2019/6/8.
//  Copyright © 2019 Shenzhen Zego Technology Company Limited. All rights reserved.
//

#import "ZegoRefreshHeader.h"
#import  <Lottie/Lottie.h>

@interface ZegoRefreshHeader()

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) LOTAnimationView *animationView;

@property (nonatomic, assign) MJRefreshState oldState;
@property (nonatomic, assign) BOOL isSuccessed;


@end

@implementation ZegoRefreshHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 55;
    
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.textColor = UIColorHex(#666666);
    self.tipLabel.font = BOLD_FONT(11);
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.text = TLLocalizedString(refresh_loading);
    [self.tipLabel sizeToFit];
    [self addSubview:self.tipLabel];
    
    self.animationView = [LOTAnimationView animationNamed:@"refresh"];
    self.animationView.size = CGSizeMake(27, 27);
    self.animationView.loopAnimation = YES;
    [self addSubview:self.animationView];
    
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.animationView.left = (kScreenWidth - self.animationView.width - self.tipLabel.width - 5) * 0.5;
    self.tipLabel.left = self.animationView.right + 5;
    self.animationView.top = 30 * kScreenWidth;
    self.animationView.centerY = self.tipLabel.centerY = self.mj_h * 0.5;

}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            [self.animationView stop];
            self.tipLabel.text = TLLocalizedString(refresh_pull_down);
            
            if (self.oldState == MJRefreshStateRefreshing && self.isSuccessed) {
                self.tipLabel.text = TLLocalizedString(refresh_done);
            }else if (self.oldState == MJRefreshStateRefreshing && !self.isSuccessed){
                self.tipLabel.text = TLLocalizedString(refresh_done);
            }

            break;
        case MJRefreshStatePulling:
          
            [self.animationView stop];
            self.tipLabel.text = TLLocalizedString(refresh_release_trigger);

            break;
        case MJRefreshStateRefreshing:
            [self.animationView play];
            self.tipLabel.text = TLLocalizedString(refresh_loading);

            break;
        default:
            break;
    }
    [self.tipLabel sizeToFit];
    
    self.oldState = state;
}

- (void)endRefreshingWithResult:(BOOL)isSuccessed
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isSuccessed = isSuccessed;
        [self endRefreshing];
    });
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
}


@end
