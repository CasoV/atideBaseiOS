//
//  FunctionFactory.h
//  ycxm
//
//  Created by 末末班车 on 2018/9/19.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpecialUseListCell.h"
#import "SafetyProblemCell.h"
#import "ProblemListCell.h"
#import "BaseListCell1.h"
#import "BaseListCell2.h"
#import "LogListcell.h"

typedef NS_ENUM(NSInteger, FunctionType) {
    FunctionTypeCMS = 1,                            //通知公告 1
    FunctionTypeQualityInspectionUnsubmitted,       //质量检查未提交
    FunctionTypeQualityInspectionWaitRectification, //质量检查待整改
    FunctionTypeQualityInspectionWaitReview,        //质量检查待复查
    FunctionTypeQualityInspectionFinished,          //质量检查已完结 5
    FunctionTypeProcessTracking,                    //工艺工序过程填报
    FunctionTypeElectricianRegular,                 //电工巡视记录
    FunctionTypeSecurityCheckLog,                   //安全检查日志
    FunctionTypeMeetingMinutes,                     //会议纪要
    FunctionTypeConstructionLog,                    //施工日志 10
    FunctionTypeSupervisionLog,                     //监理日志
    FunctionTypeEquipment,                          //特种设备“一机一档”
    FunctionTypeEquipmentSubType1,                  //特种设备“一机一档” 定期检查
    FunctionTypeEquipmentSubType2,                  //特种设备“一机一档” 维护保养
    FunctionTypeEquipmentSubType3,                  //特种设备“一机一档” 运行故障和事故记录 15
    FunctionTypeConstructionDesign,                 //施工组织设计
    FunctionTypeChangeMngA,                         //A类变更
    FunctionTypeChangeMngB,                         //B类变更
    FunctionTypeChangeMngC,                         //C类变更
    FunctionTypeChangeMngD,                         //D类变更 20
    FunctionTypeConstructionPlan,                   //施工方案
    FunctionTypeSpecialConstructionPlan,            //专项施工方案
    FunctionTypeOtherPrograms,                      //其他方案
    FunctionTypeGreenProblemUnsubmitted,            //环境问题未提交
    FunctionTypeGreenProblemWaitRectification,      //环境问题待整改 25
    FunctionTypeGreenProblemWaitReview,             //环境问题待复查
    FunctionTypeGreenProblemFinished,               //环境问题已完结
    FunctionTypeSafetyDangerUnsubmitted,            //安全隐患未提交
    FunctionTypeSafetyDangerWaitRectification,      //安全隐患待整改
    FunctionTypeSafetyDangerWaitReview,             //安全隐患待复查 30
    FunctionTypeSafetyDangerFinished,               //安全隐患已完结
    FunctionTypeGreenInnovation,                    //创新创优展示
    FunctionTypeSafetyProblem,                      //安全问题整改
    FunctionTypeSecurityCheckRecord,                //安全检查记录
    FunctionTypeEngineeringDynamics,                //工程动态 35
    FunctionTypeMeetingAnnouncement,                //会议通知
    FunctionTypeWaterProblemUnsubmitted,            //水保问题未提交
    FunctionTypeWaterProblemWaitRectification,      //水保问题待整改
    FunctionTypeWaterProblemWaitReview,             //水保问题待复查
    FunctionTypeWaterProblemFinished,               //水保问题已完结 40
    FunctionTypeSafetyDisclosure,                   //安全交底
    FunctionTypeSafetyEducation,                    //安全教育
    FunctionTypeProgressAllowedDay,                     //日报
    FunctionTypeProgressAllowedWeek,                    //周报
    FunctionTypeProgressAllowedMonth,                   //月报 45
    FunctionTypeProgressAllowedQuarter,                 //季报
    FunctionTypeProgressAllowedYear,                    //年报
    FunctionTypeChangeListCard,                         //处理卡
    FunctionTypeSecurityCheck,                          //安全检查记录
    FunctionTypeSecurityListSd,                         //安全生产隐患检查记录 50
    FunctionTypeSecurityList,                           //隧道安全步距检查
    FunctionTypeFileInfo,                               //安全影像资料
    FunctionTypeSafeAccidentReport,                      //安全事故快报
    FunctionTypeHiddenAccidentReport,                     //隐患事故上报清单
    FunctionTypeSupervisoryNotice,                          //督办通知 55
    FunctionTypeRectificationReply,                         //整改回复
    FunctionTypeRectificationAcceptance,                   //整改验收
    FunctionTypeSafecheckRecode,                          //检查记录
    FunctionTypeSideStationRecord,                           //旁站记录
    FunctionTypePatrolInspectRecord,                         //巡视记录 60
    FunctionTypeSupervisionList,                            //督查督办
    FunctionTypeNoticeList,                                  //消息中心
    FunctionTypeNoticeReplyList,                               //回复内容
    FunctionTypeProgressPlanMonth,                   //月计划
    FunctionTypeProgressPlanQuarter,                 //季计划 65
    FunctionTypeProgressPlanYear,                    //年计划
    FunctionTypeControlEngineering,                  //控制性工程日报
    FunctionTypeSupervisionListNew1,                 //督查督办（我收到的）
    FunctionTypeSupervisionListNew2,                 //督查督办（我创建的）
};

@interface FunctionFactory : NSObject

//返回功能列表标题
+ (NSString *)titleOfFunctionType:(FunctionType)type;
//返回列表URL
+ (NSString *)listURLOfFunctionType:(FunctionType)type;
//返回删除URL
+ (NSString *)deleteURLOfFunctionType:(FunctionType)type;
//返回功能列表模型
+ (NSString *)modelOfFunctionType:(FunctionType)type;
//返回搜索关键字
+ (NSString *)searchOfFunctionType:(FunctionType)type;
+ (NSString *)keywordOfFunctionType:(FunctionType)type;
//表单获取传递参数
+(NSString *)getUrlParamsSetData:(id)data Type:(FunctionType)type mid:(NSString *)mid;
//返回功能列表cell高度
+ (CGFloat)cellHeightOfFunctionType:(FunctionType)type;
//返回是否显示新增按钮
+ (BOOL)isShowAddBtn:(FunctionType)type;
//返回是否显示筛选按钮
+ (BOOL)isShowFilter:(FunctionType)type;
//返回是否优先加载部位
+ (BOOL)isPriorityLoadPart:(FunctionType)type;
//返回是否显示筛选日期
+ (BOOL)isShowDateFilter:(FunctionType)type;
//返回是否显示筛选关键字
+ (BOOL)isShowKeywordFilter:(FunctionType)type;
//返回是否可删除
+ (BOOL)canDelete:(FunctionType)type;
//返回是否可编辑
+ (BOOL)canEdit:(FunctionType)type;

//填充cell1数据
+ (void)baseListCell1:(BaseListCell1 *)cell setData:(id)data withType:(FunctionType)type;
//填充cell2数据
+ (void)baseListCell2:(BaseListCell2 *)cell setData:(id)data withType:(FunctionType)type;


+ (void)logListcell:(LogListcell *)cell setData:(id)data withType:(FunctionType)type;
+ (void)problemListCell:(ProblemListCell *)cell setData:(id)data withType:(FunctionType)type;
+ (void)specialUseListCell:(SpecialUseListCell *)cell setData:(id)data withType:(FunctionType)type;
+ (void)safetyProblemListCell:(SafetyProblemCell *)cell setData:(id)data withType:(FunctionType)type;

//返回功能详情视图控制器
+ (UIViewController *)viewControllerOfFunctionType:(FunctionType)type withModel:(id)model;
//返回功能子列表视图控制器
+ (UIViewController *)childViewControllerOfFunctionType:(FunctionType)type withModel:(id)model;

//+(void)allowedListCell:(AllowedCell *)cell setData:(id)data withType:(FunctionType)type;
//
//+(void)planListCell:(AllowedCell *)cell setData:(id)data withType:(FunctionType)type;
@end
