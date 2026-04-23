//
//  SelectRoomCallMembersViewController.m
//  ZIMExampleDemo
//
//  Created by 武耀琳 on 2022/11/7.
//

#import "SelectCallMembersViewController.h"
#import "SelectMembersTableViewCell.h"
#import "ZGZIMManager.h"
#import "KeyCenter.h"
@interface SelectCallMembersViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray<ZIMUserInfo *> *myUserList;

@property NSMutableArray *selectMemberList;

@end

@implementation SelectCallMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectMemberList = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
}

-(void)selectTheUserID:(nonnull NSString *)selectedUserID{
    
    [self.selectMemberList addObject:selectedUserID];
}

-(void)unSelectTheUserID:(nonnull NSString *)unSelectedUserID{
    [self.selectMemberList removeObject:unSelectedUserID];
}


-(void)addList:(NSArray<ZIMUserInfo *> *)userList{
    if(self.myUserList == nil){
        self.myUserList = [[NSMutableArray alloc] init];
    }
    [self.myUserList addObjectsFromArray:userList];
    [self.tableView reloadData];
    
}
- (IBAction)okButtonClicked:(id)sender {
    ZIMCallInviteConfig *config = [[ZIMCallInviteConfig alloc] init];
    config.timeout = 60;
    config.mode = ZIMCallInvitationModeGeneral;
    ZIMPushConfig *pushConfig = [[ZIMPushConfig alloc] init];
    pushConfig.resourcesID = KeyCenter.resourceID;
    pushConfig.title = [ZGZIMManager shared].myUserID;
    pushConfig.content = @"邀请你发起直播";
    pushConfig.payload = @"payload";
//    pushConfig.voIPConfig = [[ZIMVoIPConfig alloc] init];
//    pushConfig.voIPConfig.iOSVoIPHandleType = ZIMCXHandleTypeGeneric;
//    pushConfig.voIPConfig.iOSVoIPHandleValue = @"510";
//    pushConfig.voIPConfig.iOSVoIPHasVideo = YES;
    config.pushConfig = pushConfig;
    [[ZGZIMManager shared] callInviteWithInvitees:self.selectMemberList config:config callback:^(NSString * _Nonnull callID, ZIMCallInvitationSentInfo * _Nonnull info, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"tips" message:@"success" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            [alertView addAction:action];
            [self presentViewController:alertView animated:YES completion:nil];
            
        }
    }];
    
}
//MARK: - TableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myUserList.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SelectMembersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectRoomMembersTableViewCell"];

    NSString *userID = self.myUserList[indexPath.row].userID;
    cell.selectUserIDLabel.text = userID;
    cell.masterVC = self;
    cell.myUserID = userID;
    return cell;
}

@end
