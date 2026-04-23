//
//  CreateCallTableViewCell.m
//  ZIMExampleDemo
//
//  Created by 武耀琳 on 2023/5/21.
//

#import "CreateCallTableViewCell.h"

@implementation CreateCallTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.deleteButton setTitle:NSLocalizedString(@"delete", nil) forState:UIControlStateNormal];
    // Configure the view for the selected state
}
- (IBAction)deleteButtonClicked:(id)sender {
    [_vc.createCallModel   deleteMemberList:self.userNameLabel.text];
}



@end
