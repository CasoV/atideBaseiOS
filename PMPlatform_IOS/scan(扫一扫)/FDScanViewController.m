//
//  FDScanViewController.m
//  YXConstructionApp
//
//  Created by 末末班车 on 2018/3/28.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "FDScanViewController.h"
#import "QRCodeReaderView.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
//#import <IMPortal/IMPortal.h>

#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define widthRate DeviceMaxWidth/320

@interface FDScanViewController ()<QRCodeReaderViewDelegate, AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) CIDetector *detector;

@property (copy, nonatomic) NSString *tempResult;


@end

@implementation FDScanViewController {
    QRCodeReaderView * readview;//二维码扫描对象
    
    BOOL isFirst;//第一次进入该页面
    BOOL isPush;//跳转到下一级页面
    BOOL isRestart;//跳转到下一级页面
    
    BOOL _isEnd;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    UIBarButtonItem * rbbItem = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStyleDone target:self action:@selector(alumbBtnEvent)];
    self.navigationItem.rightBarButtonItem = rbbItem;
    
    UIBarButtonItem * lbbItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonEvent)];
    self.navigationItem.leftBarButtonItem = lbbItem;
    
    isRestart = YES;
    isFirst = YES;
    isPush = NO;
    _isEnd = NO;
    
    [self InitScan];
}

- (void)dealloc {
}

#pragma mark - 返回
- (void)backButtonEvent
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark 初始化扫描
- (void)InitScan
{
    if (readview) {
        [readview removeFromSuperview];
        readview = nil;
    }
    
    readview = [[QRCodeReaderView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
    readview.is_AnmotionFinished = YES;
    readview.backgroundColor = [UIColor clearColor];
    readview.delegate = self;
    readview.alpha = 0;
    
    [self.view addSubview:readview];
    
    [UIView animateWithDuration:0.5 animations:^{
        self->readview.alpha = 1;
    }completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - 相册
- (void)alumbBtnEvent
{
    
    self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) { //判断设备是否支持相册
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    isPush = YES;
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes = [UIImagePickerController         availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    mediaUI.allowsEditing = NO;
    mediaUI.delegate = self;
    [self presentViewController:mediaUI animated:YES completion:nil];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    readview.is_Anmotion = YES;
    
    NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >=1) {
        
        [picker dismissViewControllerAnimated:YES completion:^{
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            //播放扫描二维码的声音
            SystemSoundID soundID;
            NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
            AudioServicesPlaySystemSound(soundID);
            
            [self accordingQcode:scannedResult];
        }];
    }
    else{
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该图片没有包含一个二维码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        [picker dismissViewControllerAnimated:YES completion:^{
            self->readview.is_Anmotion = NO;
            [self->readview start];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark -QRCodeReaderViewDelegate
- (void)readerScanResult:(NSString *)result
{
    readview.is_Anmotion = YES;
    [readview stop];
    
    //播放扫描二维码的声音
    SystemSoundID soundID;
    NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
    AudioServicesPlaySystemSound(soundID);
    
    [self accordingQcode:result];
    
    if (isRestart) {
        [self performSelector:@selector(reStartScan) withObject:nil afterDelay:1.5];
    }
    isRestart = YES;
}

-(void)meetingSignin:(NSString*)str {
    __weak typeof(self) weakSelf = self;
    [MBManager showLoading];
    [[HttpManager manager] post:[NSString stringWithFormat:@"%@%@",[UrlConfig URL:signPhone], str]  param:nil success:^(NSData *data) {
        [MBManager hideAlert];
        if ([ResponseUtils success:data]) {
            [self handleDissmiss:@"扫码签到成功！"];
        } else {
            [MBManager showBriefAlert:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:@"扫码登录失败！"];
    }];
}

#pragma mark - 扫描结果处理
- (void)accordingQcode:(NSString *)str {
    if ([str containsString:@"XZBG_FQHY"]) {
        self.tempResult = [str substringFromIndex:17];
        // 扫描签到
        __weak typeof(self) weakSelf = self;
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要扫码签到吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf meetingSignin:weakSelf.tempResult];
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertC animated:YES completion:nil];
        return;
    }
    
    if ([str containsString:@"http"] || [str containsString:@"appLookView"]) {
        if (self.scanResult) {
            self.scanResult(str);
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [MBManager showBriefAlert:str];
        }
        return;
    }
    
    NSArray <NSString *>*strArr = [str componentsSeparatedByString:@":"];
//    if ([strArr.firstObject containsString:@"loginId="]) {
        __weak typeof(self) weakSelf = self;
        [MBManager showLoading];
        [[HttpManager manager] get:[NSString stringWithFormat:@"%@%@",[UrlConfig URL:scanQRCode],str]  param:nil
                            success:^(NSData *data) {
            [MBManager hideAlert];
                                if ([ResponseUtils success:data]) {
                                    [self handleDissmiss];
                                } else {
                                    [MBManager showBriefAlert:[ResponseUtils getMsg]];
                                }
                            } faild:^(NSString *msg) {
                                [MBManager hideAlert];
                                [MBManager showBriefAlert:@"扫码登录失败！"];
                            }];
//    }
    
//   else if ([strArr.firstObject isEqualToString:@"approvalPartID"] && strArr.count >= 2) {
//        [SVProgressHUD showWithStatus:nil];
//        NSString *partid = strArr[1];
//        isRestart = NO;
//
//        __weak typeof(self) weakSelf = self;
//        [[HttpManager manager] post:[UrlConfig URL:selectPartBYQRCode] param:@{@"partid":partid} success:^(NSData *data) {
//            if ([ResponseUtils success:data]) {
//                if (!weakSelf.locationManager) {
//                    [weakSelf initCompleteBlock];
//                    [weakSelf configLocationManager];
//                }
//                NSArray <ApprovalPartModel *>*models = [ApprovalPartModel mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
//
//                if (models.count) {
//                    [UserAgent DefaultAgent].approvalPartModel = models.firstObject;
//                    //进行单次定位
//                    [weakSelf.locationManager requestLocationWithReGeocode:NO completionBlock:weakSelf.completionBlock];
//                } else {
//                    [SVProgressHUD showErrorWithStatus:@"未匹配到相应部位!"];
//                    [weakSelf reStartScan];
//                }
//            } else {
//                [SVProgressHUD showErrorWithStatus:@"无部位权限!"];
//                [weakSelf reStartScan];
//            }
//        } faild:^(NSString *msg) {
//            [SVProgressHUD showErrorWithStatus:msg];
//            [weakSelf reStartScan];
//        }];
//     if([str containsString:@"|"]&&[str containsString:@"infosec"]){
//        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_USER_NAME];
//        if([IMCert hasCertWithUsername:userName]){
//            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:
//                                          UIAlertControllerStyleAlert];
//            [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//                textField.placeholder = @"请输入PIN码";
//            }];
//            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//                //登录
//                [[CaLoginUtil alloc]loginByPin:[[alertVc textFields] objectAtIndex:0].text openId:^(NSString * _Nonnull openId) {
//                    IMUser *user = [IMUser userWithUserName:userName];
//                    NSArray <NSString *>*resultArr = [str componentsSeparatedByString:@"|"];
//                    [user scaveningLoginWithRandom:resultArr[1] time:resultArr[2] pin:[[alertVc textFields] objectAtIndex:0].text completionBlock:^(NSDictionary *dict) {
//                        if([dict[@"result"][@"resultcode"] isEqualToString:@"000000"]){
//                            [user isLoginWithRandom:resultArr[1] completionBlock:^(NSDictionary *dict1) {
//                                [SVProgressHUD showSuccessWithStatus:@"扫码登录成功！"];
//                                [self dismissViewControllerAnimated:YES completion:nil];
//                            }];
//                        }else{
//                            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"扫码登录失败！%@",dict[@"result"][@"resultcode"]]];
//                        }
//                    }];
//                }];
//
//            }];
//            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//            [alertVc addAction:action2];
//            [alertVc addAction:action1];
//            [self presentViewController:alertVc animated:YES completion:nil];
//        }else{
//            [SVProgressHUD showErrorWithStatus:@"未下载证书！"];
//        }
//    }else {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫描结果" message:str preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
}

- (void)reStartScan
{
    readview.is_Anmotion = NO;
    
    if (readview.is_AnmotionFinished) {
        [readview loopDrawLine];
    }
    
    [readview start];
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if (_isEnd) {
        [self dismissViewControllerAnimated:NO completion:nil];
        return;
    }
    
    self.title = @"扫一扫";
    if (isFirst || isPush) {
        if (readview) {
            [self reStartScan];
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (readview) {
        [readview stop];
        readview.is_Anmotion = YES;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (isFirst) {
        isFirst = NO;
    }
    if (isPush) {
        isPush = NO;
    }
}

//- (void)initCompleteBlock {
//    __weak typeof(self) weakSelf = self;
//    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
//        if (error) {
//            [SVProgressHUD showErrorWithStatus:@"定位失败!"];
//            [weakSelf reStartScan];
//            return;
//        }
//
//        if (location) {
//            UserAgent *user = [UserAgent DefaultAgent];
//            CGFloat gpsRanger = 0;
//            for (ProjectInfo *prjInfo in user.projectInfos) {
//                if ([prjInfo.id isEqualToString:user.approvalPartModel.PRJID]) {
//                    for (SectionInfo *secInfo in prjInfo.children) {
//                        if ([secInfo.sectionId isEqualToString:user.approvalPartModel.SECTION_ID]) {
//                            gpsRanger = secInfo.gpsRanger;
//                            break;
//                        }
//                    }
//                }
//            }
//
////            if (gpsRanger >= [weakSelf distanceBetweenOrderBy:user.approvalPartModel.Y_POINT :location.coordinate.latitude :user.approvalPartModel.X_POINT :location.coordinate.longitude]) {
////                [SVProgressHUD dismiss];
////                [weakSelf showPopView];
////            } else {
////                [SVProgressHUD showErrorWithStatus:@"未在指定范围内!"];
////                [weakSelf reStartScan];
////            }
//        } else {
//            [SVProgressHUD showErrorWithStatus:@"定位失败!"];
//            [weakSelf reStartScan];
//        }
//    };
//}
//
//- (void)configLocationManager {
//    self.locationManager = [[AMapLocationManager alloc] init];
//
//    [self.locationManager setDelegate:self];
//
//    //设置期望定位精度
//    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
//}
//
//- (double)distanceBetweenOrderBy:(double) lat1 :(double) lat2 :(double) lng1 :(double) lng2{
//
//    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
//
//    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
//
//    double  distance  = [curLocation distanceFromLocation:otherLocation];
//
//    return  distance;
//
//}
//
//- (void)showPopView {
//    __weak typeof(self) weakSelf = self;
//    SiteFuncPopView *popView = [[SiteFuncPopView alloc] initWithPart:[UserAgent DefaultAgent].approvalPartModel];
//    popView.block = ^(NSString * _Nonnull funcStr) {
//        if (funcStr) {
//            if ([funcStr isEqualToString:@"填报质检资料"]) {
//                self->_isEnd = YES;
//                QDTab1Controller *vc = [[QDTab1Controller alloc] initWithNibName:@"QDTab1Controller" bundle:nil];
//                vc.isFromScan = YES;
//                [weakSelf.navigationController pushViewController:vc animated:YES];
//            } else if ([funcStr isEqualToString:@"工艺（隐蔽）工序"]) {
//                self->_isEnd = YES;
//                ApprovalPartModel *model = [UserAgent DefaultAgent].approvalPartModel;
//                UseCoorBaseListController *vc = [[UseCoorBaseListController alloc] initWithNibName:@"UseCoorBaseListController" bundle:nil];
//                vc.type = FunctionTypeProcessTracking;
//                vc.sectionId = model.SECTION_ID;
//                vc.projectId = model.PRJID;
//                vc.partCode = model.CODE_;
//                vc.partName = model.NAME_;
//
//                [weakSelf.navigationController pushViewController:vc animated:YES];
//            } else {
//
//            }
//        } else {
//            [weakSelf reStartScan];
//        }
//    };
//    [popView show];
//}

- (void)handleDissmiss {
    [MBManager showBriefAlert:@"扫码登录成功!"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)handleDissmiss:(NSString *)msg {
    [MBManager showBriefAlert:msg];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
