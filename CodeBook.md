# Code Book for the Getting and Cleaning Data Course Project

Please read the README file first and refer to this code book only when you need more information about the final data.

## Data output

The run\_analysis.R script takes the data from from the dir "UCI HAR Dataset" and produces two output files: data\_final\_means.txt and data\_final\_colnames.txt. 

If you want to read the data you can use the following (  )

```
library(readr)
data_final_means <- read_delim("data_final_means.txt", delim = " ", col_names = FALSE)
data_final_colnames <- read_delim("data_final_colnames.txt", delim = " ", col_names = FALSE)
```

You will have all the data in data\_final\_means, while the column names are in the variable data\_final\_colnames.

You could set the names of teh dataframe with the command

```
colnames(data_final_means) <- data_final_colnames$X2
```

Note that the first two columns are of particular importance.

The first one named "subject" is an integer that represents each one of the participants in the study.

The second column "activity" is a string with one out of the sif activities:

1. walking
2. walking\_upstairs
3. walking\_downstairs
4. sitting 
5. standing
6. laying

The rest of the columns are the mean for each one of the fields indicated in the column name. They are all doubles normalized between -1 and 1.