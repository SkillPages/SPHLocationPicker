//
//  SPHLocationPickerViewController.h
//  SPHLocationPicker
//
//  Created by Karl Monaghan on 04/07/2013.
//  Copyright (c) 2013 SkillPages Holdings. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

typedef void (^SPHLocationPickerSuccessReturnBlock)(CLPlacemark *place);
typedef void (^SPHLocationPickerSuccessBlock)(void);
typedef void (^SPHLocationPickerFauilreBlock)(NSError* error);

@protocol SPHAutoComplete
- (void)updateSearchTerm:(NSString *)term withLocation:(CLLocationCoordinate2D)location onFinished:(SPHLocationPickerSuccessBlock)success;
- (void)placemarkAtIndex:(NSInteger)index onSuccess:(SPHLocationPickerSuccessReturnBlock)success onFailure:(SPHLocationPickerFauilreBlock)failure;
@end

@class SPHTableViewDataSource;
@class SPHAutoCompleteTableViewDataSource;

@interface SPHLocationPickerViewController : UIViewController <CLLocationManagerDelegate, UITableViewDelegate, UIScrollViewDelegate, UISearchDisplayDelegate , UISearchBarDelegate>

@property (assign, nonatomic, getter = canBounce) BOOL bounce;
@property (assign, nonatomic, getter = canDropPin) BOOL dropPin;
@property (assign, nonatomic, getter = willShowUserLocation) BOOL showUserLocation;
@property (assign, nonatomic, getter = canSearch) BOOL searchable;
@property (assign, nonatomic, getter = willZoom) BOOL zoomToDroppedPin;
@property (assign, nonatomic) CGFloat mapHeight;
@property (strong, nonatomic) SPHTableViewDataSource *tableDataSource;
@property (strong, nonatomic) id <SPHAutoComplete, UITableViewDataSource> autocompleteDataSource;

- (id)initWithSucess:(SPHLocationPickerSuccessReturnBlock)sucess onFailure:(SPHLocationPickerFauilreBlock)failure;
@end
