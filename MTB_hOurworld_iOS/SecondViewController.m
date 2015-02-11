//
//  SecondViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/5/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "SecondViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"
#import "QuartzCore/QuartzCore.h"
#import "MTBItem.h"
#import "MTBTaskDetailViewController.h"
#import "MTBCategoryViewController.h"
#import "MTBTaskCategoryViewController.h"
#import "MTBProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DropDownListView.h"

@interface SecondViewController ()

@end

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 15.0f

@implementation SecondViewController

@synthesize scheduleList;
@synthesize scheduleListCopy;
@synthesize jsonArray;
@synthesize tableViewList;
@synthesize refreshBtn;
@synthesize addBtn;
@synthesize searchBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self downloadContent];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"OfferViewController";
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
    return [scheduleList count];
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
    MTBItem *tItem = [scheduleList objectAtIndex:indexPath.row];
    UIImageView *userImage = (UIImageView *)[cell viewWithTag:100];
    UILabel *userNameLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:102];
    UILabel *datetimeLabel = (UILabel *)[cell viewWithTag:103];
    
    // user image
    // reference: https://github.com/rs/SDWebImage
    //[userImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hourworld.org/%@", tItem.mProfileImage]] placeholderImage:[UIImage imageNamed:@"who_checkin_default.png"]];
    [userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hourworld.org/%@", tItem.mProfileImage]] placeholderImage:[UIImage imageNamed:@"who_checkin_default.png"]];
    userImage.layer.cornerRadius = userImage.frame.size.width / 2;
    userImage.clipsToBounds = YES;
    userImage.layer.borderWidth = 1.0f;
    userImage.layer.borderColor = [UIColor whiteColor].CGColor;
 
    // user name
    if (tItem.mUserName != (id)[NSNull null] && [tItem.mUserName length] != 0) {
        userNameLabel.text = tItem.mUserName;
    }
    else {
        userNameLabel.text = @"No username found";
    }
    
    // description
    if (tItem.mDescription != (id)[NSNull null] && [tItem.mDescription length] != 0) {
        [descriptionLabel setText:tItem.mDescription];
    }
    else {
        [descriptionLabel setText:@"No description found"];
    }
    
    
    // timestamp
    if (tItem.mTimestamp != (id)[NSNull null]) {
        NSArray *splitTimestamp = [tItem.mTimestamp componentsSeparatedByString:@" "];
        datetimeLabel.text = splitTimestamp[0];
    }
    else {
        datetimeLabel.text = @"No datetime found";
    }
    
    // user image clicked
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [cell.imageView addGestureRecognizer:tapGesture];
    cell.imageView.userInteractionEnabled = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    /*
    MTBItem *tItem = [scheduleList objectAtIndex:indexPath.row];
    NSString *text = tItem.mDescription;
    
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
	CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
	CGSize labelSize = [text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    int height = 0;
    
    if(text.length < 50) {
        height = 50;
    }
    else if(text.length >= 50 && text.length < 100) {
        height = 35;
    }
    else if(text.length > 500){
        height = -100;
    }
    else {
        height = 0;
    }

	return labelSize.height + height;
     */
    
    // let's fix the height to 90.0
    return 90.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"MTBTaskDetailViewController"]) {
        
        NSIndexPath *indexPath = [self.tableViewList indexPathForCell:sender];
        MTBItem *mItem = [scheduleList objectAtIndex:indexPath.row];
        
        MTBTaskDetailViewController *viewController = (MTBTaskDetailViewController *)[segue destinationViewController];
        [viewController setMItem:mItem];
        [viewController setMIsOffer:@"T"];
    }
    else if ([[segue identifier] isEqualToString: @"MTBTaskCategoryViewController"]) {
        
        MTBTaskCategoryViewController *viewController = (MTBTaskCategoryViewController *)[segue destinationViewController];
        [viewController setIsOffer:@"T"];
        [viewController setIsRequest:@"F"];
    }
}

- (IBAction)pressRefreshBtn:(id)sender {
    [self downloadContent];
    
}

- (IBAction)pressAddBtn:(id)sender {
    MTBCategoryViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBCategoryViewController"];
    [viewController setIsOffer:@"T"];
    [viewController setIsRequest:@"F"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)updateTimeLine {
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.title = @"Offers";
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    // automatically reload only if there is some insertion or deletion
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([[userDefault objectForKey:@"reload"] intValue] == 1) {
        
        // update to '0'
        [userDefault setInteger:0 forKey:@"reload"];
        
        [self downloadContent];
    }
    else {
        
    }
}

- (void) downloadContent {
    // start downloading
    // show a dialogbox asking download JSON strings
    // http://stackoverflow.com/questions/4269842/objective-c-server-requests-in-a-thread-like-asynctask-in-android
    // http://allseeing-i.com/ASIHTTPRequest/Setup-instructions
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params = @{@"requestType"     :@"Offers,30",
                             @"accessToken"     :[userDefault objectForKey:@"access_token"],
                             @"EID"             :[userDefault objectForKey:@"EID"],
                             @"memID"           :[userDefault objectForKey:@"memID"]};
    
    [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
                // check the return value of "success"
              if ([[responseObject objectForKey:@"success"] boolValue] == TRUE) {
                  jsonArray = [NSMutableArray arrayWithCapacity:0];
                  scheduleList = [NSMutableArray arrayWithCapacity:0];
                  [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
                  
                  NSLog(@"%@", jsonArray);
                  
                  int i;
                  int arrayCount = [jsonArray count];
                  bool hasItem = false;
                  
                  if(arrayCount > 0) {
                      // insert new items into the table
                      for (i = 0 ; i < arrayCount; i++) {
                          // get an item
                          NSDictionary *item = [jsonArray objectAtIndex:i];
                          NSDictionary *locObj = [item objectForKey:@"mobLatLon"];
                          
                          if ([[item objectForKey:@"Eblast"] isEqualToString:@""] || [[item objectForKey:@"Eblast"] isEqual:@"No messages found"]) {
                              continue;
                          }
                          
                          int xDays = 14;
                          
                          if ([[locObj objectForKey:@"xDays"] isEqual:[NSNull null]]) {
                              xDays = 14;
                          }
                          else {
                              xDays = [[locObj objectForKey:@"xDays"] intValue];
                          }
                          
                          MTBItem *tItem;
                          
                          NSString *memName = [NSString stringWithFormat:@"%@ %@", [item objectForKey:@"Fname"], [item objectForKey:@"Lname"]];
                          
                          if([locObj objectForKey:@"oLat"] != (id)[NSNull null] && [[locObj objectForKey:@"oLat"] intValue] != 0) {
                              tItem = [[MTBItem alloc] initToTask:[[item objectForKey:@"listMbrID"] intValue] Edescr:[item objectForKey:@"Descr"] ESvcCat:[item objectForKey:@"SvcCat"] EMemName:memName ESvcCatID:[[item objectForKey:@"SvcCatID"] intValue] ESvcID:[[item objectForKey:@"SvcID"] intValue] EService:[item objectForKey:@"Service"] ETimestamp:[item objectForKey:@"timestamp"] EProlfileImage:[item objectForKey:@"Profile"] EOLat:[[locObj objectForKey:@"oLat"] doubleValue] EOLon:[[locObj objectForKey:@"oLon"] doubleValue] EDLat:[[locObj objectForKey:@"dLat"] doubleValue] EDLon:[[locObj objectForKey:@"dLon"] doubleValue] EXDays:xDays EEmail1:[item objectForKey:@"Email1"]];
                              
                          }
                          else {
                              tItem = [[MTBItem alloc] initToTask:[[item objectForKey:@"listMbrID"] intValue] Edescr:[item objectForKey:@"Descr"] ESvcCat:[item objectForKey:@"SvcCat"] EMemName:memName ESvcCatID:[[item objectForKey:@"SvcCatID"] intValue] ESvcID:[[item objectForKey:@"SvcID"] intValue] EService:[item objectForKey:@"Service"] ETimestamp:[item objectForKey:@"timestamp"] EProlfileImage:[item objectForKey:@"Profile"] EOLat:[[locObj objectForKey:@"oLat"] doubleValue] EOLon:[[locObj objectForKey:@"oLon"] doubleValue] EDLat:[[locObj objectForKey:@"dLat"] doubleValue] EDLon:[[locObj objectForKey:@"dLon"] doubleValue] EXDays:xDays EEmail1:[item objectForKey:@"Email1"]];
                          }
                          
                          hasItem = true;
                          
                          [scheduleList addObject:tItem];
                      }
                  }
                  else {
                      NSLog(@"No data available");
                  }
                  
                  if (hasItem == false) {
                      UIAlertView *dialog = [[UIAlertView alloc]init];
                      [dialog setDelegate:nil];
                      [dialog setTitle:@"Message"];
                      [dialog setMessage:@"No result."];
                      [dialog addButtonWithTitle:@"OK"];
                      [dialog show];
                  }
                  
                  [tableViewList reloadData];
              }
              else {
                  UIAlertView *dialog = [[UIAlertView alloc]init];
                  [dialog setDelegate:self];
                  [dialog setTitle:@"Message"];
                  [dialog setMessage:@"No result."];
                  [dialog addButtonWithTitle:@"OK"];
                  [dialog show];
              }
        
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", operation);
          }];
}

- (IBAction)pressSearchBtn:(id)sender {
    [Dropobj fadeOut];
    [self showPopUpWithTitle:@"Select Category" withOption:categoryList xy:CGPointMake(18, 58) size:CGSizeMake(287, 350) isMultiple:NO];
}

-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    
    
    Dropobj = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    Dropobj.delegate = self;
    [Dropobj showInView:self.view animated:YES];
    
    /*----------------Set DropDown backGroundColor-----------------*/
    [Dropobj SetBackGroundDropDwon_R:0.0 G:108.0 B:194.0 alpha:0.90];
    
}

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{

    NSString *selectedCategory = [categoryList objectAtIndex:anIndex];
    
    if ([selectedCategory isEqualToString:@"All"]) { // show all
        scheduleList = [NSMutableArray arrayWithArray:scheduleListCopy];
    }
    else if ([selectedCategory isEqualToString:@"My Offers"]) {
        [scheduleList removeAllObjects];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        for (int i = 0; i < [scheduleListCopy count]; i++) {
            MTBItem *tItem = [scheduleListCopy objectAtIndex:i];
            
            if (tItem.mListMbrID == [[userDefault objectForKey:@"memID"] intValue]) {
                [scheduleList addObject:tItem];
            }
        }
    }
    else { // show a list of categories posted
        
        [scheduleList removeAllObjects];
        
        for (int i = 0; i < [scheduleListCopy count]; i++) {
            MTBItem *tItem = [scheduleListCopy objectAtIndex:i];
            
            if ([tItem.mSvcCat isEqual:selectedCategory]) {
                [scheduleList addObject:tItem];
            }
        }
    }
    
    [tableViewList reloadData];
}

- (void)DropDownListViewDidCancel{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]]) {
        [Dropobj fadeOut];
    }
}

-(CGSize)GetHeightDyanamic:(UILabel*)lbl
{
    NSRange range = NSMakeRange(0, [lbl.text length]);
    CGSize constraint;
    constraint= CGSizeMake(288 ,MAXFLOAT);
    CGSize size;
    
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)) {
        NSDictionary *attributes = [lbl.attributedText attributesAtIndex:0 effectiveRange:&range];
        CGSize boundingBox = [lbl.text boundingRectWithSize:constraint options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    }
    else{
        
        
        //size = [lbl.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        size = [lbl.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14]}];
        
        
    }
    return size;
}


@end