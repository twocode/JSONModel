//
//  MasterViewController.m
//  JSONModelDemo
//
//  Created by Marin Todorov on 02/12/2012.
//  Copyright (c) 2012 Underplot ltd. All rights reserved.
//

#import "MasterViewController.h"

#import "KivaViewController.h"
#import "GitHubViewController.h"
#import "YouTubeViewController.h"
#import "StorageViewController.h"
#import "KivaViewControllerNetworking.h"

#import "JSONModel+networking.h"
#import "VideoModel.h"

#import <objc/runtime.h>
#import <objc/message.h>

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

/*
#define OPT(type, opt, name) type name; @property id opt name##Property__;
#define OptionalProperties(...) @property BOOL zz_____OptionalPropertiesBegin;  __VA_ARGS__ @property BOOL zz_____OptionalPropertiesEnd;

@interface Ignore_Model : JSONModel

//OptionalProperties
//(
    @property (strong, nonatomic) NSNumber<Optional>* oName;
//)

@property (assign, nonatomic) OPT(BOOL, <Optional>, name);
@property (strong, nonatomic) NSNumber<Ignore, Optional, Index>* iName;
@property (strong, nonatomic) NSDate* mydate;

@end

@implementation Ignore_Model

//@dynamic nameProperty;

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return ([propertyName isEqualToString:@"name"]);
}

@end

@interface TopModel : JSONModel
@property (strong, nonatomic) Ignore_Model* im;
@end

@implementation TopModel
@end
*/

#define modelOptional

@protocol JSONAnswer

@end

//
// JSON Connector
//

@protocol JSONAnswerJSON

@required
@property (nonatomic) NSString* name;

@optional
@property (nonatomic) NSString* age;

-(void)importAgeFromJSON:(id)value;
-(id)exportAgeToJSON;

-(void)importAgeFromCoreData:(id)value;
-(id)exportAgeToCoreData;

@end

@interface Model : JSONModel 
@property (copy, nonatomic) NSString * no;
@property (copy, nonatomic) NSString * desc;
@end

@implementation Model
@synthesize no      = _no;
@synthesize desc    = _desc;

- (id)init
{
    self = [super init];
    
    assert(self != nil);
    
    _no     = nil;
    _desc   = nil;
    
    return self;
}

@end

@interface TopModel : JSONModel
@property (copy, nonatomic) NSString * id;
@property (copy, nonatomic) NSString * name;
@property (strong, nonatomic) Model * model;

-(id)initWithString:(NSString*)string error:(JSONModelError**)err;

@end

@implementation TopModel
@synthesize id      = _id;
@synthesize name    = _name;
@synthesize model   = _model;

-(id)initWithString:(NSString*)string error:(JSONModelError**)err
{
    self = [super initWithString:string error:err];
    
    if (self) {
        _model = [[Model alloc] init];
//        _model.no = @"TEST";
//        [self setValue:@"mabide" forKeyPath:@"model.no"];
    } else {
        //ERROR
    }
    
    return self;
}

+(BOOL)propertyIsIgnored:(NSString *)propertyName
{
    return NO;
}
-(NSString*)getText
{
    return @"1123";
}


+(JSONKeyMapper*)keyMapper
{
    return [JSONKeyMapper mapperFromCamelCaseToObjCKey];
}
@end

@implementation MasterViewController

-(void)viewDidAppear:(BOOL)animated
{
    
//    NSString* json = @"{\"id\":1, \"answer\": {\"name\":\"marin\"}, \"dict\":[], \"description\":\"Marin\"}";
    NSString* json2 = @"{\"id\": \"123456\", \"name\": \"little\", \"modelNo\": \"model 1586\",  \"modelDesc\": \"a short description\"}";

    TopModel* tm = [[TopModel alloc] initWithString:json2 error:nil];
    NSLog(@"tm: %@", tm.toDictionary);
    NSLog(@"to string: %@", tm.toJSONString);
}

-(IBAction)actionLoadCall:(id)sender
{
    [JSONHTTPClient getJSONFromURLWithString:@"http://localhost/testapi/test.php"
                                  completion:^(NSDictionary *json, JSONModelError *err) {
                                      
                                      NSLog(@"GOT: %@", [json allKeys]);
                                      
                                  }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Demos";
        _objects = [NSMutableArray arrayWithArray:@[@"Kiva.org demo", @"GitHub demo", @"Youtube demo", @"Used for storage"]];
    }
    return self;
}
							
#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            KivaViewController* kiva  = [[KivaViewController alloc] initWithNibName:@"KivaViewController" bundle:nil];
            [self.navigationController pushViewController:kiva animated:YES];
        }break;
            
        case 1:{
            GitHubViewController* gh  = [[GitHubViewController alloc] initWithNibName:@"GitHubViewController" bundle:nil];
            [self.navigationController pushViewController:gh animated:YES];
        }break;
            
        case 2:{
            YouTubeViewController* yt  = [[YouTubeViewController alloc] initWithNibName:@"YouTubeViewController" bundle:nil];
            [self.navigationController pushViewController:yt animated:YES];
        }break;
            
        case 3:{
            StorageViewController* sc  = [[StorageViewController alloc] initWithNibName:@"StorageViewController" bundle:nil];
            [self.navigationController pushViewController:sc animated:YES];
        }break;

        default:
            break;
    }
}

//-(BOOL)__importDictionary:(NSDictionary*)dict withKeyMapper:(JSONKeyMapper*)keyMapper validation:(BOOL)validation error:(NSError**)err
//{
//    [super __]
//}

@end
