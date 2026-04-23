//
//  UrlConfig.h
//  YNXYJTXXPT
//
//  Created by 末末班车 on 2017/6/26.
//  Copyright © 2017年 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>

//菜单类型枚举
static NSString * MENU_LINK_TYPE_OVERALL_ID = @"299801723252244480";
static NSString * MENU_LINK_TYPE_All_ID = @"299801797860524032";

/*IP*/
static NSString * protocolStrIp = @"http://220.165.247.77:8099/atideApps/ios/config.txt";
static NSString * loginUrl = @"/api/login/check";
static NSString * loginBgUrl = @"/apk/app.png";
static NSString * pwdWayUrl = @"/api/login/crypto";
static NSString * publicKeyUrl = @"/api/login/rsa/publicKey";

static NSString * serverPort = @"13381";

// 国道生产   http://112.112.9.234:13380/
// 国道测试   http://220.165.247.94:13381/
static NSString * protocolStr = @"http";
static NSString * serverHost = @"220.165.247.94";

/*验证码*/
static BOOL useCaptcha = NO;
static NSString * captchaUrl = @"/api/login/v2/captcha";
static NSString * captchaKey = @"";
static NSString * captcha = @"";

/*是否使用ca*/
static BOOL isCa = NO;
//质检资料显示附件按钮
static BOOL qdShowAtc = YES;
/*切换组织*/
static NSString * changeOrg = @"/oa/changeOrg";
/*切换状态*/
static NSString * setState = @"/api/baseUser/setState";
static NSString * getUserList=@"/api/baseUser/getUserList";
/*首页*/
static NSString * getTodoList = @"/workflow/personalWork/getTodoList";
static NSString * getDoneList = @"/workflow/personalWork/getDoneList";
static NSString * getDoingList = @"/workflow/personalWork/getDoingList";
static NSString * getTodoMsgList = @"/api/noticeMsg/getTodoMsgList";

//手机端表单拼接地址
static NSString * temMobile = @"/mobileView/";
static NSString * temMobileFina = @"/financeApp/";
static NSString * temMobileEmpty = @"";
/*收文列表*/
static NSString * queryRcvList = @"/oa/doc/rcv/queryRcvDealList";
static NSString * queryRcvBookList = @"/oa/doc/rcv/queryRcvList";
static NSString * queryRcvInfo = @"/oa/doc/rcv/queryRcvInfo";
static NSString * queryRcvDealInfo = @"/oa/doc/rcv/queryRcvDealInfo";
static NSString * querySealDealInfo = @"/oa/doc/sealApproval/queryObject";
static NSString * querySealLoanInfo = @"/oa/doc/sealLoan/queryObject";

/*发文列表*/
static NSString * queryList = @"/oa/doc/send/queryList";
static NSString * queryObject = @"/oa/doc/send/queryObject";

/*项目列表*/
static NSString * sendPQueryList = @"/oa/doc/common/sendPQueryList";
/*项目列表*/
static NSString * getProjects = @"/api/proOrg/getProOrgTree";

/*获取类型*/
static NSString * getEasyuiCombobox = @"/idmweb/category/getEasyuiCombobox";

/*获取组织树*/
static NSString * getEasyuiTree = @"/idmweb/org/getEasyuiTree";
static NSString * userEasyuiCombobox = @"/idmweb/user/getEasyuiCombobox";

/*获取项目单位*/
static NSString * queryRcvOrgList = @"/oa/doc/rcv/queryRcvOrgList";
static NSString * sendOrgQueryList = @"/oa/doc/common/sendOrgQueryList";

/*获取附件*/
static NSString * getFileListByBizPk = @"/oa/file/getFileListByBizPk";

/*获取办理意见*/
static NSString * getComments = @"/workflow/commonFlow/getComments";
static NSString * getForwardComments = @"/workflow/commonFlow/getForwardComments";
static NSString * getFlowPass = @"/api/workflow/commonFlow/pass";
static NSString * queryUserTask = @"/workflow/commonFlow/queryUserTask";

/*获取头像*/
static NSString * getImg = @"/idmweb/user/getImg";

/*下载文件*/
static NSString * download = @"/oa/doc/rcv/download";
static NSString * sendDownload = @"/oa/doc/send/download";
static NSString * fileDownload = @"/oa/file/download";
static NSString * fileDfsDownload = @"/oa/dfs/";

static NSString * commentsEnum = @"/api/processapprovalnew/formCommon/commentsEnum";

/*获取工具栏*/
static NSString * getFlowToolbar = @"/workflow/commonFlow/getFlowToolbar";

/*办理过程*/
static NSString * handleHis = @"/workflow/mobileFlow/queryHandleHis";
static NSString * workFlowPic = @"/workflow/commonFlow/queryWorkFlowPic";

/*通过*/
static NSString * pass = @"/apiworkflow/mobileFlow/pass";
//static NSString * pass = @"/api/caService/showPdf/instance/";
//static NSString * passCa = @"/api/caService/showPdf/instanceByCa/";
static NSString * rcvCompleteTask = @"/oa/doc/rcv/completeTask";
static NSString * sendCompleteTask = @"/oa/doc/send/completeTask";
static NSString * sealCompleteTask = @"/oa/doc/sealApproval/completeTask";

/*催办*/
static NSString * urge = @"/workflow/mobileFlow/urge";
static NSString * urgeCompleteTask = @"/oa/doc/send/urgeTask";

/*退回*/
static NSString * reject = @"/workflow/mobileFlow/reject";
static NSString * rcvRejectTask = @"/oa/doc/rcv/rejectTask";
static NSString * sendRejectTask = @"/oa/doc/send/rejectTask";
static NSString * sealRejectTask = @"/oa/doc/sealApproval/rejectTask";

/*撤回*/
static NSString * rcvRevokeTask = @"/oa/doc/rcv/revokeTask";
static NSString * sendRevokeTask = @"/oa/doc/send/revokeTask";
static NSString * sealRevokeTask = @"/oa/doc/sealApproval/revokeTask";

/*补签*/
static NSString * updateComment = @"/workflow/mobileFlow/updateComment";
static NSString * rcvUpdateComment = @"/oa/doc/rcv/updateComment";
static NSString * sendUpdateComment = @"/oa/doc/send/updateComment";
static NSString * sealUpdateComment = @"/oa/doc/sealApproval/updateComment";

/*代签*/
static NSString * replacePass = @"/workflow/mobileFlow/replacePass";
static NSString * rcvReplacePass = @"/oa/doc/rcv/replaceCompleteTask";
static NSString * sendReplacePass = @"/oa/doc/send/replaceCompleteTask";
static NSString * sealReplacePass = @"/oa/doc/sealApproval/replaceCompleteTask";

/*转办*/
static NSString * rcvTransferTask = @"/oa/doc/rcv/transferTask";
static NSString * sendTransferTask = @"/oa/doc/send/transferTask";
static NSString * transfer = @"/workflow/mobileFlow/transfer";
static NSString * sealTransferTask = @"/oa/doc/sealApproval/transferTask";

/*结果*/
static NSString * saveMemo = @"/oa/doc/rcv/saveMemo";

/*计量统计*/
static NSString * getAvaliableByUser = @"/tcmsQuery/compPayBizService/getAvaliableByUser";
static NSString * getAnalyData = @"/tcmsQuery/queryReportService/getAnalyData";
static NSString * getPrjData = @"/tcmsQuery/queryReportService/getPrjData";

/*计量审核*/
static NSString * getMidMeaListByCode = @"/tcmsQuery/compPayBizService/getMidMeaListByCode";
static NSString * getOtherListByCode = @"/tcmsQuery/compPayBizService/getOtherListByCode";
static NSString * getCompAffix = @"/tcmsQuery/compPayBizService/getCompAffix";
static NSString * getSupervisingCompAffix = @"/tcmsQuery/compPayBizService/getSupervisingCompAffix";
static NSString * getBussFlowListByCode = @"/tcmsQuery/compPayBizService/getBussFlowListByCode";
static NSString * getApprovalIdealByKey = @"/tcmsQuery/compPayBizService/getApprovalIdealByKey";

/*隧道、桩基、监理*/
static NSString * getInterReportBasic = @"/tcmsQuery/compPayBizService/getInterReportBasic";
static NSString * getSuperVisingPayCert = @"/tcmsQuery/compPayBizService/getSuperVisingPayCert";
static NSString * getSuperVising = @"/tcmsQuery/compPayBizService/getSuperVising";

static NSString * getFileContent = @"/tcmsQuery/downloadService/getFileContent";

/*中期支付*/
static NSString * getPayCertBill = @"/tcmsQuery/compPayBizService/getPayCertBill";
static NSString * getPayCert = @"/tcmsQuery/compPayBizService/getPayCert";

/*单位事务*/
static NSString *sealQueryList = @"/oa/doc/sealApproval/queryList";
static NSString *loanQueryList = @"/oa/doc/sealLoan/queryList";

/*单位事务保存*/
static NSString *saveSealApproval = @"/oa/doc/sealApproval/save";

/*印章外借保存*/
static NSString *saveSealLoan = @"/oa/doc/sealLoan/save";

/*获取外借印章类型*/
static NSString *querySealList = @"/oa/doc/sealLoan/querySealList";

static NSString * setPrjInfo = @"/api/login/setProjectInfo";

static NSString * scanQRCode = @"/api/login/scanQRCode?token=";

static NSString * signPhone = @"/api/finance/cms/conference/signPhone?id=";

static NSString * MENU_LINK_TYPE_PRO_ID = @"299801881675300864";

//考勤打卡
static int attendanceType = 2;
static NSString * kqUseSave = @"/api/workattendance/KqUse/save";
static NSString * selectByDay = @"/api/workattendance/KqUse/selectByDay";
static NSString * mouthUserStatis =  @"/api/workattendance/kqStatis/mouthUserStatisForZunQin";
static NSString * kqStatisDayUserStatis =  @"/api/workattendance/kqStatis/dayUserStatis";
static NSString * kqTimeDesignGetSingle = @"/api/workattendance/kqTimeDesign/getSingle";
static NSString * kqTimeDesignGetname = @"/api/workattendance/kqTimeDesign/getname";

/*文件操作*/
static NSString * searchFiles = @"/fs/files/search";
static NSString * deleteFile = @"/fs/files/delete";
static NSString * downloadFile = @"/fs/files/download";
static NSString * filesUpload = @"/fs/files/upload";
static NSString * filesUpload2 = @"/zuul/fs/files/upload";

/*影像资料文件上传*/
static NSString * yxzlFileUpload = @"/api/sjgc/ybgc/yxzl/upload";

static NSString * getUserByCode = @"/api/baseUser/getUserByCode";

static NSString * getPhoneVersion = @"/api/finance/baseInfo/getPhoneVersion";
static NSString * liveAdd = @"/api/videosrv/live/live/add";
static NSString * liveStart = @"/api/videosrv/live/live/start";
static NSString * liveEnd = @"/api/videosrv/live/live/end";
static NSString * validate = @"/api/login/validate";
static NSString * liveList = @"/api/videosrv/live/live/list?page=1&rows=999";
static NSString * recordStart = @"/api/videosrv/live/record/start";
static NSString * recordEnd = @"/api/videosrv/live/record/end";
static NSString * liveDelete = @"/api/videosrv/live/live/delete";
static NSString * personGet = @"/api/videosrv/person/get";

static NSString * getCategoryTreeByKey = @"/api/category/getCategoryTreeByKey";

/*中期支付*/
static NSString * getChildrenFilter = @"/meterage/reportPage/getChildrenFilter/2";

//计量支付
static NSString * getIntermediateProcess = @"/meterage/reportPage/getIntermediateProcess";
static NSString * selectPayByInfo = @"/meterage/metaphasePay/selectPayByInfo";
static NSString * mpSheetData = @"/meterage/metaphasePay/sheetData";

//中期支付报表 区分总包和工区
static NSString * getMeterageIntermediate = @"/meterage/intermediateNew/getMeterageIntermediate";

//监理计量支付
static NSString * getParamsForTask = @"/meterage/supervisorPayInfo/getParamsForTask";

/*获取质检资料待审核列表*/
static NSString * getQIApprovalList = @"/api/processapprovalnew/documentEnum/getApprovalList";
static NSString * submitQIApprovalList = @"/api/processapprovalnew/documentEnum/submitApprovalList";
static NSString * getApprovalDoneList = @"/api/processapprovalnew/documentEnum/getApprovalDoneList";
static NSString * getApprovalDoingList = @"/api/processapprovalnew/documentEnum/getApprovalDoingList";
static NSString * getApprovalListByParentCode = @"/api/processapprovalnew/documentEnum/getApprovalListByParentCode";

/*获取质检资料列表*/
static NSString * getQualityDatumList = @"/api/processapprovalnew/qualityDataTemp/getQualityDatumList";
static NSString * getQualityListFile = @"/api/processapprovalnew/qualityDataTemp/getQualityListFile";

/*监理违约处罚*/
static NSString * qualityRule = @"/api/quality/rule";
static NSString * qualityRecord = @"/api/quality/record";
static NSString * qualityRuleItem = @"/api/quality/rule/item";
static NSString * qualityRecordUser = @"/api/quality/record/user";
static NSString * qualityRecordRevokeTask = @"/api/quality/record/revokeTask";
static NSString * qualityRecordRejectTask = @"/api/quality/record/rejectTask";
static NSString * qualityRecordCompleteTask = @"/api/quality/record/completeTask";

/*质量检查*/
static NSString * getQualityProblemCount = @"/api/quality/problem/countByStatus";
static NSString * getQualityProblem = @"/api/quality/problem/getAllContentList";
static NSString * delQualityProblem = @"/api/quality/problem/delContent";
static NSString * saveQualityProblem = @"/api/quality/problem/saveContent";
static NSString * getQualityProblemSingle = @"/api/quality/problem/getSingleContent";
static NSString * commitQualityProblem = @"/api/quality/problem/commit";

static NSString * commitGreeProblem = @"/api/quality/greeProblem/commit";
static NSString * commitGreeWaterProblem = @"/api/quality/greeWaterProblem/commit";
static NSString * commitRisk = @"/api/quality/risk/commit";

static NSString * getGreeProblem = @"/api/quality/greeProblem/getAllContentList";
static NSString * getGreeWaterProblem = @"/api/quality/greeWaterProblem/getAllContentList";
static NSString * getRisk = @"/api/quality/risk/getAllContentList";

static NSString * delGreeProblem = @"/api/quality/greeProblem/delContent";
static NSString * delGreeWaterProblem = @"/api/quality/greeWaterProblem/delContent";
static NSString * delRisk = @"/api/quality/risk/delContent";


static NSString * saveGreeProblem = @"/api/quality/greeProblem/saveContent";
static NSString * saveGreeWaterProblem = @"/api/quality/greeWaterProblem/saveContent";
static NSString * saveRisk = @"/api/quality/risk/saveContent";

static NSString * greeProblemCount = @"/api/quality/greeProblem/countByStatus";
static NSString * greeWaterProblemCount = @"/api/quality/greeWaterProblem/countByStatus";
static NSString * riskCount = @"/api/quality/risk/countByStatus";

static NSString * qualityProblemCertReform = @"/api/quality/problemReply/certReform";
static NSString * qualityProblemRecheck = @"/api/quality/problemReply/recheck";
static NSString * qualityProblemSaveContent = @"/api/quality/problemReply/saveContent";
static NSString * qualityProblemContent = @"/api/quality/problemReply/getAllContentList";


static NSString * greeWaterReform = @"/api/quality/greeWaterProblemReply/certReform";
static NSString * greeWaterRecheck = @"/api/quality/greeWaterProblemReply/recheck";
static NSString * greeWaterSaveContent = @"/api/quality/greeWaterProblemReply/saveContent";
static NSString * greeWaterContent = @"/api/quality/greeWaterProblemReply/getAllContentList";


static NSString * greeReform = @"/api/quality/greeProblemReply/certReform";
static NSString * greeRecheck = @"/api/quality/greeProblemReply/recheck";
static NSString * greeSaveContent = @"/api/quality/greeProblemReply/saveContent";
static NSString * greeContent = @"/api/quality/greeProblemReply/getAllContentList";


static NSString * riskReform = @"/api/quality/riskReply/certReform";
static NSString * riskRecheck = @"/api/quality/riskReply/recheck";
static NSString * riskSaveContent = @"/api/quality/riskReply/saveContent";
static NSString * riskContent = @"/api/quality/riskReply/getAllContentList";


/*环境问题*/
static NSString * getGreenProblemCount = @"/greenactualize/problem/countByStatus";
static NSString * getGreenProblem = @"/greenactualize/problem/getAllContentList";
static NSString * delGreenProblem = @"/greenactualize/problem/delContent";
static NSString * saveGreenProblem = @"/greenactualize/problem/saveContent";
static NSString * getGreenProblemSingle = @"/greenactualize/problem/getSingleContent";
static NSString * commitGreenProblem = @"/greenactualize/problem/commit";
static NSString * greeProblemSingleContent = @"/api/quality/greeProblem/getSingleContent";


static NSString * greenProblemCertReform = @"/greenactualize/problemReply/certReform";
static NSString * greenProblemRecheck = @"/greenactualize/problemReply/recheck";
static NSString * greenProblemSaveContent = @"/greenactualize/problemReply/saveContent";
static NSString * greenProblemContent = @"/greenactualize/problemReply/getAllContentList";

/*安全隐患*/
static NSString * getSafetyDangerCount = @"/safety/danger/countByStatus";
static NSString * getSafetyDanger = @"/safety/danger/getAllContentList";
static NSString * delSafetyDanger = @"/safety/danger/delContent";
static NSString * saveSafetyDanger = @"/safety/danger/saveContent";
static NSString * getSafetyDangerSingle = @"/safety/danger/getSingleContent";
static NSString * commitSafetyDanger = @"/safety/danger/commit";

static NSString * safetyDangerCertReform = @"/safety/dangerReply/certReform";
static NSString * safetyDangerRecheck = @"/safety/dangerReply/recheck";
static NSString * safetyDangerSaveContent = @"/safety/dangerReply/saveContent";
static NSString * safetyDangerContent = @"/safety/dangerReply/getAllContentList";

//安全检查
static NSString * mySafetyCheckRecord = @"/mobileView/mySafetyCheckRecord";
static NSString * securityListMain = @"/api/quality/safecheck/recode/listMain";
static NSString * deleteMain = @"/api/quality/safecheck/recode/deleteMain";
static NSString * safetyCheckRecordMain = @"/mobileView/SafetyCheckRecordMain";
static NSString * safetRecodeListSd = @"/api/quality/safecheck/recode/listSd";
static NSString * safetRecodeList = @"/api/qualitycheck/safecheck/recode/list";
static NSString * safetRecodeDelete = @"/api/quality/safecheck/recode/delete";
static NSString * safetRecodeDeleteSd = @"/api/quality/safecheck/recode/deleteSd";
static NSString * safetyCheckRecord = @"/mobileView/safetyCheckRecord";
static NSString * schePlanForm = @"/mobileView/planForm";
static NSString * safetyCheckTunnel = @"/mobileView/safetyCheckTunnel";
static NSString * safecheckTableInfo = @"/api/quality/safecheck/notify/getTableInfo";
static NSString * developEntity = @"/api/develop/experiment/entity/";
static NSString * getTableExcelId = @"/api/quality/safecheck/notify/getTableExcelId";
static NSString * updateStatu = @"/api/quality/safecheck/notify/updateStatu";
static NSString * getInstBizByBizPk = @"/workflow/commonFlow/getInstBizByBizPk";
static NSString * fileInfoList = @"/api/quality/safecheck/fileInfo/list";
static NSString * delfileInfo = @"/api/quality/safecheck/fileInfo/delete";
static NSString * safetyCheckFileInfo = @"/mobileView/safetyCheckFileInfo";
static NSString * transferInfo = @"/api/quality/safecheck/notify/transferInfo";
static NSString * getListWithNotifyByCriteria2 = @"/api/quality/safecheck/replyOrAcceprt/getListWithNotifyByCriteria/2";
static NSString * getListWithNotifyByCriteria3 = @"/api/quality/safecheck/replyOrAcceprt/getListWithNotifyByCriteria/3";
static NSString * safetyCheckNotify =@"/mobileView/mySafetyCheckNotify";
static NSString * notiDeleteNofify = @"/api/quality/safecheck/notify/deleteNofify";
static NSString * safetyCheckReply = @"/mobileView/mySafetyCheckReply";
static NSString * safetyCheckAcceprt = @"/mobileView/safetyCheckAcceprt";
static NSString * saveNofifyRecode = @"/api/quality/safecheck/notify/saveNofifyRecode";

//旁站记录
static NSString *sideStationRecord = @"/api/jtother/recode/sideStationRecord/getList";
static NSString *deleteSideStationRecord = @"/api/jtother/recode/sideStationRecord/delete?id=";
//static NSString *saveSideStationRecord = @"/api/jtother/recode/sideStationRecord/save";
static NSString *saveSideStationRecord = @"/api/jtother/recode/sideStationRecord/saveWithPart";
static NSString *updateSideStationRecord = @"/api/jtother/recode/sideStationRecord/updateByInstId";
static  NSString *sideStationRecordCommitFlow = @"/api/jtother/recode/sideStationRecord/commitFlow";
static NSString *commonFlowPass =  @"/api/workflow/commonFlow/pass";

//巡视记录
static NSString *patrolInspectRecordGetList = @"/api/jtother/recode/patrolInspectRecord/getList";
static NSString *patrolInspectRecordDelete = @"/api/jtother/recode/patrolInspectRecord/delete?id=";
//static NSString *patrolInspectRecordSave = @"/api/jtother/recode/patrolInspectRecord/save";
static NSString *patrolInspectRecordSave = @"/api/jtother/recode/patrolInspectRecord/saveWithPart";
static NSString *patrolInspectRecordUpdate = @"/api/jtother/recode/patrolInspectRecord/updateByInstId";
static  NSString *patrolInspectRecordCommitFlow = @"/api/jtother/recode/patrolInspectRecord/commitFlow";

//施工监理日志
static NSString *logList = @"/api/quality/qualityOther/sgrz/list";
static NSString *logDel= @"/api/quality/qualityOther/sgrz/delete?id=";
static NSString *sgrzUsekey = @"/api/quality/qualityOther/sgrz/useKey";
static NSString *logUrl1 = @"/mobileView/constructionLog";
static NSString *logUrl2 = @"/mobileView/supervisionLog";
static NSString *jlrzList = @"/api/quality/qualityOther/jlrz/list";
static NSString *jlrzDelete = @"/api/quality/qualityOther/jlrz/delete?id=";
static NSString *jlrzUseKey = @"/api/quality/qualityOther/jlrz/useKey";
static NSString *updateStatuV2 = @"/api/quality/safecheck/notify/updateStatuV2";
static NSString *sgrzCreatProcess = @"/api/quality/qualityOther/sgrz/creatProcess";
static NSString *jlrzCreatProcess = @"/api/quality/qualityOther/jlrz/creatProcess";

static NSString *ybgcList = @"/api/quality/qualityOther/ybgc/list";
static NSString *ybgcSave = @"/api/quality/qualityOther/ybgc/save";
static NSString *ybgcDelete = @"/api/quality/qualityOther/ybgc/delete";

/*签章*/
static NSString *bjcaGenSign = @"/api/bjca/server/genSign";
/*生成过程信息*/
static NSString * genClientSignDigestInfo = @"/api/bjca/client/genClientSignDigestInfo";
/*生成摘要*/
static NSString * signDigest =  @"/api/bjca/client/signDigest";
/*生成签名*/
static NSString * clientSign = @"/api/bjca/client/clientSign";

//动态表单列表
static NSString * recordQueryUrl = @"/api/dftdstore/api/de/record/query?page=1&rows=1";
/*动态表单*/
static NSString * definitionExists = @"/api/dftdstore/api/de/definition/exists";
static NSString * entityTemplate = @"/api/develop/experiment/entity/template/%@";
static NSString * mergeTemplates = @"/api/develop/merge/templates";
static NSString * saveMappin = @"/api/processapprovalnew/qualityDatumNew/saveMappin";
static NSString * dynMobile = @"/dynMobileWh";
static NSString * dynRecordQuery = @"/api/dftdstore/api/de/record/query";
static NSString * dynRecordSave = @"/api/dftdstore/api/de/record/save/";
static NSString * dynDefinitionGet = @"/api/dftdstore/api/de/definition/get";
static NSString * dynDel = @"/api/dftdstore/api/de/record/delete";
static NSString * dynCategoryList = @"/api/dftdstore/api/de/record/list?entityName=DYN_RESOURCE_CATEGORY_INFO";
static NSString * showPdfView = @"/api/caservice/showPdf/view?fileSrc=/api/develop/odsToPdf/convert/";
static NSString * getPrjPartChildren = @"/api/prjPart/getChildren/";

/*待办事项*/
static NSString * newGetTodoList = @"/workflow/personalWork/getTodoList";
static NSString * getBizTypeList = @"/workflow/admin/bizType/getBizTypeList";
static NSString * getTodoStatistics = @"/workflow/personalWork/getTodoStatistics";

/*获取ID*/
static NSString * formGetPkId = @"/form/BaseInfo/getPkId";
static NSString * safetyGetPkId = @"/safety/BaseInfo/getPkId";
static NSString * getQualityProblemId = @"/api/quality/BaseInfo/getPkId";
static NSString * getProcessApprovalId = @"/processapprovalnew/BaseInfo/getPkId";
static NSString * getGreenId = @"/greenactualize/BaseInfo/getPkId";
static NSString * newGetPkId = @"/api/quality/base/getPkId";

/*质检评定*/
static NSString * inspectSummary = @"/processapprovalnew/inspectSummary/evalDetailExcel";
static NSString * inspectSummaryEvalDetailExcel = @"/processapprovalnew/inspectSummary/evalDetailExcel4Mobile";
static NSString * inspectSummaryList = @"/processapprovalnew/inspectSummary/getSummaryListHtml";
static NSString * inspectSummarySingleContent = @"/processapprovalnew/inspectyc/getSingleContent";

/*获取质检部位*/
static NSString * getApprovalPartTree = @"/processapprovalnew/BaseInfo/getApprovalPartTree";
/*原表*/
static NSString * getOriginalRecord = @"/processapprovalnew/detectionRecord/getSingleContent";
static NSString * saveOriginalRecord = @"/processapprovalnew/detectionRecord/saveContent";
static NSString * getApprovalInfoList = @"/processapprovalnew/approvalInfo/getAllContentList";
static NSString * getExcelTemplate = @"/processapprovalnew/excelModel/getExcelTemplate";
static NSString * getExcelJson = @"/processapprovalnew/excelJson/getJson";
static NSString * saveExcelJson = @"/processapprovalnew/excelJson/save";

/*获取质检资料影像资料列表*/
static NSString * getQIPhotoFilesList = @"/processapprovalnew/photoFiles/getAllContentList";
static NSString * saveQIPhotoFilesList = @"/processapprovalnew/photoFiles/saveContent";
static NSString * delQIPhotoFilesList = @"/processapprovalnew/photoFiles/delContent";

static NSString * materialSectionInfoQueryOne = @"/material/sectionInfo/queryOne";

/*文件操作*/
static NSString * zuulBatchUpload = @"/zuul/fs/files/batchUpload";

/*标段详情*/
static NSString * getSingleContentSectionInfo = @"/api/project/sectionInfo/getSingleContent";

/*获取工程部位*/
static NSString * getProjectListTree = @"/processapprovalnew/BaseInfo/getProjectListTree";
static NSString * getDiviTypeList = @"/processapprovalnew/qualityDatum/getTypeList";
static NSString * getPartNodeInfo = @"/processapprovalnew/qualityDatum/getPartNodeInfo";
static NSString * getQualityTree = @"/processapprovalnew/qualityDatum/getTree";

/*工艺工序过程填报*/
static NSString * constructRegisterContentList = @"/form/constructRegister/getAllContentList";
static NSString * delConstructRegisterContent = @"/form/constructRegister/mainDelContent";
static NSString * saveConstructRegisterContent = @"/form/constructRegister/mainSaveContent";
static NSString * constructRegisterModelChart = @"/form/constructRegister/getModelChart";
static NSString * constructRegisterSingleContent = @"/form/constructRegister/getSingleContent";
static NSString * saveConstructRegisterModelContent = @"/form/constructRegister/saveContent";
static NSString * getConstructRegisterModelList = @"/form/BaseInfo/getModelList";

static NSString * getCommentTemplateList = @"/api/workflow/admin/bizType/getCommentTemplateList?manage=0";

/*新版审核接口*/
static NSString * caServiceInstance = @"/api/caService/showPdf/instance/%@";
static NSString * caServiceInstanceDyn = @"/api/caService/showPdf/instanceDyn/%@";
static NSString * caServiceInstanceByCa = @"/api/caService/showPdf/instanceByCa/%@";
static NSString * odsToPdf = @"/api/develop/odsToPdf/change";
static NSString * saveTaskHttpInst = @"/api/schedule/task/http/saveTaskHttpInst";

#pragma mark - 新获取工程部位
static NSString * qualityDatumPartDoc = @"/api/fusion/qualityDatum/partDoc/%@";

/*现场进度填报*/
static NSString * getMea4mid = @"/processapprovalnew/meapay/mea4mid";

//获取枚举
static NSString * getCategoryList = @"/api/category/getCategoryList/key";

/*日志*/
static NSString * listTree = @"/api/quality/qualityOther/sgrz/listTree";
static NSString * getConstructionLogList = @"/processapprovalnew/zhConstructionLog/getAllContentList";
static NSString * getSupervisorLogList = @"/processapprovalnew/zhSupervisorLog/getAllContentList";
static NSString * getConstructionLogMobileData = @"/processapprovalnew/zhConstructionLog/getMobileData";
static NSString * getSupervisorLogMobileData = @"/processapprovalnew/zhSupervisorLog/getMobileData";
static NSString * saveConstructionLog = @"/processapprovalnew/zhConstructionLog/saveContent";
static NSString * saveSupervisorLog = @"/processapprovalnew/zhSupervisorLog/saveContent";
static NSString * getSingleConstructionLog = @"/processapprovalnew/zhConstructionLog/getSingleContent";
static NSString * getSingleSupervisorLog = @"/processapprovalnew/zhSupervisorLog/getSingleContent";
static NSString * getConstructionLogCount = @"/processapprovalnew/zhConstructionLog/getCount";
static NSString * getSupervisorLogCount = @"/processapprovalnew/zhSupervisorLog/getCount";
static NSString * savePersonsConstructionLog = @"/processapprovalnew/zhConstructionLog/savePersons";
static NSString * savePersonsSupervisorLog = @"/processapprovalnew/zhSupervisorLog/savePersons";

/*现场进度填报*/
static NSString * getLineScheduleList = @"/processapprovalnew/allLineSchedule/getProjectPartInfo";
static NSString * batchLineScheduleInsert = @"/processapprovalnew/allLineSchedule/batchInsert";

//报表
static NSString * getReportData = @"/reportApi/report/getReportData";
static NSString * reportGenerateKey = @"/reportApi/report/generateKey";
static NSString * reportDownload = @"/reportApi/report/download?fileId=";

static NSString * replyMsgNew = @"/mobileView/replyMsgNew";

//控制性日报
static NSString * saveReportMain = @"/api/progress/progressControlPart/saveReportMain";
static NSString * getReportMain =@"/api/progress/progressControlPart/getReportMain/";
static NSString * getReportMainListPagination =@"/api/progress/progressControlPart/getReportMainListPagination";
static NSString * deleteReportMain = @"/api/progress/progressControlPart/deleteReportMain/";

@interface UrlConfig : NSObject
    
+ (NSString *)URL:(NSString *)url;

+ (NSString *)login;

+ (NSString *)showImg;

+ (NSString *)MeteringURL:(NSString *)url;

+ (NSString *)MeteringLogin;

@end
