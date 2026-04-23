//
//  AttachmentTableCell.h
//  ycxm
//
//  Created by 高小伟 on 2020/7/20.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIMFile.h"
NS_ASSUME_NONNULL_BEGIN

@interface AttachmentTableCell : UITableViewCell

- (void)loadModel:(BIMFile *)model;

@end

NS_ASSUME_NONNULL_END
