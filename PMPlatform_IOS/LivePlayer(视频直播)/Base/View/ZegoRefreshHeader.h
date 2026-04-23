//
//  ZegoRefreshHeader.h
//  ZegoEducation
//
//  Created by MrLQ  on 2019/6/8.
//  Copyright © 2019 Shenzhen Zego Technology Company Limited. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZegoRefreshHeader : MJRefreshHeader

- (void)endRefreshingWithResult:(BOOL)isSuccessed;

@end

NS_ASSUME_NONNULL_END
