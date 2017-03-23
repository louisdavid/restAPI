import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

var accounts = Accounts()

accounts.addAccount(username:"cbcdiver", email:"c@d.com", password:"pencil99")
accounts.addAccount(username:"dogs", email:"a@b.com", password:"pencil99")

let server = HTTPServer()
server.serverPort = 8080
server.documentRoot = "webroot"

var routes = Routes()
//*************  /Invalid Paths *************
routes.add(method: .get, uris: ["/json","/json/username","/json/login/{username}","/json/login"]){
    request, response in
    do {
        try response.setBody(json: ["Result":"Error invalid URL path specified"])
        response.setHeader(.contentType, value: "application/json")
        response.completed()
        
    } catch {
        response.setBody(string: "Error handling request: \(error)")
        response.completed()
    }
}

//*************  /json/username/{username} *************
routes.add(method: .get, uri: "/json/username/{username}"){
    request, response in
    do {
        try response.setBody(json: accounts.username(username: request.urlVariables["username"]!))
        response.setHeader(.contentType, value: "application/json")
        response.completed()
        
    } catch {
        response.setBody(string: "Error handling request: \(error)")
        response.completed()
    }
}

//*************  /json/login/{username}/{password} *************
routes.add(method: .get, uri: "/json/login/{username}/{password}"){
    request, response in
    do {
        try response.setBody(json: accounts.loginValid(username: request.urlVariables["username"]!, password: request.urlVariables["password"]!))
        response.setHeader(.contentType, value: "application/json")
        response.completed()
        
    } catch {
        response.setBody(string: "Error handling request: \(error)")
        response.completed()
    }
}

//*************  /json/all *************
routes.add(method: .get, uri: "/json/all"){
    request, response in
    do {
        try response.setBody(json: accounts.dictionary)
        response.setHeader(.contentType, value: "application/json")
        response.completed()
        
    } catch {
        response.setBody(string: "Error handling request: \(error)")
        response.completed()
    }
}


server.addRoutes(routes)

do {
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
