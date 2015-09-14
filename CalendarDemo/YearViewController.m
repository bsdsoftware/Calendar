//
//  YearViewController.m
//  CalendarDemo - Graphical Calendars Library for iOS
//
//  Copyright (c) 2014-2015 Julien Martin. All rights reserved.
//

#import "YearViewController.h"
#import "NSCalendar+MGCAdditions.h"


@interface YearViewController ()

@property (nonatomic) NSDateFormatter *dateFormatter;

@end


@implementation YearViewController

- (MGCYearCalendarView*)yearCalendarView
{
	return (MGCYearCalendarView*)self.view;
}

- (NSDateFormatter*)dateFormatter
{
	if (!_dateFormatter) {
		_dateFormatter = [NSDateFormatter new];
		_dateFormatter.calendar = self.calendar;
		_dateFormatter.dateFormat = @"yyyy";
	}
	return _dateFormatter;
}

- (void)setCalendar:(NSCalendar*)calendar
{
	_calendar = calendar;
	self.yearCalendarView.calendar = calendar;
	self.dateFormatter.calendar = calendar;
}

#pragma mark - MGCYearCalendarViewDelegate

- (void)calendarYearViewDidScroll:(MGCYearCalendarView*)view
{
	NSDate *date = [self.yearCalendarView dateForMonthAtPoint:self.yearCalendarView.center];
	if (date) {
		[self.delegate calendarViewController:self didShowDate:date];
	}
}

- (void)calendarYearView:(MGCYearCalendarView *)view didSelectMonthAtDate:(NSDate*)date
{
	if ([self.delegate respondsToSelector:@selector(yearViewController:didSelectMonthAtDate:)]) {
		[self.delegate yearViewController:self didSelectMonthAtDate:date];
	}
}

#pragma mark - CalendarControllerNavigation

- (NSDate*)centerDate
{
	MGCDateRange *visibleRange = [self.yearCalendarView visibleMonthsRange];
	if (visibleRange) {
		NSUInteger monthCount = [self.calendar components:NSMonthCalendarUnit fromDate:visibleRange.start toDate:visibleRange.end options:0].month;
		NSDateComponents *comp = [NSDateComponents new];
		comp.month = monthCount / 2;
		NSDate *centerDate = [self.calendar dateByAddingComponents:comp toDate:visibleRange.start options:0];
		return [self.calendar mgc_startOfMonthForDate:centerDate];
	}
	return nil;
}

- (void)moveToDate:(NSDate*)date animated:(BOOL)animated
{
	[self.yearCalendarView scrollToDate:date animated:animated];
}

- (void)moveToNextPageAnimated:(BOOL)animated
{
	NSDateComponents *comps = [NSDateComponents new];
	comps.year = 1;
	NSDate *date = [self.calendar dateByAddingComponents:comps toDate:[self.yearCalendarView visibleMonthsRange].start options:0];
	[self moveToDate:date animated:animated];
}

- (void)moveToPreviousPageAnimated:(BOOL)animated
{
	NSDateComponents *comps = [NSDateComponents new];
	comps.year = -1;
	NSDate *date = [self.calendar dateByAddingComponents:comps toDate:[self.yearCalendarView visibleMonthsRange].start options:0];
	[self moveToDate:date animated:animated];
}

#pragma mark - UIViewController

- (void)loadView
{
	MGCYearCalendarView *view = [[MGCYearCalendarView alloc]initWithFrame:CGRectNull];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
		
	self.yearCalendarView.delegate = self;
	self.yearCalendarView.calendar = self.calendar;
	
	
	NSMutableArray *dateEventi = [NSMutableArray new];
	NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
	[formatter setDateFormat:@"dd/MM/yyyy"];
	NSDate *date = [formatter dateFromString:@"01/09/2015"];
	NSDate *data1 = [formatter dateFromString:@"05/09/2015"];
	NSDate *data2 = [formatter dateFromString:@"06/09/2015"];
	NSDate *data3 = [formatter dateFromString:@"15/09/2015"];
	NSDate *data4 = [formatter dateFromString:@"16/09/2015"];
	NSDate *data5 = [formatter dateFromString:@"01/10/2015"];
	NSDate *data6 = [formatter dateFromString:@"16/10/2015"];
	NSDate *data7 = [formatter dateFromString:@"15/10/2015"];
	NSDate *data8 = [formatter dateFromString:@"31/10/2016"];
	[dateEventi addObject:date];
	[dateEventi addObject:data1];
	[dateEventi addObject:data2];
	[dateEventi addObject:data3];
	[dateEventi addObject:data4];
	[dateEventi addObject:data5];
	[dateEventi addObject:data6];
	[dateEventi addObject:data7];
	[dateEventi addObject:data8];
	
	self.yearCalendarView.events = dateEventi;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[self.yearCalendarView setNeedsLayout];
}

#pragma mark - CalendYearViewDelegate

- (CGFloat)heightForYearHeaderInCalendarYearView:(MGCYearCalendarView *)view
{
	return 60;
}

- (NSAttributedString*)calendarYearView:(MGCYearCalendarView *)view headerTextForYearAtDate:(NSDate*)date
{
	UIFont *font = [UIFont fontWithName:@"HelveticaNeue-light" size:46];
	self.dateFormatter.dateFormat = @"yyyy";
	NSString *year = [self.dateFormatter stringFromDate:date];
	
	NSMutableParagraphStyle* para = [NSMutableParagraphStyle new];
	para.firstLineHeadIndent = 10;
	para.lineBreakMode = NSLineBreakByWordWrapping;
	
	NSMutableAttributedString* str = [[NSMutableAttributedString alloc]initWithString:year attributes:@{ NSFontAttributeName:font, NSParagraphStyleAttributeName: para }];
	return str;
}

- (NSAttributedString*)calendarYearView:(MGCYearCalendarView *)view headerTextForMonthAtDate:(NSDate*)date
{
	self.dateFormatter.dateFormat = @"MMMM";
	NSString *month = [[self.dateFormatter stringFromDate:date]uppercaseString];
	
	NSMutableParagraphStyle *para = [NSMutableParagraphStyle new];
	para.lineBreakMode = NSLineBreakByTruncatingTail;

	UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:22];
	NSMutableAttributedString* str = [[NSMutableAttributedString alloc]initWithString:month attributes:@{ NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blueColor], NSParagraphStyleAttributeName: para }];
	return str;
}



@end
