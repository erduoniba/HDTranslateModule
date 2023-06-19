//
//  JDLTAttributedString.m
//  JDLTTranslateModule
//
//  Created by denglibing on 2023/6/19.
//

#import "JDLTAttributedString.h"
#import "JDLTTranslateManager.h"

@implementation JDLTAttributedString

- (instancetype)initWithString:(NSString *)str {
    NSString *translateStr = [JDLTTranslateManager translateText:str];
    self = (JDLTAttributedString *)[[NSAttributedString alloc] initWithString:translateStr];
    return self;
}

- (instancetype)initWithString:(NSString *)str attributes:(NSDictionary<NSAttributedStringKey,id> *)attrs {
    NSString *translateStr = [JDLTTranslateManager translateText:str];
    self = (JDLTAttributedString *)[[NSAttributedString alloc] initWithString:translateStr attributes:attrs];
    return self;
}

@end


@implementation JDLTMutableAttributedString

- (instancetype)initWithString:(NSString *)str {
    NSString *translateStr = [JDLTTranslateManager translateText:str];
    self = (JDLTMutableAttributedString *)[[NSMutableAttributedString alloc] initWithString:translateStr];
    return self;
}

- (instancetype)initWithString:(NSString *)str attributes:(NSDictionary<NSAttributedStringKey,id> *)attrs {
    NSString *translateStr = [JDLTTranslateManager translateText:str];
    self = (JDLTMutableAttributedString *)[[NSMutableAttributedString alloc] initWithString:translateStr attributes:attrs];
    return self;
}

@end

