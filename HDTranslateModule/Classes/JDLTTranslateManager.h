//
//  JDLTTranslateManager.h
//  JDLTTranslateModule
//
//  Created by denglibing on 2023/6/18.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, JDLTLanguageMode) {
    JDLTLanguageSyetem = 0,
    JDLTLanguageEN,
    JDLTLanguageZH
};

NS_ASSUME_NONNULL_BEGIN

@interface JDLTTranslateManager : NSObject

+ (instancetype)shared;

// 获取用户在App内选中的语言，如果用户未选中默认是System，则使用系统语言
- (JDLTLanguageMode)selectedLanguage;
- (void)updateLanguage:(JDLTLanguageMode)mode;

// 获取用户在系统选中的语言
- (JDLTLanguageMode)systemSelectedLanguage;

// 根据selectedLanguage和systemSelectedLanguage最终使用到的语言，只能可能是EN和ZH
// 如果用户在App选择优先使用，否则使用系统语言
- (JDLTLanguageMode)realUsedLanguage;


// 将 text 翻译成对应的语言
+ (NSString *)translateText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
