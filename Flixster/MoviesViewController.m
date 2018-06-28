//
//  MoviesViewController.m
//  Flixster
//
//  Created by Jonathan Cabrera on 6/27/18.
//  Copyright © 2018 Jonathan Cabrera. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

// This class implements this protocol, we will implement the methods that are defined by UITableView
@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

// @property automatically creates getter and setter
// everything will be nonatomic
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.tableView addSubview:self.refreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
    (NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];

    cell.titleLabel.text = movie[@"title"];
    
    cell.descriptionLabel.text = movie[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500/";
    
    NSString *posterURLString = movie[@"poster_path"];
    
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];

    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
   
    cell.posterView.image = nil;
    
    [cell.posterView setImageWithURL:posterURL];
    
    return cell;
}

#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *tappedCell = sender;

    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];

    NSDictionary *movie = self.movies[indexPath.row];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    
    detailsViewController.movie = movie;
}


- (void)fetchMovies {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:
                             [NSURLSessionConfiguration defaultSessionConfiguration] delegate:
                             nil delegateQueue:
                             [NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
    if (error != nil) {
          NSLog(@"%@", [error localizedDescription]);
    }
    else {
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:
                                        data options:NSJSONReadingMutableContainers error:nil];
        self.movies = dataDictionary[@"results"];
        for (NSDictionary *movie in self.movies) {
            NSLog(@"%@", movie[@"title"]);
        }
        [self.tableView reloadData];
    }
    [self.refreshControl endRefreshing];
    }];
    [task resume];
}

@end



























