//
//  PartCell.m
//  ycxm
//
//  Created by 高小伟 on 2019/3/6.
//  Copyright © 2019 末末班车. All rights reserved.
//

#import "PartCell.h"

@implementation PartCell
- (void)awakeFromNib{
    [super awakeFromNib];
    self.nameBtn.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    self.nameBtn.layer.cornerRadius = 15.0;
    [self.nameBtn setTitleColor: UIColorFromRGB(0x0295FF) forState:UIControlStateSelected];
    [self.nameBtn.layer setBorderWidth:1.0];
    self.nameBtn.layer.borderColor = UIColor.clearColor.CGColor;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    // 获得每个cell的属性集
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    // 计算cell里面textfield的宽度
    CGRect frame = [self.nameBtn.titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.nameBtn.titleLabel.font,NSFontAttributeName, nil] context:nil];
    
    // 这里在本身宽度的基础上 又增加了10
    frame.size.width += 40;
    frame.size.width = frame.size.width >= kScreen_Width ? kScreen_Width: frame.size.width;
    frame.size.height = 30;
    
    // 重新赋值给属性集
    attributes.frame = frame;
    
    return attributes;
}
@end
