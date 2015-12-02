//
//  TraktController.m
//  putio-atv
//
//  Created by Anthony May on 22/11/2015.
//  Copyright © 2015 The Means. All rights reserved.
//

#import "MetaInfoController.h"
#import "File.h"

@import ThunderRequestTV;

@interface MetaInfoController ()

@property (nonatomic, strong) TSCRequestController *showMetaRequestController;
@property (nonatomic, strong) TSCRequestController *episodeMetaRequestController;

@end

@implementation MetaInfoController

+ (MetaInfoController *)sharedController
{
    static MetaInfoController *sharedController;
    
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
        
        NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithDictionary:@{@"Content-Type":@"application/json",@"trakt-api-version":@"2",@"trakt-api-key":@"a6215a99caf6e7766a6655ac180a1d1cee7ee7c06c400e8fd27fa0e44bfb1325"}];
        
        self.showMetaRequestController = [[TSCRequestController alloc] initWithBaseAddress:@"https://api-v2launch.trakt.tv/search"];
        self.showMetaRequestController.sharedRequestHeaders = headers;
        
        self.episodeMetaRequestController = [[TSCRequestController alloc] initWithBaseAddress:@"https://api-v2launch.trakt.tv/shows/(:id)/seasons/(:season)/episodes"];
        self.episodeMetaRequestController.sharedRequestHeaders = headers;
        
        
    }
    return self;
}

- (void)getMetaCollectionFromFileCollection:(NSArray<File *> *)filesArray withCompletion:(ContentDictionaryCompletion)completion
{
    NSMutableDictionary *seasonsChildren = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *moviesChildren = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *otherChildren = [[NSMutableDictionary alloc] init];
    
    for (File *fileItem in filesArray) {
        NSDictionary *seasonInfo = [self getSeasonInfoFromFilename:fileItem.title];
        NSString *movieInfo = [self getMovieInfoFromFilename:fileItem.title];
        
        if([seasonInfo valueForKey:@"seasonName"]){
            
            
            // Get Existing Values if they exist
            File *season = [seasonsChildren valueForKey:[seasonInfo valueForKey:@"seasonName"]];
            // If the season doesn't exit, then create it
            if(season == nil)
            {
                season = [[File alloc] initAsParentWithName:[seasonInfo valueForKey:@"seasonName"]];
            }
            
            File *seasonNumber = [[season getChildren] valueForKey:[seasonInfo valueForKey:@"seasonNumber"]];;
            // If the season number doesn't exist, create it
            if(seasonNumber == nil)
            {
                NSString *seasonTitle = [NSString stringWithFormat:@"Season %@",[seasonInfo valueForKey:@"seasonNumber"]];
                seasonNumber = [[File alloc]  initAsParentWithName:seasonTitle];
                [season setObject:seasonNumber forChildKey:[seasonInfo valueForKey:@"seasonNumber"]];
            }
            
            // Build the new object into the existing structure
            NSString *key = [seasonInfo valueForKey:@"episodeNumber"];
            
            [seasonNumber setObject:fileItem forChildKey:key];
            [seasonsChildren setValue:season forKey:[seasonInfo valueForKey:@"seasonName"]];
        }
        else if([movieInfo length])
        {
            // Add to movie structure
            [moviesChildren setObject:fileItem forKey:movieInfo];
            
        }
        else
        {
            [otherChildren setObject:fileItem forKey:fileItem.title];
        }
    }
    
    NSString *parentString = [[[File alloc] init] getParentTypeString];
    
    File *seasons = [[File alloc] initWithDictionary:@{@"name":@"Seasons",@"content_type":parentString}];
    File *movies = [[File alloc] initWithDictionary:@{@"name":@"Movies",@"content_type":parentString}];
    File *other = [[File alloc] initWithDictionary:@{@"name":@"Other",@"content_type":parentString}];
    seasons.children = seasonsChildren;
    movies.children = moviesChildren;
    other.children = otherChildren;
    NSDictionary *fileCollection = @{@"seasons":seasons,@"movies":movies,@"other":other};
    
    completion(fileCollection, nil);
}

- (void)getFileMetadata:(File *)parentFile withCompletion:(ContentDictionaryCompletion)completion
{
    
    NSDictionary *seasonInfo = [self getSeasonInfoFromFilename:parentFile.title];
    
    NSString *baseRoute = @"?type=show&query=";
    NSString *escapedTitle = @"";
    
    if([seasonInfo valueForKey:@"seasonName"])
    {
        escapedTitle = [[seasonInfo valueForKey:@"seasonName"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    }
    else
    {
        NSString *movieName = [self getMovieInfoFromFilename:parentFile.title];
        if([movieName length] == 0)
        {
            return;
        }
        baseRoute = @"?type=movie&query=";
        escapedTitle = [movieName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        NSString *route = [baseRoute stringByAppendingString:escapedTitle];
        
        [self.showMetaRequestController get:route withURLParamDictionary:nil completion:^(TSCRequestResponse * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                completion(nil, error);
                return;
            }
            
            NSDictionary *movieMetaParentData = [response.array objectAtIndex:0];
            NSDictionary *movieMetaData = [movieMetaParentData valueForKey:@"movie"];
            
            if (completion) {
                completion(movieMetaData, nil);
                return;
            }
        }];
        
        return;
    }
    
    NSString *route = [baseRoute stringByAppendingString:escapedTitle];
    
    [self.showMetaRequestController get:route withURLParamDictionary:nil completion:^(TSCRequestResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSDictionary *showMetaData = [response.array objectAtIndex:0];
        NSString *showSlug = [[[showMetaData valueForKey:@"show"] valueForKey:@"ids"] valueForKey:@"slug"];
        
        NSDictionary *params = @{@"id":showSlug,@"season":[seasonInfo valueForKey:@"seasonNumber"]};
        NSString *route = [[seasonInfo valueForKey:@"episodeNumber"] stringByAppendingString:@"?extended=images,full"];
        
        [self.episodeMetaRequestController get:route withURLParamDictionary:params completion:^(TSCRequestResponse * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                completion(nil, error);
                return;
            }
            
            NSDictionary *episodeMetaData = response.dictionary;
            
            if (completion) {
                completion(episodeMetaData, nil);
            }
        }];
        
    }];
}

- (NSDictionary *)getSeasonInfoFromFilename:(NSString*)fileName
{
    NSString *searchedString = fileName;
    NSRange   searchedRange = NSMakeRange(0, [searchedString length]);
    NSString *pattern = @"(.+?)[Ss](\\d+)[Ee](\\d+)|(.+?)(\\d{1,2})x(\\d{1,2})|(.+?)season.*?(\\d{1,2}).*?episode.*?(\\d{1,2})";
    NSError  *error = nil;
    NSMutableDictionary *output = [[NSMutableDictionary alloc] init];
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
    NSArray* matches = [regex matchesInString:searchedString options:0 range: searchedRange];
    for (NSTextCheckingResult* match in matches) {
        
//        NSString* matchText = [searchedString substringWithRange:[match range]];
//        int num = (int)[match numberOfRanges];
        
        NSRange rangeOne = [match rangeAtIndex:1];
        if(rangeOne.length)
        {
            [output setObject:[[searchedString substringWithRange:rangeOne] stringByReplacingOccurrencesOfString:@"." withString:@" "] forKey:@"seasonName"];
        }
        NSRange rangeTwo = [match rangeAtIndex:2];
        if(rangeTwo.length)
        {
            [output setObject:[searchedString substringWithRange:rangeTwo] forKey:@"seasonNumber"];
            
        }
        NSRange rangeThree= [match rangeAtIndex:3];
        if(rangeThree.length)
        {
            [output setObject:[searchedString substringWithRange:rangeThree] forKey:@"episodeNumber"];
        }
        
        break;
    }
    
    return output;
}

- (NSString *)getMovieInfoFromFilename:(NSString*)fileName
{
    NSString *searchedString = fileName;
    NSRange   searchedRange = NSMakeRange(0, [searchedString length]);
    NSString *pattern = @"(.+?)(\\d\\d\\d\\d)";
    NSError  *error = nil;
    NSString *output = @"";
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
    NSArray* matches = [regex matchesInString:searchedString options:0 range: searchedRange];
    for (NSTextCheckingResult* match in matches) {
        
        //        NSString* matchText = [searchedString substringWithRange:[match range]];
        //        int num = (int)[match numberOfRanges];
        
        NSRange rangeOne = [match rangeAtIndex:1];
        if(rangeOne.length)
        {
            output = [[searchedString substringWithRange:rangeOne] stringByReplacingOccurrencesOfString:@"." withString:@" "];
        }
        
        break;
    }
    
    return output;
}

@end
