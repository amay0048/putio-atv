//
//  FilesViewController.m
//  putio-atv
//
//  Created by Anthony May on 16/11/2015.
//  Copyright © 2015 The Means. All rights reserved.
//


#import "FilesViewController.h"
#import "File.h"
#import "FileDetailViewController.h"

@interface FilesViewController ()

@end

@implementation FilesViewController

- (instancetype)init
{
    if (self = [super init]) {
        
        self.title = @"Files";
        self.collectionView = [[FileCollectionView alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
}

- (void)fileCollectionView:(FileCollectionView *)view didSelectFile:(File *)file
{
    
    if ([file.subtitle isEqualToString:[file getFolderTypeString]] || [file.subtitle isEqualToString:[file getParentTypeString]]) {
        [self.activityIndicatorView startAnimating];
        [self.view bringSubviewToFront:self.activityIndicatorView];
        
        [[PutioController sharedController] getFileList:file withCompletion:^(NSArray *files, NSError *error) {
            
            if(error)
            {
                NSArray *rootFileOnly = @[[[File alloc] initAsRoot]];
                self.files = rootFileOnly;
                self.collectionView.files = rootFileOnly;
            }
            
            [self.activityIndicatorView stopAnimating];
            
            self.files = files;
            self.collectionView.files = files;
            
        }];
    } else {
        
        FileDetailViewController *viewController = [[FileDetailViewController alloc] initWithFile:file];
        [self presentViewController:viewController animated:YES completion:nil];
        
    }
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
