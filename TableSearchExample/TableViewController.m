//
//  TableViewController.m
//  TableSearchExample
//
//  Created by hemant kumar on 03/01/13.
//  Copyright (c) 2013 hemant kumar. All rights reserved.
//

#import "TableViewController.h"
#import "DetailViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController
@synthesize  savedSearchTerm;
@synthesize  contentsList;
@synthesize  searchResults;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"];
   NSDictionary *countryNamesByCode = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray *names = [countryNamesByCode allValues];
    NSLog(@"names---->%@",names);
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[names sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
	
	[self setContentsList:array];
	if ([self savedSearchTerm])
	{
        [[[self searchDisplayController] searchBar] setText:[self savedSearchTerm]];
    }
    
    totalSections = [[NSMutableDictionary alloc] init];
    for (NSString *str in [[UILocalizedIndexedCollation currentCollation] sectionTitles])
    {
        
     self.sectionArray=[[NSMutableArray alloc] init];

      for (int i=0;i<[contentsList count];i++)
      {
        NSString *c = [[contentsList objectAtIndex:i] substringToIndex:1];
            if ([str isEqualToString:c])
            {
                [self.sectionArray addObject:[contentsList objectAtIndex:i]];
            }
       }
          [totalSections setValue:self.sectionArray forKey:str];
        NSLog(@"self.sectionArray %@",[self.sectionArray description]);

    }
    NSLog(@"sections %@",[totalSections description]);
	[self.tableView reloadData];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows;
    key=[[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles] objectAtIndex:section];
    NSArray *rowInSectionsArrary = [totalSections valueForKey:key];
   
    
	if (tableView == [[self searchDisplayController] searchResultsTableView])
		rows = [[self searchResults] count];
	else
		rows =  [rowInSectionsArrary count];;
	return rows;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSString *key1 =[[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles] objectAtIndex:indexPath.section];
    NSArray *rowInSectionsArrary = [totalSections valueForKey:key1];
    // Configure the cell...
    if (tableView == [[self searchDisplayController] searchResultsTableView])
    {
        cell.textLabel.text = [[self searchResults] objectAtIndex:indexPath.row];
      
    }
    
	else
    {
        cell.textLabel.text = [rowInSectionsArrary objectAtIndex:indexPath.row];
       
	}

    
    return cell;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    [self.tableView reloadSectionIndexTitles];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    [self.tableView reloadSectionIndexTitles];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    if (tableView == [[self searchDisplayController] searchResultsTableView])
    {
        detailViewController.labelStr = [[self searchResults] objectAtIndex:indexPath.row];
        
    }
	else
    {
        detailViewController.labelStr = [[self contentsList] objectAtIndex:indexPath.row];
        
	}

     [self.navigationController pushViewController:detailViewController animated:YES];
    
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
	
	[self setSavedSearchTerm:searchTerm];
	if ([self searchResults] == nil)
	{
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[self setSearchResults:array];
	}
	
	[[self searchResults] removeAllObjects];
	
	if ([[self savedSearchTerm] length] != 0)
	{
		for (NSString *currentString in [self contentsList])
		{
			if ([currentString rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound)
			{
				[[self searchResults] addObject:currentString];
			}
		}
	}
	
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	[self handleSearchForTerm:searchString];
	return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
	[self setSavedSearchTerm:nil];
	[self.tableView reloadData];
	
	
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
                [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    } else {
        if (title == UITableViewIndexSearch) {
            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
            return -1;
        } else {
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
        }
    }
}
#pragma mark -

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
		NSLog(@"[[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] %@",[[UILocalizedIndexedCollation currentCollation] sectionTitles]);
       // return [[self.sectionedListContent objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    }
}






@end
