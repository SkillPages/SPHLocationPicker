//
//  SPHLocationPickerViewController.h
//  SPHLocationPicker
//
//  Created by Karl Monaghan on 04/07/2013.
//  Copyright (c) 2013 SkillPages Holdings. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@class SPHTableViewDataSource;
@class SPHAutoCompleteTableViewDataSource;

@interface SPHLocationPickerViewController : UIViewController <CLLocationManagerDelegate, UITableViewDelegate, UIScrollViewDelegate, UISearchDisplayDelegate , UISearchBarDelegate>

@property (assign, nonatomic, getter = canBounce) BOOL bounce;
@property (assign, nonatomic, getter = canDropPin) BOOL dropPin;
@property (assign, nonatomic, getter = willShowUserLocation) BOOL showUserLocation;
@property (assign, nonatomic, getter = canSearch) BOOL searchable;
@property (assign, nonatomic) CGFloat mapHeight;
@property (strong, nonatomic) SPHTableViewDataSource *tableDataSource;
@property (strong, nonatomic) SPHAutoCompleteTableViewDataSource *autocompleteDataSource;

@end
