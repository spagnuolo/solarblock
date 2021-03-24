'use strict';

class ParamUtil{


    //validation functions

    static validateOrg(organization){
      if(organization.startsWith("Org")) {
          return true;
      }
      else {
          throw new Error("You did not provide an valide organization name");
      }
    }

    static validatePositiveInteger(number){
        if(number >0){
            return true;
        }
        else{
            throw new Error("You provided a negative integer where a positive one was expected");
        }
    }

}

module.exports = ParamUtil;
