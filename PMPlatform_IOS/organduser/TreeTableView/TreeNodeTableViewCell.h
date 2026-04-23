//
//  TreeNodeTableViewCell.h
//  circlViewText
//
//  Created by 末末班车 on 2017/9/7.
//  Copyright © 2017年 atide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TreeNodeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;
@property (weak, nonatomic) IBOutlet UIImageView *nodeIMG;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *nodeName;

@end
