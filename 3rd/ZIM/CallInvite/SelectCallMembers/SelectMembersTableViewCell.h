//
//  SelectRoomMembersTableViewCell.h
//  ZIMExampleDemo
//
//  Created by 武耀琳 on 2022/11/7.
//

#import <UIKit/UIKit.h>
#import "SelectCallMembersViewController.h"
#import "ZGZIMManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface SelectMembersTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet UILabel *selectUserIDLabel;

@property NSString *myUserID;
@property SelectCallMembersViewController *masterVC;
@end

NS_ASSUME_NONNULL_END
