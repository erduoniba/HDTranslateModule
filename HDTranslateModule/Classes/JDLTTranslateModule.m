//
//  JDLTTranslateModule.m
//
//

#import <Foundation/Foundation.h>
#import "JDLTTranslateModule.h"
#import "JDLTTranslateHook.h"

@implementation JDLTTranslateModule

+ (void)openAutoTranslate {
    [JDLTTranslateHook jdltTranslateHook];
}

@end
