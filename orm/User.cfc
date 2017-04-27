/**
*   @table          users
*   @entityname     User
*   @output         false
*   @persistent     true
*/
component
{

    property name="id"                  fieldtype="id"          generator="native";
    property name="fullname"            ormtype="string"        length="255";
    property name="email"               ormtype="string"        length="255";
    property name="hash"                ormtype="string"        length="255";
    property name="points"              ormtype="integer"       default="1";
    property name="created"             ormtype="timestamp"     notnull="true" required="true";
    property name="updated"             ormtype="timestamp";

    public function init(){
        setCreated(now());
    }

    public void function preUpdate(struct oldData ){
       setUpdated(now());
    }

    public function setEmail(value){
        email  = arguments.value;
        hash   = lcase(hash(lcase(arguments.value)));
    }

}