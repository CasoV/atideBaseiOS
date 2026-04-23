//
//  FileScanViewCell.m
//  ConstructionApp
//
//  Created by 末末班车 on 2017/12/25.
//  Copyright © 2017年 atide. All rights reserved.
//

#import "FileScanViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FileScanViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;
@property (weak, nonatomic) IBOutlet UIImageView *videoPlayImage;

@property (nonatomic, strong) BIMFile *model;

@end

@implementation FileScanViewCell {
    BOOL _isAddCell;
}

- (void)loadDataModel:(BIMFile *)model isImage:(BOOL)isImage {
    _model = model;
    self.videoPlayImage.hidden = YES;
    if ([model.contentType isEqualToString:@"add"]) {
        self.titleLabel.text = @"";
        self.titleHeight.constant = 0;
        self.imageView.image = [UIImage imageNamed:@"AlbumAddBtn"];
        self.deleteBtn.hidden = YES;
    } else {
        self.deleteBtn.hidden = NO;
        if (isImage) {
            if ([_model.contentType isEqualToString:@"video/mp4"]) {
                self.videoPlayImage.hidden = NO;
                if (_model.image) {
                    self.titleLabel.text = @"";
                    self.titleHeight.constant = 0;
                    self.imageView.image = _model.image;
                } else {
                    self.titleLabel.text = _model.filename;
                    self.titleHeight.constant = 10;
                    self.imageView.image = [UIImage imageNamed:@"ic_parttern_icon_mp4"];
                }
            } else {
                self.titleLabel.text = @"";
                self.titleHeight.constant = 0;
                if ([_model.id isEqualToString:@""]) {
                    self.imageView.image = _model.image;
                } else {
                    if ([_model isDownload]) {
                        [self setImageWithFile:_model];
                    } else {
                        __weak typeof(self) weakSelf = self;
                        [[HttpManager manager] downloadWithFileid:_model.id fileName:_model.filename progress:nil completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                            [weakSelf setImageWithFile:weakSelf.model];
                        }];
                    }
                }
            }
        } else {
            self.titleLabel.text = _model.filename;
            self.titleHeight.constant = 10;
            self.imageView.image = [UIImage imageNamed:@"ic_parttern_icon_nofind"];
        }
    }
}

- (void)loadDataModel:(BIMFile *)model {
    _model = model;
    self.videoPlayImage.hidden = YES;
    if ([model.contentType isEqualToString:@"add"]) {
        self.titleLabel.text = @"";
        self.titleHeight.constant = 0;
        self.imageView.image = [UIImage imageNamed:@"AlbumAddBtn"];
        self.deleteBtn.hidden = YES;
    } else {
        self.deleteBtn.hidden = NO;
        if (_model.isImageOrVideo) {
            if ([_model.contentType isEqualToString:@"video/mp4"] || [_model.contentType isEqualToString:@"video/quicktime"]) {
                self.videoPlayImage.hidden = NO;
                if (_model.image) {
                    self.titleLabel.text = @"";
                    self.titleHeight.constant = 0;
                    self.imageView.image = _model.image;
                } else {
                    self.titleLabel.text = _model.filename;
                    self.titleHeight.constant = 10;
                    self.imageView.image = [UIImage imageNamed:@"ic_parttern_icon_mp4"];
                }
            } else {
                self.titleLabel.text = @"";
                self.titleHeight.constant = 0;
                if ([_model.id isEqualToString:@""]) {
                    self.imageView.image = _model.image;
                } else {
                    if ([_model isDownload]) {
                        [self setImageWithFile:_model];
                    } else {
                        self.imageView.image = [UIImage imageNamed:@"ic_parttern_icon_jpeg"];
                        _model.image = self.imageView.image;
                        __weak typeof(self) weakSelf = self;
                        [[HttpManager manager] downloadWithFileid:_model.id fileName:_model.filename progress:nil completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                            [weakSelf setImageWithFile:weakSelf.model];
                        }];
                    }
                }
            }
        } else {
            self.titleLabel.text = _model.filename;
            self.titleHeight.constant = 10;
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_parttern_icon_%@", _model.extName]];
            self.imageView.image = image ? image : [UIImage imageNamed:@"ic_parttern_icon_nofind"];
        }
    }
}

- (IBAction)deleteClicked:(id)sender {
    if (self.block) {
        self.block(_model);
    }
}

- (void)setImageWithFile:(BIMFile *)file {
    if ([file isDownload]) {
        NSString *fileStr = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), file.filePath];
        UIImage *image = [UIImage imageWithContentsOfFile:fileStr];
        if (!image) {
            image = [UIImage imageNamed:@"image_damage"];
        }
        self.imageView.image = image;
        file.image = self.imageView.image;
        NSData *data = [NSData dataWithContentsOfFile:fileStr];
        
        CIImage *testImage = [CIImage imageWithData:data];
        NSDictionary *propDict = [testImage properties];
        NSDictionary *GPSDic =[propDict objectForKey:(NSString*)kCGImagePropertyGPSDictionary];
        NSDictionary *ExifDic =[propDict objectForKey:(NSString*)kCGImagePropertyExifDictionary];

        file.latitude = [GPSDic objectForKey:(NSString*)kCGImagePropertyGPSLatitude];
        file.longitude = [GPSDic objectForKey:(NSString*)kCGImagePropertyGPSLongitude];
        file.dateTimeOriginal = [ExifDic objectForKey:(NSString*)kCGImagePropertyExifDateTimeOriginal];
    }
}

- (void)hiddenDeleteBtn {
    self.deleteBtn.hidden = YES;
}

@end
