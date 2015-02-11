//
//  MTBGroupMessageViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/29/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBGroupMessageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"

#import "MTBProfileViewController.h"

@interface MTBGroupMessageViewController ()

@end

@implementation MTBGroupMessageViewController

@synthesize jsonArray;
@synthesize tableViewList;
@synthesize groupID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self downloadContent];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [jsonArray count];
}


// ref: http://www.colejoplin.com/2012/09/28/ios-tutorial-basics-of-table-views-and-prototype-cells-in-storyboards/
// ref2:http://www.appcoda.com/ios-programming-customize-uitableview-storyboard/
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // display items
    NSDictionary *item = [jsonArray objectAtIndex:indexPath.row];
    UIImageView *userImage = (UIImageView *)[cell viewWithTag:100];
    UILabel *userNameLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:102];
    UILabel *datetimeLabel = (UILabel *)[cell viewWithTag:103];
    
    // user image
    // reference: https://github.com/rs/SDWebImage
    NSString *profileImage = [[item objectForKey:@"postProfile"] stringByReplacingOccurrencesOfString:@".." withString:@""];
    //[userImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hourworld.org/%@", profileImage]] placeholderImage:[UIImage imageNamed:@"who_checkin_default.png"]];
    [userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hourworld.org/%@", profileImage]] placeholderImage:[UIImage imageNamed:@"who_checkin_default.png"]];

    // user name
    userNameLabel.text = [item objectForKey:@"postOwName"];
    
    NSString *postMessage = [item objectForKey:@"postMsg"];
    postMessage = [postMessage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    postMessage = [postMessage stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    postMessage = [postMessage stringByReplacingOccurrencesOfString:@"<span class='cat'> " withString:@"\n"];
    postMessage = [postMessage stringByReplacingOccurrencesOfString:@" </span>" withString:@""];
    
    [descriptionLabel setText:postMessage];
    datetimeLabel.text = [item objectForKey:@"postDate"];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [cell.imageView addGestureRecognizer:tapGesture];
    cell.imageView.userInteractionEnabled = YES;
    
    return cell;
}

/*
- (void)imageTapped:(UITapGestureRecognizer *)gesture {
    UITableViewCell *cell = [[[gesture view] superview] superview];
    NSIndexPath *tappedIndexPath = [self.tableViewList indexPathForCell:cell];
    
    NSDictionary *item = [jsonArray objectAtIndex:tappedIndexPath.row];
    
    MTBProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBProfileViewController"];
	[viewController setMemID:[[item objectForKey:@"postOwner"] intValue]];
    [self.navigationController pushViewController:viewController animated:YES];
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSDictionary *item = [jsonArray objectAtIndex:indexPath.row];
    
    NSString *postMessage = [item objectForKey:@"postMsg"];
    postMessage = [postMessage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    postMessage = [postMessage stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    postMessage = [postMessage stringByReplacingOccurrencesOfString:@"<span class='cat'> " withString:@"\n"];
    postMessage = [postMessage stringByReplacingOccurrencesOfString:@" </span>" withString:@""];
    
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
	//CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
	//CGSize labelSize = [postMessage sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    CGSize labelSize = [postMessage sizeWithAttributes:@{NSFontAttributeName:cellFont}];
    
    int height = 0;
    
    if(postMessage.length < 50) {
        height = 50;
    }
    else if(postMessage.length >= 50 && postMessage.length < 100) {
        height = 35;
    }
    else if(postMessage.length > 500){
        height = -100;
    }
    else {
        height = 0;
    }
    
	return labelSize.height + height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    NSDictionary *item = [jsonArray objectAtIndex:indexPath.row];
    
    MTBProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBProfileViewController"];
	[viewController setMemID:[[item objectForKey:@"postOwner"] intValue]];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[self navigationItem] setTitle:@"Group messages"];
    [super viewWillAppear:animated];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
}

- (void) downloadContent {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params = @{@"requestType"     :@"EditGroups,PLAY",
                             @"accessToken"     :[userDefault objectForKey:@"access_token"],
                             @"EID"             :[userDefault objectForKey:@"EID"],
                             @"memID"           :[userDefault objectForKey:@"memID"]};
    
    [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
              if(![[responseObject objectForKey:@"results"]isEqual:[NSNull null]] && ![[responseObject objectForKey:@"results"]isEqual:@"{}"]) {
                  jsonArray = [NSMutableArray arrayWithCapacity:0];
                  [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
                  
                  [tableViewList reloadData];
              }
              else {
                  UIAlertView *dialog = [[UIAlertView alloc]init];
                  [dialog setDelegate:self];
                  [dialog setTitle:@"Message"];
                  [dialog setMessage:@"No messages found"];
                  [dialog addButtonWithTitle:@"OK"];
                  [dialog show];
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", operation);
          }];
}

@end
