//
//  SelectRoomMembersTableViewCell.m
//  ZIMExampleDemo
//
//  Created by 武耀琳 on 2022/11/7.
//

#import "SelectMembersTableViewCell.h"

@implementation SelectMembersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)selectMemberButtonClicked:(UIButton *)sender {
    if(sender.isSelected == NO){
        if([self.myUserID isEqual:[ZGZIMManager shared].myUserID]){
            return;
        }
        [sender setImage:[UIImage imageNamed:@"tongzhi"] forState:UIControlStateNormal];
        
        [self.masterVC selectTheUserID:self.myUserID];
        sender.selected = YES;
    }else{
        [sender setImage:[UIImage imageNamed:@"xingzhuang-tuoyuanxing"] forState:UIControlStateNormal];
        [self.masterVC unSelectTheUserID:self.myUserID];
        sender.selected = NO;
    }
    
}
@end
