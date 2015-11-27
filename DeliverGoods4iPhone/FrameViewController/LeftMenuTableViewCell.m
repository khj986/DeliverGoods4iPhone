//
//  LeftMenuTableViewCell.m
//  GQBack4iPhone
//
//  Created by ztt on 15/10/27.
//  Copyright © 2015年 ztt. All rights reserved.
//
#import "Prefix.h"
#import "LeftMenuTableViewCell.h"
#import "CPSwitchVew.h"
//#import "CustomButton.h"

@implementation LeftMenuTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath cellData:(LeftMenuTableViewCellData *)cellData
{
    NSArray *labelList = [NSArray arrayWithObjects:@"形状-36", @"形状-37",@"update",@"形状-38",nil];
   // _cellData = cellData;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        
//        if( indexPath.row  == 3){
//            
//            [self setUpExitButton];
//            
//            return self ;
//        }
        
        _label = [[UILabel alloc]init];

        _imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:labelList[indexPath.row]]];
        _baseLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"矩形-6-拷贝"]];
        [self.contentView addSubview:_imageview];
        [self.contentView addSubview:_label];
        [self.contentView addSubview:_baseLine];
       
        [_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(MasonryRight(self.contentView)).multipliedBy(0.11);
            make.centerY.mas_equalTo(MasonryBottom(self.contentView)).multipliedBy(0.45);
            make.width.height.mas_equalTo(MasonryHeight(self.contentView)).multipliedBy(0.5);
        }];
        
        
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(MasonryRight(self.contentView)).multipliedBy(0.25);
            make.centerY.mas_equalTo(MasonryBottom(self.contentView)).multipliedBy(0.45);
            make.height.mas_equalTo(MasonryHeight(self.contentView)).multipliedBy(0.6);
            make.width.mas_equalTo(MasonryWidth(self.contentView)).multipliedBy(0.5);
        }];
        
        [_baseLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imageview);
            make.right.mas_equalTo(MasonryRight(self.contentView)).multipliedBy(0.8);
            make.top.mas_equalTo(MasonryBottom(self.contentView)).multipliedBy(0.9);
            make.height.equalTo(1);
            
        }];
        
        [_label setNeedsDisplay];
        [_label layoutIfNeeded];
        
        _label.text = cellData.cellTitles[indexPath.row];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont fontWithName:nil size:[_label.text fontSizeSingleLineFitsRect:_label.frame attributes:nil]];
        
//        if( indexPath.row == 0 ){
//
//            [self setUpInfoSwitch];
//
//        }

    }
    
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier block: (void(^)(UITableViewCell * cell))block{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        block(self);
    }
    return self;
}

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier block:(cellblock)block{
//    self initWithStyle:style reuseIdentifier:reuseIdentifier indexPath:block cellData:<#(LeftMenuTableViewCellData *)#>
//}

//-(void) setUpExitButton{
//    CustomButton * exitButton = [CustomButton buttonWithType:UIButtonTypeCustom];
//    //CustomButton * exitButton = [[CustomButton alloc]init];
//    UIImage * img = [UIImage imageNamed:@"圆角矩形-27-拷贝-3"];
//    CGSize imgSize = img.size;
//
//    [self.contentView addSubview:exitButton];
//
//    [exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(MasonryHeight(self.contentView)).multipliedBy(0.8);
//        make.width.mas_equalTo(exitButton.height).multipliedBy(imgSize.width/imgSize.height);
//        make.bottom.mas_equalTo(self.contentView);
//        make.centerX.mas_equalTo(MasonryRight(self.contentView)).multipliedBy(0.45);
//    }];
//    
//    [exitButton setNeedsDisplay];
//    [exitButton layoutIfNeeded];
//    [exitButton setBackgroundImage:img forState:UIControlStateNormal];
//    [exitButton setImage:[UIImage imageNamed:@"圆角矩形-27-拷贝-2"] forState:UIControlStateNormal];
//    //exitButton.adjustsImageWhenHighlighted = YES;
//    [exitButton setTitle:@"注销并退出" forState:UIControlStateNormal];
//    exitButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    exitButton.titleLabel.textColor = [UIColor whiteColor];
//    exitButton.titleLabel.font = [UIFont fontWithName:nil size:[exitButton.titleLabel.text fontSizeSingleLineFitsRect:exitButton.titleLabel.frame attributes:nil]];
//    exitButton.showsTouchWhenHighlighted = YES;
//
//}

-(void) setUpInfoSwitch{
    // CPSwitchVew *switchView = [[CPSwitchVew alloc]initWithFrame:CGRectMake(self.contentView.bounds.size.width*0.6,self.contentView.bounds.size.height*0.05,89,62)];
    CPSwitchVew *switchView = [[CPSwitchVew alloc]init];
    
    
    [self.contentView addSubview:switchView];
    UIImage * img = [UIImage imageNamed:@"on"];
    
    
    [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        //                make.right.mas_equalTo(_baseLine);
        //                make.centerY.mas_equalTo(MasonryBottom(self.contentView)).multipliedBy(0.45);
        //                make.height.mas_equalTo(MasonryHeight(self.contentView)).multipliedBy(0.6);
        //                make.width.mas_equalTo(MasonryHeight(self.contentView)).multipliedBy(1);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(MasonryRight(self.contentView)).multipliedBy(0.8);
        make.height.mas_equalTo( MasonryHeight(self.contentView));
        make.width.mas_equalTo(switchView.height).multipliedBy(img.size.width/img.size.height);
    }];
    [switchView setNeedsLayout];
    [switchView layoutIfNeeded];
    
    CGRect rect = switchView.frame;
    [switchView removeFromSuperview];
    
    CPSwitchVew *switchView2 = [[CPSwitchVew alloc]initWithFrame:rect];
    
    [switchView2 setOnBackImage:img];
    [switchView2 setOffBackImage:[UIImage imageNamed:@"off"]];
    [switchView2 addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [switchView2 setOn:YES];
    [self.contentView addSubview:switchView2];
}

-(void)switchChanged:(id)sender{
    NSLog(@"change!");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
