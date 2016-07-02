
var http   = require('http');
var fs     = require('fs');
var path   = require('path');
var crypto = require('crypto');

//http://nodeguide.com/style.html

var template_directory = fs.readFileSync('./patch.js');

var CONFIG = {
    'host'              : '127.0.0.1',
    'port'              : 9999,
    'site_base'         : './site',
    'file_expiry_time'  : 480,
    'directory_listing' : true
};

var server = http.createServer(function(request, response){

    var headers = request.headers;
    var method = request.method;
    var url = request.url;
    var body = [];

    console.log(url);

    request.on('error',function(err){
        console.error(err);
        response.statusCode = 400;
        response.end();
    }).on( 'data', function(chunk){
        body.push(chunk);
    }).on( 'end', function(){

        response.on('error', function(err){
            console.error(err);
        });

        if(request.method === 'GET'){
            if(request.url === '/echo'){
               //response.statusCode = 200;
               // response.setHeader('Content-Type','application/json');
               // response.end(body);

               request.pipe(response);
               console.log(request);
            }else{
                response.statusCode = 404;
                response.end();
            }

        }else{
            //TODO
        }

/*
        var responseBody = {
            headers:          headers,
            method:           method,
            url:              url,
            body:             body
        };

        response.write(JSON.stringify(responseBody));
        response.end();
*/
    });
}).listen(CONFIG.port, CONFIG.host);

/*
server.on('download',(request, socket, head) {
    socket.write('HTTP/1.1 101 Web Socket Protocol Handshake\r\n' +
                 'Upgrade: WebSocket\r\n' +
                 'Connection: Upgrade\r\n' +
                 '\r\n');
    socket.pipe(socket);
})
*/

console.log("listem :"+CONFIG.host +":" + CONFIG.port);

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


//MIME类型支持
exports.types = {
    "css"         : "text/css",
    "html"        : "text/html",
    "txt"         : "text/plain",
    "xml"         : "text/xml",
    "json"        : "application/json",
    "js"          : "text/javascript",
    "ico"         : "image/x-icon",
    "jpeg"        : "image/jpeg",
    "gif"         : "image/gif",
    "jpg"         : "image/jpeg",
    "png"         : "image/png",
    "pdf"         : "application/pdf",
    "svg"         : "image/svg+xml",
    "swf"         : "application/x-shockwave-flash",
    "tiff"        : "image/tiff",
    "wav"         : "audio/x-wav",
    "wma"         : "audio/x-ms-wma",
    "wmv"         : "video/x-ms-wmv",
};


function staticResourceHandler(localPath, ext, response){
    fs.readFile(localPath, "binary", function (error, file){
        if(error){
            response.writeHead(500, { "Content-Type" : "text/plain" });
            response.end("Server Error: " + error);
        }else{
            response.writeHead(200,{ "Content-Type" : getContentTypeByExt(ext) });
            response.end(file, "binary");
        }
    });
}

function cookie(req,res){
    console.log("client cookie:"+req.headers.cookie);

    var today   = new Date();
    var time    = today.getTime() + 60*1000;
    var time2   = new Date(time);
    var timeObj = time2.toGMTString();

    res.setHeader("Set-Cookie",['d=001;maxAge=10*1000', 'e=1112', 'f=2222;Expires='+timeObj]);

    var msg = {"status" : 1, "msg" : "succeed"};
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


