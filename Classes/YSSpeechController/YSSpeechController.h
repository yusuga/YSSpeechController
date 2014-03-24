//
//  YSSpeechController.h
//  YSSpeechControllerExample
//
//  Created by Yu Sugawara on 2014/03/25.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YSSpeechControllerSpeechType) {
    YSSpeechControllerSpeechTypeEn,
    YSSpeechControllerSpeechTypeJa,
};

@interface YSSpeechController : NSObject

+ (instancetype)sharedController;

- (void)speechWithString:(NSString*)speechStr
            speechType:(YSSpeechControllerSpeechType)speechType
         didFinishSpeech:(void(^)(void))didFinishSpeech;

+ (void)setSpeechRate:(CGFloat)rate;

@end
