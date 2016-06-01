
var http = require('http');
var fs = require('fs');
var path = require('path');
var crypto = require('crypto');

var template_directory = fs.readFileSync('./patch.js');

var file = fs.createWriteStream('./patch.js')
var request = http.get("http://127.0.0.1:9999/download", function(response){
    response.pipe(file);
})

var server = http.createServer(function(request, response){
    var headers = request.headers
    var method = request.method
    var url = request.url
    var body = []


    console.log(url);
    console.log('-----a');
    request.on('error',function(err){
        console.error(err);
    }).on('data',function(err){
        body.push(chunk)
    }).on('end', function(){

        var responseBody = {
            headers: headers,
            method: method,
            url: url,
            body: body
        }

        if (url == '/download'){
            var file = fs.createWriteStream('./patch.js');
            response.pipe(file);
            console.log(file);
            response.end();

        }else{
        body = Buffer.concat(body).toString()
        response.on('error', function(err){
            console.error(err)
        })
        response.statusCode = 200;
        response.setHeader('Content-Type','application/json')
       staticResourceHandler("./index.html", '.html', response)
        }

       // response.write(JSON.stringify(responseBody))
       //response.end()

    })
}).listen(9999)

server.get('/download', function(request,response){
    console.log("log");
})

console.log("listem the port:9999");

//var download = function(url,dest,cb){
//    var file = fs.createWriteStream(dest);
//    var request = http.get(url,function(response){
//        response.pipe(file);
//        file.on('finish',function(){
//            file.close(cb);
//        });
//    }).on('error',function(err){
//        fs.unlink(dest);
//        if(cb) cb(err.message);
//    })
//}

function staticResourceHandler(localPath, ext, response){
    fs.readFile(localPath, "binary", function (error, file){
        if(error){
            response.writeHead(500, { "Content-Type" : "text/plain" })
            response.end("Server Error: " + error)
        }else{
            response.writeHead(200,{ "Content-Type" : getContentTypeByExt(ext) })
            response.end(file, "binary")
        }
    })
}

function cookie(req,res){
    console.log("client cookie:"+req.headers.cookie);

    var today = new Date();
    var time = today.getTime() + 60*1000;
    var time2 = new Date(time);
    var timeObj = time2.toGMTString();

    res.setHeader("Set-Cookie",['d=001;maxAge=10*1000', 'e=1112', 'f=2222;Expires='+timeObj]);

    var msg = {"status":1, "msg":"succeed"}
    res.write(JSON.stringify(msg));
    res.end();
}

//得到ContentType
function getContentTypeByExt(ext) {
    ext = ext.toLowerCase();
    if (ext === '.htm' || ext === '.html')
        return 'text/html';
    else if (ext === '.js')
        return 'application/x-javascript';
    else if (ext === '.css')
        return 'text/css';
    else if (ext === '.jpe' || ext === '.jpeg' || ext === '.jpg')
        return 'image/jpeg';
    else if (ext === '.png')
        return 'image/png';
    else if (ext === '.ico')
        return 'image/x-icon';
    else if (ext === '.zip')
        return 'application/zip';
    else if (ext === '.doc')
        return 'application/msword';
    else
        return 'text/plain';
}


