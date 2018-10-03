<cfscript>
    // form posts
    if (cgi.REQUEST_METHOD == "POST"){
        // processs login
        if (structKeyExists(form,"password") && form.password == "123456"){
            session.auth = true;
            location("./",false);
        }
        // process update
        if (structKeyExists(form,"process")){

            // get the user
            if (structKeyExists(form,"id"))
                user = entityLoadByPK("User",form.id);

            switch (form.process){

                case "save":
                    if (!isNull(user)){
                        user.setPoints(form.points);
                        transaction { entitySave(user); }
                        // update view
                        d = {
                                "name"      : user.getFullName(),
                                "email"     : user.getEmail(),
                                "points"    : user.getPoints(),
                                "id"        : user.getHash(),
                                "gravatar"  : "http://www.gravatar.com/avatar/" & user.getHash() & "?s=50"
                            };
                        thread name="run" action="run" {
                            WSPublish("raffle",{"process":"update-user","user":d});
                        }
                        sleep(200);
                    }
                break;

                case "delete":
                    if (!isNull(user)){
                        thread name="run" action="run" {
                            WSPublish("raffle",{"process":"delete-user","id":user.getHash()});
                        }
                        transaction { entityDelete(user); }
                        sleep(200);
                    }
                break;

                case "open":
                    lock scope="application" timeout="10" {
                        application.registrationopen = true;
                        thread name="run" action="run" {
                            WSPublish("raffle",{"process":"open-registration"});
                        }
                        location("./",false);
                    }
                break;

                case "close":
                    lock scope="application" timeout="10" {
                        application.registrationopen = false;
                        thread name="run" action="run" {
                            WSPublish("raffle",{"process":"close-registration"});
                        }
                        location("./",false);
                    }
                break;

                case "select-winner":
                    // get users
                    getUsers = entityLoad("User",{},"fullname");
                    // full array
                    users = [];
                    for (user in getUsers){
                        for (i = 1; i <= user.getPoints(); i++){
                            arrayAppend(users,{
                                "name"      : user.getFullName(),
                                "email"     : user.getEmail(),
                                "points"    : user.getPoints(),
                                "hash"      : user.getHash(),
                                "id"        : user.getID(),
                                "gravatar"  : "http://www.gravatar.com/avatar/" & user.getHash() & "?s=50"
                            });
                        }
                    }
                    // now that we have the array lets have some fun
                    for (i = 1; i < randRange (20,30); i++){
                        thread name="#createUUID()#" action="run" {
                            WSPublish("raffle",{"process":"choosing-winner","user" : users[randRange(1,arrayLen(users))]});
                        }
                        sleep(100);
                    }
                    // now do the winner
                    thread name="#createUUID()#" action="run" {
                        application.winner  = users[randRange(1,arrayLen(users))];
                        application.winnerselected = true;
                        WSPublish("raffle",{"process":"winner","user" : application.winner });
                    }
                    location("./",false);
                break;
            }
            writeOutput(1);
            abort;
        }
    }
    // logout
    if (structKeyExists(url,"logout")){
        structDelete(session,"auth");
            location("./",false);
    }
    // view : get users
    if (structKeyExists(session,'auth') ){
        getUsers = entityLoad("User",{},"fullname");
    }
</cfscript>
<cfoutput>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ColdFusion Software Raffle Admin</title>
    <link rel="shortcut icon" href="../favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="//fonts.googleapis.com/css?family=Source+Sans+Pro:400,600">
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="../assets/theme.css">
</head>
<body class="#structKeyExists(session,'auth') ? '' : 'login'#">
    <div class="container">
        <cfif structKeyExists(session,"auth")>
            <div class="page-header">
                <a href="./?logout=1" class="btn btn-danger pull-right">Logout</a>
                <cfif !application.winnerselected>
                    <form class="pull-right" style="margin-right:5px;" action="./" method="post">
                    <cfif application.registrationopen>
                        <input type="hidden" name="process" value="close">
                        <button type="submit" class="btn btn-default">Close Registration</button>
                    <cfelse>
                        <input type="hidden" name="process" value="open">
                        <button type="submit" class="btn btn-success">Open Registration</button>
                    </cfif>
                    </form>
                </cfif>
                <cfif !application.registrationopen && !application.winnerselected>
                    <form class="pull-right" style="margin-right:5px;" action="./" method="post">
                        <input type="hidden" name="process" value="select-winner">
                        <button type="submit" class="btn btn-primary">Select Winner</button>
                    </form>
                </cfif>
                <h1>Raffle Admin <small>Registration <cfif application.registrationopen> Open<cfelse>Closed</cfif></small></h1>
            </div>
            <table class="table table-striped">
                <colgroup>
                    <col width="70%">
                    <col width="15%">
                    <col width="15%">
                </colgroup>
                <thead>
                    <tr>
                        <th>USER</th>
                        <th>POINTS</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop array="#getUsers#" index="user">
                        <tr>
                            <td>#user.getFullName()#</td>
                            <td><input type="number" class="form-control" value="#user.getPoints()#" data-id="#user.getID()#" /></td>
                            <td class="text-right">
                                <button type="button" class="btn btn-primary" data-role="save"><i class="fa fa-save"></i></button>
                                <button type="button" class="btn btn-danger" data-role="delete"><i class="fa fa-trash-o"></i></button>
                            </td>
                        </tr>
                    </cfloop>
                </tbody>
            </table>
        <cfelse>
            <form class="form-signin simple-validation" id="loginFrm" role="form" action="./" method="POST">
                <input type="password" name="password" class="form-control required" placeholder="Password" title="Password Required">
                <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
            </form>
        </cfif>
    </div>
    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
    <script src="../assets/validation.min.js"></script>
    <script src="../assets/admin.js"></script>
</body>
</html>
</cfoutput>