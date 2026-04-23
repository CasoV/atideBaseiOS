//
//  ProjectInvestDetailCell.h
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/08.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectInvestDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *value;
- (void)initData:(NSString *)nameTxt value:(NSString *)valueTxt;

@end
