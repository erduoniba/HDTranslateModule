//
//  HDViewController.m
//  HDTranslateModule
//
//  Created by denglibing5 on 06/19/2023.
//  Copyright (c) 2023 denglibing5. All rights reserved.
//

#import "HDViewController.h"

#import <HDTranslateModule/JDLTTranslateManager.h>
#import <HDTranslateModule/JDLTAttributedString.h>

#import "UILabelCell.h"
#import "UIButtonCell.h"
#import "UITextViewCell.h"
#import "UITextFieldCell.h"

@interface HDViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *languageSegment;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    _tableView.contentInset = UIEdgeInsetsMake(32, 0, 0, 0);
    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"UITableViewCell"];
    [_tableView registerClass:UILabelCell.class forCellReuseIdentifier:@"UILabelCell"];
    [_tableView registerClass:UIButtonCell.class forCellReuseIdentifier:@"UIButtonCell"];
    [_tableView registerClass:UIButtonCell2.class forCellReuseIdentifier:@"UIButtonCell2"];
    [_tableView registerClass:UITextViewCell.class forCellReuseIdentifier:@"UITextViewCell"];
    [_tableView registerClass:UITextViewCell2.class forCellReuseIdentifier:@"UITextViewCell2"];
    [_tableView registerClass:UITextFieldCell.class forCellReuseIdentifier:@"UITextFieldCell"];
    [_tableView registerClass:UITextFieldCell2.class forCellReuseIdentifier:@"UITextFieldCell2"];

    _dataArray = [@[] mutableCopy];
    
    [_languageSegment setSelectedSegmentIndex:JDLTTranslateManager.shared.selectedLanguage];
    [self reloadTabbar];
    
    [self reloadDatas];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect frame = _languageSegment.frame;
    frame.size.width = self.view.frame.size.width;
    _languageSegment.frame = frame;
}

- (void)reloadDatas {
    [_dataArray removeAllObjects];
    
    UILabel *label = [[UILabel alloc] init];
    NSString *str = @"Hello, World!";
    label.text = str;
    
    
    NSMutableArray *rowDatas = [@[] mutableCopy];
    // case1：直接显示文字
    [rowDatas addObject:@"弹窗组件页面"];
    // case2：文字中包含转译符 %d，转译符号在 setText 使用真实值
    [rowDatas addObject:@"分类缓存是时间阀值：%d，当前缓存时间：%d"];
    // case3：文字中包含转译符 %@，转译符号先使用真实值，再调用 setText 场景
    [rowDatas addObject:[NSString stringWithFormat:[JDLTTranslateManager translateText:@"更新资质合规：%@"], @"我是服务器数据"]];
    // case4：文字中包含转译符 %d，转译符号在 setText 使用真实值
    [rowDatas addObject:@"第%d张图片不符合规范，请替换或删除后重新上传"];
    // case5：文字中包含转译符 %@，转译符号在 setText 使用真实值
    [rowDatas addObject:@"订单编号：%@"];
    [rowDatas addObject:@"I am Harry：%@"];
    // ⚠️⚠️⚠️  带有转译符号的，需要先使用 Format 处理然后再调用 setText
    NSDictionary *section = @{
        @"UILable.text Case": rowDatas
    };
    [_dataArray addObject:section];
    
    
    // ⚠️⚠️⚠️  带有转译符号的，需要先使用 Format 处理然后再调用 setText
    section = @{
        @"UILable.attributedText Case": rowDatas
    };
    [_dataArray addObject:section];
    
    
    // ⚠️⚠️⚠️  带有转译符号的，需要先使用 Format 处理然后再调用 setText
    section = @{
        @"UIButton.setTitle Case": rowDatas
    };
    [_dataArray addObject:section];
    
    
    
    // ⚠️⚠️⚠️  带有转译符号的，需要先使用 Format 处理然后再调用 setText
    section = @{
        @"UIButton.setAttributedTitle Case": rowDatas
    };
    [_dataArray addObject:section];
    
    
    // ⚠️⚠️⚠️  带有转译符号的，需要先使用 Format 处理然后再调用 setText
    section = @{
        @"UITextView.text Case": rowDatas
    };
    [_dataArray addObject:section];
    
    // ⚠️⚠️⚠️  带有转译符号的，需要先使用 Format 处理然后再调用 setText
    section = @{
        @"UITextView.attributedText Case": rowDatas
    };
    [_dataArray addObject:section];
    
    
    // ⚠️⚠️⚠️  带有转译符号的，需要先使用 Format 处理然后再调用 setText
    section = @{
        @"UITextField.text Case": rowDatas
    };
    [_dataArray addObject:section];
    
    // ⚠️⚠️⚠️  带有转译符号的，需要先使用 Format 处理然后再调用 setText
    section = @{
        @"UITextField.attributedText Case": rowDatas
    };
    [_dataArray addObject:section];
}


- (IBAction)selectLanguage:(UISegmentedControl *)sender {
    [JDLTTranslateManager.shared updateLanguage:sender.selectedSegmentIndex];
    
    [self reloadDatas];
    [_tableView reloadData];
    
    [self reloadTabbar];
}

- (void)reloadTabbar {
    NSArray *zhTitles = @[@"中文", @"英文", @"中文", @"英文"];
    [self.tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitle:zhTitles[idx]];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *sections = _dataArray[section];
    return sections.allKeys.firstObject;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sections = _dataArray[section];
    if ([sections.allValues.firstObject isKindOfClass:NSArray.class]) {
        NSArray *rowDatas = (NSArray *)sections.allValues.firstObject;
        return rowDatas.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    NSDictionary *sections = _dataArray[indexPath.section];
    NSString *titleForHeaderInSection = sections.allKeys.firstObject;
    if ([titleForHeaderInSection hasPrefix:@"UILable.text"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UILabelCell"];
        
        if ([sections.allValues.firstObject isKindOfClass:NSArray.class]) {
            NSArray *rowDatas = (NSArray *)sections.allValues.firstObject;
            NSString *text = rowDatas[indexPath.row];
            if ([text containsString:@"%d"]) {
                cell.textLabel.text = [NSString stringWithFormat:[JDLTTranslateManager translateText:text], 1];
            }
            else if ([text containsString:@"%@"]) {
                cell.textLabel.text = [NSString stringWithFormat:[JDLTTranslateManager translateText:text], @"我也是服务器数据"];
            }
            else {
                cell.textLabel.text = text;
            }
        }
        return cell;
    }
    else if ([titleForHeaderInSection hasPrefix:@"UILable.attributedText"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        
        if ([sections.allValues.firstObject isKindOfClass:NSArray.class]) {
            NSArray *rowDatas = (NSArray *)sections.allValues.firstObject;
            NSString *text = rowDatas[indexPath.row];
            
            // attributedText 需要继承 JDLTMutableAttributedString 翻译
            if ([text containsString:@"%d"]) {
                text = [NSString stringWithFormat:[JDLTTranslateManager translateText:text], 1];
            }
            else if ([text containsString:@"%@"]) {
                text = [NSString stringWithFormat:[JDLTTranslateManager translateText:text], @"我也是服务器数据"];
            }
            
            JDLTMutableAttributedString *attributedString = [self defaultAttributedString:text];
            cell.textLabel.attributedText = attributedString;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }
        return cell;
    }
    else if ([titleForHeaderInSection hasPrefix:@"UIButton.setTitle"]) {
        UIButtonCell *cell = (UIButtonCell *)[tableView dequeueReusableCellWithIdentifier:@"UIButtonCell"];
        
        if ([sections.allValues.firstObject isKindOfClass:NSArray.class]) {
            NSArray *rowDatas = (NSArray *)sections.allValues.firstObject;
            NSString *text = rowDatas[indexPath.row];
            
            // attributedText 需要继承 JDLTMutableAttributedString 翻译
            if ([text containsString:@"%d"]) {
                text = [NSString stringWithFormat:[JDLTTranslateManager translateText:text], 1];
            }
            else if ([text containsString:@"%@"]) {
                text = [NSString stringWithFormat:[JDLTTranslateManager translateText:text], @"我也是服务器数据"];
            }
            
            [cell.button setTitle:text forState:UIControlStateNormal];
        }
        return cell;
    }
    else if ([titleForHeaderInSection hasPrefix:@"UIButton.setAttributedTitle"]) {
        UIButtonCell *cell = (UIButtonCell *)[tableView dequeueReusableCellWithIdentifier:@"UIButtonCell2"];
        
        if ([sections.allValues.firstObject isKindOfClass:NSArray.class]) {
            NSArray *rowDatas = (NSArray *)sections.allValues.firstObject;
            NSString *text = rowDatas[indexPath.row];
            
            // attributedText 需要继承 JDLTMutableAttributedString 翻译
            if ([text containsString:@"%d"]) {
                text = [NSString stringWithFormat:[JDLTTranslateManager translateText:text], 1];
            }
            else if ([text containsString:@"%@"]) {
                text = [NSString stringWithFormat:[JDLTTranslateManager translateText:text], @"我也是服务器数据"];
            }
            JDLTMutableAttributedString *attributedString = [self defaultAttributedString:text];
            [cell.button setAttributedTitle:attributedString forState:UIControlStateNormal];
        }
        return cell;
    }
    else if ([titleForHeaderInSection hasPrefix:@"UITextView.text"]) {
        UITextViewCell *cell = (UITextViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UITextViewCell"];
        
        if ([sections.allValues.firstObject isKindOfClass:NSArray.class]) {
            NSArray *rowDatas = (NSArray *)sections.allValues.firstObject;
            NSString *text = rowDatas[indexPath.row];
            
            // attributedText 需要继承 JDLTMutableAttributedString 翻译
            if ([text containsString:@"%d"]) {
                text = [NSString stringWithFormat:[JDLTTranslateManager translateText:text], 1];
            }
            else if ([text containsString:@"%@"]) {
                text = [NSString stringWithFormat:[JDLTTranslateManager translateText:text], @"我也是服务器数据"];
            }
            cell.textView.text = text;
        }
        return cell;
    }
    else if ([titleForHeaderInSection hasPrefix:@"UITextView.attributedText"]) {
        UITextViewCell *cell = (UITextViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UITextViewCell2"];
        
        if ([sections.allValues.firstObject isKindOfClass:NSArray.class]) {
            NSArray *rowDatas = (NSArray *)sections.allValues.firstObject;
            NSString *text = rowDatas[indexPath.row];
            
            // attributedText 需要继承 JDLTMutableAttributedString 翻译
            if ([text containsString:@"%d"]) {
                text = [NSString stringWithFormat:[JDLTTranslateManager translateText:text], 1];
            }
            else if ([text containsString:@"%@"]) {
                text = [NSString stringWithFormat:[JDLTTranslateManager translateText:text], @"我也是服务器数据"];
            }
            JDLTMutableAttributedString *attributedString = [self defaultAttributedString:text];
            cell.textView.attributedText = attributedString;
        }
        return cell;
    }
    else if ([titleForHeaderInSection hasPrefix:@"UITextField.text"]) {
        UITextFieldCell *cell = (UITextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"UITextFieldCell"];
        
        if ([sections.allValues.firstObject isKindOfClass:NSArray.class]) {
            NSArray *rowDatas = (NSArray *)sections.allValues.firstObject;
            NSString *text = rowDatas[indexPath.row];
            
            // attributedText 需要继承 JDLTMutableAttributedString 翻译
            if ([text containsString:@"%d"]) {
                text = [NSString stringWithFormat:[JDLTTranslateManager translateText:text], 1];
            }
            else if ([text containsString:@"%@"]) {
                text = [NSString stringWithFormat:[JDLTTranslateManager translateText:text], @"我也是服务器数据"];
            }
            cell.textField.text = text;
        }
        return cell;
    }
    else if ([titleForHeaderInSection hasPrefix:@"UITextField.attributedText"]) {
        UITextFieldCell *cell = (UITextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"UITextFieldCell2"];
        
        if ([sections.allValues.firstObject isKindOfClass:NSArray.class]) {
            NSArray *rowDatas = (NSArray *)sections.allValues.firstObject;
            NSString *text = rowDatas[indexPath.row];
            
            // attributedText 需要继承 JDLTMutableAttributedString 翻译
            if ([text containsString:@"%d"]) {
                text = [NSString stringWithFormat:[JDLTTranslateManager translateText:text], 1];
            }
            else if ([text containsString:@"%@"]) {
                text = [NSString stringWithFormat:[JDLTTranslateManager translateText:text], @"我也是服务器数据"];
            }
            JDLTMutableAttributedString *attributedString = [self defaultAttributedString:text];
            cell.textField.attributedText = attributedString;
        }
        return cell;
    }
    
    return cell;
}


- (JDLTMutableAttributedString *)defaultAttributedString:(NSString *)text {
    JDLTMutableAttributedString *attributedString = [[JDLTMutableAttributedString alloc] initWithString:text attributes:@{}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString.string length])];
    [attributedString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [attributedString.string length])];
    return attributedString;
}


@end
