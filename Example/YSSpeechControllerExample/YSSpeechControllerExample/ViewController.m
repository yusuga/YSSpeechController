//
//  ViewController.m
//  YSSpeechControllerExample
//
//  Created by Yu Sugawara on 2014/03/25.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "ViewController.h"
#import "YSSpeechController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *enText = @"Hello";
    NSString *jaText = @"おはようございます";

    YSSpeechController *speechController = [YSSpeechController sharedController];
    [speechController speechWithString:enText speechType:YSSpeechControllerSpeechTypeEn didFinishSpeech:^{
        [speechController speechWithString:enText speechType:YSSpeechControllerSpeechTypeJa didFinishSpeech:^{
            [speechController speechWithString:jaText speechType:YSSpeechControllerSpeechTypeJa didFinishSpeech:^{
                [speechController speechWithString:jaText speechType:YSSpeechControllerSpeechTypeEn didFinishSpeech:^{
                    
                }];
            }];
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
