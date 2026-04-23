//
//  FlowOperator.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/12.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "FlowOperator.h"

@implementation FlowOperator

+ (FlowOperatorType)generator:(NSString *)pageId {
    if ([pageId isEqualToString:@"button-revoke"]) {
        return FlowOperatorTypeREVOKE;
    }
    if ([pageId isEqualToString:@"button-pass"]) {
        return FlowOperatorTypePASS;
    }
    if ([pageId isEqualToString:@"button-seal-type1"]) {
        return FlowOperatorTypeSeal;
    }
    if ([pageId isEqualToString:@"page-reject"]) {
        return FlowOperatorTypeREJECT;
    }
    if ([pageId isEqualToString:@"button-updateComment"]) {
        return FlowOperatorTypeUPDATECOMMENT;
    }
    if ([pageId isEqualToString:@"button-replacePaas"]) {
        return FlowOperatorTypeREPLACEPAAS;
    }
    if ([pageId isEqualToString:@"button-transfer"]) {
        return FlowOperatorTypeTRANSFER;
    }
    if ([pageId isEqualToString:@"button-result"]) {
        return FlowOperatorTypeRESULT;
    }
    if ([pageId isEqualToString:@"button-process"]) {
        return FlowOperatorTypePROCESS;
    }
    if ([pageId isEqualToString:@"button-remove"]) {
        return FlowOperatorTypeREMOVE;
    }
    if ([pageId isEqualToString:@"button-submit"]) {
        return FlowOperatorTypeSUBMIT;
    }
    if ([pageId isEqualToString:@"button-back"]) {
        return FlowOperatorTypeBACK;
    }
    return FlowOperatorTypeUNKNOW;
}

+ (Panel *)generatorInfo:(ToolBar *)toolBar {
    if ([toolBar.pageId isEqualToString:@"button-revoke"]) {
        return [[Panel alloc] init:toolBar.pageId text:@"撤回" icon:toolBar.pageEvent];
    }
    if ([toolBar.pageId isEqualToString:@"button-seal-type1"]) {
        
        [[NSUserDefaults standardUserDefaults]setValue:toolBar.actionVar forKey:@"actionVar"];
        return [[Panel alloc] init:toolBar.pageId text:@"签章" icon:toolBar.pageEvent];
    }
    if ([toolBar.pageId isEqualToString:@"button-pass"]) {
        if (isCa&&!!toolBar.actionVar) {
            [[NSUserDefaults standardUserDefaults]setValue:toolBar.actionVar forKey:@"actionVar"];
            return [[Panel alloc] init:toolBar.pageId text:@"签章" icon:toolBar.pageEvent];
        }
        if (isCa&&!toolBar.actionVar) {
            return [[Panel alloc] init:toolBar.pageId text:@"签名" icon:toolBar.pageEvent];
        }
        return [[Panel alloc] init:toolBar.pageId text:@"通过" icon:toolBar.pageEvent];
    }
    if ([toolBar.pageId isEqualToString:@"page-reject"]) {
        return [[Panel alloc] init:toolBar.pageId text:@"退回" icon:toolBar.pageEvent];
    }
    if ([toolBar.pageId isEqualToString:@"button-updateComment"]) {
        return [[Panel alloc] init:toolBar.pageId text:@"补签" icon:toolBar.pageEvent];
    }
    if ([toolBar.pageId isEqualToString:@"button-replacePaas"]) {
        return [[Panel alloc] init:toolBar.pageId text:@"代签" icon:toolBar.pageEvent];
    }
    if ([toolBar.pageId isEqualToString:@"button-transfer"]) {
        return [[Panel alloc] init:toolBar.pageId text:@"转办" icon:toolBar.pageEvent];
    }
    if ([toolBar.pageId isEqualToString:@"button-result"]) {
        return [[Panel alloc] init:toolBar.pageId text:@"办理结果" icon:toolBar.pageEvent];
    }
    if ([toolBar.pageId isEqualToString:@"button-process"]) {
        return [[Panel alloc] init:toolBar.pageId text:@"办理过程" icon:toolBar.pageEvent];
    }
    if ([toolBar.pageId isEqualToString:@"button-remove"]) {
        return [[Panel alloc] init:toolBar.pageId text:@"删除" icon:toolBar.pageEvent];
    }
    if ([toolBar.pageId isEqualToString:@"button-submit"]) {
        return [[Panel alloc] init:toolBar.pageId text:@"提交" icon:toolBar.pageEvent];
    }
    if ([toolBar.pageId isEqualToString:@"button-back"]) {
        return [[Panel alloc] init:toolBar.pageId text:@"返回" icon:toolBar.pageEvent];
    }
    if ([toolBar.pageId isEqualToString:@"button-save"]) {
        return [[Panel alloc] init:toolBar.pageId text:@"保存" icon:toolBar.pageEvent];
    }
    
    return [[Panel alloc] init:toolBar.pageId text:toolBar.name icon:toolBar.pageEvent];
}
@end
