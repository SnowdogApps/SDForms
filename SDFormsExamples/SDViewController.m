//
//  SDViewController.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 13.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDViewController.h"
#import "SDForms.h"

@interface Person : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *surname;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSNumber *salary;
@property (nonatomic, strong) NSDate *dateOfBirth;
@property (nonatomic, readonly) NSString *formattedDOB;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSNumber *hp;
@property (nonatomic, strong) NSNumber *isStudent;

@end

@implementation Person

- (NSString *)description
{
    return [NSString stringWithFormat:@"name:%@\nsurname:%@\nage:%@\nsex:%@\nsalary:%@\ndob:%@\nbio:%@\nhp:%@\nisStudent:%@", self.name, self.surname, self.age, self.sex, self.salary, self.dateOfBirth, self.bio, self.hp, self.isStudent];
}

- (NSString *) formattedDOB
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd MMM yyyy";
    return [NSString stringWithFormat:@"%@", [formatter stringFromDate:self.dateOfBirth]];;
}

@end

@interface SDViewController () <SDFormFieldCustomizationDelegate, SDFormDelegate, SDFormDataSource>

@property (nonatomic, strong) SDForm *form;
@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) NSMutableArray *section1Fields;
@property (nonatomic, strong) NSMutableArray *section2Fields;

@end

@implementation SDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog (@"VC frame: %@", NSStringFromCGRect(self.view.frame));
    NSLog (@"TableView frame: %@", NSStringFromCGRect(self.tableView.frame));
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonTapped:)];
    self.navigationItem.rightBarButtonItem = save;
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasSwiped:)];
    [self.tableView addGestureRecognizer:swipeRecognizer];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self initFields];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog (@"After layout VC frame: %@", NSStringFromCGRect(self.view.frame));
    NSLog (@"After layout TableView frame: %@", NSStringFromCGRect(self.tableView.frame));
    [self.form reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString *)formattedValueForField:(SDFormField *)field
{
    if ([field.name isEqualToString:@"selection1"]) {
        NSInteger i = 0;
        SDItemSelectionField *selectionField = (SDItemSelectionField *)field;
        NSString *title;
        if (selectionField.selectedIndexes.count > 0) {
            for (NSNumber *number in selectionField.selectedIndexes) {
                NSString *item = [selectionField.items objectAtIndex:number.integerValue];
                if (i > 0) {
                    title = [NSString stringWithFormat:@"%@, %@", title, item];
                } else {
                    title = [NSString stringWithFormat:@"%@", item];
                }
                i++;
            }
        } else {
            title = @"( ͡° ͜ʖ ͡°)";
        }
        return title;
    }
    return nil;
}



- (void)saveButtonTapped:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Person" message:[NSString stringWithFormat:@"%@", self.person] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (UIViewController *)viewControllerForForm:(SDForm *)form
{
    return self;
}

- (void)form:(SDForm *)form didSelectFieldAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Did select field in section: %ld row: %ld", indexPath.section, indexPath.row);
    SDFormField *field = [form fieldForIndexPath:indexPath];
    if ([field.name isEqualToString:@"submit"]) {
        [self saveButtonTapped:nil];
    }
}

- (NSInteger)numberOfSectionsForForm:(SDForm *)form
{
    return 2;
}

- (NSInteger)form:(SDForm *)form numberOfFieldsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.section1Fields.count;
    } else {
        return self.section2Fields.count;
    }
}

- (NSString *)form:(SDForm *)form titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Section 1";
    } else {
        return @"Section 2";
    }
}

- (NSString *)form:(SDForm *)form titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return @"End of section 1";
    } else {
        return nil;
    }
}

- (CGFloat)form:(SDForm *)form heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30.0;
    } else {
        return 30.0;
    }
}

- (CGFloat)form:(SDForm *)form heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 30.0;
    } else {
        return 0.0;
    }
}

- (UIView *)form:(SDForm *)form viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)form:(SDForm *)form viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (SDFormField *)form:(SDForm *)form fieldForRow:(NSInteger)row inSection:(NSInteger)section
{
    if (section == 0) {
        SDFormField *field = [self.section1Fields objectAtIndex:row];
        return field;
    } else {
        SDFormField *field = [self.section2Fields objectAtIndex:row];
        return field;
    }
}

- (void)initFields
{
    self.person = [[Person alloc] init];
    self.person.name = @"John";
    self.person.surname = @"Smith";
    self.person.salary = @3000;
    self.person.dateOfBirth = [[NSDate date] dateByAddingTimeInterval:(3600 * 24 * 365 * 25)];
    self.person.age = @25;
    self.person.bio = @"There was a boy";
    self.person.hp = @70;
    self.person.isStudent = @YES;
    
    self.form = [[SDForm alloc] initWithTableView:self.tableView];
    self.form.delegate = self;
    self.form.dataSource = self;
	
    SDTextFormField *name = [[SDTextFormField alloc] initWithObject:self.person relatedPropertyKey:@"name"];
    name.title = @"Name";
    name.placeholder = @"Name";
    name.cellType = SDTextFormFieldCellTypeTextAndLabel;
    
    SDTextFormField *surname = [[SDTextFormField alloc] initWithObject:self.person relatedPropertyKey:@"surname"];
    surname.title = @"Surname";
    surname.placeholder = @"Surname";
    surname.cellType = SDTextFormFieldCellTypeTextAndLabel;
    
    SDTextFormField *password = [[SDTextFormField alloc] initWithObject:self.person relatedPropertyKey:@"password"];
    password.placeholder = @"Password";
    password.value = @"P@ssw0rd";
    password.autocorrectionType = UITextAutocorrectionTypeNo;
    password.secure = YES;
    
    SDTextFormField *age = [[SDTextFormField alloc] initWithObject:self.person relatedPropertyKey:@"age"];
    age.placeholder = @"Age";
    age.valueType = SDFormFieldValueTypeInt;
    
    SDPickerField *sex = [[SDPickerField alloc] init];
    sex.name = @"sex";
    sex.title = @"Sex";
    [sex setItems:@[@[@"Male", @"Female", @"Other"]]];
    [sex setValues:@[@[@"male", @"female", @"other"]]];
    sex.enabled = YES;
    sex.relatedObjects = @[self.person];
    sex.relatedPropertyKeys = @[@"sex"];
    [sex selectItem:1 inComponent:0];
    
    SDTextFormField *salary = [[SDTextFormField alloc] initWithObject:self.person relatedPropertyKey:@"salary"];
    salary.placeholder = @"Salary";
    salary.valueType = SDFormFieldValueTypeDouble;
    
    SDLabelField *label = [[SDLabelField alloc] init];
    label.title = @"Time worked";
    label.value = @"5h";
    
    SDMultilineTextField *bio = [[SDMultilineTextField alloc] init];
    bio.relatedObject = self.person;
    bio.relatedPropertyKey = @"bio";
    bio.title = @"Biography";
    
    SDDatePickerField *dob = [[SDDatePickerField alloc] initWithObject:self.person relatedPropertyKey:@"dateOfBirth" formattedValueKey:@"formattedDOB"];
    dob.title = @"Date of birth";
    dob.value = [NSDate date];
    dob.datePickerMode = UIDatePickerModeDateAndTime;
    
    SDSliderField *hp = [[SDSliderField alloc] initWithObject:self.person relatedPropertyKey:@"hp"];
    hp.title = @"HP";
    hp.min = 0.0;
    hp.max = 100.0;
    hp.step = 10.0;
    
    SDSwitchField *isStudent = [[SDSwitchField alloc] initWithObject:self.person relatedPropertyKey:@"isStudent"];
    isStudent.title = @"Is student";
    
    self.section1Fields = [@[name, surname, password, age, sex, salary, label, bio, dob, hp, isStudent] mutableCopy];
    
    SDButtonField *addField = [[SDButtonField alloc] init];
    addField.name = @"addField";
    addField.title = @"Add field";
    
    __weak SDButtonField *wAddField = addField;
    [addField setOnTapBlock:^{
        SDButtonField *sAddField = wAddField;
        SDLabelField *newField = [[SDLabelField alloc] init];
        newField.title = @"New field";
        newField.value = @"value";
        [self.section2Fields insertObject:newField atIndex:(sAddField.indexPath.row + 1)];
        [self.form addField:newField atIndexPath:[NSIndexPath indexPathForRow:(sAddField.indexPath.row + 1) inSection:sAddField.indexPath.section] withRowAnimation:UITableViewRowAnimationBottom];
    }];
    
    SDPickerField *picker1 = [[SDPickerField alloc] init];
    picker1.name = @"picker1";
    picker1.title = @"Picker 1";
    [picker1 setItems:@[@[@"Option 1", @"Option 2", @"Option 3"]]];
    [picker1 selectItem:2 inComponent:0];
    
    SDItemSelectionField *selection = [[SDItemSelectionField alloc] init];
    selection.formatDelegate = self;
    selection.title = @"Selection 1";
    selection.name = @"selection1";
    selection.multiChoice = YES;
    selection.presentingMode = SDFormFieldPresentingModePush;
    [selection setItems:@[@"Option 1", @"Option 2", @"Option 3", @"Option 4"]];
    [selection setSelectedIndexes:[@[@0] mutableCopy]];
    
    SDDatePickerField *hired = [[SDDatePickerField alloc] init];
    hired.title = @"Hired";
    hired.value = [NSDate date];
    hired.datePickerMode = UIDatePickerModeDateAndTime;
    
    SDMultilineTextField *autoHeightText = [[SDMultilineTextField alloc] init];
    autoHeightText.editable = NO;
    autoHeightText.backgroundColor = [UIColor lightGrayColor];
    autoHeightText.automaticHeight = YES;
    autoHeightText.value = @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. \
        \n\nNullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi.";
    
    SDButtonField *submit = [[SDButtonField alloc] init];
    submit.name = @"submit";
    submit.title = @"Submit";
    
    self.section2Fields = [@[addField, picker1, selection, hired, autoHeightText, submit] mutableCopy];
}

- (void) cellWasSwiped:(UIGestureRecognizer *)recognizer
{
    CGPoint swipeLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    if(swipedIndexPath)
    {
        SDFormField *field = [self.form fieldForIndexPath:swipedIndexPath];
        if (swipedIndexPath.section == 0) {
            [self.section1Fields removeObject:field];
        } else {
            [self.section2Fields removeObject:field];
        }

        [self.form removeFieldAtIndexPath:field.indexPath withRowAnimation:UITableViewRowAnimationLeft];
    }
}

@end
