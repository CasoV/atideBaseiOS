//
//  HandleCell.h
//  ConstructionApp
//
//  Created by RedLi on 2018/1/23.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, Status) {
    STANDBY = 1,
    RUN = 2,
    SUSPEND = 3,
    SKIP = 4,
    COMPLETE = 9
};

@interface HandleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *rightContainer;
@property (weak, nonatomic) IBOutlet UIView *leftContainer;

@property (weak, nonatomic) IBOutlet UIView *rightTopContrainer;

@property (weak, nonatomic) IBOutlet UIView *bottomContainer;

@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowWidth;

//1 未启动 2 运行 3 挂起 4 跳过 9 完成
@property (weak, nonatomic) IBOutlet UILabel *status;

@property (weak, nonatomic) IBOutlet UILabel *orgName;

- (NSString *) getStatusByInt: (NSInteger) status;

- (NSString *) getImageByStatus: (NSInteger) status;

- (void) updateTabCell: (NSArray*) arr;

@end
