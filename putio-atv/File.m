//
//  File.m
//  putio-atv
//
//  Created by Anthony May on 19/11/2015.
//  Copyright © 2015 The Means. All rights reserved.
//

#import "File.h"
#import "NSDate+Tools.h"

@implementation File

- (NSString *)getfolderTypeString
{
        return @"application/x-directory";
}

- (NSString *)getMpfourTypeString
{
    return @"video/mp4";
}

- (instancetype)initAsRoot
{
    self = [super init];
    
    self.identifier = @0;
    self.parentIdentifier = @0;
    self.title = @"root";
    self.subtitle = @"application/x-directory";
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            
            if (dictionary[@"id"] && [dictionary[@"id"] isKindOfClass:[NSNumber class]]) {
                
                self.identifier = dictionary[@"id"];
                
            }
            
            if (dictionary[@"parent_id"] && [dictionary[@"parent_id"] isKindOfClass:[NSNumber class]]) {
                
                self.parentIdentifier = dictionary[@"parent_id"];
                
            }
            
            
            if (dictionary[@"is_mp4_available"] && [dictionary[@"is_mp4_available"] isKindOfClass:[NSNumber class]]) {
                
                self.mpfour = dictionary[@"is_mp4_available"];
                
                if(![self.mpfour isEqualToNumber:@0])
                {
                    NSString *urlString = [NSString stringWithFormat:@"https://put.io/v2/files/%@/mp4/stream%@", dictionary[@"id"], @"?token=IK4Q6CE2"];
                    self.mpfourURL = [NSURL URLWithString:urlString];
                    self.mpfourRoute = @"mp4/stream?oauth_token=IK4Q6CE2";
                }
                
            }
            
            if (dictionary[@"name"] && [dictionary[@"name"] isKindOfClass:[NSString class]]) {
                
                self.title = dictionary[@"name"];
                
            }
            
            if (dictionary[@"content_type"] && [dictionary[@"content_type"] isKindOfClass:[NSString class]]) {
                
                self.subtitle = dictionary[@"content_type"];
                
                if([dictionary[@"content_type"] isEqualToString:[self getMpfourTypeString]])
                {
                    self.mpfour = @1;
                    NSString *urlString = [NSString stringWithFormat:@"https://put.io/v2/files/%@/stream%@", dictionary[@"id"], @"?token=IK4Q6CE2"];
                    self.mpfourURL = [NSURL URLWithString:urlString];
                    self.mpfourRoute = @"stream?oauth_token=IK4Q6CE2";
                }
                
            }
            
            if (dictionary[@"images"] && [dictionary[@"images"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *imageDictionary = dictionary[@"images"];
                
                if (imageDictionary[@"standard"] && [imageDictionary[@"standard"] isKindOfClass:[NSString class]]) {
                    
                    NSString *urlString = [imageDictionary[@"standard"] stringByReplacingOccurrencesOfString:@"{recipe}" withString:@"1344x756"];
                    self.thumbnailURL = [NSURL URLWithString:urlString];
                    
                }
                
            }
            
            if (dictionary[@"synopses"] && [dictionary[@"synopses"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *synopsesDictionary = dictionary[@"synopses"];
                
                if (synopsesDictionary[@"small"] && [synopsesDictionary[@"small"] isKindOfClass:[NSString class]]) {
                    
                    self.shortDescription = synopsesDictionary[@"small"];
                    
                }
                
            }
            
            if (dictionary[@"synopses"] && [dictionary[@"synopses"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *synopsesDictionary = dictionary[@"synopses"];
                
                if (synopsesDictionary[@"medium"] && [synopsesDictionary[@"medium"] isKindOfClass:[NSString class]]) {
                    
                    self.mediumDescription = synopsesDictionary[@"medium"];
                    
                }
                
            }
            
            if (dictionary[@"synopses"] && [dictionary[@"synopses"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *synopsesDictionary = dictionary[@"synopses"];
                
                if (synopsesDictionary[@"large"] && [synopsesDictionary[@"large"] isKindOfClass:[NSString class]]) {
                    
                    self.longDescription = synopsesDictionary[@"large"];
                    
                }
                
            }
            
            if (dictionary[@"release_date_time"] && [dictionary[@"release_date_time"] isKindOfClass:[NSString class]]) {
                
                self.releaseDate = [NSDate dateWithISO86SomethingString:dictionary[@"release_date_time"]];
                
            }
            
            if (dictionary[@"versions"] && [dictionary[@"versions"] isKindOfClass:[NSArray class]]) {
                
                NSMutableArray *versionArray = [NSMutableArray array];
                
                for (NSDictionary *versionDictionary in dictionary[@"versions"]) {
                    
//                    EpisodeVersion *aVersion = [[EpisodeVersion alloc] initWithDictionary:versionDictionary];
//                    [versionArray addObject:aVersion];
                    
                }
                
                self.versions = versionArray;
                
            }
            
            if (dictionary[@"initial_children"] && [dictionary[@"initial_children"] isKindOfClass:[NSArray class]]) {
                
                NSArray *children = dictionary[@"initial_children"];
                NSDictionary *episodeInfo = children.firstObject;
                
                if (episodeInfo) {
                    
                    NSMutableArray *versionArray = [NSMutableArray array];
                    
                    for (NSDictionary *versionDictionary in episodeInfo[@"versions"]) {
                        
//                        EpisodeVersion *aVersion = [[EpisodeVersion alloc] initWithDictionary:versionDictionary];
//                        [versionArray addObject:aVersion];
                        
                    }
                    
                    self.versions = versionArray;
                    
                }
                
            }
            
            
        }
        
        
    }
    return self;
}

@end

