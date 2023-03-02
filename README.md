# R packages indexing

## Usage
This project indexes R packages from CRAN.

To run indexing, you can run the following command:
```shell
rails packages:index
```

Or enqueue the job to run in background:
```ruby
IndexPackagesJob.perform_later
```

Or just run indexing from the Rails console:
```ruby
IndexPackages.new.call
``` 

## Next steps

* Use "last modified" column at https://cran.r-project.org/src/contrib/ to only index packages that have been updated since last indexing
  * At the moment package will be reindexed if last index was more than 5 days ago
* Denormalize package data to give app more flexibility
  * Authors
  * Maintainers
  * Dependencies
* UI for searching packages

  
    
