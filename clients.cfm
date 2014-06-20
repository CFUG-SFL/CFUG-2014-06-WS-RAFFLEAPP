<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ColdFusion Software Raffle Connected Clients</title>
    <link rel="shortcut icon" href="../favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="//fonts.googleapis.com/css?family=Source+Sans+Pro:400,600">
    <style>
        table{
            font-family: 'Source Sans Pro', sans-serif !important;
            font-size: 14px !important;
        }
    </style>
</head>
<body>
<cfscript>
    writeDump(WSgetSubscribers("raffle"));
</cfscript>
</body>
</html>