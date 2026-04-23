//
//  XCMultiTableView.h
//  XCMultiTableDemo
//
//  Created by Kingiol on 13-7-20.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DataItem.h"
#import "XCMultiSortTableViewDefault.h"
@class XCMultiTableViewBGScrollView;
typedef NS_ENUM(NSUInteger, TableColumnSortType) {
    TableColumnSortTypeAsc,
    TableColumnSortTypeDesc,
    TableColumnSortTypeNone
};
typedef NS_ENUM(NSUInteger, SortColumnType) {
    SortColumnTypeInteger,
    SortColumnTypeFloat,
    SortColumnTypeDate,
};

@protocol XCMultiTableViewDataSource;

@interface XCMultiTableView : UIView{
    NSMutableArray *leftHeaderDataArray;
    NSArray *columnPointCollection;
    NSMutableDictionary *columnTapViewDict;
    
    NSMutableDictionary *columnSortedTapFlags;
    XCMultiTableViewBGScrollView *topHeaderScrollView;
    NSMutableArray *contentDataArray;
}

@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat topHeaderHeight;
@property (nonatomic, assign) CGFloat leftHeaderWidth;
@property (nonatomic, assign) CGFloat sectionHeaderHeight;
@property (nonatomic, assign) CGFloat boldSeperatorLineWidth;
@property (nonatomic, assign) CGFloat normalSeperatorLineWidth;

@property (nonatomic, strong) UIColor *boldSeperatorLineColor;
@property (nonatomic, strong) UIColor *normalSeperatorLineColor;

@property (nonatomic, assign) BOOL leftHeaderEnable;

@property (nonatomic, weak) id<XCMultiTableViewDataSource> datasource;


- (void)reloadData;
- (void)addBottomLineWithWidth:(CGFloat)width bgColor:(UIColor *)color;
- (CGFloat)cellHeightInIndexPath:(NSIndexPath *)indexPath;
- (UIColor *)bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column;
- (UITableViewCell *)leftHeaderTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)accessContentTableViewCellWidth:(NSUInteger)column;
- (CGFloat)accessTopHeaderHeight;
- (UIColor *)headerBgColorColumn:(NSUInteger)column;

@end

@protocol XCMultiTableViewDataSource <NSObject>

@required
- (NSArray *)arrayDataForTopHeaderInTableView:(XCMultiTableView *)tableView;
- (NSArray *)arrayDataForLeftHeaderInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section;
- (NSArray *)arrayDataForContentInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section;

@optional
- (NSUInteger)numberOfSectionsInTableView:(XCMultiTableView *)tableView;
- (CGFloat)tableView:(XCMultiTableView *)tableView contentTableCellWidth:(NSUInteger)column;
- (CGFloat)tableView:(XCMultiTableView *)tableView cellHeightInRow:(NSUInteger)row InSection:(NSUInteger)section;
- (CGFloat)topHeaderHeightInTableView:(XCMultiTableView *)tableView;
- (UIColor *)tableView:(XCMultiTableView *)tableView bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column;
- (UIColor *)tableView:(XCMultiTableView *)tableView headerBgColorInColumn:(NSUInteger)column;
- (NSString *)leftHeaderTextInTableView:(XCMultiTableView *)tableView;
- (void)tableViewForLeft:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
