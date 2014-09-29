//
//  ViewController.m
//  AdvertiseBeacon
//
//  Created by Vivek Jain on 9/29/14.
//  Copyright (c) 2014 Vivek Jain. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property NSArray *beacons;
@property CBPeripheralManager *peripheralManager;
@property NSNumber *selectedMajorId;
@property NSNumber *selectedMinorId;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBeaconArray];
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.beacons.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell"
                                                            forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Stop Advertising";
    } else {
        NSArray *selectedBeacon = self.beacons[indexPath.row - 1];
        NSNumber *majorId = selectedBeacon[0];
        NSNumber *minorId = selectedBeacon[1];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ / %@", majorId, minorId];
    }    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self stopAdvertisingBeacon];
        return;
    }
    NSArray *selectedBeacon = self.beacons[indexPath.row - 1];
    self.selectedMajorId = selectedBeacon[0];
    self.selectedMinorId = selectedBeacon[1];
    [self startAdvertisingBeacon];
}

#pragma mark - Beacon advertising delegate methods
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheralManager error:(NSError *)error
{
    if (error) {
        NSLog(@"Couldn't turn on advertising: %@", error);
        return;
    }
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheralManager
{
    if (peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        NSLog(@"peripheralManagerDidUpdateState: Peripheral manager is off.");
        return;
    }
    
    NSLog(@"Peripheral manager is on.");
    [self startAdvertisingBeacon];
}

#pragma mark - Helpers

- (void)startAdvertisingBeacon {
    if (self.selectedMajorId == nil) return;
    if (self.peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        NSLog(@"turnOnAdvertising: Peripheral manager is off.");
        return;
    }

    [self stopAdvertisingBeacon];
    
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:@"8A216B41-DBC2-435C-9B3D-16AB00B369D3"];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                                     major:[self.selectedMajorId integerValue]
                                                                     minor:[self.selectedMinorId integerValue]
                                                                identifier:@"TWAir"];
    NSDictionary *beaconPeripheralData = [region peripheralDataWithMeasuredPower:nil];
    [self.peripheralManager startAdvertising:beaconPeripheralData];
    
    NSLog(@"Turning on advertising for region: %@.", region);
}

- (void)stopAdvertisingBeacon
{
    [self.peripheralManager stopAdvertising];
    
    NSLog(@"Turned off advertising.");
}

- (void)loadBeaconArray {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"beacons" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error: nil];
    self.beacons = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                   options:kNilOptions error:nil];
}

@end
