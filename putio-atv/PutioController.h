//
//  PutioController.h
//  putio-atv
//
//  Created by Anthony May on 17/11/2015.
//  Copyright © 2015 The Means. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"

@interface PutioController : NSObject

+ (PutioController *)sharedController;

typedef void (^ContentCompletion)(NSArray *content, NSError *error);
typedef void (^ContentURLCompletion)(NSURL *fileURL, NSError *Error);

- (void)getFileList:(File *)parentFile withCompletion:(ContentCompletion)completion;
- (void)getAVPlayerURL:(File *)parentFile withCompletion:(ContentURLCompletion)completion;
- (void)getFilesForSearchTerm:(NSString *)searchString withCompletion:(ContentCompletion)completion;

@end
