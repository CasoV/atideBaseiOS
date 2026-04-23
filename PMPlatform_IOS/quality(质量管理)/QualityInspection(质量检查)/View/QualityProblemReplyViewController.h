//
//  QualityProblemReplyViewController.h
//  ycxm
//
//  Created by 末末班车 on 2018/9/30.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QualityProblemReplyViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *url;

@property(nonatomic, copy) NSString *resourceTitle;

@end
