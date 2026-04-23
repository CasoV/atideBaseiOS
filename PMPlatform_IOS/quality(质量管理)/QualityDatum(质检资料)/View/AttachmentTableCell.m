//
//  AttachmentTableCell.m
//  ycxm
//
//  Created by 高小伟 on 2020/7/20.
//  Copyright © 2020 末末班车. All rights reserved.
//
#import "AttachmentTableCell.h"

@interface AttachmentTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileTypeLabel;

@end

@implementation AttachmentTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)loadModel:(BIMFile *)model {
    if ([model.extName isEqualToString:@""]) {
        self.iconImageView.image = [UIImage imageNamed:@"ic_parttern_icon_folder"];
    } else {
        self.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_parttern_icon_%@", model.extName].lowercaseString];
    }
    self.fileNameLabel.text = model.filename;
    self.fileTypeLabel.text = [NSString stringWithFormat:@"文件类别:%@",model.extName];
}

@end
