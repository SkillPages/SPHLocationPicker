SPHLocationPicker
===============

SPHLocationPicker provides a configurable UITableView with a dynamically resizing MKMapView which can be used to allow a user select a location. The map can expand and contract as the user drags the tableview. The selected item can be returned to the calling controller as a [CLPlacemark](http://developer.apple.com/library/ios/#documentation/CoreLocation/Reference/CLPlacemark_class/Reference/Reference.html).

<img src="https://raw.github.com/SkillPages/SPHLocationPicker/master/Screenshot.PNG" />

##Usage
```obj-c
    SPHLocationPickerViewController *locationPicker = [[SPHLocationPickerViewController alloc] initWithSucess:^(CLPlacemark *place){
        NSLog(@"place.addressDictionary: %@", place.addressDictionary);
    }
                                                                                                    onFailure:nil];

    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:locationPicker];
    [self presentViewController:navController
                       animated:YES
                     completion:nil];
```

## Installation

1. Link `CoreLocation.framework`, `MapKit.framework` and `QuartzCore.framework` to your project. If you are using the default data source for the tableviews, you'll also need to link to `AddressBookUI.framework`
2. Include the `SPHLocationPickerViewController.h` header
3. Initialise the SPHLocationPicker
```obj-c
SPHLocationPickerViewController *locationPicker = [[SPHLocationPickerViewController alloc] initWithSucess:^(CLPlacemark *place){
        NSLog(@"%@", place.addressDictionary);
    }
                                                                                                    onFailure:nil];
```

4. You can provide your own datasource for the UITableView using the property `tableDataSource`. This should conform to both `SPHTableViewDataSource` and `UITableViewDataSource`. A default implementation of this is already provided.
5. Optionally set one of the configuration options.
6. Push the controller

### Options

`bounce` (default YES) When set to YES, the tableview map will return to the set size on release.

`dropPin` (default YES) Allow pins to be dropped on the map.

`showUserLocation` (default YES) Turn on or off the user's location.

`searchable` (default NO) When this is set, a datasource which conforms to both `UITableViewDateSource` and `SPHAutoComplete` must be provided. This will then display a search bar under the map which will allow the user to search for a location.
 
`zoomToDroppedPin` (default YES) When set to YES the map will zoom into the dropped pin.

`mapHeight` (default 150) The initial height of the map. If the map bounces, it will return to this size.

### Example
To run the example project, you will need to initialise the [SPGooglePlacesAutocomplete](https://github.com/spoletto/SPGooglePlacesAutocomplete) and [SVProgressHUD](https://github.com/samvermette/SVProgressHUD) submodules:
`$ git submodule update --init --recursive`

Once initialised, you will need to provide your own [Google Places API key](https://developers.google.com/places/documentation/).
 
SPGooglePlacesAutocomplete is used by `ExampleAutoCompleteTableViewDataSource` to provide the data for the autocomplete. 

## Requirements

SPHLocationPicker requires [iOS 5.0](http://developer.apple.com/library/ios/#releasenotes/General/WhatsNewIniOS/Articles/iOS5.html#//apple_ref/doc/uid/TP30915195-SW1) and above.

### ARC

SPHLocationPicker uses ARC.

If you are using SPHLocationPicker in your non-arc project, you will need to set a `-fobjc-arc` compiler flag on all of the SPHLocationPicker source files.

To set a compiler flag in Xcode, go to your active target and select the "Build Phases" tab. Now select all SPHLocationPicker source files, press Enter, insert `-fobjc-arc` and then "Done" to enable ARC for SPHLocationPicker.

## Creator

[Karl Monaghan](http://github.com/kmonaghan)
[@karlmonaghan](https://twitter.com/karlmonaghan)
 
## License
SPHLocationPicker is available under the MIT license. See the LICENSE file for more info.
