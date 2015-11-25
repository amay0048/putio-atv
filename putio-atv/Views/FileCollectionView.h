//
//  FileCollectionView.h
//  putio-atv
//
//  Created by Anthony May on 16/11/2015.
//  Copyright © 2015 The Means. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FileCollectionView;
@class File;

@protocol FileCollectionViewDelegate <NSObject>

- (void)fileCollectionView:(FileCollectionView *)view didSelectFile:(File *)file;

@end

@interface FileCollectionView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionLayout;
@property (nonatomic, assign) NSInteger numberOfFilesPerRow;
@property (nonatomic, weak) id <FileCollectionViewDelegate> delegate;

@property (nonatomic, strong) NSArray *files;

@end