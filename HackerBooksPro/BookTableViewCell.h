//
//  BookTableViewCell.h
//  HackerBooksPro
//
//  Created by Edu González on 20/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Book;

@interface BookTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

+(NSString *)cellId;

-(void)observeBook:(Book *)book;

+(CGFloat)cellHeight;

@end
