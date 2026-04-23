//
//  GeneralManagementApi.h
//  ConstructionApp
//
//  Created by RedLi on 2018/1/19.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "BIMPostRequest.h"

/**
 
 REVOKE(0,"button-revoke","撤回"),
 PASS(1,"button-pass","审批"),
 REJECT(2,"page-reject","退回"),
 UPDATECOMMENT(3,"button-updateComment","补签"),
 REPLACEPAAS(4,"button-replacePaas","代签"),
 TRANSFER(5,"button-transfer","转办"),
 PROCESS(7,"button-process","办理过程"),
 RESULT(6,"button-result","办理结果"),
 SAVE(8,"button-save","保存"),
 DELETE(9,"button-remove","删除"),
 SUBMIT(10,"button-submit","提交");
 
 **/

typedef NS_ENUM(NSInteger, GeneralManagementType) {
    FlowToolbar,//底部按钮 0
    BaseInfo,//基本信息 1
    Comments,//审批意见 2
    HandleHis,//办理过程 3
    AddSave,//新增保存 4
    EditSave,//编辑保存 5
    
    //底部按钮操作
    DELETE,//删除 6
    SUBMIT,//提交 7
    REVOKE,//撤回 8
    REJECT,//退回 9
    PASS,//通过 10
    SUBMIT_SAVE,//提交-保存 11
    REJECT_SAVE,//退回-保存 12
    PASS_SAVE,//通过-保存 13
    /**
     提交 退回 通过 跳转到同一个界面选择提交给谁， 退回给谁， 通过
     **/
};

@interface ApiGeneralManagement : BIMPostRequest

- (instancetype)initWithRequestParams:(id)requestParams flag:(NSInteger)flag bizKey:(NSString*) bizKey;
- (void) initFinalStr:(NSString *) finalStr;
@end
