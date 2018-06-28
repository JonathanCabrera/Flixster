//
//  DetailsViewController.m
//  Flixster
//
//  Created by Jonathan Cabrera on 6/28/18.
//  Copyright © 2018 Jonathan Cabrera. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500/";
    
    NSString *posterURLString = self.movie[@"poster_path"];
    
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [self.posterView setImageWithURL:posterURL];
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    
    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
    [self.backdropView setImageWithURL:backdropURL];
    
    self.titleLabel.text = self.movie[@"title"];
    self.descriptionLabel.text = self.movie[@"overview"];
    
    
    [self.descriptionLabel sizeToFit];
    CGFloat maxHeight = self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.size.height;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, maxHeight);
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
