//
//  UILabelCell.m
//  JDLTTranslateModule_Example
//
//  Created by denglibing on 2023/6/18.
//  Copyright © 2023 邓立兵. All rights reserved.
//

#import "UILabelCell.h"

@implementation UILabelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.numberOfLines = 0;
        self.textLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
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
