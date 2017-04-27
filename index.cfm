<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ColdFusion Software Raffle</title>
    <link rel="shortcut icon" href="./favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="//fonts.googleapis.com/css?family=Source+Sans+Pro:400,600">
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="./assets/theme.css">
</head>
<body>

    <div class="jumbotron">
      <div class="container">
        <h1>CFUG Software Raffle</h1>
        <p>
            Enter your email name and email address to register for today's raffle below<br />
            <small><a href="" data-toggle="modal" data-target="#rules">Click here to view the rules for this raffle and how points are being distributed.</a></small>
        </p>
      </div>
    </div>

    <div class="container">
        <div class="row">
            <div class="col-sm-4">
                <div class="well">
                    <p class="alert alert-info instructions">
                        Only 1 entry per person is allowed. The entries are monitored and you do need to be in the meeting to participate.
                    </p>
                    <cfoutput>
                    <form role="form" id="entryFrm" data-open="#application.registrationopen#">
                      <div class="form-group required">
                        <label for="fullname">Name</label>
                        <input type="text" class="form-control" id="fullname" name="fullname" placeholder="Enter Full Name">
                      </div>
                      <div class="form-group required">
                        <label for="fullname">Email</label>
                        <input type="email" class="form-control email" id="email" name="email" placeholder="Enter Email">
                      </div>
                      <button type="submit" class="btn btn-default">Submit</button>
                    </form>
                    </cfoutput>
                </div>
            </div>
            <div class="col-sm-8">
                <div class="row" id="users">

                </div>
            </div>
        </div>
    </div>

    <!--- MODAL VIEW RULES --->
    <cfscript>
        pointstodistribute = {
            'Chris Lee'         : [ 1, 3, 0, 0, 0],
            'Geoff Bergey'      : [ 4, 3, 4, 0, 1],
            'Bill Reese'        : [ 5, 0, 4, 0, 2],
            'Jose Maestri'      : [ 2, 3, 0, 0, 0],
            'Oscar Contreras'   : [ 0, 2, 0, 0, 0],
            'Doug Roberson'     : [ 0, 1, 0, 0, 0]
        };
    </cfscript>
    <cfoutput>
    <div class="modal fade" id="rules" role="dialog" >
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="myModalLabel">Rules and Point Distribution</h4>
                </div>
                <div class="modal-body">
                    <p>
                        After succesfully registering you will be given points manually by one of our admins based on your
                        group activity for this year. Below is a table for points being awarded to active members.
                    </p>
                    <p>
                        By default everyone who registers today gets a point which is as valuable as 1 raffle ticket.
                        Each point just means more tickets. At the end of the meeting we will run a simple
                        ColdFusion <a href="https://wikidocs.adobe.com/wiki/display/coldfusionen/RandRange" target="_blank">RandRange</a> function against the total number of tickets and the
                        value returned will choose a winner based on position in the array that we will generate.
                        Just like purchasing tickets, they will be consecutive. The array will be created by name in
                        alphabetical order and the total positions you get are based on your point value.
                    </p>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th class="text-center">Attended</th>
                                <th class="text-center">Checked in on Facebook</th>
                                <th class="text-center">Used Webcam</th>
                                <th class="text-center">Presented</th>
                                <th class="text-center">* Other</th>
                                <th class="text-center">Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop list="#listSort(structKeyList(pointstodistribute),"text")#" index="key">
                             <tr>
                                <td>#key#</td>
                                <cfloop from="1" to="5" index="col">
                                    <td class="text-center">#pointstodistribute[key][col]#</td>
                                </cfloop>
                                <td class="text-center">#arraySum(pointstodistribute[key])#</td>
                            </tr>
                            </cfloop>
                        </tbody>
                    </table>
                    <p class="text-center">
                        <small class="text-muted">
                            * Other points are based on additional activity. Voting on bugs submitted by other team members and/or bringing new members to
                            the group/community.
                        </small>
                    </p>
                </div>
            </div>
        </div>
    </div>
    </cfoutput>

    <cfwebsocket    name        = "ws"
                    onMessage   = "messageHandler"
                    subscribeTo = "raffle"
                    secure      = "#cgi.server_port_secure#">

    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
    <script> var BootstrapVersion = 3, FontAwesomeVersion = 4;</script>
    <script src="assets/validation.min.js"></script>
    <script src="assets/websocket.js"></script>
    <cfif  application.winnerselected>
        <cfoutput>
        <script>
            var winner = #serializeJSON(application.winner)#
        </script>
        </cfoutput>
    </cfif>
</body>
</html>