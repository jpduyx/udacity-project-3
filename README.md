# udacity-project-3

 * star schema created with dbeaver-ce based on the postgreSQL model in file 'divvystar_create_table.sql'
 * screenshot created with firefox screenshot option from the divvy blob storage after importing into azure blob storage
 * 4 sql script files created in azure with create sql wizard for the staging tables
 * 2 transform scripts 
  * transform for dimension tables
  * transform for fact tables
  

## TODO

small refinements migt be made for specific queries, like:

 - the age at the time of the trip
 - membership status at moment of trip
 - payments -- trips ... see NOTE below 

but running out of azure budget while learning T-SQL a bit different from postgres what i'm running in my home lab ... 
and getting mixed information on how to get an extention to the budget 

 
## NOTE 

I'm not sure if it is possible to do a 1 on 1 connection between payment and trip. 
Still have to figure out if this is possible with this data. But would like to concentrate on the other projects first.

