//
//  JDLTTranslateManager.m
//  JDLTTranslateModule
//
//  Created by denglibing on 2023/6/18.
//

#import "JDLTTranslateManager.h"

@interface JDLTTranslateManager ()

@property (nonatomic, assign) JDLTLanguageMode selectedLanguage;
@property (nonatomic, strong) NSBundle *jdltTranslateModuleBundle;
@property (nonatomic, copy) NSString *lprojPath;
@property (nonatomic, copy) NSString *tableName;

@end

@implementation JDLTTranslateManager

+ (instancetype)shared {
    static JDLTTranslateManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JDLTTranslateManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *bundlePath = [[NSBundle bundleForClass:self.class] pathForResource:@"HDTranslateModule" ofType:@"bundle"];
        if (!bundlePath) {
            bundlePath = [[NSBundle mainBundle] pathForResource:@"HDTranslateModule" ofType:@"bundle"];
        }
        _jdltTranslateModuleBundle = [NSBundle bundleWithPath:bundlePath];
        _tableName = @"HDTranslateModule";
        _selectedLanguage = [NSUserDefaults.standardUserDefaults integerForKey:@"JDLTTranslateManager.selectedLanguage"];
    }
    return self;
}

- (void)customTranslateBundle:(NSBundle *)bundle tableName:(NSString *)tableName {
    if (bundle) {
        _jdltTranslateModuleBundle = bundle;
        _tableName = tableName;
    }
}

- (JDLTLanguageMode)selectedLanguage {
    return _selectedLanguage;
}

- (void)updateLanguage:(JDLTLanguageMode)mode {
    if (_selectedLanguage == mode) {
        return;
    }
    
    _selectedLanguage = mode;
    
    // 切换语言模式，需要重制一次语言模型路径
    _lprojPath = nil;
    [self lprojPath];
    
    [NSUserDefaults.standardUserDefaults setInteger:_selectedLanguage forKey:@"JDLTTranslateManager.selectedLanguage"];
}

- (JDLTLanguageMode)systemSelectedLanguage {
    //获取系统语言
    JDLTLanguageMode mode = JDLTLanguageEN;
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *systemlanguage = [languages objectAtIndex:0];
    if ([systemlanguage containsString:@"zh-Hans"]) {
        mode = JDLTLanguageZH;
    }
    return mode;
}

- (JDLTLanguageMode)realUsedLanguage {
    if (_selectedLanguage != JDLTLanguageSyetem) {
        return _selectedLanguage;
    }
    return [self systemSelectedLanguage];
}


- (NSString *)lprojPath {
    if (!_lprojPath) {
        NSString *appLanguage = @"en";
        if ([JDLTTranslateManager.shared realUsedLanguage] == JDLTLanguageZH) {
            appLanguage = @"zh-Hans";
        }
        _lprojPath = [_jdltTranslateModuleBundle pathForResource:appLanguage ofType:@"lproj"];
    }
    return _lprojPath;
}


+ (NSString *)translateText:(NSString *)text {
    NSString *translate = [[NSBundle bundleWithPath:JDLTTranslateManager.shared.lprojPath] localizedStringForKey:text value:nil table:JDLTTranslateManager.shared.tableName];
//    NSLog(@"translate: %@", translate);
    return translate;
}

@end
