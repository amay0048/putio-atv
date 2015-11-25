//
//  TraktController.h
//  putio-atv
//
//  Created by Anthony May on 22/11/2015.
//  Copyright © 2015 The Means. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"

@interface TraktController : NSObject

+ (TraktController *)sharedController;

typedef void (^ContentDictionaryCompletion)(NSDictionary *content, NSError *error);
typedef void (^ContentURLCompletion)(NSURL *fileURL, NSError *Error);

- (void)getFileMetadata:(File *)parentFile withCompletion:(ContentDictionaryCompletion)completion;

@end
