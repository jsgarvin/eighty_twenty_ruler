# EightyTwentyRuler

Parses a folder of Garmin TCX export files for runs and calculates percentage
of time spent in Light, Moderate, and High intensity HR zones and sends a
report to your phone with values for the last run, as well as 1 and 3 week 
trailing averages.

## Why?

See...
* [Train At The Right Intensity Ratio](https://www.runnersworld.com/rt-web-exclusive/train-at-the-right-intensity-ratio) 
* [Intensity Guidelines For Running](http://mattfitzgerald.org/intensity-guidelines-for-running/)

## Requirements

* A Garmin fitness watch with a Heart Rate monitor. 
* A folder of exported TCX files from Garmin
* A pushover.net account to send reports to your phone.
* Know your current Lactate Threshold estimate (your watch may have a guided
  test built in to find this).

## Recommendations

* I love having a HR monitor built into my watch for all day HR recording and
  tracking RHR, but for runs I find the wrist based HR monitor can be erratic,
  so I use a chest strap HR montior for actual runs.
* You could download the TCX files manually, but a service like [tapiriik.com](http://tapiriik.com)
  is great for automatically fetching the files and putting them in Dropbox. 
* Set this up as a cron to run once a day, or however often you prefer.

## Setup

* git clone this repo
* copy config/eighty_twenty_ruler.rb.sample to config/eighty_twenty_ruler.rb
* modify personal preferences in the new file.
* run 'bundle install`
* run `bundle exec rake make_ruling` whenever you want to generate a report.
* update your lactate threshold setting whenever your watch reports a change.
