//
//  BrowseFilesViewController.m
//  putio-atv
//
//  Created by Anthony May on 17/11/2015.
//  Copyright © 2015 The Means. All rights reserved.
//

#import "BrowseFilesViewController.h"
#import "File.h"
#import "MetaInfoController.h"

@interface BrowseFilesViewController ()

@end

@implementation BrowseFilesViewController

- (instancetype)init
{
    if (self = [super init]) {
        
        self.title = @"Browse";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refresh];
}

- (void)viewDidAppear
{
    
//    [super viewDidLoad];
    
//    [self refresh];
}

- (void)refresh
{
    [self.activityIndicatorView startAnimating];
    
    File *root = [[File alloc] initAsRoot];
    
    [[PutioController sharedController] getFileList:root withCompletion:^(NSArray *files, NSError *error) {
        
        [self.activityIndicatorView stopAnimating];
        
        self.files = files;
        self.collectionView.files = files;
        
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
