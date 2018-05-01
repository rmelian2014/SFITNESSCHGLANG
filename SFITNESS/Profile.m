//
//  Profile.m
//  SFITNESS
//
//  Created by BRO on 02/03/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "Profile.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "twoColumnTableViewCell.h"
#import "ProfileEdit.h"
#include <CommonCrypto/CommonDigest.h>

@interface Profile (){
    
    AppDelegate *appDelegate;
    NSString *sURL, *strResult, *sRemaining;
    NSString *sMemCode, *sLanguage;
    NSArray *profileName;
    NSMutableArray  *arrayForTableView;

}

@end

@implementation Profile

@synthesize profileData;
@synthesize lblName;
@synthesize lblPoints;
@synthesize lblRewards;
@synthesize btnEditProfile;
@synthesize btnChgLang;
@synthesize btnLogOut;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor : [ UIColor grayColor]];
    //=== Set the navigation Bar text color
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //self.navigationController.navigationBar.translucent = NO;
    
    //=== Customize the btn
    btnEditProfile.layer.cornerRadius =7.0f;
    btnEditProfile.layer.shadowRadius = 3.0f;
    btnEditProfile.layer.shadowColor = [UIColor blackColor].CGColor;
    btnEditProfile.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    btnEditProfile.layer.shadowOpacity = 0.5f;
    btnEditProfile.layer.masksToBounds = NO;
    
    //=== Customize the btn
    btnChgLang.layer.cornerRadius =7.0f;
    btnChgLang.layer.shadowRadius = 3.0f;
    btnChgLang.layer.shadowColor = [UIColor blackColor].CGColor;
    btnChgLang.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    btnChgLang.layer.shadowOpacity = 0.5f;
    btnChgLang.layer.masksToBounds = NO;
    
    //=== Customize the btn
    btnLogOut.layer.cornerRadius =7.0f;
    btnLogOut.layer.shadowRadius = 3.0f;
    btnLogOut.layer.shadowColor = [UIColor blackColor].CGColor;
    btnLogOut.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    btnLogOut.layer.shadowOpacity = 0.5f;
    btnLogOut.layer.masksToBounds = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    
    //--- Call the stored txtMemCode, something like session ---
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    sMemCode = [defaults objectForKey:@"txtMemCode"];
    sLanguage = [defaults objectForKey:@"txtLanguage"];
    
    if ([sLanguage isEqualToString:@"CN"]){
        
        [btnEditProfile setTitle:@"编辑个人资料" forState:UIControlStateNormal];
        [btnChgLang setTitle:@"更改语言" forState:UIControlStateNormal];
        [btnLogOut setTitle:@"登出" forState:UIControlStateNormal];
        
    }
    
    [self loadProfileTable];
    [self.profileTableView reloadData]; //==== to reload when back from EditProfile VC
    
    //=== Customize the Table View
    self.profileTableView.backgroundColor = [UIColor lightGrayColor];
    self.profileTableView.layer.borderColor = [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:0.8].CGColor;
    self.profileTableView.layer.borderWidth = 0;
    self.profileTableView.layer.cornerRadius = 0;
    self.profileTableView.clipsToBounds = YES;
    self.profileTableView.layer.masksToBounds = YES;
    [self.profileTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(void)viewDidAppear:(BOOL)animated{
    
    if ([sLanguage isEqualToString:@"CN"]){
        
        self.navigationController.navigationBar.topItem.title = @"我的资料";
        
    }
}

- (void)loadProfileTable{
    
    if ([sLanguage isEqualToString:@"CN"]){
    
        profileName = [NSArray arrayWithObjects:@"邮件", @"电话", @"地址1",@"地址2",@"地址3", @"邮编", @"州省",@"国家",@"性别", nil];
        
    }else{
        
        profileName = [NSArray arrayWithObjects:@"Email", @"Phone", @"Address1",@"Address2",@"Address3", @"Post Code", @"State",@"Country",@"Gender", nil];
    }
    
    //--- Pass the string to web and get the return Profile Data result
    //=== Concatenate the sMemCode and bsh368 and pass to the method sha256 to return an Encoded string.
    NSString *sInput = [sMemCode stringByAppendingString:@"bsh368"];
    
    NSString *sEnCode = [[NSString alloc] init];
    sEnCode = [self sha256:sInput];
    
    //NSLog(@" This is sEnCode : %@",sEnCode);
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sURL = appDelegate.gURL;
    sURL = [sURL stringByAppendingString:@"/apps/getinfo.asp?"];
    sURL = [sURL stringByAppendingString:@"memCode="];
    sURL = [sURL stringByAppendingString:sMemCode];
    sURL = [sURL stringByAppendingString:@"&encode="];
    sURL = [sURL stringByAppendingString:sEnCode];
    
    self.responseData = [NSMutableData data];
    
    NSLog(@" This will be loaded : %@",sURL);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:sURL]];
    
    (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //NSLog(@"didFailWithError");
    //NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
    //[spinner stopAnimating];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //NSLog(@"connectionDidFinishLoading");
    //NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    strResult = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"This returned response.write stuff %@", strResult);
    
    NSString *sSeparator= @"|";
    
    NSRange range = [strResult rangeOfString:sSeparator];
    NSInteger position = range.location + range.length;
    NSString *sLoop = [strResult substringToIndex:position-1];
    sRemaining = [strResult substringFromIndex:position];
    
    NSLog(@"This is sLoop %@", sLoop);
    
    if ([sLoop isEqualToString:@"ERR"]){
        
        NSLog(@"This is sRemaining %@", sRemaining);
        
        UIAlertController * alert; alert = [UIAlertController alertControllerWithTitle:@"Error!" message:sRemaining preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancel; cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                         {
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }];
        
        [alert addAction:cancel ];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        NSString *sSeparator= @"|";
        
        //=== Take away the data for the first 2 pipes.
        NSRange range = [strResult rangeOfString:sSeparator];
        NSInteger position = range.location + range.length;
        sRemaining = [strResult substringFromIndex:position];
        
        range = [sRemaining rangeOfString:sSeparator];
        position = range.location + range.length;
        sRemaining = [sRemaining substringFromIndex:position];
        
        profileData = [[NSMutableArray alloc] init];
        
        do {
            
            range = [sRemaining rangeOfString:sSeparator];
            position = range.location + range.length;
            
            //NSLog(@"The remainning : %@ ", sRemaining);
            
            if(range.length == 1){
                NSString *sProfileData = [sRemaining substringToIndex:position-1];
                sRemaining = [sRemaining substringFromIndex:position];
                [profileData addObject:sProfileData];
                
            }else{
                
                [profileData addObject:sRemaining];
            }
            
        } while (range.length == 1); //=== will keep on doing until there is no more pipes |

        NSLog(@"The ProfileData Array : %@ ", profileData);
    
    }
    //=== Label the Name label first
    self.lblName.text = [profileData objectAtIndex:0];
    NSString *credits = [profileData objectAtIndex:10];
    NSString *points = [profileData objectAtIndex:11];
    
    if ([sLanguage isEqualToString:@"CN"]){
        
        self.lblPoints.text = [credits stringByAppendingString:@" 钱币"];
        
        self.lblRewards.text = [points stringByAppendingString:@" 忠诚点"];
        
        
    }else{
    
        self.lblPoints.text = [credits stringByAppendingString:@" CREDITS"];
   
        self.lblRewards.text = [points stringByAppendingString:@" POINTS"];
    }
    
    //=== Copy to another array because I need to remove Name for the Table View
    arrayForTableView = [[NSMutableArray alloc] initWithArray:profileData copyItems:YES];
    //=== Remove Name from the Mutable Array
    [arrayForTableView removeObjectAtIndex:0];
    
    //=== Use table view natural loop to insert each and every object.
    //=== Reload TableView because, the response.write just finish loaded and processed. 
    [self.profileTableView reloadData];
}

//*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [profileName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"twoColumnCell";

    twoColumnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }

    cell.lblProfileName.text = [profileName objectAtIndex:indexPath.row];
    cell.lblProfileData.text = [arrayForTableView objectAtIndex:indexPath.row];

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ProfileEdit *target = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"EditProfile"]) {
        
        target.dataFromProfile = profileData;
    }
}




- (IBAction)btnEditProfile:(id)sender {
    
    [self performSegueWithIdentifier:@"EditProfile" sender:self];
}

- (IBAction)btnChgLang:(id)sender {
    
    
    [self performSegueWithIdentifier:@"ChangeLang" sender:self];
    
}



- (IBAction)btnLogOut:(id)sender {
    
    User *userObj = [[User alloc] init];
    [userObj logout];
    
    //AppDelegate *authObj = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //authObj.authenticated = YES;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    RootViewController *initView =  (RootViewController*)[storyboard instantiateViewControllerWithIdentifier:@"RootNavigationControllerID"];
    [initView setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:initView animated:NO completion:nil];
    
}

-(NSString*) sha256:(NSString *)clear{
    const char *s=[clear cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}

@end
