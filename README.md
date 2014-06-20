cfug-20140614
=============

CFUG RAFFLE APP

This is meant for a simple install on IIS7+ ( I did not include an .htaccess for Apache but if you need it let me know)

Create an empty DB in your MS SQL Server or any server (just remove the dialect from the orm settings)

Add the Datasource in your ColdFusion Admin called cfug_raffle_20140614 or if you decide to change update in Application.cfc

Start app and go - all files should be accessed without the cfm (rewrites used) for instance, accessing admin, use the url /admin/ instead of admin.cfm just to avoid assets from not being loaded properly. I could add a Rewrite Rule to handle this but for now it was a quick get up and go for the day.
