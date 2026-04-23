//
//  FlowOperator.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/12.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToolBar.h"
#import "Panel.h"

typedef NS_ENUM(NSInteger, FlowOperatorType) {
    FlowOperatorTypeREVOKE,
    FlowOperatorTypePASS,
    FlowOperatorTypeREJECT,
    FlowOperatorTypeUPDATECOMMENT,
    FlowOperatorTypeREPLACEPAAS,
    FlowOperatorTypeTRANSFER,
    FlowOperatorTypePROCESS,
    FlowOperatorTypeRESULT,
    FlowOperatorTypeREMOVE,
    FlowOperatorTypeSUBMIT,
    FlowOperatorTypeBACK,
    FlowOperatorTypeUNKNOW,
    FlowOperatorTypeSeal
};

@interface FlowOperator : NSObject

+ (FlowOperatorType)generator:(NSString *)pageId;

+ (Panel *)generatorInfo:(ToolBar *)toolBar;

@end
