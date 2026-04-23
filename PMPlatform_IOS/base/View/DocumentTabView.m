//
//  DocumentTabView.m
//  YXConstructionApp
//
//  Created by 末末班车 on 2018/3/22.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "DocumentTabView.h"

@implementation DocumentTabView {
    NSArray *_titles;
    NSMutableArray <UIButton *>*_buttons;
    UIView *_lineView;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
    if (self = [super initWithFrame:frame]) {
        _titles = titles;
        _currentIndex = 0;
        [self setupUI];
    }
    return self;
}


//初始化界面
- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    _buttons =  [NSMutableArray array];
    
    CGFloat btnWidth = kScreen_Width / _titles.count;
    CGFloat btnHeight = self.frame.size.height;
    
    for (NSInteger i = 0; i < _titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * btnWidth, 0, btnWidth, btnHeight);
        btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [btn setTitle:_titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x269FE7) forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [_buttons addObject:btn];
        
        if (i == 0) {
            btn.selected = YES;
        }
    }
    
    _lineView =  [[UIView alloc] initWithFrame:CGRectMake(10, btnHeight - 3, btnWidth - 20, 3)];
    _lineView.backgroundColor = UIColorFromRGB(0x269FE7);
    [self addSubview:_lineView];
    
    UIView *line =  [[UIView alloc] initWithFrame:CGRectMake(0, btnHeight - 0.5, kScreen_Width, 0.5)];
    line.backgroundColor = UIColorBackground;
    [self addSubview:line];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    for (UIButton *btn in _buttons) {
        [btn.titleLabel setFont:font];
    }
}

- (void)btnClicked:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    sender.selected = YES;
    for (UIButton *btn in _buttons) {
        if (btn != sender) {
            btn.selected = NO;
        }
    }
    if (self.callBack) {
        self.callBack([_buttons indexOfObject:sender]);
    }
    
    CGPoint point = _lineView.center;
    point.x = sender.center.x;
    
    _currentIndex = [_titles indexOfObject:sender.currentTitle];
    
    [UIView animateWithDuration:0.3 animations:^{
        self->_lineView.center = point;
    }];
}

- (void)selectBtn:(NSInteger)index {
    [self btnClicked:_buttons[index]];
}

- (NSInteger)titleCount {
    return _titles.count;
}

@end
