/* Redcode JavaScript Logging Library
 * (c) 2006 Redcode Technologies, LLC
 * http://www.rcode.net/blog/tlaurenzo/introducing-protowidget
 *
 * Example
 * Log.debug("Hello World");
 *
 * This library is freely distributable under the terms of an MIT-style license.
 * For details see: http://www.rcode.net/opensource/mit-license.html
 A Logger library is also included with Protowidget (see src/logger.js). 
 We intend to break this out separately because it has no ties to Protowidget. 
 While looking at the example, press ‘ALT-L’ to see the log window (if it doesn’t 
 work, click somewhere in the document and try again to make sure the document 
 has focus). The logger will automatically popup on errors. The primary methods 
 to interact with it are Log.debug, Log.info, Log.warn and Log.error. Each of 
 those methods also exposes an ‘enabled’ property for checking whether that log 
 level is turned on. For example:

if (Log.debug.enabled) Log.debug("Hello World");

This would typically only be used if generating the log message was an expensive operation. 

 */
var Log=(function() {
  var visible=false;
  var canShow=false;
  var pendingVisible=false;
  
  var Log={};
  Log.MaxLogMessages=50;
  Log.CheckActivateKey=function(evt) {
     var c=String.fromCharCode(evt.charCode || evt.keyCode);
     if ((c=='L' || c=='l') && evt.altKey) {
       return true;
     } else {
       return false;
     }
  };
  Log.KeyCombinationDesc='ALT-L';
  
  function LogUI() {
    var me=this;
    this.messageCount=0;
    this.windowDiv=document.createElement('div');
    with (this.windowDiv.style) {
      border='3px solid #a0a0a0';
      bottom='10px';
      width='90%';
      left='5%';
      
      if (navigator.appVersion.match(/\bMSIE\b/)) {
         // IE doesn't support fixed positioning
         position='absolute';
      } else {
         position='fixed';
      }
    }
    Event.observe(this.windowDiv, 'dblclick', function() {
       while (me.contentDiv.lastChild) me.contentDiv.removeChild(me.contentDiv.lastChild);
       me.messageCount=0;
    });
    
    this.titleBar=document.createElement('div');
    this.windowDiv.appendChild(this.titleBar);
    with (this.titleBar.style) {
      borderBottom='3px solid #a0a0a0';
      backgroundColor='#0000ff';
      color='#ffffff';
      fontWeight='bold';
    }
    this.titleBar.appendChild(
      document.createTextNode('Log Output - ' + Log.KeyCombinationDesc + ' to show/hide: Double Click to clear'));
    
    this.contentDiv=document.createElement('div');
    this.windowDiv.appendChild(this.contentDiv);
    with (this.contentDiv.style) {
      backgroundColor='#000000';
      color='#00ff00';
      height='200px';
      overflow='auto';
      fontFamily='"Courier New", monospace';
    }
  }
  LogUI.prototype.addMessage=function(msg) {
     var msgDiv=document.createElement('div');
     msgDiv.appendChild(document.createTextNode(msg));
     while (this.messageCount>=Log.MaxLogMessages) {
        if (this.contentDiv.lastChild) this.contentDiv.removeChild(this.contentDiv.lastChild);
        this.messageCount-=1;
     }
     if (this.contentDiv.firstChild) {
        this.contentDiv.insertBefore(msgDiv, this.contentDiv.firstChild);
     } else {
        this.contentDiv.appendChild(msgDiv);
     }
     this.messageCount+=1;
     return msgDiv;
  };
  var logUi=new LogUI();

  Log.show=function() {
     if (!canShow) pendingVisible=true;
     if (!visible) {
        document.body.appendChild(logUi.windowDiv);
        visible=true;
     }
  };
  Log.hide=function() {
     if (visible) {
        document.body.removeChild(logUi.windowDiv);
        visible=false;
     }
  };
  
  Log.print=function(msg, color) {
     var div=logUi.addMessage(msg);
     if (color) {
        div.style.color=color;
     }
  };
  
  Log.defineLogLevel=function(name, displayName, color, doShow) {
     function log(msg, e) {
        if (!arguments.callee.enabled) return;
        var d=new Date();
        var timeFmt=d.getHours() +':' + d.getMinutes() + ':' + d.getSeconds() + '.' + d.getMilliseconds();
        var fullMsg=displayName + ' ' + timeFmt + ' - ' + msg + 
         (e?(': ' + e.toString()):'');
        Log.print(fullMsg, color);
        if (doShow) Log.show();
     };
     log.enabled=true;
     Log[name]=log;
  };
  
  Log.toggle=function() {
     if (visible) {
        Log.hide();
     } else {
        Log.show();
     }
  };
  
  Log.defineLogLevel('debug', 'DEBUG', null, false);
  Log.defineLogLevel('info',  'INFO ', null, false);
  Log.defineLogLevel('warn',  'WARN ', '#ffa500', false);
  Log.defineLogLevel('error', 'ERROR', '#ff0000', true);
  
  function handleActivateKeyPress(evt) {
     if (!Log.CheckActivateKey) return;
     if (Log.CheckActivateKey(evt)) {
       evt.cancelBubble=true;
       Log.toggle();
     }
  }
  
  Event.observe(window, 'load', function() {
    canShow=true;
    if (pendingVisible) {
       Log.show();
    }
    
    if (Log.CheckActivateKey) {
       Event.observe(document, 'keypress', handleActivateKeyPress);
    }
  });
  return Log;
})();
