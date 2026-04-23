//
//  QualityInspectionView.h
//  ycxm
//
//  Created by 末末班车 on 2018/9/20.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QualityInspectionModel.h"
#import "NewFileScanView.h"

@interface QualityInspectionView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *partTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *levelTitleLb;
@property (weak, nonatomic) IBOutlet UIButton *rwcordingTimeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *partViewTop;

@property (nonatomic, copy) NSString *resourceTitle;

@property (nonatomic, strong) QualityInspectionModel *model;

@property (nonatomic, strong) NewFileScanView *imagesView;

@property (nonatomic, assign) BOOL canEdit;

@property (nonatomic, copy) void (^voiceClicked)(UIButton *btn);

- (NSDictionary *)params;

@end
