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
@property (nonatomic, strong) NSMutableArray *arrSearchTodosInfo;
@property (nonatomic) int recordIDToEdit;
@property BOOL isFiltered;

-(void) loadData;

@end

@implementation ToDoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isFiltered = NO;
    
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

-(void)addToDo:(id)sender
{
    // Before performing the segue, set the -1 value to the recordIDToEdit. That way we'll indicate that we want to add a new record and not to edit an existing one.
    self.recordIDToEdit = -1;
    
    [self performSegueWithIdentifier:@"idSegue" sender:self];
    
}

#pragma mark - Segue for reload data
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddToDoViewController *addToDoVC = [segue destinationViewController];
    addToDoVC.delegate = self;
    addToDoVC.recordIDToEdit = self.recordIDToEdit;
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
    
    if (self.arrTodosInfo != nil)
    {
        //  Reload the table view.
        NSLog(@"-----------------------------------------------------------------------------------------");
        NSLog(@"Query was executed succesfully. Data is loaded the Array.");
        NSLog(@"-----------------------------------------------------------------------------------------");
        [self.tableView reloadData];
    }
    else
    {
        NSLog(@"-----------------------------------------------------------------------------------------");
        NSLog(@"Query was executed unsuccesfully. Data is  not loaded the Array.");
        NSLog(@"-----------------------------------------------------------------------------------------");
    }
    

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
    //  Return the number of the filtered items.
    if (self.isFiltered) {
        return self.arrSearchTodosInfo.count;
    }
    
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
    
    
    if(!self.isFiltered)
    {
        // Configure the cell...
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrTodosInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfTitle]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[self.arrTodosInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfDescription]];
    }
    else
    {
        //  Configue the cell with filtered results.
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrSearchTodosInfo objectAtIndex:indexPath.row] objectForKey:@"title"]];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[self.arrSearchTodosInfo objectAtIndex:indexPath.row] objectForKey:@"description"]];
        
    }
    
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 2;
    
    cell.backgroundColor = [UIColor colorWithRed:(232.0 / 255.0) green:(166.0 / 255.0) blue:(105.0 / 255.0) alpha:1.0f];
    
    return cell;
}

// When delete a row on the list. Also delete from database.
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
        if (self.dbManager.affectedRows != 0)
        {
            NSLog(@"-----------------------------------------------------------------------------------------");
            NSLog(@"Query was executed succesfully. Affected rows = %d", self.dbManager.affectedRows);
            NSLog(@"Deleted Todo Name: %@", [[self.arrTodosInfo objectAtIndex:indexPath.row] objectAtIndex:1]);
            NSLog(@"-----------------------------------------------------------------------------------------");
            
            // Reload the table view.
            [self loadData];
        }
        else
        {
            NSLog(@"-----------------------------------------------------------------------------------------");
            NSLog(@"Query was executed unsuccesfully.");
            NSLog(@"-----------------------------------------------------------------------------------------");
        }
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //  Get the record ID of the selected name and set it to the recordIDToEdit.
    self.recordIDToEdit = [[[self.arrTodosInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    
    //Perform the Segue
    [self performSegueWithIdentifier:@"idSegue" sender:self];
}

#pragma mark - searchBar Methods
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        self.isFiltered = NO;
    }
    else
    {
        NSInteger indexOfTitle = [self.dbManager.arrColumnNames indexOfObject:@"title"];
        NSInteger indexOfDescription = [self.dbManager.arrColumnNames indexOfObject:@"description"];
        
        self.isFiltered = YES;
        self.arrSearchTodosInfo = [[NSMutableArray alloc] init];
        
        for (int i = 0; i<self.arrTodosInfo.count; i++)
        {
            NSRange rangeTodoTitle = [[[self.arrTodosInfo objectAtIndex:i] objectAtIndex:indexOfTitle] rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange rangeTodoDesc = [[[self.arrTodosInfo objectAtIndex:i] objectAtIndex:indexOfDescription] rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if (rangeTodoTitle.location != NSNotFound || rangeTodoDesc.location != NSNotFound)
            {
                [self.arrSearchTodosInfo addObject:
                        @{@"title":[[self.arrTodosInfo objectAtIndex:i] objectAtIndex:indexOfTitle] ,
                        @"description":[[self.arrTodosInfo objectAtIndex:i] objectAtIndex:indexOfDescription]}];
            }
            
        }
    }
    
    [self.tableView reloadData];
}

@end
