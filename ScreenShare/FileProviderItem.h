//
//  FileProviderItem.h
//  ScreenShare
//
//  Created by 高小伟 on 2024/3/5.
//  Copyright © 2024 com.atide. All rights reserved.
//

#import <FileProvider/FileProvider.h>

@interface FileProviderItem : NSObject<NSFileProviderItem>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithItemIdentifier:(NSFileProviderItemIdentifier)itemIdentifier NS_DESIGNATED_INITIALIZER;

@end
