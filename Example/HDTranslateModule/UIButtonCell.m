//
//  UIButtonCell.m
//  JDLTTranslateModule_Example
//
//  Created by denglibing on 2023/6/19.
//  Copyright © 2023 邓立兵. All rights reserved.
//

#import "UIButtonCell.h"

@implementation UIButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = self.contentView.bounds;
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _button.titleLabel.numberOfLines = 0;
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_button];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _button.frame = self.contentView.bounds;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end



@implementation UIButtonCell2

@end
