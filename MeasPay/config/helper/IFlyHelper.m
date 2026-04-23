//
//  IFlyHelper.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/4/8.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "IFlyHelper.h"

//@implementation IFlyHelper {
//    IFlyRecognizerView *_iflyView;
//    
//    NSString *_speechResult;
//}
//
//- (instancetype)initWithView:(UIView *)view delegate:(id<IFlyRecognizerViewDelegate>)delegate {
//    if (self = [super init]) {
//        _speechResult = @"";
//        [self initRecognizer:view delegate:delegate];
//    }
//    return self;
//}
//
//- (void)initRecognizer:(UIView *)view delegate:(id<IFlyRecognizerViewDelegate>)delegate {
//    _iflyView = [[IFlyRecognizerView alloc] initWithCenter:view.center];
//    _iflyView.delegate = delegate;
//    [_iflyView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
//    [_iflyView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
//    [_iflyView setParameter:@"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
//    [_iflyView setParameter:[IFlySpeechConstant ASR_PTT_HAVEDOT] forKey:[IFlySpeechConstant ASR_PTT]];
//    [_iflyView setParameter:[IFlySpeechConstant LANGUAGE_CHINESE] forKey:[IFlySpeechConstant LANGUAGE]];
//    [_iflyView setParameter:[IFlySpeechConstant ACCENT_MANDARIN] forKey:[IFlySpeechConstant ACCENT]];
//
//    //设置音频来源为麦克风
//    [_iflyView setParameter:IFLY_AUDIO_SOURCE_MIC forKey:[IFlySpeechConstant AUDIO_SOURCE]];
//    //设置采样率，推荐使用16K
//    [_iflyView setParameter:[IFlySpeechConstant SAMPLE_RATE_16K] forKey:[IFlySpeechConstant SAMPLE_RATE]];
//
//    //设置听写结果格式为json
//    [_iflyView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
//}
//
//- (void)speech {
//    _speechResult = @"";
//    [_iflyView start];
//}
//
//- (void)destory {
//    [_iflyView cancel];
//    _iflyView.delegate = nil;
//    [_iflyView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
//}
//
///*!
// *  回调返回识别结果
// *
// *  @param resultArray 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，sc为识别结果的置信度
// *  @param isLast      -[out] 是否最后一个结果
// */
//- (void)onResult:(NSArray *)resultArray isLast:(BOOL) isLast {
//    if (resultArray == nil) {
//        return;
//    }
//    
//    NSDictionary *dic = resultArray[0];
//    if ([dic isKindOfClass:[NSDictionary class]]) {
//        for (NSString *key in [dic allKeys] ) {
//            _speechResult = [NSString stringWithFormat:@"%@%@", _speechResult, key];
//        }
//    }
//
//    return;
//}
//
///*!
// *  识别结束回调
// *
// *  @param error 识别结束错误码
// */
//- (NSString *)onError: (IFlySpeechError *) error {
//    if (error.errorCode == 0) {
//        return _speechResult;
//    }
//    
//    return @"";
//}

//@end
