//
//  MeaMidListCell.m
//  ycxm
//
//  Created by 末末班车 on 2019/2/26.
//  Copyright © 2019 末末班车. All rights reserved.
//

#import "MeaMidListCell.h"

@interface MeaMidListCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UILabel *label6;

@end

@implementation MeaMidListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tf.delegate = self;
    [self.tf addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setModel:(MeaMidListModel *)model {
    _model = model;
    
    self.label1.text = model.NAME;
    self.label2.text = model.UNIT;
    self.label3.text = model.UNIT_PRICE;
    self.label4.text = model.AMOUNT;
    self.tf.text = model.REALAMOUNT;
    self.label6.text = [NSString stringWithFormat:@"%.02f", model.UNIT_PRICE.floatValue * model.REALAMOUNT.floatValue];
}
- (void)textFieldValueChanged:(UITextField *)sender {
    self.model.REALAMOUNT = sender.text;
    self.label6.text = [NSString stringWithFormat:@"%.02f", self.model.UNIT_PRICE.floatValue * sender.text.floatValue];
    
    if (self.callBack) {
        self.callBack();
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"."]) {
        if ([textField.text containsString:@"."]) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return YES;
    }
}

@end
