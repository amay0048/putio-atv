//
//  SearchFilesViewController.h
//  putio-atv
//
//  Created by Anthony May on 16/11/2015.
//  Copyright © 2015 The Means. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PutioViewController.h"
#import "FilesViewController.h"

@interface SearchFilesViewController : FilesViewController <UISearchControllerDelegate, UISearchResultsUpdating>;

@end
