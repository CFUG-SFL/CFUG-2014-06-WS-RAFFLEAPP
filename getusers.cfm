<cfscript>
    getUsers = entityLoad("User",{},"fullname");
    users = [];
    for (user in getUsers){
        arrayAppend(users,{
            "name"      : user.getFullName(),
            "email"     : user.getEmail(),
            "points"    : user.getPoints(),
            "id"        : user.getHash(),
            "gravatar"  : "http://www.gravatar.com/avatar/" & user.getHash() & "?s=50"
        });
    }
    writeoutput(serializeJSON(users));
</cfscript>