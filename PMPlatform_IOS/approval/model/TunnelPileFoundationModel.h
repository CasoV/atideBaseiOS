//
//  TunnelPileFoundationModel.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/17.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TunnelPileFoundationModel : NSObject

@property (nonatomic, copy) NSString *sessionCode;
@property (nonatomic, copy) NSString *approvalUnitId;
@property (nonatomic, copy) NSString *approvalUnitStep;
@property (nonatomic, copy) NSString *sectNo;
@property (nonatomic, copy) NSString *confirmDate;
@property (nonatomic, copy) NSString *approvalGrpId;
@property (nonatomic, copy) NSString *applyAmt;
@property (nonatomic, assign) BOOL process;
@property (nonatomic, copy) NSString *approvalGrpStep;
@property (nonatomic, copy) NSString *approvalStatus;
@property (nonatomic, copy) NSString *declareDate;
@property (nonatomic, copy) NSString *datumName;
@property (nonatomic, copy) NSString *datumStatus;
@property (nonatomic, copy) NSString *interimPayId;
@property (nonatomic, copy) NSString *flowID;
@property (nonatomic, copy) NSString *flowName;
@property (nonatomic, copy) NSString *confirmAmt;

@end
