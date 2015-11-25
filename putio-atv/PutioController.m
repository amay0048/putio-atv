//
//  PutioController.m
//  putio-atv
//
//  Created by Anthony May on 17/11/2015.
//  Copyright © 2015 The Means. All rights reserved.
//

#import "PutioController.h"

@import ThunderRequestTV;

@interface PutioController ()

@property (nonatomic, strong) TSCRequestController *filesListRequestController;
@property (nonatomic, strong) TSCRequestController *fileStreamRequestController;
@property (nonatomic, strong) TSCRequestController *searchFilesRequestController;
@property (nonatomic, strong) TSCRequestController *mpfourUrlRequestController;

@end

@implementation PutioController

+ (PutioController *)sharedController
{
    static PutioController *sharedController;
    
    @synchronized(self) {
        if (sharedController == nil) {
            sharedController = [self new];
        }
    }
    
    return sharedController;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.filesListRequestController = [[TSCRequestController alloc] initWithBaseAddress:@"https://api.put.io/v2/files/list/"];
        self.mpfourUrlRequestController = [[TSCRequestController alloc] initWithBaseAddress:@"https://put.io/v2/files/(:fileId)"];
        self.searchFilesRequestController = [[TSCRequestController alloc] initWithBaseAddress:@"https://put.io/v2/files/search"];
        
    }
    return self;
}

- (void)getFileList:(File *)parentFile withCompletion:(ContentCompletion)completion
{
    
    NSString *route = [[parentFile.identifier stringValue] stringByAppendingString:@"?oauth_token=IK4Q6CE2"];
    
    [self.filesListRequestController get:route withURLParamDictionary:nil completion:^(TSCRequestResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(nil, error);
            return;
        }
        
//        @"file_type"
//        @"id"
//        @"is_mp4_available"
//        @"screenshot"
//        @"crc32"
//        @"parent_id"
//        @"created_at"
//        @"content_type"
//        @"first_accessed_at"
//        @"is_shared"
//        @"size"
//        @"icon"
//        @"extension"
//        @"opensubtitles_hash"
//        @"name"
        
        NSArray *filesArray = response.dictionary[@"files"];
        NSMutableArray *files = [NSMutableArray array];
        
        if(![parentFile.identifier isEqualToNumber:@0])
        {
            File *parent = [[File alloc] initWithDictionary:@{@"id":parentFile.parentIdentifier,@"parent_id":@0,@"name":@"..",@"content_type":@"application/x-directory"}];
            [files addObject:parent];
        }
        
//        NSArray *keys = [fileItem allKeys];
        
        for (NSDictionary *fileItem in filesArray) {
            
            File *fileObject = [[File alloc] initWithDictionary:fileItem];
            [files addObject:fileObject];
            
//            if ([fileeItem[@"type"] isEqualToString:@"group_large"]) {
//
//                NSArray *children = episodeItem[@"initial_children"];
//
//
//            } else {
//                
//                Episode *episodeObject = [[Episode alloc] initWithDictionary:episodeItem];
//                
//                if (episodeObject.subtitle) {
//                    [episodes addObject:episodeObject];
//                }
//                
//            }
            
        }
        
        if (completion) {
            completion(files, nil);
        }
    }];
}

- (void)getAVPlayerURL:(File *)parentFile withCompletion:(ContentURLCompletion)completion
{
    
    NSString *route = parentFile.mpfourRoute;
    
    [self.mpfourUrlRequestController head:route withURLParamDictionary:@{@"fileId":parentFile.identifier} completion:^(TSCRequestResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        if (completion) {
            completion(response.HTTPResponse.URL, nil);
        }
    }];
}

- (void)getFilesForSearchTerm:(NSString *)searchString withCompletion:(ContentCompletion)completion
{
    if([searchString length] == 0)
    {
        completion(@[],nil);
        return;
    }
    
    NSString *searchRoute = [[searchString stringByAppendingString:@" type:iphone"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *route = [searchRoute stringByAppendingString:@"?oauth_token=IK4Q6CE2"];
    
    [self.searchFilesRequestController get:route withURLParamDictionary:nil completion:^(TSCRequestResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSArray *filesArray = [response.dictionary valueForKey:@"files"];
        NSMutableArray *files = [[NSMutableArray alloc] init];
        
        for (NSDictionary *fileItem in filesArray) {
            File *fileObject = [[File alloc] initWithDictionary:fileItem];
            [files addObject:fileObject];
        }
        
        if (completion) {
            completion(files, nil);
        }
    }];
}

@end
