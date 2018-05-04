# What is this?

This is the code that runs [http://goclimateneutral.org](http://goclimateneutral.org)

# How do I set up my environment?

* Install Ruby
  * [https://www.ruby-lang.org/en/downloads/](https://www.ruby-lang.org/en/downloads/)
* Install Rails
  * `gem install rails`
* Install Postgres
  * `brew install postgresql` 
* Install project-specific gems
  * `bundle install`  
* Init the DB
  * `initdb db/goclimateneutral`
* Start Postgres
  * `pg_ctl -D db/goclimateneutral -l logfile start`
* Create the DB
  * `createdb goclimateneutral`
* Init the DB tables
  * `bin/rails db:migrate RAILS_ENV=development`  
* Set Stripe API key
  * TODO
* Init basic LifestyleChoice data
  * `bin/rails c`
  * in console mode, enter: 
```
LifestyleChoice.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('lifestyle_choices')
Project.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('projects')

LifestyleChoice.create!([
  {name: "vegan", category: "food", version: 1, co2: "0.59"},
  {name: "vegetarian", category: "food", version: 1, co2: "1.23"},
  {name: "meat_eater", category: "food", version: 1, co2: "2.62"},
  {name: "no_car", category: "car", version: 1, co2: "0.0"},
  {name: "electric_car", category: "car", version: 1, co2: "0.0"},
  {name: "fuel_efficient_seldom_drives", category: "car", version: 1, co2: "0.156"},
  {name: "fuel_efficient_car_drives_often", category: "car", version: 1, co2: "0.624"},
  {name: "normal_car_seldom_drives", category: "car", version: 1, co2: "0.312"},
  {name: "normal_car_drives_often", category: "car", version: 1, co2: "1.248"},
  {name: "suv_seldom_drives", category: "car", version: 1, co2: "0.468"},
  {name: "suv_drives_often", category: "car", version: 1, co2: "1.872"},
  {name: "never_flies", category: "flying", version: 1, co2: "0.0"},
  {name: "flies_short_distance_1_time_year", category: "flying", version: 1, co2: "0.268"},
  {name: "flies_short_distance_2_time_year", category: "flying", version: 1, co2: "0.536"},
  {name: "flies_short_distance_3_time_year", category: "flying", version: 1, co2: "0.804"},
  {name: "flies_short_distance_6_time_year", category: "flying", version: 1, co2: "1.608"},
  {name: "flies_short_distance_12_time_year", category: "flying", version: 1, co2: "3.216"},
  {name: "flies_long_distance_1_time_year", category: "flying", version: 1, co2: "2.3"},
  {name: "flies_long_distance_2_time_year", category: "flying", version: 1, co2: "4.6"},
  {name: "flies_long_distance_3_time_year", category: "flying", version: 1, co2: "6.9"},
  {name: "flies_long_distance_6_time_year", category: "flying", version: 1, co2: "13.8"},
  {name: "flies_long_distance_12_time_year", category: "flying", version: 1, co2: "27.6"},
  {name: "hardly_ever_flies", category: "custom", version: 1, co2: "0.536"},
  {name: "flies_sometimes", category: "custom", version: 1, co2: "2.3"},
  {name: "base", category: "base", version: 1, co2: "4.0"},
  {name: "meat_eater_lots_of_beef", category: "food", version: 1, co2: "4.0"},
  {name: "1_people", category: "people", version: 1, co2: "1.0"},
  {name: "sometimes_vegetarian", category: "food", version: 1, co2: "2.0"},
  {name: "mostly_vegetarian", category: "food", version: 0, co2: "1.8"},
  {name: "2_people", category: "people", version: 1, co2: "2.0"},
  {name: "3_people", category: "people", version: 1, co2: "3.0"},
  {name: "4_people", category: "people", version: 1, co2: "4.0"},
  {name: "5_people", category: "people", version: 1, co2: "5.0"},
  {name: "6_people", category: "people", version: 1, co2: "6.0"},
  {name: "7_people", category: "people", version: 1, co2: "7.0"},
  {name: "8_people", category: "people", version: 1, co2: "8.0"},
  {name: "9_people", category: "people", version: 1, co2: "9.0"},
  {name: "10_people", category: "people", version: 1, co2: "10.0"},
  {name: "11_people", category: "people", version: 1, co2: "11.0"},
  {name: "12_people", category: "people", version: 1, co2: "12.0"},
  {name: "13_people", category: "people", version: 1, co2: "13.0"},
  {name: "14_people", category: "people", version: 1, co2: "14.0"},
  {name: "15_people", category: "people", version: 1, co2: "15.0"},
  {name: "16_people", category: "people", version: 1, co2: "16.0"},
  {name: "17_people", category: "people", version: 1, co2: "17.0"},
  {name: "18_people", category: "people", version: 1, co2: "18.0"},
  {name: "19_people", category: "people", version: 1, co2: "19.0"},
  {name: "20_people", category: "people", version: 1, co2: "20.0"}
])
Project.create!([
  {name: "Trang Palm Oil Wastewater Treatment Project in Trang Province", link: "https://offset.climateneutralnow.org/trang-palm-oil-wastewater-treatment-project-in-trang-province-thailand-3335-", image_url: "https://www.goclimateneutral.org/blog/wp-content/uploads/2017/05/0000213_trang-palm-oil-wastewater-treatment-project-in-trang-province-thailand_550.jpeg", blog_url: "https://www.goclimateneutral.org/blog/carbon-offset-investment-in-trang-palm-oil-wastewater-treatment-project/", longitude: "99.438056", latitude: "7.555", carbon_offset: 50, country: "Thailand", offset_type: "CDM", cost_in_sek: 228, date_bought: "2017-05-21 00:00:00", invoice_url: "https://www.goclimateneutral.org/blog/wp-content/uploads/2017/05/invoice_1491461_2048.pdf", certificate_url: "https://www.goclimateneutral.org/blog/wp-content/uploads/2017/05/1491461_2048.pdf"}
])

```

# How do I start the server locally?

* `bin/rails server`
* Surf to [http://localhost:3000](http://localhost:3000)

