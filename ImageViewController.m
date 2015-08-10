//
//  ImageViewController.m
//  Imaginarium
//
//  Created by Tamara L Blood on 7/28/15.
//  Copyright (c) 2015 tamblood. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation ImageViewController

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  return self.imageView;
}

-(void)setScrollView:(UIScrollView *)scrollView
{
  _scrollView = scrollView;
  _scrollView.minimumZoomScale = 0.2;
  _scrollView.maximumZoomScale = 2.0;
  _scrollView.delegate = self;
  self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

-(void)setImageUrl:(NSURL *)imageUrl
{
  _imageUrl = imageUrl;
// self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageUrl]];
  [self startDownloadingImage];
}

-(void)startDownloadingImage
{
  self.image = nil;
  [self.spinner startAnimating];
  if (self.imageUrl)
  {
    NSURLRequest *request = [NSURLRequest requestWithURL:self.imageUrl];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
      if (!error)
      {
        if([request.URL isEqual:self.imageUrl])
        {
          UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
          dispatch_async(dispatch_get_main_queue(),^{ self.image = image; });
        }
      }
    }];
    
    [task resume];
  }
}

-(UIImageView *)imageView
{
  if (!_imageView)
  {
    _imageView = [[UIImageView alloc] init];
  }
  return _imageView;
}

-(UIImage *)image
{
  return self.imageView.image;
}

-(void)setImage:(UIImage *)image
{
  self.imageView.image = image;
  self.scrollView.zoomScale = 1.0;
  [self.imageView sizeToFit];
  self.scrollView.frame = CGRectMake(0,0, image.size.width, image.size.height);
  self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
  [self.spinner stopAnimating];
}

-(void)viewDidLoad
{
  [super viewDidLoad];
  [self.scrollView addSubview:self.imageView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
