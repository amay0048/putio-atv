//
//  FolderViewController.m
//  putio-atv
//
//  Created by Anthony May on 16/11/2015.
//  Copyright © 2015 The Means. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryMetaInfoViewController.h"
#import "FilesTableViewController.h"

#import "UIColor+Putio.h"
#import "PutioController.h"

@interface CategoryViewController () <FilesTableViewControllerDelegate>

@property (nonatomic, strong) FilesTableViewController *filesTableViewController;
@property (nonatomic, strong) CategoryMetaInfoViewController *filesViewController;

@end

@implementation CategoryViewController

- (instancetype)init
{
    if (self = [super init]) {
        
        self.title = @"Browse";
        
        self.filesViewController = [CategoryMetaInfoViewController new];
        self.filesViewController.collectionView.numberOfFilesPerRow = 2;
        
        self.filesTableViewController = [FilesTableViewController new];
        self.filesTableViewController.delegate = self;
        
        self.viewControllers = @[self.filesTableViewController, self.filesViewController];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor putioSecondaryColor];
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
