//
//  VxgUIUtils.m
//  TrafficMs
//
//  Created by apple on 2015/11/03.
//  Copyright © 2015年 com. All rights reserved.
//

#import "MJRefresh.h"
#import "VxgUIUtils.h"


@implementation VxgUIUtils

/*
 * 为uuchart bar类型添加柱状图描述
 * view：宿主view
 * colors：示意图颜色
 */
+ (void) s_uuchart_bar_init_item_desc:(UIView *)view y:(CGFloat)y labelWidth:(CGFloat)width colors:(NSMutableArray *)colors labels:(NSMutableArray *)colorsLabels{
    
    float xPieLabel = 5 ;
    float yPieLabel = y + ATIDE_TITLE_VIEW_HEIGHT + 2 ;
    float imgWidth = 10 ;
    float labelWidth = 40 ;
    float labelHeight = 10 ;
    float sepImg = 1 ;
    float sepLabel = 3 ;
    if (width == 0) {
        width = labelWidth;
    }
    float itemWidth = imgWidth + width + sepImg + sepLabel ;
    
    for (int k=0; k<colors.count; k++) {
        UIColor *color = [colors objectAtIndex:k];
        CGRect rectImg = CGRectMake(xPieLabel + k*itemWidth, yPieLabel, imgWidth, imgWidth);
        CGRect rectLabel = CGRectMake(xPieLabel + (imgWidth+sepImg)+k*itemWidth, yPieLabel, width, labelHeight);
        UILabel *colorLabel = [[UILabel alloc]initWithFrame:rectImg];
        colorLabel.backgroundColor = color;
        UILabel *label = [[UILabel alloc]initWithFrame:rectLabel];
        label.numberOfLines = 0;
        label.textColor = color;
        label.text = [colorsLabels objectAtIndex:k];
        label.font = [label.font fontWithSize:9.0f];
        [view addSubview:colorLabel];
        [view addSubview:label];
    }
}


+ (UIView *)s_create_header_view:(NSMutableArray *)tbArray view:(UIView *)sourceView eButton:(UIButton*)eButton section:(NSInteger)section isExpanded:(BOOL)isExpanded{

    
    //把节号保存到按钮tag，以便传递到expandButtonClicked方法
    eButton.tag = section;
    
    //设置图标
    //根据是否展开，切换按钮显示图片
    if (isExpanded)
        [eButton setImage: [UIImage imageNamed:@"an_expand_expand"]forState:UIControlStateNormal];
    else
        [eButton setImage: [UIImage imageNamed:@"an_expand_collapse_icon"]forState:UIControlStateNormal];
    
    //设置分组标题
    [eButton setTitle:[[tbArray objectAtIndex:section] objectForKey:DIC_TITILESTRING]forState:UIControlStateNormal];
    [eButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    eButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [eButton setTitleColor:UUTwitterColor forState:UIControlStateNormal];
    
    //设置button的图片和标题的相对位置
    //4个参数是到上边界，左边界，下边界，右边界的距离
    CGFloat width = sourceView.frame.size.width * 0.9f;
    eButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [eButton setTitleEdgeInsets:UIEdgeInsetsMake(5,5,0,0)];
    [eButton setImageEdgeInsets:UIEdgeInsetsMake(4,width-10,0,0)];
    
    //上显示线
//    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, sourceView.frame.size.width*0.8,1)];
//    CGPoint center = label1.center;
//    center.x = sourceView.center.x;
//    [label1 setCenter:center];
//    label1.backgroundColor = UUTwitterColor;
//    [sourceView addSubview:label1];
    
    //下显示线
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, sourceView.frame.size.height-1, sourceView.frame.size.width*0.8,1)];
    CGPoint center = label.center;
    center.x = sourceView.center.x;
    [label setCenter:center];
    label.backgroundColor = UUTwitterColor;
    [sourceView addSubview:label];
    
    [sourceView addSubview: eButton];
    return sourceView;
}

+ (void)s_vxg_view_set_corner:(UIView *)sourceView cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color{
    
    if (color == nil) {
        color = [UIColor whiteColor];
    }
    
    sourceView.layer.masksToBounds = YES;
    sourceView.layer.cornerRadius = cornerRadius;
    sourceView.layer.borderWidth = borderWidth;
    sourceView.layer.borderColor = [color CGColor];
}

@end
