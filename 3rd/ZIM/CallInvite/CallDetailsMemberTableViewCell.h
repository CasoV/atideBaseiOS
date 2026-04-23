//
//  CallDetailsMemberTableViewCell.h
//  ZIMExampleDemo
//
//  Created by 武耀琳 on 2023/5/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CallDetailsMemberTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *callMemberIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *userStateLabel;

@end

NS_ASSUME_NONNULL_END
