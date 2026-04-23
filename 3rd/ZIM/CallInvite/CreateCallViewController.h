//
//  CreateCallViewController.h
//  ZIMExampleDemo
//
//  Created by 武耀琳 on 2023/5/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CallinviteModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CreateCallViewController : UIViewController
@property NSString *viewTitle;
@property NSString *callID;
@property (weak, nonatomic) IBOutlet UITableView *memberTableView;
@property CallinviteModel *createCallModel;
@property (weak, nonatomic) IBOutlet UITextField *memberIDTextField;
@property (weak, nonatomic) IBOutlet UIButton *addMemberButton;

@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

NS_ASSUME_NONNULL_END
