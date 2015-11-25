//
//  FileCollectionViewCell.m
//  putio-atv
//
//  Created by Anthony May on 17/11/2015.
//  Copyright © 2015 The Means. All rights reserved.
//

#import "FileCollectionViewCell.h"
#import "UIColor+Putio.h"

@implementation FileCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.imageView = [[AsyncImageView alloc] init];
        self.imageView.adjustsImageWhenAncestorFocused = YES;
        self.imageView.clipsToBounds = false;
        [self.contentView addSubview:self.imageView];
        
        self.textLabel = [UILabel new];
        self.textLabel.text = @"File Name";
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont boldSystemFontOfSize:28];
        [self.contentView addSubview:self.textLabel];
        
        self.detailLabel = [UILabel new];
        self.detailLabel.text = @"File Subtitle";
        self.detailLabel.textColor = [UIColor lightGrayColor];
        self.detailLabel.textAlignment = NSTextAlignmentCenter;
        self.detailLabel.font = [UIFont systemFontOfSize:24];
        self.detailLabel.alpha = 0;
        [self.contentView addSubview:self.detailLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat padding = 60;
    CGFloat width = self.contentView.bounds.size.width;
    CGFloat height = self.contentView.bounds.size.height;
    
    self.imageView.frame = CGRectMake(padding, padding, width - (padding * 2), height - (padding * 2));
    
    CGFloat imageOffsetY = self.imageView.focusedFrameGuide.layoutFrame.size.height + padding;
    
    self.textLabel.frame = CGRectMake(0, imageOffsetY, width, 30);
    self.detailLabel.frame = CGRectMake(0, imageOffsetY + 30, width, 30);
}

- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
{
    [coordinator addCoordinatedAnimations:^{
        
        if (self.focused) {
            self.textLabel.textColor = [UIColor putioPrimaryColor];
            self.detailLabel.alpha = 1.0;
        } else {
            self.textLabel.textColor = [UIColor whiteColor];
            self.detailLabel.alpha = 0.0;
        }
        
    } completion:nil];
}

@end
