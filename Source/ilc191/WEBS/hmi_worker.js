/*global document,window,navigator,Event,SpiderControl */
/*jshint white: false, noempty: false */
/****************************************************************************
* (c) 2016 iniNet Solutions GmbH
* FILENAME:     hmi_worker.js
 * DESCRIPTION:     Implements the spider write values to server in a separate thread from GUI thread 
 *		    since the write val needs to be done in a blocking way
 * MODIFICATIONS:   06.10.2016/vf:   initial source code
 ****************************************************************************/
//https: //developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers
//http://www.codeproject.com/Articles/168604/Combining-jQuery-Deferred-with-the-HTML-Web-Worker



var g_ajaxTimeout = 10000;
var isInit = 0;

onerror = function(error)
{
    if( (error !== null)
     && (error !== undefined)
    )
    {
        throw error;
    }
};


// "cmd": "writeVal", "sc.AjaxTimeout": sc.AjaxTimeout.toString(), "requestURLWriteVal": requestURLWriteVal }); ; // Sending message as an array to the worker
onmessage = function(e)
{


    var data = e.data;
    if (data.cmd === "isInit")
    {
        self.postMessage({ "cmd": data.cmd, "value": isInit.toString() });
    }

    else if (data.cmd === "init")
    {
        var tempStr = data.ajaxTimeout;
        var tempi = parseInt(tempStr, 10);
        if (isNaN(tempi) === false)
        {
            g_ajaxTimeout = tempi;
        }
        isInit = 1;
        self.postMessage({ "cmd": data.cmd, "value": isInit.toString() });
    }
    else if (data.cmd === "writeVal")
    {
        if (data.requestURLWriteVal.length > 0)
        {
            try
            {

                var xhr = new XMLHttpRequest();

                if ((xhr !== null)
                 && (xhr !== undefined)
                )
                {
                    //xhr.timeout = g_ajaxTimeout; //since the request is made in a synchrone way, the timeout makes no sens
                    xhr.open("GET", data.requestURLWriteVal, false);
                    xhr.onreadystatechange = function()
                    {
                        if (xhr.readyState == xhr.DONE)
                        {
                            if (xhr.status == 200 /*&& xhr.response*/)
                            {
                                if ((xhr.statusText !== null)
                                 && (xhr.statusText !== undefined)
                                )
                                {
                                    self.postMessage({ "cmd": data.cmd, "value": data.requestURLWriteVal, "ret": "Done with succes \ncgi ajax returned xhr.status = " + xhr.status + "\n xhr.statusText = " + xhr.statusText });
                                }
                                else
                                {
                                    self.postMessage({ "cmd": data.cmd, "value": data.requestURLWriteVal, "ret": "Done with succes \ncgi ajax returned no status text for xhr.status = " + xhr.status });
                                }
                            }
                            else
                            {
                                self.postMessage({ "cmd": data.cmd, "value": data.requestURLWriteVal, "ret": "Done but failed xhr.status = " + xhr.status });
                            }
                        }
                    }

                    xhr.send();
                }
            }
            catch (err)
            {
                self.postMessage({ "cmd": data.cmd, "value": data.requestURLWriteVal, "ret": "Done but failed nerr =  " + err });                
            }
        }
    }
};