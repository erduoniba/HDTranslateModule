//
//  JDLTTranslateHook.m
//  JDLTTranslateModule
//
//  Created by denglibing on 2023/6/18.
//

#import "JDLTTranslateHook.h"

#import "JDLTTranslateManager.h"

#import <objc/runtime.h>



static inline void jdlttranslate_swizzleSelector(Class theClass, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(theClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(theClass, swizzledSelector);
    BOOL didAddMethod = class_addMethod(theClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(theClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        if (originalMethod && swizzledMethod) {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}


@implementation UILabel (JDLTTranslate)

+ (void)jdltLoad {
    jdlttranslate_swizzleSelector(UILabel.class, @selector(setText:), @selector(setJDLTTranslateText:));
}

- (void)setJDLTTranslateText:(NSString *)text {
    [self setJDLTTranslateText:[JDLTTranslateManager translateText:text]];
}

@end


@implementation UITextView (JDLTTranslate)

+ (void)jdltLoad {
    jdlttranslate_swizzleSelector(UITextView.class, @selector(setText:), @selector(setJDLTTranslateText:));
}

- (void)setJDLTTranslateText:(NSString *)text {
    [self setJDLTTranslateText:[JDLTTranslateManager translateText:text]];
}

@end


@implementation UITextField (JDLTTranslate)

+ (void)jdltLoad {
    jdlttranslate_swizzleSelector(UITextField.class, @selector(setText:), @selector(setJDLTTranslateText:));
}

- (void)setJDLTTranslateText:(NSString *)text {
    [self setJDLTTranslateText:[JDLTTranslateManager translateText:text]];
}

@end



@implementation UITabBarItem (JDLTTranslate)

+ (void)jdltLoad {
    jdlttranslate_swizzleSelector(UITabBarItem.class, @selector(setTitle:), @selector(setJDLTTranslateTitle:));
}

- (void)setJDLTTranslateTitle:(NSString *)text {
    [self setJDLTTranslateTitle:[JDLTTranslateManager translateText:text]];
}

@end


@implementation UINavigationItem (JDLTTranslate)

+ (void)jdltLoad {
    jdlttranslate_swizzleSelector(UINavigationItem.class, @selector(setTitle:), @selector(setJDLTTranslateTitle:));
}

- (void)setJDLTTranslateTitle:(NSString *)text {
    [self setJDLTTranslateTitle:[JDLTTranslateManager translateText:text]];
}

@end


@implementation UIViewController (JDLTTranslate)

+ (void)jdltLoad {
    jdlttranslate_swizzleSelector(UIViewController.class, @selector(setTitle:), @selector(setJDLTTranslateTitle:));
}

- (void)setJDLTTranslateTitle:(NSString *)text {
    [self setJDLTTranslateTitle:[JDLTTranslateManager translateText:text]];
}

@end


@implementation NSAttributedString (JDLTTranslate)

+ (void)jdltLoad {
    // 发现NSAttributedString的initWithString:和initWithString:attributes:方法确实无法直接hook。
    // 这可能是因为NSAttributedString的这些方法是由其子类NSConcreteAttributedString实现的。
    Class class = NSClassFromString(@"NSConcreteAttributedString");
    jdlttranslate_swizzleSelector(class, @selector(initWithString:), @selector(jdltInitWithString:));
}

- (instancetype)jdltInitWithString:(NSString *)str {
//    NSLog(@"jdltInitWithString: %@", str);
    return [self jdltInitWithString:[JDLTTranslateManager translateText:str]];
}

@end



@implementation JDLTTranslateHook

+ (void)jdltTranslateHook {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // UILabel：直接使用UILabel来显示文本。
        // UIButton：底层使用UIButtonLabel（继承自UILabel）来显示按钮标题
        [UILabel jdltLoad];
        
        // 底层使用NSTextContainer、NSTextStorage和NSLayoutManager等类来实现文本显示和编辑，而不是直接使用UILabel。
        [UITextView jdltLoad];
        [UITextField jdltLoad];
        [UITabBarItem jdltLoad];
        [UINavigationItem jdltLoad];
        [UIViewController jdltLoad];
        
        // NSMutableAttributedString 会导致偶现崩溃，不能直接book使用
        // 推荐使用 JDLTAttributedString、JDLTMutableAttributedString
        // [NSAttributedString jdltLoad];
    });
}

@end
