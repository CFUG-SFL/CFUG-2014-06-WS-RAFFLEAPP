# The Raffle App ( cfug-20140614 )

This app was created to process our online raffles for our ColdFusion User Group. It was
also done as an example of what we can do with WebSockets.

## Run using CommandBox
You can easily run this application using CommandBox. Simply clone this repo to your local machine
and execute the ``box start`` command at the root folder .

## Running using your own WebServer
If you are running in IIS or Apache with a physical ColdFusion install make sure to create an
Apache Derby database with the name of ``cfug_raffle`` or go into the ``APplication.cfc`` and
add your Administrator credentials in the ``onError`` function, so it automatically creates it
for you.

## Conferences
* ColdFusion Summit 2018
