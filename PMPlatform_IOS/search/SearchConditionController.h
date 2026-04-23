//
//  SearchConditionController.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/6.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchParam.h"
#import "SearchFactory.h"
#import "SearchTypeModel.h"

@interface SearchConditionController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic, copy) NSArray <SearchModel *>*searchModels;
@property (nonatomic, copy) NSArray <SearchTypeModel *>*projectModels;
@property (nonatomic, assign) SearchType searchType;
@property (nonatomic, copy) void (^callback)();

- (SearchParam *)params;

@end
