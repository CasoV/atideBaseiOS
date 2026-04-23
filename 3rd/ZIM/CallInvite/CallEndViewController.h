//
//  CallEndViewController.h
//  ZIMExampleDemo
//
//  Created by 武耀琳 on 2023/5/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CallEndViewController : UIViewController
@property NSString *endTimeMinusCreateTime;
@property NSString *endTimeMinusAcceptTime;

@property (weak, nonatomic) IBOutlet UILabel *endTimeMinusCreateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeMinusAcceptTimeLabel;

@end

NS_ASSUME_NONNULL_END
