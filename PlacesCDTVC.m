//
//  PlacesCDTVC.m
//  FlickrPlacesMania
//
//  Created by Tamara L Blood on 8/9/15.
//  Copyright (c) 2015 tamblood. All rights reserved.
//

#import "PlacesCDTVC.h"
#import "Place.h"
#import "Place+Flickr.h"
#import "FlickrFetcher.h"
#import "ATopPlaceFlickrPhotosTVC.h"

@interface PlacesCDTVC ()
@property (strong, nonatomic) UIManagedDocument *document;
@end

@implementation PlacesCDTVC

- (IBAction)startFlickrFetch
{
  [self.refreshControl beginRefreshing];
  NSURL *url = [FlickrFetcher URLforTopPlaces];
  NSData *jsonResults = [NSData dataWithContentsOfURL:url];
  NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                      options:0
                                                                        error:NULL];
  //  NSLog(@"Property list results are: %@", propertyListResults);
  NSArray *places = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PLACES];
  
  NSManagedObjectContext *context = self.managedObjectContext;
  [context performBlock:^{
    [Place loadPlacesFromFlickrArray:places intoManagedObjectContext:context];
  }];
  
}

-(void)documentIsReady
{
  if (self.document.documentState == UIDocumentStateNormal) { // start using document
    NSManagedObjectContext *context = self.document.managedObjectContext;
    self.managedObjectContext = context;
    
    // start fetching
    [self startFlickrFetch];
  }
}

- (void)createUIManagedDocument
{
  UIManagedDocument *document = nil;
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *documentName = @"FlickrPlacesMania";
  NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] firstObject];
  NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
  
  document = [[UIManagedDocument alloc] initWithFileURL:url];
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
    [document openWithCompletionHandler:^(BOOL success) {
      if (success) {
        [self documentIsReady];
      }
      if (!success) {
        NSLog(@"error could not open document at %@", url);
      }
    }]; } else {
      [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating
        completionHandler:^(BOOL success) {
          if (success) {
            [self documentIsReady];
          }
          if (!success) {
            NSLog(@"error could not create document at %@", url);
          }
        }];
    }
  self.document = document;
}


-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
  _managedObjectContext = managedObjectContext;
  [self.tableView reloadData];
  
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
  request.predicate = nil;
  request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"country" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"stateProvince" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"city" ascending:YES]];
  
  self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request          managedObjectContext:managedObjectContext sectionNameKeyPath:@"country" cacheName:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Place Cell"];
  
  Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.textLabel.text = place.city;
  cell.detailTextLabel.text = place.stateProvince;
  
  return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUIManagedDocument];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

//-(void)prepareATopPlaceController:(ATopPlaceFlickrPhotosTVC *)atpfptvc toDisplayPhotoListFromPlace:(NSDictionary *)place
//{
//  atpfptvc.title = [place valueForKeyPath:FLICKR_PLACE_CITY];
//  atpfptvc.flickrPlaceId = [place valueForKeyPath:FLICKR_PLACE_ID];
//  atpfptvc.maxResults = 50;
//}

-(void)prepareATopPlaceController:(ATopPlaceFlickrPhotosTVC *)atpfptvc toDisplayPhotoListFromPlace:(Place *)place
{
  atpfptvc.title = place.city;
  atpfptvc.flickrPlaceId = place.placeId;
  atpfptvc.maxResults = 50;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  if ([sender isKindOfClass:[UITableViewCell class]]) {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (indexPath) {
      if ([segue.identifier isEqualToString:@"Display Flickr Place Photo List"]) {
        if ([segue.destinationViewController isKindOfClass:[ATopPlaceFlickrPhotosTVC class]]) {
          [self prepareATopPlaceController:segue.destinationViewController                          toDisplayPhotoListFromPlace:place];
        }
      }
    }
  }
  else
  {
    NSLog(@"error - sender is not kind of class UITableViewCell");
  }
  
}


@end
