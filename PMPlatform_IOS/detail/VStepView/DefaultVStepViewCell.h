//
//  DefaultVStepViewCell.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/11.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefaultVStepViewCell : UIView

@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIView *childCircle;
@property (weak, nonatomic) IBOutlet UIView *circleIcon;
@property (weak, nonatomic) IBOutlet UIImageView *headPhoto;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *stepName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToImg;

- (void)fillData;

@end
