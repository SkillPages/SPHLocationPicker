//
//  SPHTableViewDataSource.m
//  SPHLocationPicker
//
//  Created by Karl Monaghan on 05/07/2013.
//  Copyright (c) 2013 SkillPages Holdings. All rights reserved.
//
#import <AddressBookUI/AddressBookUI.h>

#import "SPHTableViewDataSource.h"

@interface SPHTableViewDataSource ()
@property (strong, nonatomic) NSArray *places;
@end

@implementation SPHTableViewDataSource
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.places = @[];
    }
    
    return self;
}

- (void)addPlace:(CLPlacemark *)place
{
    NSMutableArray *allPlaces = self.places.mutableCopy;
    [allPlaces insertObject:place atIndex:0];
    self.places = allPlaces;
}

- (CLPlacemark *)fetchPlaceAtIndex:(NSInteger)index
{
    return self.places[index];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placemark"];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"placemark"];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.minimumScaleFactor = 0.75f;
	}
    
	cell.textLabel.text = ABCreateStringWithAddressDictionary(((CLPlacemark *)self.places[indexPath.row]).addressDictionary, YES);
	
	return cell;
}
@end
