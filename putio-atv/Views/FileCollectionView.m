//
//  FileCollectionView.m
//  putio-atv
//
//  Created by Anthony May on 16/11/2015.
//  Copyright © 2015 The Means. All rights reserved.
//

#import "FileCollectionView.h"
#import "FileCollectionViewCell.h"

#import "File.h"

@interface FileCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation FileCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    if (self = [super init]) {
        
        self.collectionLayout = [[UICollectionViewFlowLayout alloc] init];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[FileCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        
        [self addSubview:self.collectionView];
        
        self.numberOfFilesPerRow = 3;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

- (void)setFiles:(NSArray *)files
{
    [super willChangeValueForKey:@"files"];
    _files = files;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.collectionView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [self.collectionView reloadData];
        self.collectionView.contentOffset = CGPointZero;
        // HACK: For some reason calling animateCellsIn immediatly after reload doesn't return visiblecells
        [self performSelector:@selector(animateCellsIn) withObject:nil afterDelay:0.000001];
        
    }];
    
    [self didChangeValueForKey:@"files"];
}

#pragma mark - Collection view delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.files.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    File *file = self.files[indexPath.row];
    FileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

//    cell.textLabel.text = @"Title";
//    cell.detailLabel.text = @"Subtitle";
    
    cell.textLabel.text = file.title;
    cell.detailLabel.text = file.subtitle;
    cell.imageView.image = [UIImage imageNamed:@"file-thumbnail-placeholder"];
    
//    [cell.imageView setImageURL:file.thumbnailURL];
    
    return cell;
}

#pragma mark - Collection view flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.bounds.size.width / self.numberOfFilesPerRow;
    CGFloat height = width / 16 * 9;
    
    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    File *file = self.files[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(fileCollectionView:didSelectFile:)]) {
        [self.delegate fileCollectionView:self didSelectFile:file];
    }
}

- (void)animateCellsIn
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"layer.position.y" ascending:YES];
    NSArray *orderedCells = [self.collectionView.visibleCells sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    // Hide all cells
    [orderedCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.alpha = 0.0;
        obj.transform = CGAffineTransformMakeTranslation(0, 100);
    }];
    
    self.collectionView.alpha = 1.0;
    
    /// ...and like S Club 7, bring it all back...
    [orderedCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [UIView animateWithDuration:0.8 delay:0.05 * idx usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:kNilOptions animations:^{
            
            obj.alpha = 1.0;
            obj.transform = CGAffineTransformMakeTranslation(0, 0);
            
        } completion:nil];
    }];
}


@end
