//
//  SPHLocationPickerViewController.m
//  SPHLocationPicker
//
//  Created by Karl Monaghan on 04/07/2013.
//  Copyright (c) 2013 SkillPages Holdings. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "SPHLocationPickerViewController.h"

#import "SPHTableViewDataSource.h"
#import "SPHAutoCompleteTableViewDataSource.h"

#define kDefaultMapHeight     150.0f

@interface SPHLocationPickerViewController ()
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UISearchBar *locationSearchBar;
@property (strong, nonatomic) UISearchDisplayController *searchController;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (assign, nonatomic) BOOL searchBarDismiss;
@end

@implementation SPHLocationPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.mapHeight = kDefaultMapHeight;
        self.bounce = YES;
        self.dropPin = YES;
        self.showUserLocation = YES;
        self.searchable = NO;
        
        self.geocoder = [CLGeocoder new];
    }
    return self;
}

- (void)dealloc
{
    [self.tableView removeObserver:self
                        forKeyPath:@"contentOffset"
                           context:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (!self.tableDataSource)
    {
        self.tableDataSource = [SPHTableViewDataSource new];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.tableDataSource;
    self.tableView.contentInset = UIEdgeInsetsMake(self.mapHeight, 0, 0, 0);
    
    [self.tableView addObserver:self
                     forKeyPath:@"contentOffset"
                        options:NSKeyValueObservingOptionNew
                        context:NULL];
    
    [self.view addSubview:self.tableView];
    
    if (self.searchable)
    {
        self.locationSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0f)];
        self.locationSearchBar.delegate = self;
        
        self.searchController = [[UISearchDisplayController alloc]
                                 initWithSearchBar:self.locationSearchBar contentsController:self];
        self.searchController.delegate = self;
        self.searchController.searchResultsDataSource = self.autocompleteDataSource;
        self.searchController.searchResultsDelegate = self;
        
        self.tableView.tableHeaderView = self.locationSearchBar;
        
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.locationSearchBar.frame.size.height);
    }
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.mapHeight)];
    self.mapView.showsUserLocation = self.showUserLocation;
    
    if (self.dropPin)
    {
        UITapGestureRecognizer *mapTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.mapView addGestureRecognizer:mapTap];
    }
    
    [self.view addSubview:self.mapView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancel)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - 
- (void)geocode:(CLLocation *)location
{
    [self.geocoder cancelGeocode];
    
    __block SPHLocationPickerViewController *blockSelf = self;
    
    [self.geocoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray *placemarks, NSError *error) {
                            if (error) {
                                NSLog(@"Error from geocoder: %@", error);
                            } else if ([placemarks count]) {
                                [blockSelf.tableDataSource addPlace:placemarks[0]];
                                [blockSelf.tableView reloadData];
                            } else {
                                NSLog(@"No results");
                            }
                        }];
}

#pragma mark - Observers
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGFloat inset = self.mapHeight;
        
        if ((self.tableView.contentOffset.y == 0) && (!self.searchBarDismiss))
        {
            return;
        }
        else if (self.tableView.contentOffset.y > 0)
        {
            inset = 0;
        }
        else if (self.tableView.contentOffset.y < 0)
        {
            inset = fabsf(self.tableView.contentOffset.y);
        }
        else
        {
            inset = self.mapView.frame.size.height;
        }
        
        self.mapView.frame = CGRectMake(0, 0, 320.0f, inset);
        self.tableView.contentInset = UIEdgeInsetsMake(inset, 0, 0, 0);
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
        
        CLPlacemark *place = [self.tableDataSource fetchPlaceAtIndex:indexPath.row];
        CLLocationCoordinate2D newCenter = CLLocationCoordinate2DMake(place.location.coordinate.latitude,
                                                                      place.location.coordinate.longitude);
        self.mapView.centerCoordinate = newCenter;
        return;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.bounce && self.mapView.frame.size.height > self.mapHeight) {
        [UIView animateWithDuration:0.3 animations:^() {
            [self.tableView setContentOffset:CGPointMake(0, -self.mapHeight) animated:YES];
        }];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (void)handleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint touchPoint = [sender locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = touchMapCoordinate;
        /*
        for (id annotation in self.mapView.annotations) {
            [self.mapView removeAnnotation:annotation];
        }
         */
        
        [self.mapView addAnnotation:point];
        self.mapView.centerCoordinate = touchMapCoordinate;
        
        CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
        
        [self geocode:centerLocation];
    }
}

#pragma mark - UISearchDisplayDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.searchBarDismiss = NO;
    
    self.mapView.hidden = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.tableView scrollsToTop];
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissSearchBar];
}

- (void)dismissSearchBar
{
    self.searchBarDismiss = YES;
    
    [self.locationSearchBar resignFirstResponder];
    [self.searchDisplayController setActive:NO];
    
    self.mapView.hidden = NO;
    self.tableView.contentOffset = CGPointMake(0, -150);
}
@end
