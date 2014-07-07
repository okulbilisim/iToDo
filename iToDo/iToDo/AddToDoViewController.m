//
//  AddToDoViewController.m
//  iToDo
//
//  Created by Bilal ARSLAN on 07/07/14.
//  Copyright (c) 2014 Bilal ARSLAN. All rights reserved.
//

#import "AddToDoViewController.h"
#import "DBManager.h"

@interface AddToDoViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation AddToDoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txtTitle.delegate = self;
    self.txtDesc.delegate = self;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFileName:@"iToDoDb.sql"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSRange resultRange = [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:NSBackwardsSearch];
    
    if ([text length] == 1 && resultRange.location != NSNotFound) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Save Button
- (IBAction)SaveToDo:(id)sender
{
    //  Dismissing Keyboard
    [self.txtDesc resignFirstResponder];
    [self.txtTitle resignFirstResponder];
    
    
    //  Warning if title field is emtpy.
    if ([self.txtTitle.text isEqualToString:@""] || [self.txtTitle.text isEqual:nil]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Fill the Title" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //  Prepare the query string.
    NSString *query = [NSString stringWithFormat:@"insert into todoInfo values(null, '%@', '%@')", self.txtTitle.text, self.txtDesc.text];
    NSLog(@"The query is: %@", query);
    
    //  Execute the query.
    [self.dbManager executeQuery:query];
    
    //  If query was succesfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0)
    {
        NSLog(@"Query was executed succesfully. Affected rows = %d", self.dbManager.affectedRows);
    
        //  Inform the delegate that editing was finished.
        [self.delegate editingInfoWasFinished];
        
        //  Pop the view controller
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSLog(@"Could not ecexute the query");
    }
}

@end
