//
//  LeftMenuTableViewCell.h
//  GQBack4iPhone
//
//  Created by ztt on 15/10/27.
//  Copyright © 2015年 ztt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenuTableViewCellData.h"
//@interface LeftMenuTableViewCellData:NSObject
//
//@property (nonatomic,strong)   NSArray * cellTitles;
//
//@end



@interface LeftMenuTableViewCell : UITableViewCell

@property (nonatomic,strong)   UIImageView * imageview;
@property (nonatomic,strong)   UILabel * label;
@property (nonatomic,strong)   UIImageView * baseLine;
//@property (nonatomic,strong)   LeftMenuTableViewCellData * cellData;
//@property (nonatomic,copy)   void (^initBlock)(UITableViewCell *);

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath cellData:(LeftMenuTableViewCellData *)cellData;
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier block: (void(^)(UITableViewCell * cell))block;
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier block:(cellblock)block ;
@end

