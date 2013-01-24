//
//  TableViewController.m
//  TableSearchExample
//
//  Created by hemant kumar on 03/01/13.
//  Copyright (c) 2013 hemant kumar. All rights reserved.
//

#import "TableViewController.h"
#import "DetailViewController.h"
#import "Country.h"
#import "SQLiteOperation.h"

@interface TableViewController ()

@end

@implementation TableViewController
@synthesize  savedSearchTerm;
@synthesize  contentsList;
@synthesize  searchResults;

static NSArray *countryNames = nil;
static NSArray *countryCodes = nil;
static NSDictionary *countryNamesByCode = nil;
static NSDictionary *countryCodesByName = nil;

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
   // NSLog(@"names---->%@",names);
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[names sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
	
	[self setContentsList:array];
	if ([self savedSearchTerm])
	{
        [[[self searchDisplayController] searchBar] setText:[self savedSearchTerm]];
    }
      cellCount=[[NSMutableArray alloc]init];
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
        [cellCount addObject:[NSNumber numberWithInt:[self.sectionArray count]]];

          [totalSections setValue:self.sectionArray forKey:str];
        NSLog(@"self.sectionArray %@",[self.sectionArray description]);

    }
    NSLog(@"sections %@",[totalSections description]);
     NSLog(@"cellout----------->%@",cellCount);
	[self.tableView reloadData];
    
  
    
      
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];


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
    if(tableView == [[self searchDisplayController] searchResultsTableView])
        return 1;
    return [[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows;
    key=[[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles] objectAtIndex:section];
    NSLog(@"totalSections--------->%@---->%@",totalSections,[totalSections valueForKey:key]);
   // NSArray *rowInSectionsArrary = [totalSections valueForKey:key];
   
    
	if (tableView == [[self searchDisplayController] searchResultsTableView])
		rows = [[self searchResults] count];
	else
		rows =  [[cellCount objectAtIndex:section] intValue];
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
        
        UILabel *cellTitle=cell.textLabel;
        [cellTitle setBackgroundColor:[UIColor clearColor]];
        [cellTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        [cellTitle setTextColor:[UIColor darkGrayColor]];
        [cellTitle setText:[rowInSectionsArrary objectAtIndex:indexPath.row]];
        [cell.contentView addSubview:cellTitle];
       // cell.textLabel.text = [rowInSectionsArrary objectAtIndex:indexPath.row];
       
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
    
    NSString *key1 =[[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles] objectAtIndex:indexPath.section];
    NSArray *rowInSectionsArrary = [totalSections valueForKey:key1];
    
    if (tableView == [[self searchDisplayController] searchResultsTableView])
    {
        detailViewController.labelStr = [[self searchResults] objectAtIndex:indexPath.row];
        
    }
	else
    {
        detailViewController.labelStr = [rowInSectionsArrary objectAtIndex:indexPath.row];
        
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

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//	if (tableView == self.searchDisplayController.searchResultsTableView) {
//        return nil;
//    } else {
//		//NSLog(@"[[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] %@",[[UILocalizedIndexedCollation currentCollation] sectionTitles]);
//        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
//    }
//}


- (IBAction)save:(id)sender
{
    // Save the list to the SQLite database
    [[SQLiteOperation shared] cleanAllDataFromCountry];
    [TableViewController initialize];

    
    NSLog(@"count--------->%d %d",[contentsList count],[[countryNamesByCode allKeys] count]);
    
    for (NSString *code in [countryNamesByCode allKeys])
    {
        Country *countryinfo = [[Country alloc]init ];
        countryinfo.name =[countryNamesByCode objectForKey:code];
        countryinfo.code = code;
        [[SQLiteOperation shared] addCountry:countryinfo];

    }
       
   // [self showEmployeesFromSQLite:sender];
    
    
    
}


- (IBAction)showEmployeesFromSQLite:(id)sender
{
    //  ViewController *customerListViewController = [[ViewController alloc] init];
       [[self contentsList] removeAllObjects];
    
    NSArray *countryList = [[SQLiteOperation shared] getAllCountry];
       
    // Give the list to the main view controller
    [[self contentsList]addObjectsFromArray:countryList];
    
    
    
    [self.tableView reloadData];
    
}
+ (void)initialize
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"];
    countryNamesByCode = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSMutableDictionary *codesByName = [NSMutableDictionary dictionary];
    for (NSString *code in [countryNamesByCode allKeys])
    {
        [codesByName setObject:code forKey:[countryNamesByCode objectForKey:code]];
    }
    countryCodesByName = [codesByName copy];
    
    NSArray *names = [countryNamesByCode allValues];
    countryNames = ([names sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]);
    
    NSMutableArray *codes = [NSMutableArray arrayWithCapacity:[names count]];
    for (NSString *name in countryNames)
    {
        [codes addObject:[countryCodesByName objectForKey:name]];
    }
    countryCodes = [codes copy];
}

+ (NSArray *)countryNames
{
    return countryNames;
}

+ (NSArray *)countryCodes
{
    return countryCodes;
}

+ (NSDictionary *)countryNamesByCode
{
    return countryNamesByCode;
}

+ (NSDictionary *)countryCodesByName
{
    return countryCodesByName;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //View with the button to expand and shrink and
    //Label to display the Heading.
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 323, 44)];
    
    
    //Background Image
    UIImageView *headerBg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sectionBg.png"]];
    [headerView addSubview:headerBg];
    
    //Button
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 7, 30, 30);
    button.tag=section+1;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"shrink.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"disclosure.png"] forState:UIControlStateSelected];
    
    if([[cellCount objectAtIndex:section] intValue]==0) button.selected=YES;
    else button.selected=NO;
    
    [headerView addSubview:button];
    
    //Label
    UILabel *headerTitle=[[UILabel alloc]initWithFrame:CGRectMake(30, 7, 300, 30)];
    [headerTitle setBackgroundColor:[UIColor clearColor]];
    [headerTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [headerTitle setTextColor:[UIColor darkGrayColor]];
    [headerTitle setText:[[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section]];
    [headerView addSubview:headerTitle];
    
    
    return  headerView;
}

-(IBAction)buttonClicked:(id)sender
{
    UIButton *button=(UIButton *)sender;
    NSInteger _index=[sender tag]-1;
    
    if(![button isSelected])
        [cellCount replaceObjectAtIndex:_index withObject:[NSNumber numberWithInt:0]];
    else
    {
        NSLog(@"[self.sectionArray count]--->%d",[[totalSections valueForKey:key] count]);
        
        key=[[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles] objectAtIndex:_index];
     //   NSLog(@"totalSections--------->%@---->%@",totalSections,[totalSections valueForKey:key]);
        [cellCount replaceObjectAtIndex:_index withObject:[NSNumber numberWithInt:[[totalSections valueForKey:key] count]]];
    }
    
    [self.tableView reloadData];
    
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    NSLog(@"[cellCount objectAtIndex:section]----->%d",[[cellCount objectAtIndex:section] intValue]);
//    
//    return [[cellCount objectAtIndex:section] intValue];
//    
//}





- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  YES;
}



@end
