//
//  HeadPhotoUtils.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/11.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "HeadPhotoUtils.h"

@implementation HeadPhotoUtils

+ (void)setHeadPhotoByUserId:(UIImageView *)view userId:(NSString *)userId {
    NSString *url = [NSString stringWithFormat:@"%@?imgType=1&userId=%@", [UrlConfig URL:getImg], userId];
    view.image = [UIImage imageNamed:@"default_useravatar"];
    [[HttpManager manager] get:url param:nil success:^(NSData *data) {
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            view.image = image;
        }
    } faild:^(NSString *msg) {
        
    }];
}

@end
