# humanActivityRecognitionCourseProject
This is a repo where i have include my proposed solution to the course´s project named getting and cleaning data in wich is used a data set related to human activity recognition using Samsung Galaxy SII sensors.

##Task 1
The first task of the script is creating url references to the location of the files, and then loading the data into 4 separated dataframes: x_train, y_train, x_test, y_test using read.fwf function with a width of 16 per variable getting a total of 10299 observation and 561 variables. After this I proceed to merge the data using the rbind function over the pairs x_train/x_test and y_train/y_test.

