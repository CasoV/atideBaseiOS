//
//  AnnexView.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/11.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "AnnexView.h"

@implementation AnnexView {
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UILabel *_dataLabel;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9.5, 41, 41)];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor hex:@"007AFF"];
        _dataLabel = [[UILabel alloc] init];
        _dataLabel.font = [UIFont systemFontOfSize:12];
        _dataLabel.textColor = [UIColor hex:@"6F7179"];
        _dataLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_imageView];
        [self addSubview:_titleLabel];
        [self addSubview:_dataLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 59, frame.size.width, 1)];
        line.backgroundColor = [UIColor hex:@"E6E6E6"];
        [self addSubview:line];
    }
    return self;
}
 
- (void)loadDataModel:(AnnexModel *)model {
    self.model = model;
    NSString *dataStr = [self transformFileSize:model.fileSize];
    _imageView.image = [self chooseDocImage:model.suffix];
    _titleLabel.text = model.originalName;
    _dataLabel.text = dataStr;
    
    CGSize size = [dataStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil].size;
    _dataLabel.frame = CGRectMake(self.frame.size.width - size.width - 15, 0, size.width + 5, 60);
    _titleLabel.frame = CGRectMake(61, 0, self.frame.size.width - 81 - size.width, 60);
}

- (UIImage *)chooseDocImage:(NSString *)str {
    if ([str isEqualToString:@"doc"] || [str isEqualToString:@"docx"]) {
        return [UIImage imageNamed:@"doc"];
    }
    if ([str isEqualToString:@"png"]) {
        return [UIImage imageNamed:@"png"];
    }
    if ([str isEqualToString:@"jpg"]) {
        return [UIImage imageNamed:@"jpg"];
    }
    if ([str isEqualToString:@"pdf"]) {
        return [UIImage imageNamed:@"pdf"];
    }
    return [UIImage imageNamed:@"none"];
}

- (NSString *)transformFileSize:(NSString *)filesize {
    CGFloat result = filesize.floatValue;
    
    if (result > 1024) {
        result /= 1024;
        if (result > 1024) {
            result /= 1024;
            if (result > 1024) {
                result /= 1024;
                return [NSString stringWithFormat:@"%.2fGB", result];
            } else {
                return [NSString stringWithFormat:@"%.2fMB", result];
            }
        } else {
            return [NSString stringWithFormat:@"%.2fKB", result];
        }
    } else {
        return [NSString stringWithFormat:@"%.2fB", result];
    }
}

@end
