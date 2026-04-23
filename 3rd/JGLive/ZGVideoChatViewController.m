//
//  ZGVideoChatViewController.m
//  ZegoExpressExample
//
//  Created by 王鑫 on 2021/11/29.
//  Copyright © 2021 Zego. All rights reserved.
//

#import "ZGVideoChatViewController.h"
#import "KeyCenter.h"
#import <ZegoExpressEngine/ZegoExpressEngine.h>
#import "AppDelegate.h"
#import "UIInterface+HXRotation.h"
@interface ZGVideoChatViewController () <ZegoEventHandler>{
    UIInterfaceOrientationMask currentVCInterfaceOrientationMask;
}
@property (weak, nonatomic) IBOutlet UIButton *camChangeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fxChangeBtn;

@property (strong, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIView *playView;
@property (nonatomic, copy) NSString *playStreamID;
@property (nonatomic) ZegoPublisherState publisherState;
@property (nonatomic) ZegoPlayerState playerState;
@property(nonatomic,assign) Boolean enable;
@property(nonatomic,assign) Boolean isCross;
@end

@implementation ZGVideoChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.navTitle;
    self.enable = NO;
    self.isCross = NO;
    currentVCInterfaceOrientationMask = UIInterfaceOrientationMaskAllButUpsideDown;
    
    [self createEngineAndLogin];
    [self setupUI];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 实现系统转屏的相关方法即可

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return currentVCInterfaceOrientationMask;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    BOOL isLaunchScreen = NO;
    if (@available(iOS 16.0, *)) {
        // iOS16 需要使用 UIWindowScene 来区分横竖屏
        NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
        UIWindowScene *scene = [array firstObject];
        isLaunchScreen = scene.interfaceOrientation == UIInterfaceOrientationLandscapeRight;
    } else {
        // 这里是 UIDeviceOrientationLandscapeLeft（我们需要 Home 按键在右边）
        // UIDeviceOrientationLandscapeLeft,       // Device oriented horizontally, home button on the right
        isLaunchScreen = [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft;
    }

    [self p_updateViewWithIsLaunchScreen:isLaunchScreen size:size];
}

- (void)p_updateViewWithIsLaunchScreen:(BOOL)isLaunchScreen size:(CGSize)size {

    if (isLaunchScreen) {
        // 横屏
        [self.playView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    } else {
        // 竖屏
        [self.playView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.left.right.equalTo(self.view);
            make.height.mas_equalTo(150);
        }];
    }
}


- (void)createEngineAndLogin {
    // Create ZegoExpressEngine and set self as delegate (ZegoEventHandler)
    ZegoEngineProfile *profile = [[ZegoEngineProfile alloc] init];
    profile.appID = [KeyCenter appID];
    profile.appSign = [KeyCenter appSign];
    
    // Here we use the high quality video call scenario as an example,
    // you should choose the appropriate scenario according to your actual situation,
    // for the differences between scenarios and how to choose a suitable scenario,
    // please refer to https://docs.zegocloud.com/article/14940
    profile.scenario = ZegoScenarioHighQualityVideoCall;
    
    [ZegoExpressEngine createEngineWithProfile:profile eventHandler:self];

  
    [[ZegoExpressEngine sharedEngine] loginRoom:self.roomID user:[ZegoUser userWithUserID:self.userID]];
}
- (IBAction)cameraChange:(id)sender {
    self.enable = !self.enable;
    [[ZegoExpressEngine sharedEngine] useFrontCamera:self.enable];
}
- (IBAction)fxchange:(id)sender {
    self.isCross = !self.isCross;

    
    [self screenChange:self.isCross];

//    [self setNeedsUpdateOfSupportedInterfaceOrientations];
 
}

-(void)screenChange:(Boolean)isLand{
    
    if(isLand){
        currentVCInterfaceOrientationMask = UIInterfaceOrientationMaskAllButUpsideDown;

        [self hx_rotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }else{
        
        currentVCInterfaceOrientationMask = UIInterfaceOrientationMaskAllButUpsideDown;

        [self hx_rotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
    }
    [self orientationChanged];
}


- (void)orientationChanged {


    ZegoVideoConfig *videoConfig = [[ZegoExpressEngine sharedEngine] getVideoConfig];
    UIInterfaceOrientation orientation = UIInterfaceOrientationUnknown;
    if(self.isCross){
        orientation = UIInterfaceOrientationLandscapeRight;
        videoConfig.encodeResolution = CGSizeMake(640, 360);
    }else{
        orientation = UIInterfaceOrientationPortrait;
        videoConfig.encodeResolution = CGSizeMake(360, 640);
    }
//    switch (device.orientation) {
//        // Note that UIInterfaceOrientationLandscapeLeft is equal to UIDeviceOrientationLandscapeRight (and vice versa).
//        // This is because rotating the device to the left requires rotating the content to the right.
//        case UIDeviceOrientationLandscapeLeft:
//            orientation = UIInterfaceOrientationLandscapeRight;
//            videoConfig.encodeResolution = CGSizeMake(640, 360);
//            break;
//        case UIDeviceOrientationLandscapeRight:
//            orientation = UIInterfaceOrientationLandscapeLeft;
//            videoConfig.encodeResolution = CGSizeMake(640, 360);
//            break;
//        case UIDeviceOrientationPortrait:
//           
//            break;
//        case UIDeviceOrientationPortraitUpsideDown:
//            orientation = UIInterfaceOrientationPortraitUpsideDown;
//            videoConfig.encodeResolution = CGSizeMake(360, 640);
//            break;
//        default:
//            // Unknown / FaceUp / FaceDown
//            break;
//    }

    [[ZegoExpressEngine sharedEngine] setVideoConfig:videoConfig];
    [[ZegoExpressEngine sharedEngine] setAppOrientation:orientation];
}


- (void)setupUI {

    self.playView.hidden = YES;
    if(_isGz){
        self.camChangeBtn.hidden = true;
        self.fxChangeBtn.hidden = true;
    }
}

- (void)startLive {
    // Start preview
    ZegoCanvas *previewCavas = [ZegoCanvas canvasWithView:self.isGz?self.playView:self.previewView];
  
    [[ZegoExpressEngine sharedEngine] startPreview:previewCavas];
    
    // Start publishing


    [[ZegoExpressEngine sharedEngine] startPublishingStream:self.publishStreamID];

    [[ZegoExpressEngine sharedEngine] useFrontCamera:self.enable];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    [self screenChange:NO];
}
- (IBAction)stopButnClicked:(id)sender {
    // When you return to the previous level view, you will stopPreview, stopPublishingStream, stopPlayingStream, logoutRoom, and destroyEngine in dealloc
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Others

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



#pragma mark - ZegoEventHandler

#pragma mark - Room
- (void)onRoomStateChanged:(ZegoRoomStateChangedReason)reason errorCode:(int)errorCode extendedData:(NSDictionary *)extendedData roomID:(NSString *)roomID {
    if (errorCode != 0) {
       
    }
    if(reason == ZegoRoomStateChangedReasonLogined)
    {
        [self startLive];
    }
}

- (void)onRoomStreamUpdate:(ZegoUpdateType)updateType streamList:(NSArray<ZegoStream *> *)streamList extendedData:(NSDictionary *)extendedData roomID:(NSString *)roomID {
    if (updateType == ZegoUpdateTypeAdd) {
        // When the updateType is Add, stop playing current stream(if exist) and start playing new stream.
        if (self.playerState != ZegoPlayerStateNoPlay) {
            [[ZegoExpressEngine sharedEngine] stopPlayingStream:self.playStreamID];
            self.playStreamID = nil;
        }
        
        // No processing, just play the first stream
        ZegoStream *stream = streamList.firstObject;
        self.playStreamID = stream.streamID;
 
        ZegoCanvas *playCanvas = [ZegoCanvas canvasWithView:_isGz?self.previewView:self.playView];
        [[ZegoExpressEngine sharedEngine] startPlayingStream:self.playStreamID canvas:playCanvas];
        
    }else if (updateType == ZegoUpdateTypeDelete) {
        [SVProgressHUD showInfoWithStatus:@"对方结束了通话!"];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        // When the updateType is Delete, if the stream is being played, stop playing the stream.
        if (self.playerState == ZegoPlayerStateNoPlay) {
            return;
        }
        for (ZegoStream *stream in streamList) {
            if ([self.playStreamID isEqualToString:stream.streamID]) {
                [[ZegoExpressEngine sharedEngine] stopPlayingStream:self.playStreamID];
                self.playStreamID = nil;
            }
        }
    }
}


#pragma mark - Publish
// The callback triggered when the state of stream publishing changes.
- (void)onPublisherStateUpdate:(ZegoPublisherState)state errorCode:(int)errorCode extendedData:(NSDictionary *)extendedData streamID:(NSString *)streamID {
    // If the state is PUBLISHER_STATE_NO_PUBLISH and the errcode is not 0, it means that stream publishing has failed
    // and no more retry will be attempted by the engine. At this point, the failure of stream publishing can be indicated
    // on the UI of the App.
    self.publisherState = state;
   
}

#pragma mark - Play
// The callback triggered when the state of stream playing changes.
- (void)onPlayerStateUpdate:(ZegoPlayerState)state errorCode:(int)errorCode extendedData:(NSDictionary *)extendedData streamID:(NSString *)streamID {
    // If the state is ZegoPlayerStateNoPlay and the errcode is not 0, it means that stream playing has failed and
    // no more retry will be attempted by the engine. At this point, the failure of stream playing can be indicated
    // on the UI of the App.
    self.playerState = state;
  
    if (state == ZegoPlayerStatePlaying) {
//        self.playView.hidden = NO;
        self.playView.hidden = YES;
    } else {
        self.playView.hidden = YES;
    }
}

#pragma mark - Exit

- (void)dealloc {
    // Can destroy the engine when you don't need audio and video calls
    [ZegoExpressEngine destroyEngine:nil];
}

@end
