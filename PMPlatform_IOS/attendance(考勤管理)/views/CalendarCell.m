//
//  CalendarCell.m
//  ycxm
//
//  Created by 高小伟 on 2020/6/11.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "CalendarCell.h"
#import "UIColor+hex.h"


@implementation CalendarCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGFloat width = self.contentView.frame.size.width*0.6;
        CGFloat height = self.contentView.frame.size.height*0.6;
        CGFloat tagSize = 5;
        
        
        UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width*0.5-width*0.5,  self.contentView.frame.size.height*0.5-height*0.5, width, height)];
        image1.layer.cornerRadius = height * 0.5;
          [self.contentView addSubview:image1];
        
        UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width*0.5-width*0.5,  self.contentView.frame.size.height*0.5-height*0.5 + height/2, width, height/2)];
//         [self.contentView addSubview:image2];
        
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake( self.contentView.frame.size.width*0.5-width*0.5,  self.contentView.frame.size.height*0.5-height*0.5, width, height )];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.layer.masksToBounds = YES;
        dayLabel.layer.cornerRadius = height * 0.5;
        dayLabel.backgroundColor = [UIColor clearColor];
        dayLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:dayLabel];
        
        UIView *tagView = [[UIView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width*0.5-width*0.5 + width/2 - tagSize/2,  self.contentView.frame.size.height*0.5-height*0.5 + height - tagSize, tagSize, tagSize)];
        tagView.layer.masksToBounds = YES;
        tagView.layer.cornerRadius = tagSize * 0.5;
        tagView.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:tagView];

        self.dayLabel = dayLabel;
        self.image1 = image1;
        self.image2 = image2;
        self.tagView = tagView;
   
    }
    return self;
}

- (void)setMonthModel:(MonthModel *)monthModel{
    _monthModel = monthModel;
    self.dayLabel.text = [NSString stringWithFormat:@"%02ld",monthModel.dayValue];
    
//    if (monthModel.isSelectedDay) {
//        self.dayLabel.backgroundColor = [UIColor lightGrayColor];
//    } else {
//        self.dayLabel.backgroundColor = [UIColor clearColor];
//    }
    
    self.tagView.hidden = !monthModel.isSelectedDay;
    self.image1.backgroundColor = [UIColor whiteColor];
    if (monthModel.isWorkDay){
        self.dayLabel.textColor = [UIColor whiteColor];
        
        if([monthModel.standard1 isEqualToString:@"0"]){
            self.image1.backgroundColor = [UIColor hex:@"FF6A42"];
        }else if([monthModel.standard1 isEqualToString:@"1"]){
            self.image1.backgroundColor = [UIColor hex:@"3AC674"];
        }else if([monthModel.standard1 isEqualToString:@"2"]){
            self.image1.backgroundColor = [UIColor hex:@"78A3EC"];
        }
    }else{
        self.dayLabel.textColor = [UIColor blackColor];
//        self.image1.image = nil;
//        self.image2.image = nil;
    }
}
@end
