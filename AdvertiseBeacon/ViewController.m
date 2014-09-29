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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBeaconArray];
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
    
}

- (void)loadBeaconArray {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"beacons" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error: nil];
    self.beacons = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                   options:kNilOptions error:nil];
}

@end
