//
//  ChildBaseController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/6.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ChildBaseController.h"

@interface ChildBaseController ()

@end

@implementation ChildBaseController {
    NSString *_titleKey;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleKey = @"title";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.isDestory = YES;
}

- (void)refresh:(NSDictionary *)param {
    
}

#pragma mark - 懒加载
- (NSMutableDictionary *)searchParam {
    if (!_searchParam) {
        _searchParam = [NSMutableDictionary dictionary];
    }
    return _searchParam;
}

- (void)normalSearch:(SearchParam *)model {
    [self.searchParam removeAllObjects];
    
    [self.searchParam setValue:model.title forKey:_titleKey];
    if (![model.startDate isEqualToString:@""]) {
        [self.searchParam setValue:model.startDate forKey:@"fromDate"];
    }
    if (![model.endDate isEqualToString:@""]) {
        [self.searchParam setValue:model.endDate forKey:@"toDate"];
    }
    if (![model.proId isEqualToString:@""]) {
        [self.searchParam setValue:model.proId forKey:@"proId"];
    }
    if (![model.drafter isEqualToString:@""]) {
        [self.searchParam setValue:model.drafter forKey:@"drafter"];
    }

    if (model.models) {
        for (SearchModel *item in model.models) {
            if (item.details) {
                for (SearchDetail *detail in item.details) {
                    if (detail.isSelected) {
                        [self.searchParam setValue:detail.ID forKey:item.ID];
                        break;
                    }
                }
            }
        }
    }

    if (model.orderValue) {
        [self.searchParam setValue:[NSString stringWithFormat:model.orderFormat, model.orderValue] forKey:model.orderKey];
    }
}

- (void)setTitleKey:(NSString *)key {
    _titleKey = key;
}

@end
