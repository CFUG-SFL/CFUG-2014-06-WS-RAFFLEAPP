component{

    this.name                           = "cfug_raffle_20140614";
    this.sessionmanagement              = true;
    this.sessiontimeout                 = createTimeSpan(1,0,0,0);
    this.datasource                     = "cfug_raffle_20140614";

    // websockets
    this.wschannels=[{name="raffle"}];

    // mappings
    this.mappings       = {
        "/orm"            : ExpandPath("./orm")
    };

    this.ormEnabled     = true;
    this.ormSettings    = {
        automanageSession       : false,
        cfclocation             : "/orm/",
        dbcreate                : "dropcreate",
        dialect                 : "MicrosoftSQLServer",
        flushatrequestend       : false,
        logSQL                  : false,
        useDBForMapping         : false
    };


    public boolean function onApplicationStart(){
        application.registrationopen    = true;
        application.winnerselected      = false;
        application.winner              = {};
        return true;
    }

    public boolean function onRequestStart(targetPage){
        // reload orm
        if (structKeyExists(url,"reload")){
            application.ormtimestamp = getHttpTimeString();
            lock scope="application" type="exclusive" timeout="30"{ ormReload(); }
            applicationStop();
            location('./',false);
        }
        return true;
    }

}