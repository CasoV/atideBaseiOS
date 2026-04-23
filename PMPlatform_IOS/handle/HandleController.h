//
//  HandleController.h
//  ConstructionApp
//
//  Created by RedLi on 2018/1/19.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandleController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray * data;
@end
