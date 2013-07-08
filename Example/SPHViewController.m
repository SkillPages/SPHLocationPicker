//
//  SPHViewController.m
//  SPHLocationPicker
//
//  Created by Karl Monaghan on 03/07/2013.
//  Copyright (c) 2013 SkillPages Holdings. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>

#import "SPHViewController.h"

#import "SPHLocationPickerViewController.h"
#import "ExampleAutoCompleteTableViewDataSource.h"

@interface SPHViewController ()
@property (strong, nonatomic) IBOutlet UISwitch *bounceSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *userLocationSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *dropPinSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *searchableSwitch;
@property (strong, nonatomic) IBOutlet UITextField *mapHeightTextField;
@property (strong, nonatomic) IBOutlet UILabel *locationNameLabel;

- (IBAction)showMapAction:(id)sender;
@end

@implementation SPHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMapAction:(id)sender {
    SPHLocationPickerViewController *locationPicker = [[SPHLocationPickerViewController alloc] initWithSucess:^(CLPlacemark *place){
        self.locationNameLabel.text = ABCreateStringWithAddressDictionary(place.addressDictionary, YES);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
                                                                                                    onFailure:nil];
    
    locationPicker.bounce = self.bounceSwitch.on;
    locationPicker.showUserLocation = self.userLocationSwitch.on;
    locationPicker.dropPin = self.dropPinSwitch.on;
    locationPicker.mapHeight = [self.mapHeightTextField.text floatValue];
    locationPicker.searchable = self.searchableSwitch.on;
    locationPicker.autocompleteDataSource = [ExampleAutoCompleteTableViewDataSource new];

    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:locationPicker];
    [self presentViewController:navController
                                            animated:YES
                                          completion:nil];
}
@end
