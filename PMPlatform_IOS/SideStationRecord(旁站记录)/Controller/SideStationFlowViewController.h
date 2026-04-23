//
//  SideStationFlowViewController.h
//  ycxm
//
//  Created by 高小伟 on 2021/4/19.
//  Copyright © 2021 末末班车. All rights reserved.
//

#import "ReviewBaseController.h"
#import "NewQDKeyModel.h"

@interface SideStationFlowViewController : ReviewBaseController

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *formType;

@property (nonatomic, strong) NewQDKeyModel *model;

@end
