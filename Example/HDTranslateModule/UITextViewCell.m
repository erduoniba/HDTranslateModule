//
//  UITextViewCell.m
//  JDLTTranslateModule_Example
//
//  Created by denglibing on 2023/6/19.
//  Copyright © 2023 邓立兵. All rights reserved.
//

#import "UITextViewCell.h"

@implementation UITextViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.editable = NO;
        [self.contentView addSubview:_textView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _textView.frame = CGRectMake(10, 5, self.contentView.bounds.size.width - 20, self.contentView.bounds.size.height - 10);
}

@end


@implementation UITextViewCell2
@end
