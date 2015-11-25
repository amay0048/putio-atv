//
//  FilesViewController.h
//  putio-atv
//
//  Created by Anthony May on 16/11/2015.
//  Copyright © 2015 The Means. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PutioViewController.h"
#import "FileCollectionView.h"

@import AVFoundation;
@import AVKit;

@interface FilesViewController : PutioViewController <FileCollectionViewDelegate>

@property (nonatomic, strong) FileCollectionView *collectionView;
@property (nonatomic, strong) NSArray *files;

@end
