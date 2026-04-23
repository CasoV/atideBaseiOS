//
//  CreateCallTableViewCell.h
//  ZIMExampleDemo
//
//  Created by 武耀琳 on 2023/5/21.
//

#import <UIKit/UIKit.h>
#import "CreateCallViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface CreateCallTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property CreateCallViewController *vc;
@end

NS_ASSUME_NONNULL_END
