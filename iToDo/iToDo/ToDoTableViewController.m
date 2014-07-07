//
//  ToDoTableViewController.m
//  iToDo
//
//  Created by Bilal ARSLAN on 05/07/14.
//  Copyright (c) 2014 Bilal ARSLAN. All rights reserved.
//

#import "ToDoTableViewController.h"
#import "DBManager.h"

@interface ToDoTableViewController ()

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrTodosInfo;

-(void) loadData;

@end

@implementation ToDoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //  Bacground color with my best color :)
    self.view.backgroundColor = [UIColor colorWithRed:(232.0 / 255.0) green:(166.0 / 255.0) blue:(105.0 / 255.0) alpha:1.0f];
    
    //  Initialize the dbManager property with Database name.
    self.dbManager = [[DBManager alloc] initWithDatabaseFileName:@"iToDoDb.sql"];
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segue for reload data
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddToDoViewController *addToDoVC = [segue destinationViewController];
    addToDoVC.delegate = self;
}

#pragma mark - Load data from DataBase
-(void)loadData
{
    //  Form the query
    NSString *query = @"select * from todoInfo";
    
    //  Get data results.
    if (self.arrTodosInfo != nil) {
        self.arrTodosInfo = nil;
    }
    self.arrTodosInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDBWithQuery:query]];
    
    //  Reload the table view.
    [self.tableView reloadData];
}

#pragma mark - AddToDoViewC Delegate Method
-(void)editingInfoWasFinished
{
    //  Reload the data.
    [self loadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.arrTodosInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  Deque the cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todoCell" forIndexPath:indexPath];
    
    //
    NSInteger indexOfTitle = [self.dbManager.arrColumnNames indexOfObject:@"title"];
    NSInteger indexOfDescription = [self.dbManager.arrColumnNames indexOfObject:@"description"];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrTodosInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfTitle]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Age: %@", [[self.arrTodosInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfDescription]];
    
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 2;
    
    cell.backgroundColor = [UIColor colorWithRed:(232.0 / 255.0) green:(166.0 / 255.0) blue:(105.0 / 255.0) alpha:1.0f];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the selected record.
        // Find the record ID.
        int recordIDToDelete = [[[self.arrTodosInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        
        // Prepare the query.
        NSString *query = [NSString stringWithFormat:@"delete from todoInfo where todoInfoID=%d", recordIDToDelete];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // Reload the table view.
        [self loadData];
    }
}

@end
