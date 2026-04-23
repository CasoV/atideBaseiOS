//
//  FilesScanView.m
//  ycxm
//
//  Created by 末末班车 on 2018/10/16.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "FilesScanView.h"
#import "DBManager.h"
#import "PopoverView.h"
#import "PYPhotoBrowser.h"
#import "ApiFilesSearch.h"
#import "ApiFilesDelete.h"
#import "FileScanViewCell.h"
#import "JZLocationConverter.h"
//#import "DownloadFileController.h"
#import "OpenDocumentationController.h"
#import <TZImagePickerController/TZImagePickerController.h>

#define CompressionVideoPath [NSHomeDirectory() stringByAppendingFormat:@"/Documents/CompressionVideoField"]

@interface FilesScanView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation FilesScanView {
    CGFloat _height;
    
    ApiFilesSearch *_search;
    ApiFilesDelete *_delete;
    
    BOOL _isSelectOriginalPhoto;
}

- (instancetype)initWithFrame:(CGRect)frame isHandle:(BOOL)isHandle {
    if (self = [super initWithFrame:frame]) {
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

#pragma mark - 初始化界面
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
    if (self.isHandle) {
        BIMFile *add = [[BIMFile alloc] init];
        add.contentType = @"add";
        [self.dataSource addObject:add];
    }
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

#pragma mark - 处理数据
- (void)updateData {
    if (!self.markId) {
        return;
    }
    
    if (_search) {
        [_search stop];
    }
    
    __weak typeof(self) weakSelf = self;
    if (self.fileType) {
        _search = [[ApiFilesSearch alloc] initWithRequestParams:@{@"metaData.formId":self.markId, @"metaData.fileType":self.fileType}];
    } else {
        _search = [[ApiFilesSearch alloc] initWithFormId:self.markId];
    }
    [_search startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray <BIMFile *>*tempArr = [BIMFile mj_objectArrayWithKeyValuesArray:[request responseData]];
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.dataSource addObjectsFromArray:tempArr];
        [weakSelf handleData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf.dataSource removeAllObjects];
        [weakSelf handleData];
    }];
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

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    FileScanViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FileScanViewCell" forIndexPath:indexPath];
    [cell loadDataModel:self.dataSource[indexPath.row]];
    if (!_isHandle) {
        [cell hiddenDeleteBtn];
    }
    cell.block = ^(BIMFile *file) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"删除提示" message:@"确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([file.id isEqualToString:@""]) {
                [weakSelf deleteFileModel:file];
            } else {
                [weakSelf deleteFile:file];
            }
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self.findViewController presentViewController:alertC animated:YES completion:nil];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BIMFile *file = self.dataSource[indexPath.row];
    if ([file.contentType isEqualToString:@"add"]) {
        if (self.controller) {
            __weak typeof(self) weakSelf = self;
            NSMutableArray <PopoverAction *>*actionArr = [NSMutableArray array];
            [actionArr addObject:[PopoverAction actionWithTitle:@"拍照或相册" handler:^(PopoverAction *action) {
                [weakSelf chooseAlbum];
            }]];
            [actionArr addObject:[PopoverAction actionWithTitle:@"本地文件" handler:^(PopoverAction *action) {
                [weakSelf chooseDownloadFile];
            }]];
            PopoverView *popoverView = [PopoverView popoverView];
            popoverView.showShade = NO; // 显示阴影背景
            popoverView.style = PopoverViewStyleDark; // 设置为黑色风格
            // 有两种显示方法
            [popoverView showToView:[collectionView cellForItemAtIndexPath:indexPath] withActions:actionArr];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择文件来源" preferredStyle:UIAlertControllerStyleActionSheet];
            [alertController addAction:[UIAlertAction actionWithTitle:@"拍照或相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self chooseAlbum];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"本地文件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self chooseDownloadFile];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            
            [self.findViewController presentViewController:alertController animated:YES completion:nil];
        }
    } else {
        if (file.isImage) {
            // 1. 创建photoBroseView对象
            PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
            
            // 2.1 设置图片源(UIImage)数组
            NSMutableArray <UIImage *>*imgs = [NSMutableArray array];
            NSInteger index = 0;
            NSInteger count = _isHandle ? self.dataSource.count - 1 : self.dataSource.count;

            for (int i = 0; i < count; i++) {
                BIMFile *data = self.dataSource[i];
                if (data.isImage) {
                    [imgs addObject:data.image ? data.image : [UIImage new]];
                    if (data == file) {
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
        } else {
            if (file.asset) {
                TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
                TZAssetModel *model = [TZAssetModel modelWithAsset:self.dataSource[indexPath.row].asset type:TZAssetModelMediaTypeVideo timeLength:@""];
                vc.model = model;
                if (self.controller) {
                    [self.controller presentViewController:vc animated:YES completion:nil];
                } else {
                    [self.findViewController presentViewController:vc animated:YES completion:nil];
                }
            } else {
                if ([self.dataSource[indexPath.row] isDownload]) {
                    [self openFile:self.dataSource[indexPath.row]];
                } else {
                    [SVProgressHUD showWithStatus:@"下载中..."];
                    __weak typeof(self) weakSelf = self;
                    [[HttpManager manager] downloadVideoWithFileid:self.dataSource[indexPath.row].id fileName:self.dataSource[indexPath.row].filename progress:nil completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                        [SVProgressHUD dismiss];
                        if (!error) {
                            [weakSelf openFile:weakSelf.dataSource[indexPath.row]];
                        } else {
                            [SVProgressHUD showErrorWithStatus:@"下载失败！"];
                        }
                    }];
                }
            }
        }
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
        
        if(self.deletedBlock){
            self.deletedBlock();
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

#pragma mark - 新增的文件
- (NSArray *)addFiles {
    NSMutableArray<BIMFile *>*files = [NSMutableArray array];
    
    NSInteger index = 0;
    if (self.isHandle) {
        index = 1;
    }
    if(self.dataSource.count == 0){
        return @[];
    }
    for (int i = 0; i < self.dataSource.count - index; i++) {
        BIMFile *file = self.dataSource[i];
        if ([file.id isEqualToString:@""]) {
            [files addObject:file];
        }
    }
    return [files copy];
}

#pragma mark - 选择相册文件
- (void)chooseAlbum {
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
        NSInteger outRangeCount = 0;
        CGFloat gpsRanger = 0;
        if (self.isUserXY) {
            UserAgent *user = [UserAgent DefaultAgent];
            for (ProjectInfo *prjInfo in user.projectInfos) {
                if ([prjInfo.id isEqualToString:user.approvalPartModel.PRJID]) {
                    for (ProjectInfo *secInfo in prjInfo.children) {
                        if ([secInfo.id isEqualToString:user.approvalPartModel.SECTION_ID]) {
//                            gpsRanger = secInfo.gpsRanger;
                            break;
                        }
                    }
                }
            }
        }
        
        
        for (int i = 0; i < assets.count; i++) {
            PHAsset *asset = assets[i];
            
            BIMFile *file = [[BIMFile alloc] init];
            file.id = @"";
            file.image = photos[i];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [NSLocale currentLocale];
            formatter.timeZone = [NSTimeZone localTimeZone];
            formatter.dateFormat = @"YYYY-MM-dd HH-mm-ss";
            switch (asset.mediaType) {
                case PHAssetMediaTypeImage:
                    file.filename = [NSString stringWithFormat:@"%@ %d.jpeg", [formatter stringFromDate:[NSDate date]], arc4random() % 1000];
                    file.contentType = @"image/jpeg";
                    file.extName = @"jpeg";
                    [weakSelf setExifToImage:file asset:asset];
                    break;
                case PHAssetMediaTypeVideo:
                    file.filename = [NSString stringWithFormat:@"%@ %d.mov", [formatter stringFromDate:[NSDate date]], arc4random() % 1000];
                    file.contentType = @"video/quicktime";
                    file.extName = @"mov";
                    file.asset = asset;
                    [weakSelf videoAssetToData:file];
                    break;
                default:
                    break;
            }
            
            if ([file.contentType isEqualToString:@"image/jpeg"]) {
                if (weakSelf.isUserXY) {
                    ApprovalPartModel *model = [UserAgent DefaultAgent].approvalPartModel;
                    if (model) {
                        if ([model.CODE_ isEqualToString:self.partCode]) {
                            if (gpsRanger >= [weakSelf distanceBetweenOrderBy:model.Y_POINT :file.latitude.doubleValue :model.X_POINT :file.longitude.doubleValue]) {
                                [weakSelf.dataSource insertObject:file atIndex:weakSelf.dataSource.count - 1];
                            } else {
                                outRangeCount++;
                            }
                        } else {
                            outRangeCount++;
                        }
                    } else {
                        outRangeCount++;
                    }
                } else {
                    [weakSelf.dataSource insertObject:file atIndex:weakSelf.dataSource.count - 1];
                }
            } else {
                [weakSelf.dataSource insertObject:file atIndex:weakSelf.dataSource.count - 1];
            }
        }
        
        if (outRangeCount) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"所选%lu文件中,%ld个文件不满足位置要求", (unsigned long)assets.count, (long)outRangeCount]];
        }
        if (self.choosedBlock) {
            self.choosedBlock();
        }
        
        [weakSelf deleteFileModel:nil];
    }];
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
        
    }];
    
    if (self.choosePhotoBlock) {
        self.choosePhotoBlock(YES);
    }
    if (self.annexPushBlock) {
        self.annexPushBlock();
    }
    
    if (self.controller) {
        [self.controller presentViewController:imagePickerVc animated:YES completion:nil];
    } else {
        [self.findViewController presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark - 选择本地文件
- (void)chooseDownloadFile {
//    __weak typeof(self) weakSelf = self;
//    DownloadFileController *vc = [[UIStoryboard storyboardWithName:@"Complex" bundle:nil] instantiateViewControllerWithIdentifier:@"DownloadFile"];
//    vc.callBack = ^(DownloadFileModel *model) {
//        BIMFile *file = [[BIMFile alloc] init];
//        file.id = @"";
//        file.data = model.fileData;
//        file.extName = model.fileType;
//        file.filename = model.fileName;
//        file.contentType = [model getmimetype];
//        if (file.isImage) {
//            file.image = [UIImage imageWithData:model.fileData];
//
//            if (weakSelf.isUserXY) {
//                ApprovalPartModel *apModel = [UserAgent DefaultAgent].approvalPartModel;
//                if (apModel) {
//                    if ([apModel.CODE_ isEqualToString:weakSelf.partCode]) {
//                        CGFloat gpsRanger = 0;
//                        UserAgent *user = [UserAgent DefaultAgent];
//                        for (ProjectInfo *prjInfo in user.projectInfos) {
//                            if ([prjInfo.id isEqualToString:apModel.PRJID]) {
//                                for (ProjectInfo *secInfo in prjInfo.children) {
//                                    if ([secInfo.id isEqualToString:apModel.SECTION_ID]) {
////                                        gpsRanger = secInfo.gpsRanger;
//                                        break;
//                                    }
//                                }
//                            }
//                        }
//
//                        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)model.fileData, NULL);
//                        NSDictionary *imageInfo = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
//
//                        NSDictionary *exifDic =[imageInfo objectForKey:(NSString*)kCGImagePropertyExifDictionary];
//                        NSDictionary *GPSDic =[imageInfo objectForKey:(NSString*)kCGImagePropertyGPSDictionary];
//
//                        file.dateTimeOriginal = [exifDic objectForKey:(NSString *)kCGImagePropertyExifDateTimeOriginal];
//                        file.longitude = [GPSDic objectForKey:(NSString*)kCGImagePropertyGPSLongitude];
//                        file.latitude = [GPSDic objectForKey:(NSString *)kCGImagePropertyGPSLatitude];
//
//                        if (gpsRanger >= [weakSelf distanceBetweenOrderBy:apModel.Y_POINT :file.latitude.doubleValue :apModel.X_POINT :file.longitude.doubleValue]) {
//                            [weakSelf.dataSource insertObject:file atIndex:weakSelf.dataSource.count - 1];
//                        } else {
//                            [SVProgressHUD showInfoWithStatus:@"所选文件不满足位置要求"];
//                        }
//                    } else {
//                        [SVProgressHUD showInfoWithStatus:@"所选文件不满足位置要求"];
//                    }
//                } else {
//                    [SVProgressHUD showInfoWithStatus:@"所选文件不满足位置要求"];
//                }
//            } else {
//                [weakSelf.dataSource insertObject:file atIndex:weakSelf.dataSource.count - 1];
//            }
//        } else {
//            [weakSelf.dataSource insertObject:file atIndex:weakSelf.dataSource.count - 1];
//        }
//
//        [weakSelf deleteFileModel:nil];
//        if (self.choosedBlock) {
//            self.choosedBlock();
//        }
//    };
//
//    if (self.annexPushBlock) {
//        self.annexPushBlock();
//    }
//
//    if (self.controller) {
//        [self.controller.navigationController pushViewController:vc animated:YES];
//    } else {
//        [self.findViewController.navigationController pushViewController:vc animated:YES];
//    }
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

#pragma mark - 处理视频文件
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
- (void)openFile:(BIMFile *)file {
    if ([file isDownload]) {
        OpenDocumentationController *vc = [[OpenDocumentationController alloc] init];
        vc.filepath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:file.filePath];
        if (self.controller) {
            [self.controller.navigationController pushViewController:vc animated:YES];
        } else {
            [self.findViewController.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (double)distanceBetweenOrderBy:(double) lat1 :(double) lat2 :(double) lng1 :(double) lng2{
    
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    
    double  distance  = [curLocation distanceFromLocation:otherLocation];
    
    return  distance;
}

@end
