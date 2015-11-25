//
//  FilesTableViewController.h
//  putio-atv
//
//  Created by Anthony May on 16/11/2015.
//  Copyright © 2015 The Means. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class CategoriesTableViewController;
//@class FileCategory;

@protocol FilesTableViewControllerDelegate <NSObject>

//- (void)filesTableViewController:(FilesTableViewController *)controller didSelectCategory:(FileCategory *)category;

@end

@interface FilesTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *files;
@property (nonatomic, weak) id <FilesTableViewControllerDelegate> delegate;

@end
