//
//  FileCollectionViewCell.h
//  putio-atv
//
//  Created by Anthony May on 17/11/2015.
//  Copyright © 2015 The Means. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface FileCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) AsyncImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end
