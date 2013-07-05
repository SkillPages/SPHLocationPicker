//
//  SPHTableViewDataSource.h
//  SPHLocationPicker
//
//  Created by Karl Monaghan on 05/07/2013.
//  Copyright (c) 2013 SkillPages Holdings. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface SPHTableViewDataSource : NSObject <UITableViewDataSource>
- (void)addPlace:(CLPlacemark *)place;
- (CLPlacemark *)fetchPlaceAtIndex:(NSInteger)index;
@end
