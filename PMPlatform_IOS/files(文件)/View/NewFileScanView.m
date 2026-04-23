//
//  NewFileScanView.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/6/6.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "NewFileScanView.h"
#import "DBManager.h"
#import "PYPhotoBrowser.h"
#import "ApiFilesSearch.h"
#import "ApiFilesDelete.h"
#import "FileScanViewCell.h"
#import "JZLocationConverter.h"
#import "OpenDocumentationController.h"
#import <TZImagePickerController/TZImagePickerController.h>

#define CompressionVideoPath [NSHomeDirectory() stringByAppendingFormat:@"/Documents/CompressionVideoField"]

@interface NewFileScanView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation NewFileScanView {
    FileScanType _type;
    CGFloat _height;
    
    ApiFilesSearch *_search;
    ApiFilesDelete *_delete;
    
    UIViewController *_vc;
    
    BOOL _isSelectOriginalPhoto;
}

- (instancetype)initWithFrame:(CGRect)frame type:(FileScanType)type {
    if (self = [super initWithFrame:frame]) {
        _type = type;
        _height = frame.size.height;
        _isHandle = YES;
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame type:(FileScanType)type isHandle:(BOOL)isHandle {
    if (self = [super initWithFrame:frame]) {
        _type = type;
        _height = frame.size.height;
        _isHandle = isHandle;
        [self setupUI];
    }
    return self;
}

- (void)dealloc {
    [_search stop];
    [_delete stop];
}

- (void)setupUI {
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
}

- (void)setDefault {
    BIMFile *add = [[BIMFile alloc] init];
    add.contentType = @"add";
    [self.dataSource addObject:add];
    [self.collectionView reloadData];
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = CGSizeMake(65, 65);
        layout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0) collectionViewLayout:layout];
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"FileScanViewCell" bundle:nil] forCellWithReuseIdentifier:@"FileScanViewCell"];
    }
    return _collectionView;
}

- (NSMutableArray<BIMFile *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)updateData {
    if (!self.markId) {
        return;
    }
    
    if (_search) {
        [_search stop];
    }
    
    __weak typeof(self) weakSelf = self;
    _search = [[ApiFilesSearch alloc] initWithFormId:self.markId];
    [_search startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray <BIMFile *>*tempArr = [BIMFile mj_objectArrayWithKeyValuesArray:[request responseData]];
        [weakSelf.dataSource removeAllObjects];
        for (BIMFile *file in tempArr) {
            if ([file.contentType isEqualToString:@"image/jpeg"] || [file.contentType isEqualToString:@"image/png"] || [file.contentType isEqualToString:@"video/mp4"]) {
                if (self->_type == FileScanTypeImage) {
                    [weakSelf.dataSource addObject:file];
                }
            } else {
                if (self->_type == FileScanTypeAnnex) {
                    [weakSelf.dataSource addObject:file];
                }
            }
        }
        [weakSelf handleData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf.dataSource removeAllObjects];
        [weakSelf handleData];
    }];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    FileScanViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FileScanViewCell" forIndexPath:indexPath];
    [cell loadDataModel:self.dataSource[indexPath.row] isImage:_type == FileScanTypeImage];
    if (!_isHandle) {
        [cell hiddenDeleteBtn];
    }
    cell.block = ^(BIMFile *file) {
        if ([file.id isEqualToString:@""]) {
            [weakSelf deleteFileModel:file];
        } else {
            [weakSelf deleteFile:file];
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_isHandle) {
        if (indexPath.row == self.dataSource.count - 1) {
            if (_type == FileScanTypeAnnex) {
                [SVProgressHUD showInfoWithStatus:@"暂不支持!"];
                return;
            }
            
            __weak typeof(self) weakSelf = self;
            
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
            imagePickerVc.allowPickingMultipleVideo = YES;
            imagePickerVc.videoMaximumDuration = 180;
            imagePickerVc.imagePickerControllerDidCancelHandle = ^{
                if (weakSelf.choosePhotoBlock) {
                    weakSelf.choosePhotoBlock(NO);
                }
            };
            // You can get the photos by block, the same as by delegate.
            
            imagePickerVc.uiImagePickerControllerSettingBlock = ^(UIImagePickerController *imagePickerController) {
                imagePickerController.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
            };
            // 你可以通过block或者代理，来得到用户选择的照片.
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                self->_isSelectOriginalPhoto = isSelectOriginalPhoto;
                for (int i = 0; i < assets.count; i++) {
                    PHAsset *asset = assets[i];
                    
                    BIMFile *file = [[BIMFile alloc] init];
                    file.id = @"";
                    file.image = photos[i];
                    
                    switch (asset.mediaType) {
                        case PHAssetMediaTypeImage:
                            file.contentType = @"image/jpeg";
                            [weakSelf setExifToImage:file asset:asset];
                            break;
                        case PHAssetMediaTypeVideo:
                            file.contentType = @"video/mp4";
                            file.asset = asset;
                            [weakSelf videoAssetToData:file];
                            break;
                        default:
                            break;
                    }
                    [weakSelf.dataSource insertObject:file atIndex:weakSelf.dataSource.count - 1];
                }
                
                [weakSelf deleteFileModel:nil];
            }];
            [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
                
            }];
            
            if (self.choosePhotoBlock) {
                self.choosePhotoBlock(YES);
            }
            
            [self.controller presentViewController:imagePickerVc animated:YES completion:nil];
            return;
        }
    }

    if (_type == FileScanTypeImage) {
        if ([self.dataSource[indexPath.row].contentType isEqualToString:@"video/mp4"]) {
            if (self.dataSource[indexPath.row].asset) {
                TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
                TZAssetModel *model = [TZAssetModel modelWithAsset:self.dataSource[indexPath.row].asset type:TZAssetModelMediaTypeVideo timeLength:@""];
                vc.model = model;
                [self.findViewController presentViewController:vc animated:YES completion:nil];
            } else {
                if ([self.dataSource[indexPath.row] isDownload]) {
                    [self openVideoFile:self.dataSource[indexPath.row]];
                } else {
                    [SVProgressHUD showWithStatus:@"下载中..."];
                    __weak typeof(self) weakSelf = self;
                    [[HttpManager manager] downloadVideoWithFileid:self.dataSource[indexPath.row].id fileName:self.dataSource[indexPath.row].filename progress:nil completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                        [SVProgressHUD dismiss];
                        if (!error) {
                            [weakSelf openVideoFile:weakSelf.dataSource[indexPath.row]];
                        } else {
                            [SVProgressHUD showErrorWithStatus:@"下载失败！"];
                        }
                    }];
                }
            }
        } else {
            // 1. 创建photoBroseView对象
            PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
            
            // 2.1 设置图片源(UIImage)数组
            NSMutableArray <UIImage *>*imgs = [NSMutableArray array];
            NSInteger index = 0;
            NSInteger count = self.dataSource.count - 1;
            if (!_isHandle) {
                count = self.dataSource.count;
            }
            for (int i = 0; i < count; i++) {
                BIMFile *file = self.dataSource[i];
                if (![file.contentType isEqualToString:@"video/mp4"]) {
                    [imgs addObject:self.dataSource[i].image];
                    if (file == self.dataSource[indexPath.row]) {
                        index = imgs.count - 1;
                    }
                }
            }
            photoBroseView.images = imgs;
            // 2.2 设置初始化图片下标（即当前点击第几张图片）
            photoBroseView.currentIndex = index;
            
            photoBroseView.showFromView = [collectionView cellForItemAtIndexPath:indexPath];
            photoBroseView.hiddenToView = [collectionView cellForItemAtIndexPath:indexPath];
            
            // 3.显示(浏览)
            [photoBroseView show];
        }
    } else {
        
    }
}

#pragma mark - 删除文件
- (void)deleteFile:(BIMFile *)file {
    if (_delete) {
        [_delete stop];
    }
    
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"删除中..."];
    _delete = [[ApiFilesDelete alloc] initWithFileId:file.id];
    [_delete startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        [weakSelf deleteFileModel:file];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
    }];
}

- (void)deleteFileModel:(BIMFile *)file {
    if (file) {
        if (file.unUploadFile) {
            [DBManager deleteUploadFiles:@[file.unUploadFile]];
        }
        
        [self.dataSource removeObject:file];
    }
    
    NSInteger row = 1;
    CGFloat x = 0;
    for (int i = 0; i < self.dataSource.count; i++) {
        x += 75;
        if (x - 10 > self.frame.size.width) {
            row += 1;
            x = 0;
        }
    }
    CGFloat height = row * 70;
    if (self.block) {
        self.block(_height, height);
        _height = height;
    }
    [self.collectionView reloadData];
}

- (NSArray *)addFiles {
    NSMutableArray<BIMFile *>*files = [NSMutableArray array];
    for (int i = 0; i < self.dataSource.count - 1; i++) {
        BIMFile *file = self.dataSource[i];
        if ([file.id isEqualToString:@""]) {
            [files addObject:file];
        }
    }
    return [files copy];
}

- (UIViewController *)controller{
    if (!_controller) {
        _controller = self.findViewController;
    }
    return _controller;
}

- (void)handleData {
    if (self.unUploadFiles) {
        for (UnUploadFile *unUploadFile in self.unUploadFiles) {
            BIMFile *file = [[BIMFile alloc] init];
            file.unUploadFile = unUploadFile;
            file.id = @"";
            
            NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
            NSData *data = [NSData dataWithContentsOfFile:[doc stringByAppendingPathComponent:unUploadFile.path]];
            if ([unUploadFile.type isEqualToString:@"video"]) {
                file.contentType = @"video/mp4";
                file.filename = unUploadFile.name;
                file.filePath = unUploadFile.path;
            } else {
                file.image = [UIImage imageWithData:data];
                file.contentType = @"image/jpeg";
                
                CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
                
                NSDictionary *imageInfo = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
                
                NSDictionary *exifDic =[imageInfo objectForKey:(NSString*)kCGImagePropertyExifDictionary];
                NSDictionary *GPSDic =[imageInfo objectForKey:(NSString*)kCGImagePropertyGPSDictionary];
                
                file.dateTimeOriginal = [exifDic objectForKey:(NSString *)kCGImagePropertyExifDateTimeOriginal];
                file.longitude = [GPSDic objectForKey:(NSString*)kCGImagePropertyGPSLongitude];
                file.latitude = [GPSDic objectForKey:(NSString *)kCGImagePropertyGPSLatitude];
            }
            
            [self.dataSource addObject:file];
        }
    }
    
    
    BIMFile *add = [[BIMFile alloc] init];
    add.contentType = @"add";
    if (_isHandle) {
        [self.dataSource addObject:add];
    }
    NSInteger row = 1;
    CGFloat x = 0;
    for (int i = 0; i < self.dataSource.count; i++) {
        x += 75;
        if (x - 10 > self.frame.size.width) {
            row += 1;
            x = 0;
        }
    }
    CGFloat height = row * 70;
    if (self.block) {
        self.block(_height, height);
        _height = height;
    }
    [self.collectionView reloadData];
}

- (void)videoAssetToData:(BIMFile *)file {
    if (@available(iOS 9.1, *)) {
        PHAsset *asset = file.asset;
        NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
        PHAssetResource *resource;
        
        for (PHAssetResource *assetRes in assetResources) {
            if (assetRes.type == PHAssetResourceTypePairedVideo ||
                assetRes.type == PHAssetResourceTypeVideo) {
                resource = assetRes;
            }
        }
        
        NSString *fileName = @"tempAssetVideo.mov";
        if (resource.originalFilename) {
            fileName = resource.originalFilename;
        }
        if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.version = PHImageRequestOptionsVersionCurrent;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            
            NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
            [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
            [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE] options:nil completionHandler:^(NSError * _Nullable error) {
                if (error) {
                } else {
                    [self compressedVideoOtherMethodWithURL:[NSURL fileURLWithPath:PATH_MOVIE_FILE] compressionType:AVAssetExportPreset1920x1080 file:file];
                }
            }];
        } else {
        }
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark - 压缩视频
- (void)compressedVideoOtherMethodWithURL:(NSURL *)url compressionType:(NSString *)compressionType file:(BIMFile *)file {
    
    NSString *resultPath;
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    CGFloat totalSize = (float)data.length / 1024 / 1024;
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    // 所支持的压缩格式中是否有 所选的压缩格式
    if ([compatiblePresets containsObject:compressionType]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:compressionType];
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];// 用时间, 给文件重新命名, 防止视频存储覆盖,
        
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        
        BOOL isExists = [manager fileExistsAtPath:CompressionVideoPath];
        
        if (!isExists) {
            
            [manager createDirectoryAtPath:CompressionVideoPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        resultPath = [CompressionVideoPath stringByAppendingPathComponent:[NSString stringWithFormat:@"outputJFVideo-%@.mp4", [formater stringFromDate:[NSDate date]]]];
        
        
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         
         {
             if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                 file.data = [NSData dataWithContentsOfFile:resultPath];
                 float memorySize = (float)file.data.length / 1024 / 1024;
                 [self removeCompressedVideoFromDocuments];
             } else {
                 [SVProgressHUD dismiss];
             }
         }];
    } else {
        [SVProgressHUD dismiss];
    }
}

/**
 *  清楚沙盒文件中, 压缩后的视频所有, 在使用过压缩文件后, 不进行再次使用时, 可调用该方法, 进行删除
 */

- (void)removeCompressedVideoFromDocuments {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:CompressionVideoPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:CompressionVideoPath error:nil];
    }
}

#pragma mark - 打开视频文件
- (void)openVideoFile:(BIMFile *)file {
    if ([file isDownload]) {
        OpenDocumentationController *vc = [[OpenDocumentationController alloc] init];
        vc.filepath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:file.filePath];
        [self.findViewController.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 打印图片的Exif
- (void)setExifToImage:(BIMFile *)file asset:(PHAsset *)asset {
    [self setGPSInfo:file asset:asset data:UIImageJPEGRepresentation(file.image, 1)];
    if (_isSelectOriginalPhoto) {
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            [self setGPSInfo:file asset:asset data:imageData];
        }];
    }
}

- (void)setGPSInfo:(BIMFile *)file asset:(PHAsset *)asset data:(NSData *)data {
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    NSDictionary *imageInfo = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    
    NSMutableDictionary *metaDataDic = [imageInfo mutableCopy];
    NSMutableDictionary *exifDic =[[metaDataDic objectForKey:(NSString*)kCGImagePropertyExifDictionary]mutableCopy];
    NSMutableDictionary *GPSDic =[NSMutableDictionary dictionary];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    formatter.timeZone = [NSTimeZone localTimeZone];
    formatter.dateFormat = @"yyyy:MM:dd HH:mm:ss";
    
    if (asset.location) {
        CLLocationCoordinate2D newLocation = [JZLocationConverter wgs84ToGcj02:asset.location.coordinate];
        
        [exifDic setObject:[formatter stringFromDate:asset.creationDate] forKey:(NSString *)kCGImagePropertyExifDateTimeOriginal];
        [GPSDic setObject:[NSNumber numberWithDouble:newLocation.longitude] forKey:(NSString*)kCGImagePropertyGPSLongitude];
        [GPSDic setObject:[NSNumber numberWithDouble:newLocation.latitude] forKey:(NSString*)kCGImagePropertyGPSLatitude];
        
        file.dateTimeOriginal = [formatter stringFromDate:asset.creationDate];
        file.longitude = [NSString stringWithFormat:@"%f", newLocation.longitude];
        file.latitude = [NSString stringWithFormat:@"%f", newLocation.latitude];
    }
    
    [metaDataDic setObject:exifDic forKey:(NSString*)kCGImagePropertyExifDictionary];
    [metaDataDic setObject:GPSDic forKey:(NSString*)kCGImagePropertyGPSDictionary];
    
    CFStringRef UTI = CGImageSourceGetType(source);
    NSMutableData *newImageData = [NSMutableData data];
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)newImageData, UTI, 1,NULL);
    
    //add the image contained in the image source to the destination, overidding the old metadata with our modified metadata
    CGImageDestinationAddImageFromSource(destination, source, 0, (__bridge CFDictionaryRef)metaDataDic);
    CGImageDestinationFinalize(destination);
    
    file.data = newImageData;
}

@end
