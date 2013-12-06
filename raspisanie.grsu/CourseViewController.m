//
//  CourseViewController.m
//  raspisanie.grsu
//
//  Created by Ruslan on 17.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "CourseViewController.h"
#import "RaspisanieManager.h"
#import "GroupViewController.h"

@interface CourseViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *courseItems;
@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, strong) FacultyItem *facultyItem;
@property (nonatomic, strong) FacultyItem *specializationItem;

@end

@implementation CourseViewController

- (id)initWithFacultyItem:(FacultyItem *)facultyItem specializationItem:(FacultyItem *)specializationItem {
    self = [super init];
    if (self) {
        self.title = @"Курс";
        self.facultyItem = facultyItem;
        self.specializationItem = specializationItem;
        [self loadCourseWithFacultyID:facultyItem.id specializationID:specializationItem.id];
    }
    return self;
}

- (void)loadCourseWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID {
    [[RaspisanieManager sharedInstance] courseItemsWithFacultyID:facultyID specializationID:specializationID callback:^(NSArray *array, NSError *error) {
        [self.loadingView hideLoading];
        self.courseItems = array;
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.courseItems) {
        self.loadingView = [[LoadingView alloc] initWithView:self.view];
        [self.loadingView showLoading];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    if (path) {
        [self.tableView deselectRowAtIndexPath:path animated:YES]; // Hide selected
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courseItems.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    FacultyItem *item = self.courseItems[indexPath.row];
    
    cell.textLabel.text = item.title;
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FacultyItem *item = self.courseItems[indexPath.row];
    
    GroupViewController *controller = [[GroupViewController alloc] initWithFacultyItem:self.facultyItem specializationItem:self.specializationItem courseItem:item];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
