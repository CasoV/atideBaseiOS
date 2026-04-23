//
//  XCMultiTableViewBGScrollView.h
//  XCMultiTableDemo
//
//  Created by Kingiol on 13-7-20.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XCMultiSortTableView.h"
@interface XCMultiTableViewBGScrollView : UIScrollView

@property (nonatomic, assign) XCMultiTableView *parent;

- (void)reDraw;

@end
