//
//  FileDetailViewController.h
//  putio-atv
//
//  Created by Anthony May on 21/11/2015.
//  Copyright © 2015 The Means. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "File.h"
#import "AsyncImageView.h"
#import "FileCollectionView.h"

@interface FileDetailViewController : UIViewController

@property (nonatomic, strong) AsyncImageView *backgroundImageView;
@property (nonatomic, strong) UIVisualEffectView *backgroundVisualEffectView;
@property (nonatomic, strong) File *file;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *descriptionButton;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) AsyncImageView *thumbnailImageView;

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *convertButton;
@property (nonatomic, strong) UIButton *audioDescribedButton;
@property (nonatomic, strong) FileCollectionView *relatedEpisodeView;

- (instancetype)initWithFile:(File *)file;

@end
