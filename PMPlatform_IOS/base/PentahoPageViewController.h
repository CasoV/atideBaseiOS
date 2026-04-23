//
//  PentahoPageViewController.h
//  ycxm
//
//  Created by 高小伟 on 2021/8/18.
//  Copyright © 2021 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PentahoPageViewController : UIViewController

@property(nonatomic, copy)NSString *treeCode;
@property(nonatomic, copy)NSString *chooseProjectId;
@property(nonatomic, copy)NSString *chooseSectionId;
@property(nonatomic,strong)NSDictionary *otherInfo;

@end

NS_ASSUME_NONNULL_END
