//
//  YSSpeechController.m
//  YSSpeechControllerExample
//
//  Created by Yu Sugawara on 2014/03/25.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "YSSpeechController.h"
@import AVFoundation;

#define LOG_SPEECH_CONTROLLER 1
    #if LOG_SPEECH_CONTROLLER
    #define LOG_SPEECH(...) NSLog(__VA_ARGS__)
    #define LOG_SPEECH_METHOD NSLog(@"%s(%d)", __func__, __LINE__)
#else
    #define LOG_SPEECH(...)
    #define LOG_SPEECH_METHOD
#endif


static CGFloat s_speechRate;
static CGFloat const kDefaultsSpeechRate = 0.2f;

@interface YSSpeechController () <AVSpeechSynthesizerDelegate>

@property (nonatomic) AVSpeechSynthesizer *synthesizer;
@property (copy, nonatomic) void(^didFinishSpeech)(void);

@end

static inline NSString *languageStringFromSpeechType(YSSpeechControllerSpeechType type)
{
    switch (type) {
        case YSSpeechControllerSpeechTypeEn:
            return @"en-US";
        case YSSpeechControllerSpeechTypeJa:
            return @"ja-JP";
        default:
            NSLog(@"[ERROR] Unknown speech type: %@", @(type));
            return @"ja-JP";
    }
}

@implementation YSSpeechController

+ (instancetype)sharedController
{
    static id s_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_sharedInstance =  [[self alloc] init];
    });
    return s_sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
        self.synthesizer.delegate = self;
        
        s_speechRate = kDefaultsSpeechRate;
    }
    return self;
}

+ (void)setSpeechRate:(CGFloat)rate
{
    s_speechRate = rate;
}

- (void)speechWithString:(NSString *)speechStr
              speechType:(YSSpeechControllerSpeechType)speechType
         didFinishSpeech:(void (^)(void))didFinishSpeech
{
    [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    
    if (speechStr == nil) {
        if (didFinishSpeech) didFinishSpeech();
        return;
    }
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:speechStr];
    utterance.rate = s_speechRate;
    LOG_SPEECH(@"utterance: %@", utterance);
    
    // http://www.shinobicontrols.com/blog/posts/2013/09/25/ios7-day-by-day-day-4-avspeechsynthesizer/
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:languageStringFromSpeechType(speechType)];
    utterance.voice = voice;
    LOG_SPEECH(@"voice: %@, utterance: %@", voice, utterance);
    self.didFinishSpeech = didFinishSpeech;
    [self.synthesizer speakUtterance:utterance];
}

#pragma mark - AVSpeechSynthesizerDelegate

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance
{
    LOG_SPEECH_METHOD;
    if (self.didFinishSpeech) self.didFinishSpeech();
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance
{
    LOG_SPEECH_METHOD;
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    LOG_SPEECH_METHOD;
    if (self.didFinishSpeech) self.didFinishSpeech();
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance
{
    LOG_SPEECH_METHOD;
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    LOG_SPEECH_METHOD;
    LOG_SPEECH(@"%@ %@", synthesizer, utterance);
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance
{
    LOG_SPEECH_METHOD;
    LOG_SPEECH(@"%@ %@", synthesizer, utterance);
}

@end
