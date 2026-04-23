//
//  MeaMidListModel.m
//  ycxm
//
//  Created by 末末班车 on 2019/2/26.
//  Copyright © 2019 末末班车. All rights reserved.
//

#import "MeaMidListModel.h"

@implementation MeaMidListModel

- (NSString *)REALAMOUNT {
    if (!_REALAMOUNT) {
        _REALAMOUNT = _AMOUNT;
    }
    return _REALAMOUNT;
}

@end
