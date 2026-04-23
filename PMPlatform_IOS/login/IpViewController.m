//
//  IpViewController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2024/8/9.
//  Copyright © 2024 com.atide. All rights reserved.
//

#import "IpViewController.h"
#import "FDScanViewController.h"
#import "UrlTableViewCell.h"

@interface IpViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *ipTF;
@property (weak, nonatomic) IBOutlet UIView *moveIpView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanRight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray <NSString *>*dataSource;
@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, strong) NSNumber *enableCaptcha;

@end

@implementation IpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:@"UrlTableViewCell" bundle:nil] forCellReuseIdentifier:@"UrlTableViewCell"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.baseUrl = [userDefaults objectForKey:@"baseUrl"];
    NSString *baseUrlCode = [userDefaults objectForKey:@"baseUrlCode"];
    if (baseUrlCode != nil) {
        self.ipTF.text = baseUrlCode;
    }
//    [self handleMoveIpView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    [self setStatusBarBackgroundColor:[UIColor hex:@"FFFFFF"]];
}

-(void)setStatusBarBackgroundColor:(UIColor *)color {
    if(@available(iOS 13.0, *)) {
        static UIView*statusBar =nil;
        if(!statusBar) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                statusBar = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;
                [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
                statusBar.backgroundColor= color;
            });
        }else{
            [[UIApplication sharedApplication].keyWindow bringSubviewToFront:statusBar];
            statusBar.backgroundColor= color;
        }
    }else{
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor= color;
        }
    }
}

- (void)handleMoveIpView {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray <NSString *>*strSet = [userDefaults objectForKey:@"urlSet"];
    if (strSet != nil && strSet.count > 0) {
        self.moveIpView.hidden = NO;
        self.scanRight.constant = 40;
    } else {
        self.moveIpView.hidden = YES;
        self.scanRight.constant = 0;
    }
}

- (NSArray<NSString *> *)dataSource {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray <NSString *>*strSet = [userDefaults objectForKey:@"urlSet"];
    if (strSet != nil && strSet.count > 0) {
        return [strSet copy];
    } else {
        return @[];
    }
}


#pragma mark - 点击事件
- (IBAction)moreIpClicked:(id)sender {
    [self.tableView reloadData];
    if (self.tableView.isHidden) {
        self.tableView.hidden = NO;
    } else {
        self.tableView.hidden = YES;
    }
}

- (IBAction)scan:(id)sender {
    __weak typeof(self) weakself = self;
    FDScanViewController *fdvc = [[FDScanViewController alloc] init];
    fdvc.scanResult = ^(NSString *result) {
        weakself.ipTF.text = result;
    };
    UINavigationController * nVC = [[UINavigationController alloc] initWithRootViewController:fdvc];
    [self presentViewController:nVC animated:YES completion:nil];
}

- (IBAction)sureClicked:(id)sender {
    NSString *text = self.ipTF.text;
    if ([text isEqualToString:@""]) {
        [MBManager showBriefAlert:@"服务器编码不能为空"];
    } else {
        NSString *url = @"http://220.165.247.91:32190/api/service/url/getByCode";
        __weak typeof(self) weakself = self;
        [MBManager showLoading];
        [[HttpManager manager] get:url param:@{ @"code": [text lowercaseString] } success:^(NSData *data) {
            [MBManager hideAlert];
            if ([ResponseUtils success:data]) {
                NSDictionary *resData = [[ResponseUtils getData:@"data"] mj_JSONObject];
                
                weakself.enableCaptcha = resData[@"enableCaptcha"];
                
                NSString *url = resData[@"url"];
                NSArray<NSString *> *temp = [url componentsSeparatedByString:@":"];
                if (temp.count == 2 || temp.count == 3) {
                    NSString *ip = [temp[1] stringByReplacingOccurrencesOfString:@"/" withString:@""];
                    NSString *part = @"";
                    if (temp.count == 3) {
                        part = [temp[2] stringByReplacingOccurrencesOfString:@"/" withString:@""];
                    }
                    weakself.baseUrl = url;
                    [weakself checkLoginBgFileByIp:ip byPart:part http:temp[0]];
                }
            } else {
                [MBManager showBriefAlert:[ResponseUtils getMsg]];
            }
        } faild:^(NSString *msg) {
            [MBManager hideAlert];
            [MBManager showBriefAlert:msg];
        }];
    }
}

- (void)checkLoginBgFileByIp:(NSString *)ip byPart:(NSString *)part http:(NSString *)http {
    NSString *baseUrl = self.baseUrl;
    NSString *baseUrlCode = self.ipTF.text;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray <NSString *>*strSet0 = [userDefaults objectForKey:@"urlSet"];
    NSMutableArray <NSString *>*strSet = [NSMutableArray array];
    if (strSet0 != nil) {
        [strSet addObjectsFromArray:strSet0];
    }
    BOOL haveUrl = NO;
    for (NSString *url in strSet) {
        if ([url isEqualToString:baseUrl]) {
            haveUrl = YES;
            break;
        }
    }
    if (!haveUrl) {
        [strSet appendObject:baseUrl];
    }

    [userDefaults setObject:baseUrl forKey:@"baseUrl"];
    [userDefaults setObject:baseUrlCode forKey:@"baseUrlCode"];
    [userDefaults setObject:self.enableCaptcha forKey:@"useCaptcha"];
    [userDefaults setObject:strSet forKey:@"urlSet"];
    [userDefaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
    
//    __weak typeof(self) weakself = self;
//    NSString *temp = @":";
//    if ([part isEqualToString:@""]) {
//        temp = @"";
//    }
//    NSString *url = [NSString stringWithFormat:@"%@://%@%@%@%@", http, ip, temp, part, loginBgUrl];
//    [MBManager showLoading];
//    [[HttpManager manager] downloadWithUrl:url params:@{} fileName:@"app.png" progress:^(NSProgress *downloadProgress) {
//
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
////        if (response == nil) {
////            [MBManager showBriefAlert:@"服务器验证失败，请确认服务器地址"];
////        } else {
//            [MBManager hideAlert];
//            NSString *baseUrl = weakself.ipTF.text;
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            NSArray <NSString *>*strSet0 = [userDefaults objectForKey:@"urlSet"];
//            NSMutableArray <NSString *>*strSet = [NSMutableArray array];
//            if (strSet0 != nil) {
//                [strSet addObjectsFromArray:strSet0];
//            }
//            BOOL haveUrl = NO;
//            for (NSString *url in strSet) {
//                if ([url isEqualToString:baseUrl]) {
//                    haveUrl = YES;
//                    break;
//                }
//            }
//            if (!haveUrl) {
//                [strSet appendObject:baseUrl];
//            }
//
//            [userDefaults setObject:baseUrl forKey:@"baseUrl"];
//            [userDefaults setObject:strSet forKey:@"urlSet"];
//            [userDefaults synchronize];
//            [weakself.navigationController popViewControllerAnimated:YES];
////        }
//    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UrlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UrlTableViewCell" forIndexPath:indexPath];
    NSString *url = self.dataSource[indexPath.row];
    cell.urlLabel.text = url;
    if (self.baseUrl && [url isEqualToString:self.baseUrl]) {
        [cell.checkIV setImage:[UIImage imageNamed:@"confirm_off"]];
    } else {
        [cell.checkIV setImage:nil];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *url = self.dataSource[indexPath.row];
    self.ipTF.text = url;
    self.baseUrl = url;
    self.tableView.hidden = YES;
}

@end
