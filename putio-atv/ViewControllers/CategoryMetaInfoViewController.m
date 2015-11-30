//
//  CategoryMetaInfoViewController.m
//  putio-atv
//
//  Created by Anthony May on 29/11/2015.
//  Copyright © 2015 The Means. All rights reserved.
//

#import "CategoryMetaInfoViewController.h"
#import "File.h"
#import "FileDetailViewController.h"

@interface CategoryMetaInfoViewController ()

@end

@implementation CategoryMetaInfoViewController

- (instancetype)init
{
    if (self = [super init]) {
        
        self.title = @"Files";
//        self.collectionView = [[FileCollectionView alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refresh];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    self.collectionView.frame = self.view.bounds;
}

- (void)fileCollectionView:(FileCollectionView *)view didSelectFile:(File *)file
{
    if ([file.title isEqualToString:@"root"]) {
        [self refresh];
        return;
    }
    
    File *root = [[File alloc] initAsRoot];
    NSMutableArray *current = [[NSMutableArray alloc] init];
    [current addObject:root];
    [current addObjectsFromArray:[file.children allValues]];
    
    self.files = current;
    self.collectionView.files = current;

}

- (void)refresh
{
    [self.activityIndicatorView startAnimating];
    
    File *root = [[File alloc] initAsRoot];
    
    [[PutioController sharedController] getFileList:root withCompletion:^(NSArray *files, NSError *error) {
        
        [[MetaInfoController sharedController] getMetaCollectionFromFileCollection:files withCompletion:^(NSDictionary *content, NSError *error){
            
            [self.activityIndicatorView stopAnimating];
            
            NSArray *files = [content allValues];
            
            self.files = files;
            self.collectionView.files = files;
        }];
        
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
