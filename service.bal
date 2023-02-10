import ballerina/http;
import ballerina/io;

# A service representing a network-accessible API
# bound to port `9090`.
#
type CustomerEntry record {
    string name;
    string city;
    string company;
    string contact;
};

type CompanyEntry record {
    string name;
    string country;
};

service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + name - the input string name
    # + return - string name with hello message or error
    resource function get customer/[string name]() returns json|error {
        // Send a response back to the caller.
        http:Client httpEp = check new (url = "https://c42c-112-135-193-29.in.ngrok.io/external/rest/");
        json customerInfo = check httpEp->get(path = "customer/" + name);
        json companyInfo;
        io:println(customerInfo);
        if (customerInfo is map<json>) {
            io:println(customerInfo["company"]);
            companyInfo = check httpEp->get(path = "customer/office/" + <string>customerInfo["company"]);
            if (companyInfo is map<json>) {
                io:println(companyInfo);
                json payload = {
                    customerName: name,
                    customerOffice: <string>customerInfo["company"],
                    companyOffice: <string>companyInfo["city"]
                };
                return payload;
            } else {
                io:println("companyInfo !!! is NOT map<json>");
            }
        } else {
            io:println("customerInfo !!! is NOT map<json>");
        }

    }
}
