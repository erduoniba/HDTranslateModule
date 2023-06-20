//
//  UITextFieldCell.m
//  JDLTTranslateModule_Example
//
//  Created by denglibing on 2023/6/19.
//  Copyright © 2023 邓立兵. All rights reserved.
//

#import "UITextFieldCell.h"

@implementation UITextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_textField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _textField.frame = CGRectMake(10, 5, self.contentView.bounds.size.width - 20, self.contentView.bounds.size.height - 10);
}

@end



@implementation UITextFieldCell2
@end


