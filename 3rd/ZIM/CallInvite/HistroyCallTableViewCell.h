//
//  HistroyCallTableViewCell.h
//  ZIMExampleDemo
//
//  Created by 武耀琳 on 2023/5/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistroyCallTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *callersCallLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;

@end

NS_ASSUME_NONNULL_END
