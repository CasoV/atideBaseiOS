//
//  FunctionFactory.m
//  ycxm
//
//  Created by 末末班车 on 2018/9/19.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "FunctionFactory.h"

#import "BaseWebViewController.h"
//#import "SafetyDangerController.h"
//#import "GreenProblemController.h"
//#import "WaterProblemController.h"
//#import "SafetyProblemController.h"
//#import "SupervisionLogController.h"
//#import "ProcessTrackingController.h"
//#import "ConstructionLogController.h"
//#import "SafetyEducationController.h"
//#import "SecurityCheckLogController.h"
//#import "SpecialEquipmentController.h"
//#import "ConstructionPlanController.h"
//#import "SafetyDisclosureController.h"
//#import "QualityInspectionController.h"
//#import "ConstructionDesignController.h"
//#import "ElectricianRegularController.h"
//#import "SecurityCheckRecordController.h"
//#import "SpecialEquipmentChildController.h"
//#import "SpecialConstructionPlanController.h"
//#import "AddAllowViewController.h"
//#import "NewModelViewController.h"
//#import "BaseExcelViewController.h"
//#import "SpecialEquipmentChildListController.h"
//#import "SecurityCheckListViewController.h"
//#import "AuditSecurityViewController.h"
//#import "ProgressReportControlFlowViewController.h"

//#import "ProjectMsgModel.h"
//#import "CMSModel.h"
//#import "ChangeInfoModel.h"
//#import "SecurityListModel.h"
//#import "RecodeListModel.h"
//#import "RecodeListSdModel.h"
//#import "FileSafeCheckModel.h"
//#import "AccidentReportModel.h"
//#import "HazardAccidentModel.h"
#import "SideStationModel.h"
//#import "SupervisionModel.h"
//#import "SupervisionNewModel.h"
//#import "ControlEngineeringModel.h"
//#import "ycxm-Swift.h"
@implementation FunctionFactory

+ (NSString *)titleOfFunctionType:(FunctionType)type {
    switch (type) {
        case FunctionTypeCMS:
            return @"通知公告";
        case FunctionTypeProcessTracking:
            return @"工艺工序过程填报";
        case FunctionTypeElectricianRegular:
            return @"电工巡视记录";
        case FunctionTypeSecurityCheckLog:
            return @"安全检查日志";
        case FunctionTypeConstructionLog:
            return @"施工日志";
        case FunctionTypeSupervisionLog:
            return @"监理日志";
        case FunctionTypeEquipment:
            return @"特种设备“一机一档”";
        case FunctionTypeEquipmentSubType1:
            return @"定期检查";
        case FunctionTypeEquipmentSubType2:
            return @"维护保养";
        case FunctionTypeEquipmentSubType3:
            return @"运行故障和事故记录";
        case FunctionTypeConstructionDesign:
            return @"施工组织设计";
        case FunctionTypeConstructionPlan:
            return @"施工方案";
        case FunctionTypeSpecialConstructionPlan:
            return @"专项施工方案";
        case FunctionTypeOtherPrograms:
            return @"其他方案";
        case FunctionTypeMeetingMinutes:
            return @"会议纪要";
        case FunctionTypeGreenInnovation:
            return @"创新创优展示";
        case FunctionTypeSafetyProblem:
            return @"安全问题整改记录";
        case FunctionTypeSecurityCheckRecord:
            return @"安全检查记录";
        case FunctionTypeEngineeringDynamics:
            return @"工程动态";
        case FunctionTypeSafetyDisclosure:
            return @"安全交底";
        case FunctionTypeSafetyEducation:
            return @"安全教育";
        case FunctionTypeChangeListCard:
            return @"处理卡";
        case FunctionTypeSecurityCheck:
            return @"安全检查";
        case FunctionTypeSafecheckRecode:
            return @"检查记录";
        case FunctionTypeSecurityListSd:case FunctionTypeSecurityList:
            return @"安全检查记录";
        case FunctionTypeFileInfo:
            return @"安全影像资料";
        case FunctionTypeSafeAccidentReport:
            return @"安全事故快报";
        case FunctionTypeHiddenAccidentReport:
            return @"隐患事故上报清单";
        case FunctionTypeSideStationRecord:
            return @"旁站记录";
        case FunctionTypePatrolInspectRecord:
            return @"巡视记录";
        case FunctionTypeSupervisionList:
            return @"督查督办";
        case FunctionTypeNoticeList:
            return @"消息中心";
        case FunctionTypeNoticeReplyList:
            return @"回复内容";
        case FunctionTypeControlEngineering:
            return  @"控制性工程日报";
            
        default:
            return @"";
    }
}

+ (NSString *)listURLOfFunctionType:(FunctionType)type {
    switch (type) {
//        case FunctionTypeCMS:
//            return [UrlConfig URL:getCmsAllContent];
//        case FunctionTypeQualityInspectionUnsubmitted: case FunctionTypeQualityInspectionWaitRectification: case FunctionTypeQualityInspectionWaitReview: case FunctionTypeQualityInspectionFinished:
//            return [UrlConfig URL:getQualityProblem];
//        case FunctionTypeProcessTracking:
//            return [UrlConfig URL:constructRegisterContentList];
//        case FunctionTypeElectricianRegular:
//            return [UrlConfig URL:getElectricianRegularList];
//        case FunctionTypeSecurityCheckLog:
//            return [UrlConfig URL:getSafetyCheckLogList];
//        case FunctionTypeConstructionLog:
//            return [UrlConfig URL:getConstructionLogList];
//        case FunctionTypeSupervisionLog:
//            return [UrlConfig URL:getSupervisorLogList];
//        case FunctionTypeEquipment:
//            return [UrlConfig URL:getSpecialUseList];
//        case FunctionTypeEquipmentSubType1: case FunctionTypeEquipmentSubType2: case FunctionTypeEquipmentSubType3:
//            return [UrlConfig URL:getSpecialUseListByPid];
//        case FunctionTypeConstructionDesign: case FunctionTypeChangeMngA: case FunctionTypeChangeMngB: case FunctionTypeChangeMngC: case FunctionTypeChangeMngD: case FunctionTypeConstructionPlan:
//            return [UrlConfig URL:getAttachmentManageList];
//        case FunctionTypeSpecialConstructionPlan: case FunctionTypeOtherPrograms:
//            return [UrlConfig URL:getSafetyAttachmentManageList];
//        case FunctionTypeMeetingMinutes:
//            return [UrlConfig URL:getMeetingImportantList];
//        case FunctionTypeGreenProblemUnsubmitted: case FunctionTypeGreenProblemWaitRectification: case FunctionTypeGreenProblemWaitReview: case FunctionTypeGreenProblemFinished:
//            return [UrlConfig URL:getGreenProblem];
//        case FunctionTypeSafetyDangerUnsubmitted: case FunctionTypeSafetyDangerWaitRectification: case FunctionTypeSafetyDangerWaitReview: case FunctionTypeSafetyDangerFinished:
//            return [UrlConfig URL:getSafetyDanger];
//        case FunctionTypeGreenInnovation:
//            return [UrlConfig URL:getGreenInnovationList];
//        case FunctionTypeSafetyProblem:
//            return [UrlConfig URL:getSafetyProblem];
//        case FunctionTypeSecurityCheckRecord:
//            return [UrlConfig URL:getSafetyCheckRecordList];
//        case FunctionTypeEngineeringDynamics:
//            return [UrlConfig URL:getProjectMsgAllContent];
//        case FunctionTypeWaterProblemUnsubmitted: case FunctionTypeWaterProblemWaitRectification: case FunctionTypeWaterProblemWaitReview: case FunctionTypeWaterProblemFinished:
//            return [UrlConfig URL:getWaterProblem];
//        case FunctionTypeSafetyDisclosure:
//            return [UrlConfig URL:getSafetyDisclosureList];
//        case FunctionTypeSafetyEducation:
//            return [UrlConfig URL:getSafetyEducationList];
//
//        case FunctionTypeProgressAllowedDay: case FunctionTypeProgressAllowedWeek: case FunctionTypeProgressAllowedMonth: case FunctionTypeProgressAllowedQuarter: case FunctionTypeProgressAllowedYear:
//                return [UrlConfig URL:getPlanFinish];
//        case FunctionTypeProgressPlanMonth : case FunctionTypeProgressPlanQuarter: case FunctionTypeProgressPlanYear:
//                return [UrlConfig URL:getPlanList];
//        case FunctionTypeChangeListCard:
//            return [UrlConfig URL:getChangeCardList];
//        case FunctionTypeSecurityCheck:
//            return [UrlConfig URL:securityListMain];
//        case FunctionTypeSafecheckRecode:
//            return [UrlConfig URL:safetRecodeList];
//        case FunctionTypeSecurityListSd:
//         return [UrlConfig URL:safetRecodeListSd];
//        case FunctionTypeSecurityList:
//          return [UrlConfig URL:safetRecodeList];
//        case FunctionTypeFileInfo:
//          return [UrlConfig URL:fileInfoList];
//        case FunctionTypeSafeAccidentReport:
//            return [UrlConfig URL:getAccidentReport];
//        case FunctionTypeHiddenAccidentReport:
//            return [UrlConfig URL:getSafetyHazardAccidentList];
        case FunctionTypeSideStationRecord:
            return [UrlConfig URL:sideStationRecord];
        case FunctionTypePatrolInspectRecord:
            return [UrlConfig URL:patrolInspectRecordGetList];
//        case FunctionTypeSupervisionList:
//            return [UrlConfig URL:getMyNoticeListPagination];
//        case FunctionTypeSupervisionListNew1: case FunctionTypeSupervisionListNew2:
//            return [UrlConfig URL:getTaskListPagination];
//        case FunctionTypeNoticeList:
//            return [UrlConfig URL:getNoticeListPagination];
//        case FunctionTypeNoticeReplyList:
//            return [UrlConfig URL:getReformReplyList];
//        case FunctionTypeControlEngineering:
//            return [UrlConfig URL:getReportMainListPagination];
            
        default:
            return @"";
    }
}

+ (NSString *)deleteURLOfFunctionType:(FunctionType)type {
    switch (type) {
//        case FunctionTypeCMS:
//            return [UrlConfig URL:deleteCms];
//        case FunctionTypeQualityInspectionUnsubmitted:
//            return [UrlConfig URL:delQualityProblem];
//        case FunctionTypeProcessTracking:
//            return [UrlConfig URL:delConstructRegisterContent];
//        case FunctionTypeElectricianRegular:
//            return [UrlConfig URL:delElectricianRegular];
//        case FunctionTypeSecurityCheckLog:
//            return [UrlConfig URL:delSafetyCheckLog];
//        case FunctionTypeEquipment:
//            return [UrlConfig URL:delSpecialUse];
//        case FunctionTypeEquipmentSubType1: case FunctionTypeEquipmentSubType2: case FunctionTypeEquipmentSubType3:
//            return [UrlConfig URL:delSpecialUseListByPid];
//        case FunctionTypeConstructionDesign: case FunctionTypeChangeMngA: case FunctionTypeChangeMngB: case FunctionTypeChangeMngC: case FunctionTypeChangeMngD: case FunctionTypeConstructionPlan:
//            return [UrlConfig URL:delAttachmentManage];
//        case FunctionTypeSpecialConstructionPlan: case FunctionTypeOtherPrograms:
//            return [UrlConfig URL:delSafetyAttachmentManage];
//        case FunctionTypeMeetingMinutes:
//            return [UrlConfig URL:delMeetingImportant];
//        case FunctionTypeGreenProblemUnsubmitted:
//            return [UrlConfig URL:delGreenProblem];
//        case FunctionTypeSafetyDangerUnsubmitted:
//            return [UrlConfig URL:delSafetyDanger];
//        case FunctionTypeGreenInnovation:
//            return [UrlConfig URL:delGreenInnovation];
//        case FunctionTypeSecurityCheckRecord:
//            return [UrlConfig URL:delSafetyCheckRecord];
//        case FunctionTypeWaterProblemUnsubmitted:
//            return [UrlConfig URL:delWaterProblem];
//        case FunctionTypeSafetyDisclosure:
//            return [UrlConfig URL:delSafetyDisclosure];
//        case FunctionTypeSafetyEducation:
//            return [UrlConfig URL:delSafetyEducation];
//        case FunctionTypeSecurityCheck:
//            return [UrlConfig URL:deleteMain];
//        case FunctionTypeSafecheckRecode:
//            return [UrlConfig URL:safetRecodeDelete];
//        case FunctionTypeSecurityListSd:
//            return [UrlConfig URL:safetRecodeDeleteSd];
//        case FunctionTypeSecurityList:
//            return [UrlConfig URL:safetRecodeDelete];
//        case FunctionTypeFileInfo:
//            return [UrlConfig URL:delfileInfo];
//        case FunctionTypeSafeAccidentReport:
//            return [UrlConfig URL:delAccidentReport];
//        case FunctionTypeHiddenAccidentReport:
//             return [UrlConfig URL:deleteSafetyHazardAccidentList];
        case FunctionTypeSideStationRecord:
             return [UrlConfig URL:deleteSideStationRecord];
        case FunctionTypePatrolInspectRecord:
             return [UrlConfig URL:patrolInspectRecordDelete];
//        case FunctionTypeSupervisionList:
//            return  [UrlConfig URL:deleteNotice];
//        case FunctionTypeSupervisionListNew1: case FunctionTypeSupervisionListNew2:
//            return  [UrlConfig URL:deleteNoticeNew];
//        case FunctionTypeProgressPlanQuarter: case FunctionTypeProgressPlanYear: case FunctionTypeProgressPlanMonth:
//            return  [UrlConfig URL:delPlan];
//        case FunctionTypeProgressAllowedDay:
//        case FunctionTypeProgressAllowedWeek:
//        case FunctionTypeProgressAllowedMonth:
//        case FunctionTypeProgressAllowedQuarter:
//        case FunctionTypeProgressAllowedYear:
//            return  [UrlConfig URL:delFinish];
//        case FunctionTypeControlEngineering:
//            return [UrlConfig URL:deleteReportMain];
        default:
            return @"";
    }
}

+ (NSString *)modelOfFunctionType:(FunctionType)type {
    switch (type) {
        case FunctionTypeCMS:
            return @"CMSModel";
        case FunctionTypeQualityInspectionUnsubmitted: case FunctionTypeQualityInspectionWaitRectification: case FunctionTypeQualityInspectionWaitReview: case FunctionTypeQualityInspectionFinished:
            return @"QualityInspectionModel";
        case FunctionTypeProcessTracking:
            return @"ProcessReportModel";
        case FunctionTypeElectricianRegular:
            return @"ElectricianRegularModel";
        case FunctionTypeSecurityCheckLog:
            return @"SecurityCheckLogModel";
        case FunctionTypeConstructionLog: case FunctionTypeSupervisionLog:
            return @"LogModel";
        case FunctionTypeEquipment:
            return @"SpecialEquipmentModel";
        case FunctionTypeEquipmentSubType1: case FunctionTypeEquipmentSubType2: case FunctionTypeEquipmentSubType3:
            return @"SpecialEquipmentChildModel";
        case FunctionTypeConstructionDesign: case FunctionTypeChangeMngA: case FunctionTypeChangeMngB: case FunctionTypeChangeMngC: case FunctionTypeChangeMngD: case FunctionTypeConstructionPlan: case FunctionTypeSpecialConstructionPlan: case FunctionTypeOtherPrograms: case FunctionTypeMeetingMinutes: case FunctionTypeGreenInnovation:
            return @"TechnologyModel";
        case FunctionTypeGreenProblemUnsubmitted: case FunctionTypeGreenProblemWaitRectification: case FunctionTypeGreenProblemWaitReview: case FunctionTypeGreenProblemFinished:
            return @"GreenProblemModel";
        case FunctionTypeSafetyDangerUnsubmitted: case FunctionTypeSafetyDangerWaitRectification: case FunctionTypeSafetyDangerWaitReview: case FunctionTypeSafetyDangerFinished:
            return @"SafetyDangerModel";
        case FunctionTypeSafetyProblem:
            return @"SafetyProblemModel";
        case FunctionTypeSecurityCheckRecord:
            return @"SecurityCheckRecordModel";
        case FunctionTypeEngineeringDynamics:
            return @"ProjectMsgModel";
        case FunctionTypeWaterProblemUnsubmitted: case FunctionTypeWaterProblemWaitRectification: case FunctionTypeWaterProblemWaitReview: case FunctionTypeWaterProblemFinished:
            return @"WaterProblemModel";
        case FunctionTypeSafetyDisclosure:
            return @"SafetyDisclosureModel";
        case FunctionTypeSafetyEducation:
            return @"SafetyEducationModel";
        case FunctionTypeProgressAllowedDay: case FunctionTypeProgressAllowedWeek: case FunctionTypeProgressAllowedMonth: case FunctionTypeProgressAllowedQuarter: case FunctionTypeProgressAllowedYear:
            return @"AllowedModel";
        case FunctionTypeProgressPlanMonth: case FunctionTypeProgressPlanQuarter: case FunctionTypeProgressPlanYear: 
            return @"PlanScheduleModel";
        case FunctionTypeChangeListCard:
            return @"ChangeInfoModel";
        case FunctionTypeSecurityCheck:
            return @"SecurityListModel";
        case FunctionTypeSafecheckRecode:
            return @"RecodelistSdModel";
        case FunctionTypeSecurityListSd:
            return @"RecodelistSdModel";
        case FunctionTypeSecurityList:
            return @"RecodelistSdModel";
        case FunctionTypeFileInfo:
            return @"FileSafeCheckModel";
        case FunctionTypeSafeAccidentReport:
            return @"AccidentReportModel";
        case FunctionTypeHiddenAccidentReport:
            return @"HazardAccidentModel";
        case FunctionTypeSideStationRecord: case FunctionTypePatrolInspectRecord:
            return @"SideStationModel";
        case FunctionTypeSupervisionList: case FunctionTypeNoticeList: case FunctionTypeNoticeReplyList:
            return @"SupervisionModel";
        case FunctionTypeSupervisionListNew1: case FunctionTypeSupervisionListNew2:
            return @"SupervisionNewModel";
        case FunctionTypeControlEngineering:
            return @"ControlEngineeringModel";
        default:
            return @"";
    }
}

+ (NSString *)searchOfFunctionType:(FunctionType)type {
    switch (type) {
        case FunctionTypeProcessTracking:
            return @"registerName";
        case FunctionTypeSecurityCheckLog: case FunctionTypeEquipment:
            return @"code";
        case FunctionTypeConstructionDesign: case FunctionTypeConstructionPlan: case FunctionTypeSpecialConstructionPlan: case FunctionTypeOtherPrograms: case FunctionTypeMeetingMinutes: case FunctionTypeGreenInnovation:
            return @"fileTitle";
        case FunctionTypeSecurityCheckRecord:
            return @"inspectLeader";
        case FunctionTypeSafetyProblem:
            return @"personchargeSgName";
        case FunctionTypeSafetyDisclosure: case FunctionTypeSafetyEducation:
            return @"name";
        default:
            return @"title";
    }
}

+ (NSString *)keywordOfFunctionType:(FunctionType)type {
    switch (type) {
        case FunctionTypeSecurityCheckRecord: case FunctionTypeSafetyProblem:
            return @"负责人";
        case FunctionTypeSafetyDisclosure: case FunctionTypeSafetyEducation:
            return @"名称";
        default:
            return nil;
    }
}
+(NSString *)getUrlParamsSetData:(id)data Type:(FunctionType)type mid:(NSString *)mid{
    NSString *projectId = [UserAgent DefaultAgent].projectId;
    NSString *sectionId = [UserAgent DefaultAgent].sectionId;
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_PASSWORD];
//    if(type == FunctionTypeSecurityCheck || type == FunctionTypeSecurityListSd || type == FunctionTypeSecurityList|| type == FunctionTypeFileInfo || type == FunctionTypeSafeAccidentReport || type == FunctionTypeHiddenAccidentReport || type == FunctionTypeSupervisoryNotice || type == FunctionTypeRectificationReply || type == FunctionTypeRectificationAcceptance || type == FunctionTypeSafecheckRecode || type == FunctionTypeSupervisionList || type == FunctionTypeNoticeList|| type == FunctionTypeProgressPlanYear || type == FunctionTypeProgressPlanQuarter || type == FunctionTypeProgressPlanMonth || type == FunctionTypeSupervisionListNew1 || type == FunctionTypeSupervisionListNew2){
//        NSMutableString *urlStr;
//        if (type == FunctionTypeSupervisionListNew1 || type == FunctionTypeSupervisionListNew2) {
//            if (data) {
//                SupervisionNewModel *model = (SupervisionNewModel *)data;
//                if (model.status == 1 || model.status == 2) {
//                    urlStr = [NSMutableString stringWithString:[UrlConfig URL:sendMsgNew]];
//                    [urlStr appendFormat:@"?id=%@", model.id];
//                    [urlStr appendFormat:@"&userName=%@", [AppUser sharedInstance].name];
//                    [urlStr appendFormat:@"&orgName=%@", [AppUser sharedInstance].orgName];
//                } else {
//                    urlStr = [NSMutableString stringWithString:[UrlConfig URL:taskViewMsg]];
//                    [urlStr appendFormat:@"?id=%@", model.id];
//                }
//            } else {
//                urlStr = [NSMutableString stringWithString:[UrlConfig URL:sendMsgNew]];
//                [urlStr appendFormat:@"?userName=%@", [AppUser sharedInstance].name];
//                [urlStr appendFormat:@"&orgName=%@", [AppUser sharedInstance].orgName];
//            }
//        } else if (type == FunctionTypeNoticeList ) {
//            urlStr = [NSMutableString stringWithString:[UrlConfig URL:replyMsg]];
//            [urlStr appendFormat:@"?id=%@",[data mj_keyValues][@"noticeId"]];
//            [urlStr appendFormat:@"&userId=%@", [AppUser sharedInstance].userId];
//        }else if (type == FunctionTypeSupervisionList && data) {
//            urlStr = [NSMutableString stringWithString:[UrlConfig URL:userViewMsgLine]];
//            [urlStr appendFormat:@"?id=%@",[data mj_keyValues][@"noticeId"]];
//             [urlStr appendFormat:@"&name=%@", [AppUser sharedInstance].name];
//            [urlStr appendFormat:@"&orgName=%@", [AppUser sharedInstance].orgName];
//        }else if (type == FunctionTypeSupervisionList ) {
//            urlStr = [NSMutableString stringWithString:[UrlConfig URL:sendMsg]];
//            [urlStr appendFormat:@"?userName=%@", [AppUser sharedInstance].name];
//            [urlStr appendFormat:@"&orgName=%@", [AppUser sharedInstance].orgName];
//        }else if (type == FunctionTypeSecurityCheck ) {
//            urlStr = [NSMutableString stringWithString:[UrlConfig URL:safetyCheckRecordMain]];
//            [urlStr appendFormat:@"?projectId=%@", projectId];
//        }else if(type == FunctionTypeSecurityListSd){
//            urlStr = [NSMutableString stringWithString:[UrlConfig URL:safetyCheckTunnel]];
//            [urlStr appendFormat:@"?projectId=%@", projectId];
//            [urlStr appendFormat:@"&mid=%@", mid];
//        }else if(type == FunctionTypeSecurityList){
//            urlStr = [NSMutableString stringWithString:[UrlConfig URL:safetyCheckRecord]];
//            [urlStr appendFormat:@"?projectId=%@", projectId];
//            [urlStr appendFormat:@"&mid=%@", mid];
//        }else if(type ==  FunctionTypeFileInfo){
//            urlStr = [NSMutableString stringWithString:[UrlConfig URL:safetyCheckFileInfo]];
//            [urlStr appendFormat:@"?projectId=%@", projectId];
//            [urlStr appendFormat:@"&mid=%@", mid];
//        }else if(type ==  FunctionTypeSafeAccidentReport){
//            urlStr = [NSMutableString stringWithString:[UrlConfig URL:safetyAccidentReport]];
//            [urlStr appendFormat:@"?projectId=%@", projectId];
//        }else if(type ==  FunctionTypeHiddenAccidentReport){
//            urlStr = [NSMutableString stringWithString:[UrlConfig URL:rislAccidentForm]];
//            [urlStr appendFormat:@"?projectId=%@", projectId];
//            [urlStr appendFormat:@"&mid=%@", mid];
//        }else if(type == FunctionTypeSupervisoryNotice){
//            urlStr = [NSMutableString stringWithString:[UrlConfig URL:safetyCheckNotify]];
//                       [urlStr appendFormat:@"?projectId=%@", projectId];
//        }else if(type == FunctionTypeRectificationReply){
//            urlStr = [NSMutableString stringWithString:[UrlConfig URL:safetyCheckReply]];
//                       [urlStr appendFormat:@"?projectId=%@", projectId];
//        }else if(type == FunctionTypeRectificationAcceptance){
//            urlStr = [NSMutableString stringWithString:[UrlConfig URL:safetyCheckAcceprt]];
//                       [urlStr appendFormat:@"?projectId=%@", projectId];
//        }else if (type == FunctionTypeSafecheckRecode ) {
//            urlStr = [NSMutableString stringWithString:[UrlConfig URL:mySafetyCheckRecord]];
//            [urlStr appendFormat:@"?projectId=%@", projectId];
//        }else if(type == FunctionTypeProgressPlanMonth || type == FunctionTypeProgressPlanQuarter || type == FunctionTypeProgressPlanYear){
//            urlStr = [NSMutableString stringWithString:[UrlConfig URL:schePlanForm]];
//            [urlStr appendFormat:@"?projectId=%@", projectId];
//            [urlStr appendFormat:@"&typeKey=%@", [UserAgent DefaultAgent].typeKey];
//            [urlStr appendFormat:@"&mainPrjName=%@", [UserAgent DefaultAgent].prjName];
//            [urlStr appendFormat:@"&mainPrjCode=%@", [UserAgent DefaultAgent].projectCode];
//            [urlStr appendFormat:@"&projectPlanSn=%@", [UserAgent DefaultAgent].projectPlanSn];
//
//            if([UserAgent DefaultAgent].sectionId){
//                [urlStr appendFormat:@"&stdVersion=%@", [UserAgent DefaultAgent].stdVersion];
//                [urlStr appendFormat:@"&mainSectionName=%@", [UserAgent DefaultAgent].sectionName];
//                [urlStr appendFormat:@"&mainSectionCode=%@", [UserAgent DefaultAgent].sectionCode];
//                [urlStr appendFormat:@"&sectionMajor=%@", [UserAgent DefaultAgent].sectionMajor];
//            }
//
//            if(type == FunctionTypeProgressPlanMonth){
//                [urlStr appendFormat:@"&planOrReportType=%@", @"4"];
//            }else if(type == FunctionTypeProgressPlanQuarter){
//                [urlStr appendFormat:@"&planOrReportType=%@", @"3"];
//            }else if(type == FunctionTypeProgressPlanYear){
//                [urlStr appendFormat:@"&planOrReportType=%@", @"1"];
//            }
//        }
//        if(data && type != FunctionTypeSupervisionList && type != FunctionTypeSupervisionListNew1 && type != FunctionTypeSupervisionListNew2 && type != FunctionTypeNoticeList ){
//            if(type ==  FunctionTypeSafeAccidentReport){
//                [urlStr appendFormat:@"&id=%@", [data mj_keyValues][@"reportId"]];
//            }else if(type ==  FunctionTypeHiddenAccidentReport){
//                [urlStr appendFormat:@"&id=%@", [data mj_keyValues][@"accidentId"]];
//            }else if(type ==  FunctionTypeRectificationReply){
//                [urlStr appendFormat:@"&id=%@", [data mj_keyValues][@"notifyId"]];
//            }else if(type ==  FunctionTypeRectificationAcceptance){
//                [urlStr appendFormat:@"&id=%@", [data mj_keyValues][@"jlSignId"]];
//            }else{
//                [urlStr appendFormat:@"&id=%@", [data mj_keyValues][@"id"]];
//            }
//        }
//        [urlStr appendFormat:@"&sectionId=%@",sectionId];
//        [urlStr appendFormat:@"&user=%@", [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
//        [urlStr appendFormat:@"&pwd=%@", [password stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
//        return urlStr;
//    }
   
    return @"";
}
+ (CGFloat)cellHeightOfFunctionType:(FunctionType)type {
    switch (type) {
        case FunctionTypeSecurityCheckLog: case FunctionTypeConstructionLog: case FunctionTypeSupervisionLog: case FunctionTypeConstructionPlan: case FunctionTypeSecurityCheckRecord: case FunctionTypeSafetyDisclosure: case FunctionTypeSafetyEducation: case FunctionTypeSecurityCheck: case FunctionTypeSecurityListSd: case FunctionTypeSecurityList:case FunctionTypeSafeAccidentReport:case FunctionTypeSafecheckRecode:
        case FunctionTypeHiddenAccidentReport: case FunctionTypeSupervisionListNew1: case FunctionTypeSupervisionListNew2:
            return 90;
        case FunctionTypeQualityInspectionUnsubmitted: case FunctionTypeQualityInspectionWaitRectification: case FunctionTypeQualityInspectionWaitReview: case FunctionTypeQualityInspectionFinished: case FunctionTypeSafetyDangerUnsubmitted: case FunctionTypeSafetyDangerWaitRectification: case FunctionTypeSafetyDangerWaitReview: case FunctionTypeSafetyDangerFinished: case FunctionTypeGreenProblemUnsubmitted: case FunctionTypeGreenProblemWaitRectification: case FunctionTypeGreenProblemWaitReview: case FunctionTypeGreenProblemFinished: case FunctionTypeWaterProblemUnsubmitted: case FunctionTypeWaterProblemWaitRectification: case FunctionTypeWaterProblemWaitReview: case FunctionTypeWaterProblemFinished:
            return 65;
        case FunctionTypeSafetyProblem:
            return 70;
        case FunctionTypeEquipment:
            return 100;
        case FunctionTypeEngineeringDynamics: case FunctionTypeSideStationRecord: case FunctionTypePatrolInspectRecord: case FunctionTypeSupervisionList:
            return 110;
        default:
            return 60;
    }
}

+ (BOOL)isShowFilter:(FunctionType)type {
    switch (type) {
        case FunctionTypeQualityInspectionUnsubmitted: case FunctionTypeQualityInspectionWaitRectification: case FunctionTypeQualityInspectionWaitReview: case FunctionTypeQualityInspectionFinished: case FunctionTypeConstructionLog: case FunctionTypeSupervisionLog: case FunctionTypeEquipmentSubType1: case FunctionTypeEquipmentSubType2: case FunctionTypeEquipmentSubType3: case FunctionTypeChangeMngA: case FunctionTypeChangeMngB: case FunctionTypeChangeMngC: case FunctionTypeChangeMngD: case FunctionTypeGreenProblemUnsubmitted: case FunctionTypeGreenProblemWaitRectification: case FunctionTypeGreenProblemWaitReview: case FunctionTypeGreenProblemFinished: case FunctionTypeSafetyDangerUnsubmitted: case FunctionTypeSafetyDangerWaitRectification: case FunctionTypeSafetyDangerWaitReview: case FunctionTypeSafetyDangerFinished: case FunctionTypeEngineeringDynamics: case FunctionTypeWaterProblemUnsubmitted: case FunctionTypeWaterProblemWaitRectification: case FunctionTypeWaterProblemWaitReview: case FunctionTypeWaterProblemFinished:case FunctionTypeSecurityCheck:case FunctionTypeFileInfo:case FunctionTypeSafeAccidentReport:case FunctionTypeHiddenAccidentReport:
        case FunctionTypeSafecheckRecode:case FunctionTypeSideStationRecord:case FunctionTypePatrolInspectRecord:
        case FunctionTypeSupervisionList:case FunctionTypeNoticeList:case FunctionTypeNoticeReplyList:case FunctionTypeControlEngineering:
            return NO;
        default:
            return YES;
    }
}

+ (BOOL)isShowDateFilter:(FunctionType)type {
    switch (type) {
        case FunctionTypeConstructionDesign: case FunctionTypeConstructionPlan: case FunctionTypeSecurityCheckRecord: case FunctionTypeGreenInnovation: case FunctionTypeSafetyProblem:
            return NO;
        default:
            return YES;
    }
}

+ (BOOL)isShowKeywordFilter:(FunctionType)type {
    switch (type) {
        case FunctionTypeElectricianRegular:
            return NO;
        default:
            return YES;
    }
}

+ (BOOL)isPriorityLoadPart:(FunctionType)type {
    switch (type) {
        case FunctionTypeProcessTracking:
            return YES;
        default:
            return NO;
    }
}

+ (BOOL)isShowAddBtn:(FunctionType)type {
//    if ([UserAgent DefaultAgent].resourceKeys.count == 0) {
//        return YES;
//    }
    switch (type) {
        case FunctionTypeConstructionDesign:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_conOrgDesign_save"];
        case FunctionTypeChangeMngA:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_changeA_save"];
        case FunctionTypeChangeMngB:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_changeC_save"];
        case FunctionTypeChangeMngC:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_changeC_save"];
        case FunctionTypeChangeMngD:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_changeD_save"];
        case FunctionTypeGreenInnovation:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"green_innovation_save"];
        case FunctionTypeConstructionPlan:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_construPlan_save"];
        case FunctionTypeSpecialConstructionPlan:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_specialPlan_save"];
        case FunctionTypeOtherPrograms:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_otherPlan_save"];
        case FunctionTypeGreenProblemUnsubmitted:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"green_problem_save"];
        case FunctionTypeWaterProblemUnsubmitted:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"green_problemWarter_save"];
        case FunctionTypeQualityInspectionUnsubmitted:
//            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"quality_problem_save"];
            return YES;
        case FunctionTypeProcessTracking:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"quality_constructRegister_save"];
        case FunctionTypeElectricianRegular:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_electricianRegular_save"];
        case FunctionTypeSafetyProblem:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_problem_save"];
        case FunctionTypeSafetyDangerUnsubmitted:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_risk_save"];
        case FunctionTypeEquipment:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_specialDevice_save"];
        case FunctionTypeSafetyDisclosure:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_disclosure_save"];
        case FunctionTypeSafetyEducation:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_education_save"];
        case FunctionTypeEquipmentSubType1:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_specialDeviceDq_save"];
        case FunctionTypeEquipmentSubType2:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_specialDeviceWh_save"];
         case FunctionTypeEquipmentSubType3:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_specialDeviceYy_save"];
        case FunctionTypeCMS: case FunctionTypeEngineeringDynamics:
            return NO;
        case FunctionTypeQualityInspectionWaitRectification: case FunctionTypeQualityInspectionWaitReview: case FunctionTypeQualityInspectionFinished: case FunctionTypeGreenProblemWaitRectification: case FunctionTypeGreenProblemWaitReview: case FunctionTypeGreenProblemFinished: case FunctionTypeSafetyDangerWaitRectification: case FunctionTypeSafetyDangerWaitReview: case FunctionTypeSafetyDangerFinished: case FunctionTypeWaterProblemWaitRectification: case FunctionTypeWaterProblemWaitReview: case FunctionTypeWaterProblemFinished:
        case FunctionTypeChangeListCard: case FunctionTypeSupervisionListNew1:
            case FunctionTypeNoticeList:
            case FunctionTypeNoticeReplyList:
//            case FunctionTypeProgressAllowedMonth:
//            case FunctionTypeProgressAllowedYear:
//            case FunctionTypeProgressAllowedQuarter:
            return NO;
        default:
            return YES;
    }
}

+ (BOOL)canDelete:(FunctionType)type {
//    if ([UserAgent DefaultAgent].resourceKeys.count == 0) {
//        return YES;
//    }
    switch (type) {
        case FunctionTypeConstructionDesign:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_conOrgDesign_del"];
        case FunctionTypeChangeMngA:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_changeA_del"];
        case FunctionTypeChangeMngB:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_changeB_del"];
        case FunctionTypeChangeMngC:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_changeC_del"];
        case FunctionTypeChangeMngD:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_changeD_del"];
        case FunctionTypeGreenInnovation:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"green_innovation_del"];
        case FunctionTypeConstructionPlan:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_construPlan_del"];
        case FunctionTypeSpecialConstructionPlan:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_specialPlan_del"];
        case FunctionTypeOtherPrograms:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_otherPlan_del"];
        case FunctionTypeProcessTracking:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"quality_constructRegister_del"];
        case FunctionTypeElectricianRegular:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_electricianRegular_del"];
        case FunctionTypeEquipment:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_specialDevice_del"];
        case FunctionTypeSafetyDisclosure:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_disclosure_del"];
        case FunctionTypeSafetyEducation:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_education_del"];
        case FunctionTypeEquipmentSubType1:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_specialDeviceDq_del"];
        case FunctionTypeEquipmentSubType2:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_specialDeviceWh_del"];
        case FunctionTypeEquipmentSubType3:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_specialDeviceYy_del"];
        case FunctionTypeConstructionLog: case FunctionTypeSupervisionLog: case FunctionTypeQualityInspectionWaitRectification: case FunctionTypeQualityInspectionWaitReview: case FunctionTypeQualityInspectionFinished: case FunctionTypeGreenProblemWaitRectification: case FunctionTypeGreenProblemWaitReview: case FunctionTypeGreenProblemFinished: case FunctionTypeSafetyDangerWaitRectification: case FunctionTypeSafetyDangerWaitReview: case FunctionTypeSafetyDangerFinished: case FunctionTypeSafetyProblem: case FunctionTypeEngineeringDynamics: case FunctionTypeWaterProblemWaitRectification: case FunctionTypeWaterProblemWaitReview: case FunctionTypeWaterProblemFinished:
        case FunctionTypeChangeListCard:case FunctionTypeNoticeList: case FunctionTypeNoticeReplyList:
//        case FunctionTypeProgressAllowedMonth:
//        case FunctionTypeProgressAllowedQuarter:
//        case FunctionTypeProgressAllowedYear:
            return NO;
        default:
            return YES; 
    }
}

+ (BOOL)canEdit:(FunctionType)type {
    if ([UserAgent DefaultAgent].resourceKeys.count == 0) {
        return YES;
    }
    switch (type) {
        case FunctionTypeConstructionPlan:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_construPlan_edit"];
        case FunctionTypeProcessTracking:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"quality_constructRegister_edit"];
        case FunctionTypeElectricianRegular:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_electricianRegular_edit"];
        case FunctionTypeEquipment:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_specialDevice_edit"];
        case FunctionTypeSafetyDisclosure:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_disclosure_edit"];
        case FunctionTypeSafetyEducation:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_education_edit"];
        case FunctionTypeEquipmentSubType1:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_specialDeviceDq_edit"];
        case FunctionTypeEquipmentSubType2:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_specialDeviceWh_edit"];
        case FunctionTypeEquipmentSubType3:
            return [[UserAgent DefaultAgent].resourceKeys containsObject:@"safety_specialDeviceYy_edit"];
        default:
            return YES;
    }
}

+ (void)baseListCell1:(BaseListCell1 *)cell setData:(id)data withType:(FunctionType)type {
//    if (type == FunctionTypeCMS) {
//        CMSModel *model = (CMSModel *)data;
//        cell.label1.text = model.title;
//        cell.label2.text = model.isTop ? @"是" : @"否";
//        cell.label3.text = [NSString stringWithFormat:@"作者:%@", model.author];
//        cell.label4.text = [NSString stringWithFormat:@"时间:%@", [model.createTime substringToIndex:10]];
//        [cell.btn setImage:[UIImage imageNamed:@"right_gray_ico"] forState:UIControlStateNormal];
//    } else if (type == FunctionTypeProcessTracking) {
//        ProcessReportModel *model = (ProcessReportModel *)data;
//        [cell.btn setImage:[UIImage imageNamed:@"right_gray_ico"] forState:UIControlStateNormal];
//        cell.label1.text = model.registerName;
//        cell.label2.text = model.modelName;
//        cell.label3.text = [NSString stringWithFormat:@"负责人:%@", model.director];
//        cell.label4.text = [NSString stringWithFormat:@"监理人:%@", model.supvervisor];
//        [cell.btn setImage:[UIImage imageNamed:@"icon_blue_menu"] forState:UIControlStateNormal];
//    } else if (type == FunctionTypeElectricianRegular) {
//        ElectricianRegularModel *model = (ElectricianRegularModel *)data;
//        cell.label1.text = [NSDate dateStringYYMMddWithLLTimestamp:model.repakrTime];
//        cell.label3.text = [NSString stringWithFormat:@"工作类别:%@", model.type];
//        cell.label4.text = [NSString stringWithFormat:@"天气:%@", model.wheather];
//        [cell.btn setImage:[UIImage imageNamed:@"right_gray_ico"] forState:UIControlStateNormal];
//    } else if (type == FunctionTypeEquipmentSubType1) {
//        SpecialEquipmentChildModel *model = (SpecialEquipmentChildModel *)data;
//        cell.label1.text = [NSDate dateStringYYMMddWithLLTimestamp:model.date];
//        cell.label3.text = [NSString stringWithFormat:@"方式:%@", model.modeName];
//        cell.label4.text = [NSString stringWithFormat:@"处理情况:%@", model.inspectSituation];
//        [cell.btn setImage:[UIImage imageNamed:@"right_gray_ico"] forState:UIControlStateNormal];
//    } else if (type == FunctionTypeEquipmentSubType2) {
//        SpecialEquipmentChildModel *model = (SpecialEquipmentChildModel *)data;
//        cell.label1.text = [NSDate dateStringYYMMddWithLLTimestamp:model.date];
//        cell.label3.text = [NSString stringWithFormat:@"方式:%@", model.modeName];
//        cell.label4.text = [NSString stringWithFormat:@"维护后设备状况:%@", model.inspectSituation];
//        [cell.btn setImage:[UIImage imageNamed:@"right_gray_ico"] forState:UIControlStateNormal];
//    } else if (type == FunctionTypeEquipmentSubType3) {
//        SpecialEquipmentChildModel *model = (SpecialEquipmentChildModel *)data;
//        cell.label1.text = [NSDate dateStringYYMMddWithLLTimestamp:model.date];
//        cell.label3.text = [NSString stringWithFormat:@"类别:%@", model.modeName];
//        cell.label4.text = [NSString stringWithFormat:@"处理情况:%@", model.inspectSituation];
//        [cell.btn setImage:[UIImage imageNamed:@"right_gray_ico"] forState:UIControlStateNormal];
//    } else if (type == FunctionTypeConstructionDesign || type == FunctionTypeChangeMngA || type == FunctionTypeChangeMngB || type == FunctionTypeChangeMngC || type == FunctionTypeChangeMngD || type == FunctionTypeMeetingMinutes  || type == FunctionTypeGreenInnovation) {
//        TechnologyModel *model = (TechnologyModel *)data;
//        cell.label1.text = model.fileTitle;
//        cell.label3.text = [NSString stringWithFormat:@"发布人:%@", model.publishPerson];
//        cell.label4.text = [NSString stringWithFormat:@"发布时间:%@", [NSDate dateStringYYMMddWithLLTimestamp:model.publishTime]];
//        [cell.btn setImage:[UIImage imageNamed:@"right_gray_ico"] forState:UIControlStateNormal];
//    } else if (type == FunctionTypeSpecialConstructionPlan || type == FunctionTypeOtherPrograms) {
//        TechnologyModel *model = (TechnologyModel *)data;
//        cell.label1.text = model.fileTitle;
//        cell.label2.text = model.extendTwo;
//        cell.label3.text = [NSString stringWithFormat:@"审批日期:%@", [NSDate dateStringYYMMddWithLLTimestamp:model.publishTime]];
//        cell.label4.text = [NSString stringWithFormat:@"评审日期:%@", [NSDate dateStringYYMMddWithLLTimestamp:model.dateOne]];
//        [cell.btn setImage:[UIImage imageNamed:@"right_gray_ico"] forState:UIControlStateNormal];
//    }else if(type == FunctionTypeChangeListCard){
//        ChangeInfoModel *model = (ChangeInfoModel *)data;
//        cell.label1.text = model.code;
//        if(model.type == 0){
//
//        }
//        switch (model.type) {
//            case 0:
//                cell.label2.text = @"变更类型：工程变更";
//                break;
//            case 1:
//                cell.label2.text = @"变更类型：工程废置";
//                break;
//            case 2:
//                cell.label2.text = @"变更类型：水毁工程";
//                break;
//            default:
//                cell.label2.text = @"变更类型：未知";
//                break;
//        }
//
//        cell.label3.text = [NSString stringWithFormat:@"变更金额：%@", model.alterSum];
//        cell.label4.text = [NSString stringWithFormat:@"变更原因：%@", model.changeType];
//    }else if(type == FunctionTypeFileInfo){
//        FileSafeCheckModel *model = (FileSafeCheckModel *)data;
//        cell.label1.text = model.info;
//        cell.label3.text = [NSString stringWithFormat:@"地点：%@", model.dress];
//        cell.label4.text = [NSString stringWithFormat:@"备注：%@", model.remark];
//    }
//    else if(type == FunctionTypeNoticeList){
//        SupervisionModel *model = (SupervisionModel *)data;
//        cell.label1.text = model.content;
//        cell.label1.text = model.content;
//        cell.label3.text = [NSString stringWithFormat:@"发送人：%@", model.senderName];
//        cell.label4.text = [NSString stringWithFormat:@"接收时间：%@",model.sendDate.length > 11? [model.sendDate substringToIndex:10]:model.sendDate];
//        cell.label2.text = @"未查看";
//        for (NSDictionary *dic in model.acceptances) {
//            if([dic[@"receiverId"] isEqualToString:[AppUser sharedInstance].userId] && ![dic[@"status"] isKindOfClass:[NSNull class]]  && [dic[@"status"] isEqualToNumber:@1]){
//                cell.label2.text = @"已查看";
//                cell.label2.textColor = UIColorTextBlue;
//            }
//        }
//        [cell.btn setImage:[UIImage imageNamed:@"right_gray_ico"] forState:UIControlStateNormal];
//    }else if(type == FunctionTypeNoticeReplyList){
//        SupervisionModel *model = (SupervisionModel *)data;
//        cell.label1.text = model.replyContent;
//        cell.label3.text = [NSString stringWithFormat:@"回复人：%@", model.replierName];
//        cell.label4.text = [NSString stringWithFormat:@"回复时间:%@", model.replyDate.length > 11? [model.replyDate substringToIndex:10]:model.replyDate];
//
//    }else if(type == FunctionTypeControlEngineering){
//        ControlEngineeringModel *model = (ControlEngineeringModel *)data;
//        cell.label1.text = model.reportName;
//        cell.label3.text = [NSString stringWithFormat:@"日期：%@", model.reportDate];
//        cell.label4.text = [NSString stringWithFormat:@"创建人:%@", model.createUserName];
//        [cell.btn setImage:[UIImage imageNamed:@"right_gray_ico"] forState:UIControlStateNormal];
//        switch (model.status) {
//            case 0:case 1:
//                cell.label2.text = @"草稿";
//                cell.label2.textColor = UIColorFromRGB(0x989898);
//                break;
//            case 2:
//                cell.label2.text = @"退回";
//                cell.label2.textColor = UIColorFromRGB(0xf0685c);
//                break;
//            case 3:
//                cell.label2.text = @"流转中";
//                cell.label2.textColor = UIColorFromRGB(0xffa438);
//                break;
//            case 4:
//                cell.label2.text = @"已完结";
//                cell.label2.textColor = UIColorFromRGB(0x70ba6f);
//                break;
//            default:
//                cell.label2.text = @"未知";
//                cell.label2.textColor = UIColorFromRGB(0xababab);
//                break;
//        }
//
//    }
}

+ (void)baseListCell2:(BaseListCell2 *)cell setData:(id)data withType:(FunctionType)type {
//    if (type == FunctionTypeSupervisionListNew1 || type == FunctionTypeSupervisionListNew2) {
//        SupervisionNewModel *model = (SupervisionNewModel *)data;
//        cell.label1.text = model.problems;
//        if (model.status == 1) {
//            cell.label2.text = @"草稿";
//            cell.label2.textColor = UIColorFromRGB(0x989898);
//        } else if (model.status == 4) {
//            cell.label2.text = @"完成";
//            cell.label2.textColor = UIColorFromRGB(0x00B573);
//        } else if (model.status == 2) {
//            cell.label2.text = @"发送";
//            cell.label2.textColor = UIColorFromRGB(0x2567DB);
//        } else {
//            cell.label2.text = @"督查";
//            cell.label2.textColor = UIColorFromRGB(0xFF3D00);
//        }
//        cell.label3.text = [NSString stringWithFormat:@"牵头领导:%@", model.initiatorName];
//        cell.label4.text = [NSString stringWithFormat:@"主责部门:%@", model.respOrgName];
//        cell.label5.text = [NSString stringWithFormat:@"配合部门:%@", model.cpOrgName];
//        cell.label6.text = [NSString stringWithFormat:@"计划完成时间:%@", model.planDate];
//        [cell.btn setImage:[UIImage imageNamed:@"right_gray_ico"] forState:UIControlStateNormal];
//    } else if (type == FunctionTypeSupervisionList) {
//        SupervisionModel *model = (SupervisionModel *)data;
//        cell.label1.text = model.title;
//        if(model.reviewedCount > 0){
//            cell.label2.text = @"复查";
//            cell.label2.textColor = UIColorFromRGB(0xffa438);
//        }else if(model.repliedCount > 0 && (model.repliedCount - model.replyCount) > -1){
//            cell.label2.text = @"回复";
//            cell.label2.textColor = UIColorFromRGB(0xf0685c);
//        }else if(model.status == 1){
//            cell.label2.text = @"通知";
//            cell.label2.textColor = UIColorTextBlue;
//        }else if(model.status == 0){
//            cell.label2.text = @"草稿";
//            cell.label2.textColor = UIColorFromRGB(0x989898);
//        }
//        NSMutableString *names= [NSMutableString string];
//              if(model.acceptances && model.acceptances.count>0){
//                  for (int i = 0; i<model.acceptances.count; i++) {
//                      NSDictionary *dic = model.acceptances[i];
//                      if(i == 0){
//                          [names appendString:dic[@"receiverName"]];
//                      }else{
//                          [names appendString:@";"];
//                          [names appendString:dic[@"receiverName"]];
//                      }
//                  }
//
//              }
//
//        cell.label3.text = [NSString stringWithFormat:@"责任单位:%@", model.responseUnitName];
//        cell.label4.text = [NSString stringWithFormat:@"责任人:%@", names];
//        cell.label5.text = [NSString stringWithFormat:@"整改/回复期限:%@", model.deadlineDate];
//        cell.label6.text = [NSString stringWithFormat:@"发送时间:%@", model.sendDate.length > 11? [model.sendDate substringToIndex:10]:model.sendDate];
//
//    }else
    if (type == FunctionTypePatrolInspectRecord) {
        SideStationModel *model = (SideStationModel *)data;
        cell.label1.text = model.code;
        switch (model.status) {
            case 0:
                cell.label2.text = @"未提交";
                cell.label2.textColor = UIColorFromRGB(0x989898);
                break;
            case 1:
                cell.label2.text = @"未提交";
                cell.label2.textColor = UIColorFromRGB(0x989898);
                break;
            case 2:
                cell.label2.text = @"退回";
                cell.label2.textColor = UIColorFromRGB(0xf0685c);
                break;
            case 3:
                cell.label2.text = @"流转中";
                cell.label2.textColor = UIColorFromRGB(0xffa438);
                break;
            case 4:
                cell.label2.text = @"审核完成";
                cell.label2.textColor = UIColorFromRGB(0x70ba6f);
                break;
            default:
                cell.label2.text = @"未知";
                cell.label2.textColor = UIColorFromRGB(0xababab);
                break;
        }
        cell.label3.text = [NSString stringWithFormat:@"巡视人:%@", model.piUserName];

        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.piTime/1000];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *string = [dateFormatter stringFromDate:date];

        cell.label4.text = [NSString stringWithFormat:@"巡视时间:%@", string];
        cell.label5.text = [NSString stringWithFormat:@"巡视范围:%@",model.piScopeName?model.piScopeName:@""];
        cell.label6.text = [NSString stringWithFormat:@"主要施工情况:%@", model.mainWorkDes?model.mainWorkDes:@""];
        [cell.btn setImage:[UIImage imageNamed:@"right_gray_ico"] forState:UIControlStateNormal];
    }
    if (type == FunctionTypeSideStationRecord) {
        SideStationModel *model = (SideStationModel *)data;
        cell.label1.text = model.code;
        switch (model.status) {
            case 0:
                cell.label2.text = @"未提交";
                cell.label2.textColor = UIColorFromRGB(0x989898);
                break;
            case 1:
                cell.label2.text = @"未提交";
                cell.label2.textColor = UIColorFromRGB(0x989898);
                break;
            case 2:
                cell.label2.text = @"退回";
                cell.label2.textColor = UIColorFromRGB(0xf0685c);
                break;
            case 3:
                cell.label2.text = @"流转中";
                cell.label2.textColor = UIColorFromRGB(0xffa438);
                break;
            case 4:
                cell.label2.text = @"审核完成";
                cell.label2.textColor = UIColorFromRGB(0x70ba6f);
                break;
            default:
                cell.label2.text = @"未知";
                cell.label2.textColor = UIColorFromRGB(0xababab);
                break;
        }
        cell.label3.text = [NSString stringWithFormat:@"旁站人:%@", model.ssUserName];

        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.ssTime/1000];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *string = [dateFormatter stringFromDate:date];

        cell.label4.text = [NSString stringWithFormat:@"旁站时间:%@", string];
        cell.label5.text = [NSString stringWithFormat:@"旁站项目:%@",model.ssProjectNames?model.ssProjectNames:@""];
        cell.label6.text = [NSString stringWithFormat:@"施工过程简述:%@", model.workProgressDes?model.workProgressDes:@""];
        [cell.btn setImage:[UIImage imageNamed:@"right_gray_ico"] forState:UIControlStateNormal];
    }
//        else if (type == FunctionTypeSecurityCheckLog) {
//        SecurityCheckLogModel *model = (SecurityCheckLogModel *)data;
//        cell.label1.text = model.code;
//        cell.label3.text = [NSString stringWithFormat:@"天气:%@", model.weather];
//        cell.label4.text = [NSString stringWithFormat:@"检查时间:%@", [NSDate dateStringYYMMddWithLLTimestamp:model.time]];
//        cell.label5.text = [NSString stringWithFormat:@"单位:%@", model.unitName];
//        cell.label6.text = [NSString stringWithFormat:@"内容及情况:%@", model.content];
//        [cell.btn setImage:[UIImage imageNamed:@"right_gray_ico"] forState:UIControlStateNormal];
//    } else if (type ==FunctionTypeConstructionPlan) {
//        TechnologyModel *model = (TechnologyModel *)data;
//        cell.label1.text = model.fileTitle;
//        cell.label2.text = model.extendTwo;
//        cell.label3.text = [NSString stringWithFormat:@"编制单位:%@", model.projectPart];
//        cell.label4.text = [NSString stringWithFormat:@"编制人:%@", model.extendThree];
//        cell.label5.text = [NSString stringWithFormat:@"上传人:%@", model.userName];
//        cell.label6.text = [NSString stringWithFormat:@"上传时间:%@", [NSDate dateStringYYMMddWithLLTimestamp:model.createTime]];
//        [cell.btn setImage:[UIImage imageNamed:@"right_gray_ico"] forState:UIControlStateNormal];
//    } else if (type == FunctionTypeSecurityCheckRecord) {
//        SecurityCheckRecordModel *model = (SecurityCheckRecordModel *)data;
//        cell.label1.text = model.inspectCode;
//        cell.label2.text = model.inspectType;
//        cell.label3.text = [NSString stringWithFormat:@"区域/桩号:%@", model.inspectPileno];
//        cell.label4.text = [NSString stringWithFormat:@"检查负责人:%@", model.inspectLeader];
//        cell.label5.text = [NSString stringWithFormat:@"检查时间:%@", model.inspectTime];
//        cell.label6.text = [NSString stringWithFormat:@"验收日期:%@", model.receiverTime];
//        [cell.btn setImage:[UIImage imageNamed:@"right_gray_ico"] forState:UIControlStateNormal];
//    } else if (type == FunctionTypeSafetyDisclosure) {
//        SafetyDisclosureModel *model = (SafetyDisclosureModel *)data;
//        cell.label1.text = model.name;
//        cell.label2.text = model.personName;
//        cell.label3.text = [NSString stringWithFormat:@"交底类型:%@", model.typeName];
//        cell.label4.text = [NSString stringWithFormat:@"交底地点:%@", model.place];
//        cell.label5.text = [NSString stringWithFormat:@"被交底组织:%@", model.disclosureUnit];
//        cell.label6.text = [NSString stringWithFormat:@"交底时间:%@", [NSDate dateStringYYMMddHHmmWithLLTimestamp:model.time]];
//        [cell.btn setImage:[UIImage imageNamed:@"right_gray_ico"] forState:UIControlStateNormal];
//    } else if (type == FunctionTypeSafetyEducation) {
//        SafetyEducationModel *model = (SafetyEducationModel *)data;
//        cell.label1.text = model.name;
//        switch (model.status.integerValue) {
//            case 1:
//                cell.label2.textColor = UIColorFromRGB(0x006666);
//                cell.label2.text = @"未开始";
//                break;
//            case 2:
//                cell.label2.textColor = UIColorFromRGB(0x009966);
//                cell.label2.text = @"签到中";
//                break;
//            case 3:
//                cell.label2.textColor = UIColorFromRGB(0x006699);
//                cell.label2.text = @"考试中";
//                break;
//            case 4:
//                cell.label2.textColor = UIColorFromRGB(0x990000);
//                cell.label2.text = @"已结束";
//                break;
//            default:
//                cell.label2.text = @"";
//                break;
//        }
//
//        cell.label3.text = [NSString stringWithFormat:@"教育类型:%@", model.typeName];
//        cell.label4.text = [NSString stringWithFormat:@"教育地点:%@", model.place];
//        cell.label5.text = [NSString stringWithFormat:@"受教育单位:%@", model.educationUnit];
//        cell.label6.text = [NSString stringWithFormat:@"教育时间:%@", [NSDate dateStringYYMMddHHmmWithLLTimestamp:model.time]];
//        [cell.btn setImage:[UIImage imageNamed:@"right_gray_ico"] forState:UIControlStateNormal];
//    }else if (type == FunctionTypeSecurityCheck) {
//        SecurityListModel *model = (SecurityListModel *)data;
//        cell.label1.text = model.title;
//        cell.label3.text = [NSString stringWithFormat:@"录入人:%@", model.userName];
//        switch (model.checkType.integerValue) {
//            case 1:
//                cell.label4.text = @"检查类型:日常检查";
//                break;
//            case 2:
//                cell.label4.text = @"检查类型:定期检查";
//                break;
//            case 3:
//
//                cell.label4.text = @"检查类型:专项检查";
//                break;
//            case 4:
//
//                cell.label4.text = @"检查类型:季节性节点";
//                break;
//            case 5:
//                cell.label4.text = @"检查类型:其他";
//                break;
//            default:
//                cell.label4.text = @"检查类型:";
//                break;
//        }
//        cell.label5.text = [NSString stringWithFormat:@"检查单位:%@", model.unitName];
//        cell.label6.numberOfLines = 1;
//        cell.label6.text = [NSString stringWithFormat:@"受检单位:%@", model.inspectedUnitNames];
//        [cell.btn setImage:[UIImage imageNamed:@"ico_contentB"] forState:UIControlStateNormal];
//    }else if (type == FunctionTypeSecurityList) {
//        RecodeListModel *model = (RecodeListModel *)data;
//        cell.label1.text = model.no;
//        cell.label3.text = [NSString stringWithFormat:@"是否下放督办通知:%@",[model.notifyCount isEqual:[NSNull null]]?@"否":@"是"] ;
//        NSInteger status = model.statu.integerValue;
//        switch (status) {
//            case 0:
//                cell.label2.text = @"未提交";
//                cell.label2.textColor = UIColorFromRGB(0xffa438);
//                break;
//            case 1:
//                cell.label2.text = @"已提交";
//                cell.label2.textColor = UIColorFromRGB(0xffa438);
//                break;
//            case 2:
//                cell.label2.text = @"退回";
//                cell.label2.textColor = UIColorFromRGB(0xf0685c);
//                break;
//            case 3:
//                cell.label2.text = @"流转中";
//                cell.label2.textColor = UIColorTextBlue;
//                break;
//            case 4:
//                cell.label2.text = @"审核完成";
//                cell.label2.textColor = UIColorFromRGB(0x70ba6f);
//                break;
//            default:
//                cell.label2.text = @"未知";
//                cell.label2.textColor = UIColorFromRGB(0xababab);
//                break;
//        }
//        cell.label4.text = [NSString stringWithFormat:@"被检查单位:%@", model.unitName];
//        cell.label4.numberOfLines = 1;
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.checkDate/1000];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        NSString *string = [dateFormatter stringFromDate:date];
//        cell.label5.text = [NSString stringWithFormat:@"检查时间:%@",string];
//        cell.label6.text = [NSString stringWithFormat:@"整改时限:%@", model.rectifTimeRanger];
//        [cell.btn setImage:[UIImage imageNamed:@"ico_contentB"] forState:UIControlStateNormal];
//    }else if (type == FunctionTypeSecurityListSd) {
//        RecodelistSdModel *model = (RecodelistSdModel *)data;
//        cell.label1.text = model.type;
//        cell.label3.text = [NSString stringWithFormat:@"是否下放督办通知:%@",[model.notifyCount isEqual:[NSNull null]]?@"否":@"是"] ;
//        NSInteger status = model.statu.integerValue;
//        switch (status) {
//            case 0:
//                cell.label2.text = @"未提交";
//                cell.label2.textColor = UIColorFromRGB(0xffa438);
//                break;
//            case 1:
//                cell.label2.text = @"已提交";
//                cell.label2.textColor = UIColorFromRGB(0xffa438);
//                break;
//            case 2:
//                cell.label2.text = @"退回";
//                cell.label2.textColor = UIColorFromRGB(0xf0685c);
//                break;
//            case 3:
//                cell.label2.text = @"流转中";
//                cell.label2.textColor = UIColorTextBlue;
//                break;
//            case 4:
//                cell.label2.text = @"审核完成";
//                cell.label2.textColor = UIColorFromRGB(0x70ba6f);
//                break;
//            default:
//                cell.label2.text = @"未知";
//                cell.label2.textColor = UIColorFromRGB(0xababab);
//                break;
//        }
//        cell.label4.text = [NSString stringWithFormat:@"被检查单位:%@", model.unitName];
//        cell.label4.numberOfLines = 1;
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.checkDate/1000];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        NSString *string = [dateFormatter stringFromDate:date];
//        cell.label5.text = [NSString stringWithFormat:@"检查时间:%@",string];
//        cell.label6.text = [NSString stringWithFormat:@"整改时限:%@", model.rectifTimeRanger];
//        [cell.btn setImage:[UIImage imageNamed:@"ico_contentB"] forState:UIControlStateNormal];
//    }else if (type == FunctionTypeSafeAccidentReport) {
//        AccidentReportModel *model = (AccidentReportModel *)data;
//        cell.label1.text = model.projectName;
//        cell.label3.text = [NSString stringWithFormat:@"发生日期:%@",model.accidentTime] ;
//        cell.label4.text = [NSString stringWithFormat:@"所在地:%@", model.station];
//        cell.label5.text = [NSString stringWithFormat:@"事故发生部位:%@",model.accidentPart];
//        cell.label6.text = [NSString stringWithFormat:@"事故类别:%@", model.accidentType];
//    }else if (type == FunctionTypeHiddenAccidentReport) {
//        HazardAccidentModel *model = (HazardAccidentModel *)data;
//        cell.label1.text = model.accidentName;
//        cell.label3.text = [NSString stringWithFormat:@"事故类型:%@",model.accidentTypeName] ;
//        cell.label4.text = [NSString stringWithFormat:@"事故等级:%@", model.accidentLevelName];
//        cell.label5.text = [NSString stringWithFormat:@"发生时间:%@",model.accidentDate];
//        cell.label6.text = [NSString stringWithFormat:@"事故描述:%@", model.accidentDescribe];
//    }else if (type == FunctionTypeSafecheckRecode) {
//        RecodelistSdModel *model = (RecodelistSdModel *)data;
//        cell.label1.text = model.code;
//        cell.label3.text = [NSString stringWithFormat:@"是否下放通知:%@",[model.notifyCount isEqual:[NSNull null]]?@"否":@"是"] ;
//        switch (model.statu.integerValue) {
//            case 0:
//                cell.label2.text = @"未提交";
//                cell.label2.textColor = UIColorFromRGB(0xffa438);
//                break;
//            case 1:
//                cell.label2.text = @"未提交";
//                cell.label2.textColor = UIColorFromRGB(0xffa438);
//                break;
//            case 2:
//                cell.label2.text = @"退回";
//                cell.label2.textColor = UIColorFromRGB(0xf0685c);
//                break;
//            case 3:
//                cell.label2.text = @"流转中";
//                cell.label2.textColor = UIColorTextBlue;
//                break;
//            case 4:
//                cell.label2.text = @"审核完成";
//                cell.label2.textColor = UIColorFromRGB(0x70ba6f);
//                break;
//            default:
//                cell.label2.text = @"未知";
//                cell.label2.textColor = UIColorFromRGB(0xababab);
//                break;
//        }
//        cell.label4.text = [NSString stringWithFormat:@"创建人:%@", model.userName];
//        cell.label5.text = [NSString stringWithFormat:@"检查区域桩号:%@", model.checkUnitSign ?model.checkUnitSign:@""];
//
//        NSString *string = @"";
//        if(model.checkDate){
//            NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.checkDate/1000];
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//            string = [dateFormatter stringFromDate:date];
//        }
//
//        cell.label6.text = [NSString stringWithFormat:@"检查时间:%@",string];
//        [cell.btn setImage:[UIImage imageNamed:@"right_gray_ico"] forState:UIControlStateNormal];
//    }
}

//+(void)planListCell:(AllowedCell *)cell setData:(id)data withType:(FunctionType)type {
//    cell.nameLabel.text = [data valueForKey:@"progressPlanName"];
//    switch ([[data valueForKey:@"status"] integerValue]) {
//
//        case 0:
//            cell.statusLabel.textColor = UIColorFromRGB(0xAB9793);
//            cell.statusLabel.text = @"填报中";
//            break;
//        case 1:
//            cell.statusLabel.textColor = UIColorFromRGB(0xAB9793);
//            cell.statusLabel.text = @"待申报";
//            break;
//        case 2:
//            cell.statusLabel.textColor = UIColorFromRGB(0xE94225);
//            cell.statusLabel.text = @"退回";
//            break;
//        case 3:
//            cell.statusLabel.textColor = UIColorFromRGB(0xb2b423);
//            cell.statusLabel.text = @"流转中";
//            break;
//        case 4:
//            cell.statusLabel.textColor = UIColorFromRGB(0x35E925);
//            cell.statusLabel.text = @"审核通过";
//            break;
//        default:
//            cell.statusLabel.textColor = UIColorFromRGB(0xAB9793);
//            cell.statusLabel.text = @"未知";
//            break;
//    }
//    cell.startTimeLabel.text = [data valueForKey:@"startDate"];
//    cell.endTimeLabel.text = [data valueForKey:@"endDate"];
//}
//
//+(void)allowedListCell:(AllowedCell *)cell setData:(id)data withType:(FunctionType)type {
//    cell.nameLabel.text = [data valueForKey:@"progressFinishName"];
//    switch ([[data valueForKey:@"status"] integerValue]) {
//
//        case 0:
//            cell.statusLabel.textColor = UIColorFromRGB(0xAB9793);
//            cell.statusLabel.text = @"填报中";
//            break;
//        case 1:
//            cell.statusLabel.textColor = UIColorFromRGB(0xAB9793);
//            cell.statusLabel.text = @"待申报";
//            break;
//        case 2:
//            cell.statusLabel.textColor = UIColorFromRGB(0xE94225);
//            cell.statusLabel.text = @"退回";
//            break;
//        case 3:
//            cell.statusLabel.textColor = UIColorFromRGB(0xb2b423);
//            cell.statusLabel.text = @"流转中";
//            break;
//        case 4:
//            cell.statusLabel.textColor = UIColorFromRGB(0x35E925);
//            cell.statusLabel.text = @"审核通过";
//            break;
//        default:
//            cell.statusLabel.textColor = UIColorFromRGB(0xAB9793);
//            cell.statusLabel.text = @"未知";
//            break;
//    }
//    cell.startTimeLabel.text = [data valueForKey:@"startDate"];
//    cell.endTimeLabel.text = [data valueForKey:@"endDate"];
//}
+ (void)problemListCell:(ProblemListCell *)cell setData:(id)data withType:(FunctionType)type {
    if (type == FunctionTypeSafetyDangerUnsubmitted || type == FunctionTypeSafetyDangerWaitRectification || type == FunctionTypeSafetyDangerWaitReview || type == FunctionTypeSafetyDangerFinished ) {
        //        || type == FunctionTypeQualityInspectionUnsubmitted || type == FunctionTypeQualityInspectionWaitRectification || type == FunctionTypeQualityInspectionWaitReview || type == FunctionTypeQualityInspectionFinished
        cell.describeLabel.text = [data valueForKey:@"name"];
    } else {
        cell.describeLabel.text = [data valueForKey:@"describe"];
    }
    
    switch ([[data valueForKey:@"level"] integerValue]) {
        case 1:
            cell.levelLabel.textColor = UIColorTextBlue;
            cell.levelLabel.text = @"一般";
            break;
        case 2:
            cell.levelLabel.textColor = UIColorFromRGB(0xffa438);
            cell.levelLabel.text = @"较大";
            break;
        case 3:
            cell.levelLabel.textColor = UIColorFromRGB(0xff7b2c);
            cell.levelLabel.text = @"重大";
            break;
        case 4:
            cell.levelLabel.textColor = UIColorFromRGB(0xf0685c);
            cell.levelLabel.text = @"特大";
            break;
        default:
            cell.levelLabel.textColor = [UIColor lightGrayColor];
            cell.levelLabel.text = @"未知";
            break;
    }
    
    cell.timeLabel.text = [data valueForKey:@"createTime"];
    cell.userLabel.text = [data valueForKey:@"userName"];
    cell.reformLabel.text = [data valueForKey:@"reformUserName"];
}

+ (void)specialUseListCell:(SpecialUseListCell *)cell setData:(id)data withType:(FunctionType)type {
//    SpecialEquipmentModel *model = (SpecialEquipmentModel *)data;
//    cell.codeLabel.text = model.code;
//    cell.deviceCodeLabel.text = model.deviceCode;
//    cell.usePlaceLabel.text = [NSString stringWithFormat:@"设备地点:%@", model.usePlace];
//    cell.deviceNameLabel.text = [NSString stringWithFormat:@"设备名称:%@", model.deviceName];
//    cell.unitNameLabel.text = [NSString stringWithFormat:@"单位:%@", model.unitName];
}

//+ (void)safetyProblemListCell:(SafetyProblemCell *)cell setData:(id)data withType:(FunctionType)type {
//    SafetyProblemModel *model = (SafetyProblemModel *)data;
//    cell.label1.text = @"安全问题整改追踪落实记录";
//    cell.label3.text = model.personchargeSgName;
//    cell.label4.text = [NSDate dateStringYYMMddWithLLTimestamp:model.startTime];
//    cell.label5.text = [NSString stringWithFormat:@"整改期限:%@", model.timeLimitSg];
//    UIImage *image = nil;
//    switch (model.status.integerValue) {
//        case 1:
//            cell.label2.text = @"未提交";
//            image = [UIImage imageNamed:@"icon_draft"];
//            break;
//        case 2:
//            cell.label2.text = @"退回";
//            image = [UIImage imageNamed:@"icon_back"];
//            break;
//        case 3:
//            cell.label2.text = @"流转中";
//            image = [UIImage imageNamed:@"icon_wait"];
//            break;
//        case 4:
//            cell.label2.text = @"已通过";
//            image = [UIImage imageNamed:@"icon_pass"];
//            break;
//        default:
//            break;
//    }
//
//    cell.iv.image = image;
//}
//
//+ (void)logListcell:(LogListcell *)cell setData:(id)data withType:(FunctionType)type {
//    LogModel *model = (LogModel *)data;
//    cell.codeLabel.text = model.code;
//    NSInteger status = model.status.integerValue;
//    switch (status) {
//        case 1:
//            cell.status.text = @"草稿";
//            cell.status.textColor = UIColorFromRGB(0xffa438);
//            break;
//        case 2:
//            cell.status.text = @"退回";
//            cell.status.textColor = UIColorFromRGB(0xf0685c);
//            break;
//        case 3:
//            cell.status.text = @"流转中";
//            cell.status.textColor = UIColorTextBlue;
//            break;
//        case 4:
//            cell.status.text = @"审批通过";
//            cell.status.textColor = UIColorFromRGB(0x70ba6f);
//            break;
//        default:
//            cell.status.text = @"未知";
//            cell.status.textColor = UIColorFromRGB(0xababab);
//            break;
//    }
//
//    cell.numLabel.text = [NSString stringWithFormat:@"合同号:%@", model.constructNum];
//    cell.dateLabel.text = [NSString stringWithFormat:@"创建日期:%@", [NSDate dateStringYYMMddWithLLTimestamp:model.createTime]];
//
//    NSString *str;
//    if (type == FunctionTypeConstructionLog) {
//        str = @"承包人";
//    } else {
//        str = @"监理人";
//    }
//    cell.nameLabel.text = [NSString stringWithFormat:@"%@:%@", str, model.supervisor];
//}
//
//+ (void)dongtaiListcell:(DongTaiCell *)cell setData:(id)data withType:(FunctionType)type {
//    ProjectMsgModel *model = (ProjectMsgModel *)data;
//    cell.uname.text = model.uname;
//    cell.zname.text = model.zname;
//    cell.pname.text = model.pname;
//    cell.iname.text = model.iname;
//    cell.status.text =[NSString stringWithFormat:@"状态:%@",model.state];
//    cell.date.text = [NSDate dateStringYYMMddWithLLTimestamp:model.createTime];
//}
//
//+ (UIViewController *)viewControllerOfFunctionType:(FunctionType)type withModel:(id)model {
//    if (type == FunctionTypeCMS) {
//        CMSModel *data = (CMSModel *)model;
//        BaseWebViewController *vc = [[BaseWebViewController alloc] init];
//        vc.title = data.title;
//        vc.url = [NSString stringWithFormat:@"%@://%@:%@/processapprovalnew/cms/viewForm?id=%@", protocolStr, serverHost, serverPort, data.id];
//        return vc;
//    } else if (type == FunctionTypeQualityInspectionUnsubmitted || type == FunctionTypeQualityInspectionWaitRectification || type == FunctionTypeQualityInspectionWaitReview || type == FunctionTypeQualityInspectionFinished) {
//        QualityInspectionController *vc = [[QualityInspectionController alloc] init];
//        vc.model = model;
//        vc.type = type;
//        return vc;
//    } else if (type == FunctionTypeProcessTracking) {
//        ProcessTrackingController *vc = [[UIStoryboard storyboardWithName:@"Quality" bundle:nil] instantiateViewControllerWithIdentifier:@"ProcessTracking"];
//        vc.canEdit = [self canEdit:type];
//        vc.model = model;
//        return vc;
//    } else if (type == FunctionTypeElectricianRegular){
//        ElectricianRegularController *vc = [[UIStoryboard storyboardWithName:@"Safe" bundle:nil] instantiateViewControllerWithIdentifier:@"ElectricianRegular"];
//        vc.canEdit = [self canEdit:type];
//        vc.model = model;
//        return vc;
//    } else if (type == FunctionTypeSecurityCheckLog) {
//        SecurityCheckLogController *vc = [[UIStoryboard storyboardWithName:@"Safe" bundle:nil] instantiateViewControllerWithIdentifier:@"SecurityCheckLog"];
//        vc.model = model;
//        return vc;
//    } else if (type == FunctionTypeEquipment) {
//        SpecialEquipmentController *vc = [[UIStoryboard storyboardWithName:@"Safe" bundle:nil] instantiateViewControllerWithIdentifier:@"SpecialEquipment"];
//        vc.canEdit = [self canEdit:type];
//        vc.model = model;
//        return vc;
//    } else if (type == FunctionTypeEquipmentSubType1 || type == FunctionTypeEquipmentSubType2 || type == FunctionTypeEquipmentSubType3) {
//        SpecialEquipmentChildController *vc = [[UIStoryboard storyboardWithName:@"Safe" bundle:nil] instantiateViewControllerWithIdentifier:@"SpecialEquipmentChild"];
//        if (model) {
//            vc.canEdit = [self canEdit:type];
//        } else {
//            vc.canEdit = YES;
//        }
//        vc.model = model;
//        vc.type = type;
//        return vc;
//    } else if (type == FunctionTypeConstructionLog) {
//        ConstructionLogController *vc = [[UIStoryboard storyboardWithName:@"Complex" bundle:nil] instantiateViewControllerWithIdentifier:@"ConstructionLog"];
//        vc.model = model;
//        return vc;
//    } else if (type == FunctionTypeSupervisionLog) {
//        SupervisionLogController *vc = [[UIStoryboard storyboardWithName:@"Complex" bundle:nil] instantiateViewControllerWithIdentifier:@"SupervisionLog"];
//        vc.model = model;
//        return vc;
//    } else if (type == FunctionTypeConstructionDesign || type == FunctionTypeChangeMngA || type == FunctionTypeChangeMngB || type == FunctionTypeChangeMngC || type == FunctionTypeChangeMngD || type == FunctionTypeMeetingMinutes || type == FunctionTypeGreenInnovation) {
//        ConstructionDesignController *vc = [[UIStoryboard storyboardWithName:@"Technology" bundle:nil] instantiateViewControllerWithIdentifier:@"ConstructionDesign"];
//        switch (type) {
//            case FunctionTypeConstructionDesign:
//                vc.fileType = @"ConOrgDesign";
//                vc.canEdit = [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_conOrgDesign_edit"];
//                break;
//            case FunctionTypeChangeMngA:
//                vc.fileType = @"ChangeMngA";
//                vc.canEdit = [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_changeA_edit"];
//                break;
//            case FunctionTypeChangeMngB:
//                vc.fileType = @"ChangeMngB";
//                vc.canEdit = [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_changeB_edit"];
//                break;
//            case FunctionTypeChangeMngC:
//                vc.fileType = @"ChangeMngC";
//                vc.canEdit = [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_changeC_edit"];
//                break;
//            case FunctionTypeChangeMngD:
//                vc.fileType = @"ChangeMngD";
//                vc.canEdit = [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_changeD_edit"];
//                break;
//            case FunctionTypeGreenInnovation:
//                vc.fileType = @"greenInnovation";
//                vc.canEdit = [[UserAgent DefaultAgent].resourceKeys containsObject:@"green_innovation_edit"];
//                break;
//            default:
//                vc.fileType = @"ConOrgDesign";
//                vc.canEdit = [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_conOrgDesign_edit"];
//                break;
//        }
//        vc.model = model;
//        return vc;
//    } else if (type == FunctionTypeConstructionPlan) {
//        ConstructionPlanController *vc = [[UIStoryboard storyboardWithName:@"Technology" bundle:nil] instantiateViewControllerWithIdentifier:@"ConstructionPlan"];
//        vc.canEdit = [self canEdit:type];
//        vc.model = model;
//        return vc;
//    } else if (type == FunctionTypeSpecialConstructionPlan || type == FunctionTypeOtherPrograms) {
//        SpecialConstructionPlanController *vc = [[UIStoryboard storyboardWithName:@"Technology" bundle:nil] instantiateViewControllerWithIdentifier:@"SpecialConstructionPlan"];
//        vc.model = model;
//        if (type == FunctionTypeSpecialConstructionPlan) {
//            vc.fileType = @"specialPlan";
//            vc.canEdit = [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_specialPlan_edit"];
//        } else {
//            vc.fileType = @"specialPlanOther";
//            vc.canEdit = [[UserAgent DefaultAgent].resourceKeys containsObject:@"technology_otherPlan_edit"];
//        }
//        return vc;
//    } else if (type == FunctionTypeGreenProblemUnsubmitted || type == FunctionTypeGreenProblemWaitRectification || type == FunctionTypeGreenProblemWaitReview || type == FunctionTypeGreenProblemFinished) {
//        GreenProblemController *vc = [[GreenProblemController alloc] init];
//        vc.model = model;
//        vc.type = type;
//        return vc;
//    } else if (type == FunctionTypeSafetyDangerUnsubmitted || type == FunctionTypeSafetyDangerWaitRectification || type == FunctionTypeSafetyDangerWaitReview || type == FunctionTypeSafetyDangerFinished) {
//        SafetyDangerController *vc = [[SafetyDangerController alloc] init];
//        vc.model = model;
//        vc.type = type;
//        return vc;
//    } else if (type == FunctionTypeSafetyProblem) {
//        SafetyProblemController *vc = [[UIStoryboard storyboardWithName:@"Safe" bundle:nil] instantiateViewControllerWithIdentifier:@"SafetyProblem"];
//        vc.model = model;
//        return vc;
//    } else if (type == FunctionTypeSecurityCheckRecord) {
//        SecurityCheckRecordController *vc = [[UIStoryboard storyboardWithName:@"Safe" bundle:nil] instantiateViewControllerWithIdentifier:@"SecurityCheckRecorde"];
//        vc.model = model;
//        return vc;
//    } else if (type == FunctionTypeWaterProblemUnsubmitted || type == FunctionTypeWaterProblemWaitRectification || type == FunctionTypeWaterProblemWaitReview || type == FunctionTypeWaterProblemFinished) {
//        WaterProblemController *vc = [[WaterProblemController alloc] init];
//        vc.model = model;
//        vc.type = type;
//        return vc;
//    } else if (type == FunctionTypeSafetyDisclosure) {
//        SafetyDisclosureController *vc = [[UIStoryboard storyboardWithName:@"Safe" bundle:nil] instantiateViewControllerWithIdentifier:@"SafetyDisclosure"];
//        vc.canEdit = [self canEdit:type];
//        vc.model = model;
//        return vc;
//    } else if (type == FunctionTypeSafetyEducation) {
//        SafetyEducationController *vc = [[UIStoryboard storyboardWithName:@"Safe" bundle:nil] instantiateViewControllerWithIdentifier:@"SafetyEducation"];
//        vc.canEdit = [self canEdit:type];
//        vc.model = model;
//        return vc;
//    }else if (type == FunctionTypeProgressAllowedYear || type == FunctionTypeProgressAllowedMonth || type == FunctionTypeProgressAllowedQuarter || type == FunctionTypeProgressAllowedWeek) {
//        AddAllowViewController *vc = [AddAllowViewController new];
//        if(type == FunctionTypeProgressAllowedYear){
//            vc.planOrReportType = @"1";
//        }else if(type == FunctionTypeProgressAllowedQuarter){
//            vc.planOrReportType = @"3";
//        }else if(type == FunctionTypeProgressAllowedMonth){
//            vc.planOrReportType = @"4";
//        }else if(type == FunctionTypeProgressAllowedWeek){
//            vc.planOrReportType = @"5";
//        }
//        return vc;
//    }else if(type == FunctionTypeControlEngineering){
//        ProgressReportControlFlowViewController *flow = [[ProgressReportControlFlowViewController alloc]init];
//        ControlEngineeringModel *data = (ControlEngineeringModel *)model;
//        flow.modelId = data.id;
//        flow.modelName = data.reportName;
//        return  flow;
//    }
//    return nil;
//}
//
//+ (UIViewController *)childViewControllerOfFunctionType:(FunctionType)type withModel:(id)model {
//    if (type == FunctionTypeNoticeList) {
//        BaseListViewController*vc = [BaseListViewController new];
//        vc.type = FunctionTypeNoticeReplyList;
//        SupervisionModel *data = (SupervisionModel *)model;
//        vc.noticeId = data.noticeId;
//        NSString *pid = @"";
//        for (NSDictionary *dic in data.acceptances) {
//            if([dic[@"receiverId"] isEqualToString:[AppUser sharedInstance].userId]){
//                pid = dic[@"id"];
//            }
//        }
//        vc.pid = pid;
//        return vc;
//    }if (type == FunctionTypeProcessTracking) {
//        NewModelViewController *vc = [[UIStoryboard storyboardWithName:@"PartSeleter" bundle:nil] instantiateViewControllerWithIdentifier:@"NewModelView"];
//        ProcessReportModel *data = (ProcessReportModel *)model;
//        vc.partCode = data.partCode;
//        vc.modelId = data.modelId;
//        vc.pid = data.id;
//        return vc;
//    } else if (type == FunctionTypeEquipment) {
//        SpecialEquipmentModel *data = (SpecialEquipmentModel *)model;
//        SpecialEquipmentChildListController *vc = [[SpecialEquipmentChildListController alloc] init];
//        vc.code = data.code;
//        vc.pid = data.id;
//        return vc;
//    }else if(type == FunctionTypeSecurityCheck){
//        SecurityCheckListViewController *vc = [SecurityCheckListViewController new];
//        SecurityListModel *modelList = (SecurityListModel *)model;
//        vc.sgSignId = modelList.id;
//        return vc;
//    }else if(type == FunctionTypeSecurityListSd || type == FunctionTypeSecurityList){
//        RecodelistSdModel *data = (RecodelistSdModel *)model;
//        BaseListViewController *vc = [BaseListViewController new];
//        vc.type = FunctionTypeFileInfo;
//        vc.pid = data.id;
//        return vc;
//    }
//
//    return nil;
//}

@end
