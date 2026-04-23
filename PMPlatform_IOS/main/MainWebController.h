//
//  MainWebController.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2022/7/15.
//  Copyright © 2022 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainWebController : UIViewController

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) BOOL localUC;

-(void)gzJoinLivingRoom:(NSDictionary *)taskId;

- (void)handleTodoWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
