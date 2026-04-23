//
//  CustomXCMultiTableView.m
//  PMPlatform_IOS
//
//  Created by vxg on 2017/11/29.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "CustomXCMultiTableView.h"
#import "UIView+XCMultiSortTableView.h"
#import "XCMultiSortTableViewBGScrollView.h"
#define AddHeightTo(v, h) { CGRect f = v.frame; f.size.height += h; v.frame = f; }
@implementation CustomXCMultiTableView
- (UITableViewCell *)leftHeaderTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *inde = @"leftHeaderTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inde];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inde];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell addBottomLineWithWidth:self.normalSeperatorLineWidth bgColor:self.normalSeperatorLineColor];
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat cellH = [self cellHeightInIndexPath:indexPath];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.leftHeaderWidth, cellH)];
    view.clipsToBounds = YES;
    
    UILabel *label =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.leftHeaderWidth/3, cellH)];
    UILabel *label1 =  [[UILabel alloc] initWithFrame:CGRectMake(self.leftHeaderWidth/3, 0, self.leftHeaderWidth*2/3, cellH)];
    DataItem *item = [[leftHeaderDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    label1.text = [item.keyName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    label1.font = [UIFont systemFontOfSize:12];
    [label1 setAdjustsFontSizeToFitWidth:YES];
    [label1 setContentScaleFactor: 10];
    UIColor *color = [self bgColorInSection:indexPath.section InRow:indexPath.row InColumn:-1];
    view.backgroundColor = color;
    label1.backgroundColor = color;
    
    label.text = item.keyId;
    [label setTextAlignment:NSTextAlignmentCenter];
    label.font = [UIFont systemFontOfSize:12];
    [label setAdjustsFontSizeToFitWidth:YES];
    [label setContentScaleFactor: 10];
    label.backgroundColor = color;
    
    [view addSubview:label];
    [view addSubview:label1];
    
    [cell.contentView addSubview:view];
    [self setBorderWithView:label1 top:NO left:YES bottom:NO right:NO borderColor:[UIColor colorWithWhite:XCMultiTableView_DefaultLineGray alpha:1.0f] borderWidth:1.0f];
    AddHeightTo(cell, self.normalSeperatorLineWidth);
    
    return cell;
}

- (void)setUpTopHeaderScrollView {
    
    NSUInteger count = [self.datasource arrayDataForTopHeaderInTableView:self].count;
    for (int i = 0; i < count; i++) {
        
        CGFloat topHeaderW = [self accessContentTableViewCellWidth:i];
        CGFloat topHeaderH = [self accessTopHeaderHeight];
        
        CGFloat widthP = [[columnPointCollection objectAtIndex:i] floatValue];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, topHeaderW, topHeaderH)];
        view.clipsToBounds = YES;
        view.center = CGPointMake(widthP, topHeaderH / 2.0f);
        view.tag = i;
        NSObject *item = [[self.datasource arrayDataForTopHeaderInTableView:self] objectAtIndex:i];
        UIColor *color = [self headerBgColorColumn:i];
        view.backgroundColor = color;
        if ([item isKindOfClass:[NSString class]]) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, topHeaderW, topHeaderH)];
            label.text = item;
            [label setTextAlignment:NSTextAlignmentCenter];
            label.font = [UIFont systemFontOfSize:12];
            [label setAdjustsFontSizeToFitWidth:YES];
            [label setContentScaleFactor: 10];
            label.backgroundColor = color;
            [view addSubview:label];
        }else{
            NSArray *items = item;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, topHeaderW, topHeaderH/2)];
        label.text = [items objectAtIndex:0];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.font = [UIFont systemFontOfSize:12];
        [label setAdjustsFontSizeToFitWidth:YES];
        [label setContentScaleFactor: 10];
        label.backgroundColor = color;
        [self setBorderWithView:label top:NO left:NO bottom:YES right:NO borderColor:[UIColor colorWithWhite:XCMultiTableView_DefaultLineGray alpha:1.0f] borderWidth:1.0f];
        [view addSubview:label];
            NSInteger childCount = items.count-1;
        for (int j=0; j<childCount; j++) {
            CGRect frame = CGRectMake(j*topHeaderW/childCount, topHeaderH/2, topHeaderW/childCount, topHeaderH/2);
            UILabel *label = [[UILabel alloc] initWithFrame:frame];
            label.text = [items objectAtIndex:j+1];
            [label setTextAlignment:NSTextAlignmentCenter];
            label.font = [UIFont systemFontOfSize:12];
            [label setAdjustsFontSizeToFitWidth:YES];
            [label setContentScaleFactor: 10];
            label.backgroundColor = color;
            if (j>0) {
                [self setBorderWithView:label top:NO left:YES bottom:NO right:NO borderColor:[UIColor colorWithWhite:XCMultiTableView_DefaultLineGray alpha:1.0f] borderWidth:1.0f];
            }
            [view addSubview:label];
        }
        
        }
        
        NSString *columnStr = [NSString stringWithFormat:@"-1_%d", i];
        [columnTapViewDict setObject:view forKey:columnStr];
        
        if ([columnSortedTapFlags objectForKey:columnStr] == nil) {
            [columnSortedTapFlags setObject:[NSNumber numberWithInt:TableColumnSortTypeNone] forKey:columnStr];
        }
        
        [topHeaderScrollView addSubview:view];
    }
    
    [topHeaderScrollView reDraw];
    
}

- (void)leftHeaderView:(UIView *)container{
    [[container subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGRect frame1 = CGRectMake(0, 0, container.bounds.size.width/3, container.bounds.size.height);
    CGRect frame2 = CGRectMake(container.bounds.size.width/3, 0, container.bounds.size.width*2/3, container.bounds.size.height);
    UILabel *label = [[UILabel alloc] initWithFrame:frame1];
    label.text = @"序号";
    label.font = [UIFont systemFontOfSize:12];
    [label setAdjustsFontSizeToFitWidth:YES];
    [label setContentScaleFactor: 10];
    label.textAlignment = NSTextAlignmentCenter;
    [container addSubview:label];
    UILabel *label1 = [[UILabel alloc] initWithFrame:frame2];
    label1.text = @"工程名称";
    label1.font = [UIFont systemFontOfSize:12];
    [label1 setAdjustsFontSizeToFitWidth:YES];
    [label1 setContentScaleFactor: 10];
    label1.textAlignment = NSTextAlignmentCenter;
    [container addSubview:label1];
    [self setBorderWithView:label1 top:NO left:YES bottom:NO right:NO borderColor:[UIColor colorWithWhite:XCMultiTableView_DefaultLineGray alpha:1.0f] borderWidth:1.0f];
}

- (UITableViewCell *)contentTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSUInteger count = [datasource arrayDataForTopHeaderInTableView:self].count;
    static NSString *cellID = @"contentTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addBottomLineWithWidth:self.normalSeperatorLineWidth bgColor:self.normalSeperatorLineColor];
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray *ary = [[contentDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSUInteger count = ary.count;
    for (int i = 0; i < count; i++) {
        
        CGFloat cellW = [self accessContentTableViewCellWidth:i];
        CGFloat cellH = [self cellHeightInIndexPath:indexPath];
        
        CGFloat width = [[columnPointCollection objectAtIndex:i] floatValue];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellW, cellH)];
        view.center = CGPointMake(width, cellH / 2.0f);
        view.clipsToBounds = YES;
        UIColor *color = [self bgColorInSection:indexPath.section InRow:indexPath.row InColumn:i];
        
        view.backgroundColor = color;
        if ([[ary objectAtIndex:i] isKindOfClass:[NSArray class]]) {
            NSArray *children = [ary objectAtIndex:i];
            for (int j=0; j<children.count; j++) {
                CGRect frame = CGRectMake(j*cellW/children.count, 0, cellW/children.count, cellH);
                UILabel *label = [[UILabel alloc] initWithFrame:frame];
                label.text = [NSString stringWithFormat:@"%@", [children objectAtIndex:j]];
                
                [label setTextAlignment:NSTextAlignmentCenter];
                label.font = [UIFont systemFontOfSize:12];
                [label setAdjustsFontSizeToFitWidth:YES];
                [label setContentScaleFactor: 10];
                label.backgroundColor = color;
                if (j>0) {
                    [self setBorderWithView:label top:NO left:YES bottom:NO right:NO borderColor:[UIColor colorWithWhite:XCMultiTableView_DefaultLineGray alpha:1.0f] borderWidth:1.0f];
                }
                
                [view addSubview:label];
            }
        }else{
            CGRect frame = CGRectMake(0, 0, cellW, cellH);
            UILabel *label = [[UILabel alloc] initWithFrame:frame];
            label.text = [NSString stringWithFormat:@"%@", [ary objectAtIndex:i]];
            
            [label setTextAlignment:NSTextAlignmentCenter];
            label.font = [UIFont systemFontOfSize:12];
            [label setAdjustsFontSizeToFitWidth:YES];
            [label setContentScaleFactor: 10];
            label.backgroundColor = color;
            
            [view addSubview:label];
        }
        
        
        [cell.contentView addSubview:view];
    }
    
    AddHeightTo(cell, self.normalSeperatorLineWidth);
    
    return cell;
}
- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    view.layer.masksToBounds = YES;
}
@end
