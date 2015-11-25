//
//  FileDetailViewController.m
//  putio-atv
//
//  Created by Anthony May on 21/11/2015.
//  Copyright © 2015 The Means. All rights reserved.
//

#import "FileDetailViewController.h"
#import "UIColor+Putio.h"
#import "PCGroupView.h"
#import "PutioController.h"
#import "TraktController.h"

@import AVKit;
@import AVFoundation;

@interface FileDetailViewController ()

@property (nonatomic, strong) PCGroupView *groupView;
@property (nonatomic, strong) PCGroupView *buttonsView;

@end

@implementation FileDetailViewController

- (instancetype)initWithFile:(File *)file
{
    if (self = [super init]) {
        
        _file = file;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImageView = [AsyncImageView new];
    [self.view addSubview:self.backgroundImageView];
    
    self.backgroundVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    [self.view addSubview:self.backgroundVisualEffectView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.text = self.file.title;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:64];
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.subtitleLabel = [UILabel new];
    self.subtitleLabel.text = self.file.subtitle;
    self.subtitleLabel.font = [UIFont systemFontOfSize:48];
    self.subtitleLabel.textColor = [UIColor whiteColor];
    
    self.infoLabel = [UILabel new];
    self.infoLabel.text = @" ";
    self.infoLabel.font = [UIFont boldSystemFontOfSize:34];
    self.infoLabel.textColor = [UIColor putioPrimaryColor];
    
    self.descriptionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.descriptionButton setTitle:self.file.mediumDescription forState:UIControlStateNormal];
    self.descriptionButton.titleLabel.numberOfLines = 0;
    [self.descriptionButton addTarget:self action:@selector(handleDescription:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    self.descriptionLabel = [UILabel new];
    self.descriptionLabel.text = self.file.mediumDescription;
    self.descriptionLabel.font = [UIFont systemFontOfSize:34];
    self.descriptionLabel.textColor = [UIColor whiteColor];
    self.descriptionLabel.numberOfLines = 0;
    
    [[TraktController sharedController] getFileMetadata:self.file withCompletion:^(NSDictionary *fileMetaData, NSError *error) {
        
        if(error)
        {
            return;
        }
        
        [self.infoLabel setText:[fileMetaData valueForKey:@"title"]];
        [self.infoLabel setNeedsUpdateConstraints];
        [self.infoLabel setNeedsDisplay];
        
        [self.descriptionLabel setText:[fileMetaData valueForKey:@"overview"]];
        [self.descriptionLabel setNeedsUpdateConstraints];
        [self.descriptionLabel setNeedsDisplay];
        
        NSDictionary *images = [fileMetaData valueForKey:@"images"];
        NSDictionary *screenshot = [images valueForKey:@"screenshot"];
        NSString *artworkUrlString = [screenshot valueForKey:@"full"];
        NSURL *outputUrl = [[NSURL alloc] init];
        
        if([artworkUrlString length] != 0)
        {
            outputUrl = [NSURL URLWithString:artworkUrlString];
            
            [self.backgroundImageView setImageURL:outputUrl];
            [self.thumbnailImageView setImageURL:outputUrl];
            return;
        }

        screenshot = [images valueForKey:@"fanart"];
        artworkUrlString = [screenshot valueForKey:@"full"];
        if([artworkUrlString length] != 0)
        {
            outputUrl = [NSURL URLWithString:artworkUrlString];
            
            [self.backgroundImageView setImageURL:outputUrl];
            [self.thumbnailImageView setImageURL:outputUrl];
            return;
        }
        
    }];
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(handlePlay:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    self.audioDescribedButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.audioDescribedButton setTitle:@"AD" forState:UIControlStateNormal];
    [self.audioDescribedButton addTarget:self action:@selector(handlePlay:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    self.convertButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.convertButton setTitle:@"Make Mp4" forState:UIControlStateNormal];
    [self.convertButton addTarget:self action:@selector(handlePlay:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
//    self.relatedEpisodeView = [[FileCollectionView alloc] init];
//    self.relatedEpisodeView.numberOfFilesPerRow = 4;
//    self.relatedEpisodeView.collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    self.relatedEpisodeView.delegate = self;
//    self.relatedEpisodeView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
//    [self.view addSubview:self.relatedEpisodeView];
    
//    if ([self.episode isMemberOfClass:[Episode class]]) {
//        [[AuntieController sharedController] getRelatedEpisodesForEpisode:self.episode completion:^(NSArray *content, NSError *error) {
//            
//            self.relatedEpisodeView.episodes = content;
//        }];
//    }
//    
//    if ([self.episode isMemberOfClass:[Programme class]]) {
//        
//        [[AuntieController sharedController] getEpisodesForProgramme:self.episode completion:^(NSArray *content, NSError *error) {
//            
//            self.relatedEpisodeView.episodes = content;
//        }];
//        
//    }
    
    NSMutableArray *availableButtons = [NSMutableArray array];
    if (![self.file.mpfour isEqualToNumber:@0])
    {
        [availableButtons addObject:self.playButton];
    }
    else
    {
        [availableButtons addObject:self.convertButton];
    }
//
//    if (self.file.audioDescribedVersion) {
//        [availableButtons addObject:self.audioDescribedButton];
//    }
//    
//    if (self.file.signedVersion) {
//        [availableButtons addObject:self.signedButton];
//    }
    
    self.buttonsView = [PCGroupView groupWithViews:availableButtons];
    self.buttonsView.direction = PCGroupViewDirectionHorizontal;
    self.buttonsView.viewInsets = UIEdgeInsetsMake(30, 30, 0, 0);
    [self.view addSubview:self.buttonsView];
    
    self.groupView = [PCGroupView groupWithViews:@[self.titleLabel, self.subtitleLabel, self.infoLabel, self.descriptionLabel, self.buttonsView]];
    self.groupView.direction = PCGroupViewDirectionVertical;
    self.groupView.viewInsets = UIEdgeInsetsMake(0, 0, 20, 0);
    [self.view addSubview:self.groupView];
    
    self.thumbnailImageView = [AsyncImageView new];
//    [self.thumbnailImageView setImageURL:self.file.thumbnailURL];
    [self.view addSubview:self.thumbnailImageView];
    
    [self.playButton becomeFirstResponder];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.backgroundImageView.frame = self.view.bounds;
    self.backgroundVisualEffectView.frame = self.view.bounds;
    
    CGFloat thumbnailWidth = 700;
    self.thumbnailImageView.frame = CGRectMake(0, 0, thumbnailWidth, thumbnailWidth / 16*9);
    
    [self.thumbnailImageView positionInSuperviewX:PCGroupViewPositionRight y:PCGroupViewPositionTop offset:UIEdgeInsetsMake(170, 0, 0, 100)];
    
    self.buttonsView.constraintSize = CGSizeMake(800, MAXFLOAT);
    [self.buttonsView sizeToFit];
    [self.buttonsView positionInSuperviewX:PCGroupViewPositionLeft y:PCGroupViewPositionTop offset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    self.groupView.constraintSize = CGSizeMake(800, MAXFLOAT);
    [self.groupView sizeToFit];
    
    [self.groupView positionInSuperviewX:PCGroupViewPositionLeft y:0 offset:UIEdgeInsetsMake(50, 80, 0, 0)];
    
    self.relatedEpisodeView.frame = CGRectMake(0, self.view.bounds.size.height - 400, self.view.bounds.size.width, 400);
}

#pragma mark - Actions

- (void)handlePlay:(id)sender
{
//    FileVersion *selectedVersion;
//    if (sender == self.playButton) {
//        
//        selectedVersion = self.episode.originalVersion;
//        
//    } else if (sender == self.audioDescribedButton) {
//        
//        selectedVersion = self.episode.audioDescribedVersion;
//        
//    } else if (sender == self.signedButton) {
//        
//        selectedVersion = self.episode.signedVersion;
//        
//    }
    
    AVPlayerViewController *viewController = [[AVPlayerViewController alloc] init];
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:viewController animated:YES completion:nil];
    
    [[PutioController sharedController] getAVPlayerURL:self.file withCompletion:^(NSURL *fileURL, NSError *error) {

        if (error) {
            [viewController dismissViewControllerAnimated:YES completion:nil];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Unable to start video playback." message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        
        AVPlayer *player = [[AVPlayer alloc] initWithURL:fileURL];
        viewController.player = player;
        [viewController.player play];
        
    }];
    
    
    
//    [[PutioController sharedController] getStreamURLForVersion:selectedVersion completion:^(NSURL *episodeURL, NSError *error) {
//        
//        if (error) {
//            
//            [viewController dismissViewControllerAnimated:YES completion:nil];
//            
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Unable to start video playback." message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil]];
//            [self presentViewController:alertController animated:YES completion:nil];
//        }
//        
//        AVPlayer *player = [[AVPlayer alloc] initWithURL:episodeURL];
//        player.closedCaptionDisplayEnabled = true;
//        
//        viewController.player = player;
//        [viewController.player play];
//    }];
}

- (void)handleDescription:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.file.title message:self.file.longDescription preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)fileCollectionView:(FileCollectionView *)view didSelectedEpsiode:(File *)file
{
//    EpisodeDetailViewController *viewController = [[EpisodeDetailViewController alloc] initWithEpisode:episode];
//    [self presentViewController:viewController animated:YES completion:nil];
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
