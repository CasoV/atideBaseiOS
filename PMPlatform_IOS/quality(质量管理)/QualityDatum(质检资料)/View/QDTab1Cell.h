//
//  QDTab1Cell.h
//  ycxm
//
//  Created by 末末班车 on 2019/3/29.
//  Copyright © 2019 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckListBean.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDTab1Cell : UITableViewCell

- (void)setModel:(CheckListBean *)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
