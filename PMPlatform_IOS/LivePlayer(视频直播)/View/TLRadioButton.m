//
//  TLRadioButton.m
//  ZegoRoomkitDemo
//
//  Created by xia on 2021/6/8.
//  Copyright © 2021 zego. All rights reserved.
//

#import "TLRadioButton.h"
#import "UIButton+Edge.h"

@interface TLRadioButton ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) CALayer *customLayer;

@end


@implementation TLRadioButton

- (instancetype)initWithTitle:(NSString *)title
                   isSelected:(BOOL)isSelected {
    self = [super init];
    if (self) {
        self.title = title;
        self.isSelected = isSelected;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [[UIButton alloc] init];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
        make.width.height.mas_equalTo(14);
    }];
    [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setEnlargeEdgeWithTop:1 right:180 bottom:50 left:1];
    button.backgroundColor = UIColorHex(ffffff);
    button.layer.cornerRadius = 7;
    button.layer.borderWidth = 1;
    self.button = button;
    [self setSelected:self.isSelected];
    
    UILabel *label = [UILabel new];
    label.text = self.title;
    label.textColor = UIColorHex(0f0f0f);
    label.font = REGULAR_FONT(14);
    [label sizeToFit];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.button.mas_right).mas_offset(10);
    }];
}

#pragma mark - Action
- (void)onButtonClick:(UIButton *)sender {
    if (self.actionBlock) {
        self.actionBlock(self.tag);
    }
}

#pragma mark - Private
- (void)changeButtonToSelected {
    self.button.layer.borderColor = UIColorHex(2953ff).CGColor;

    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(3, 3, 8, 8)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.fillColor = UIColorHex(2953ff).CGColor;
    if (self.customLayer) {
        [self.customLayer removeFromSuperlayer];
        self.customLayer = nil;
    }
    self.customLayer = layer;
    [self.button.layer addSublayer:layer];
}

- (void)changeButtonToUnselected {
    self.button.layer.borderColor = UIColorHex(d7d7d7).CGColor;
    
    if (self.customLayer) {
        [self.customLayer removeFromSuperlayer];
        self.customLayer = nil;
    }
}

#pragma mark - Public
- (void)setSelected:(BOOL)selected {
    if (selected) {
        [self changeButtonToSelected];
    } else {
        [self changeButtonToUnselected];
    }
}

@end
