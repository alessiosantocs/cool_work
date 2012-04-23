/*
   SoundManager 2: Javascript Sound for the Web.
   -------------------------------------------------
   http://www.schillmania.com/projects/soundmanager/

   Pre-release version 20060824 (web20awareness)
*/

function SoundManager(smURL,smID) {
  var self = this;
  this.enabled = false;
  this.o = null;
  this.url = (smURL||'/soundmanager.swf');
  this.id = (smID||'soundmanagermovie');
  this.oMC = null;
  this.sounds = [];
  this.soundIDs = [];
  this.usePolling = true; // allow flash to poll for status update (required for "while playing", "progress" etc.)
  this.isIE = (navigator.appName.indexOf("Microsoft")!=-1);
  this._didAppend = false;
  this._didInit = false;
  this._disabled = false;

  this.defaultOptions = {
    // -----------------
    debugMode: true,    // enable debug/status messaging, handy for development/troubleshooting
    autoLoad: false,    // enable automatic loading (otherwise .load() will be called on demand with .play(), the latter being nicer on bandwidth - if you want to .load yourself, you also can)
    stream: true,       // allows playing before entire file has loaded (recommended)
    autoPlay: false,    // enable playing of file as soon as possible (much faster if "stream" is true)
    onid3: null,        // callback function for "ID3 data is added/available"
    onload: null,       // callback function for "load finished"
    onprogress: null,   // callback function for "download progress update" (X of Y bytes received)
    onplay: null,       // callback for "play" start
    whileplaying: null, // callback during play (position update)
    onstop: null,       // callback for "user stop"
    onfinish: null,     // callback function for "song finished playing"
    multiShot: true,    // let sounds "restart" or layer on top of each other when played multiple times, rather than one-shot/one at a time
    pan: 0,             // "pan" settings, left-to-right, -100 to 100
    volume: 100,        // self-explanatory. 0-100, the latter being the max.
    // -----------------
    foo: 'bar'          // you don't need to change this one - it's actually an intentional filler.
  }

  // --- public methods ---

  this.getMovie = function(smID) {
    return self.isIE?window[smID]:document[smID];
  }

  this.loadFromXML = function(sXmlUrl) {
    try {
      self.o._loadFromXML(sXmlUrl);
    } catch(e) {
      self._failSafely();
      return true;
    }
  }

  this.createSound = function(oOptions) {
    var thisOptions = self._mergeObjects(oOptions);
    self._writeDebug('soundManager.createSound(): "<a href="#" onclick="soundManager.play(\''+thisOptions.id+'\');return false" title="play this sound">'+thisOptions.id+'</a>" ('+thisOptions.url+')');
    if (self._idCheck(thisOptions.id,true)) return false;
    self.sounds[thisOptions.id] = new SMSound(self,thisOptions);
    self.soundIDs[self.soundIDs.length] = thisOptions.id;
    try {
      self.o._createSound(thisOptions.id);
    } catch(e) {
      self._failSafely();
      return true;
    }
    if (thisOptions.autoLoad || thisOptions.autoPlay) self.sounds[thisOptions.id].load(thisOptions);
  }

  this.load = function(sID,oOptions) {
    if (!self._idCheck(sID)) return false;
    self.sounds[sID].load(oOptions);
  }

  this.play = function(sID,oOptions) {
    if (!self._idCheck(sID)) {
      if (oOptions && oOptions.url) {
        // edge support case for shortcut creation/playing of sound: .play('someID',{url:'/path/to.mp3'});
        soundManager._writeDebug('soundController.play(): attempting to create "'+sID+'"');
        oOptions.id = sID;
        self.createSound(oOptions);
      } else {
        return false;
      }
    }
    self.sounds[sID].play(oOptions);
  }

  this.start = this.play; // just for convenience

  this.stop = function(sID) {
    if (!self._idCheck(sID)) return false;
    self.sounds[sID].stop(); 
  }

  this.stopAll = function() {
    for (var oSound in self.sounds) {
      oSound.stop();
    }
  }

  this.setPan = function(sID,nPan) {
    if (!self._idCheck(sID)) return false;
    self.sounds[sID].setPan(nPan);
  }

  this.setVolume = function(sID,nVol) {
    if (!self._idCheck(sID)) return false;
    self.sounds[sID].setVolume(nVol);
  }

  this.setPolling = function(bPolling) {
    if (self.usePolling && self.o) {
      self._writeDebug('soundManager.setPolling('+bPolling+')');
      self.o._setPolling(bPolling);
    }
  }

  this.disable = function() {
    // destroy all functions
    if (self._disabled) return false;
    self._disabled = true;
    self._writeDebug('soundManager.disable(): Disabling all functions - future calls will return false.');
    for (var i=self.soundIDs.length; i--;) {
      self._disableObject(self.sounds[self.soundIDs[i]]);
    }
    self.initComplete(); // fire "complete", despite fail
    self._disableObject(self);
  }

  this.getSoundById = function(sID,suppressDebug) {
    var result = self.sounds[sID];
    if (!result && !suppressDebug) soundManager._writeDebug('"'+sID+'" is an invalid sound ID.');
    return result;
  }

  // --- "private" methods ---

  this._idCheck = this.getSoundById;

  this._disableObject = function(o) {
    for (var oProp in o) {
      if (typeof o[oProp] == 'function') o[oProp] = function(){return false;}
    }
    oProp = null;
  }

  this._failSafely = function() {
    // exception handler for "object doesn't support this property or method"
    self._writeDebug('soundManager.createSound(): JS-&gt;Flash communication failed (security restrictions?)');
    if (self._didAppend) self._writeDebug('Flash may be imposing restrictions due to the JS createElement() method. Try using the inline (plain old HTML) object/embed method if you\'re viewing this on the local filesystem.');
    self.disable();
  }

  this._createMovie = function(smID,smURL) {
    self.oMC = document.createElement('div');
    self.oMC.className = 'movieContainer';
    // "hide" flash movie
    self.oMC.style.position = 'absolute';
    self.oMC.style.left = '-256px';
    self.oMC.style.width = '1px';
    self.oMC.style.height = '1px';
    var html = ['<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="16" height="16" id="'+smID+'"><param name="movie" value="'+smURL+'"><param name="quality" value="high"><param name="allowScriptAccess" value="always" /></object>','<embed name="'+smID+'" src="'+smURL+'" width="1" height="1" quality="high" allowScriptAccess="always" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash"></embed>'];
    self.oMC.innerHTML = html[self.isIE?0:1];
    document.getElementsByTagName('div')[0].appendChild(self.oMC);
    self._didAppend = true;
  }

  this._writeDebug = function(sText) {
    if (!self.defaultOptions.debugMode) return false;
    var sDID = 'soundmanager-debug';
    try {
      var o = document.getElementById(sDID);
      if (!o) {
        // attempt to create soundManager debug element
        var oNew = document.createElement('div');
        oNew.id = sDID;
        o = document.body.appendChild(oNew);
        if (!o) return false;
      }
      var p = document.createElement('div');
      p.innerHTML = sText;
      // o.appendChild(p); // top-to-bottom
      o.insertBefore(p,o.firstChild); // bottom-to-top
    } catch(e) {
      // oh well
    }
    o = null;
  }

  this._debug = function() {
    self._writeDebug('soundManager._debug(): sounds by id/url:');
    for (var i=0,j=self.soundIDs.length; i<j; i++) {
      self._writeDebug(self.sounds[self.soundIDs[i]].sID+' | '+self.sounds[self.soundIDs[i]].url);
    }
  }

  this._mergeObjects = function(oMain,oAdd) {
    // non-destructive merge
    var o1 = oMain;
    var o2 = (typeof oAdd == 'undefined'?self.defaultOptions:oAdd);
    for (var o in o2) {
      if (typeof o1[o] == 'undefined') o1[o] = o2[o];
    }
    return o1;
  }

  this._initMovie = function() {
    // attempt to get, or create, movie
    if (self.o) return false; // pre-init may have fired this function before window.onload(), may already exist
    self.o = self.getMovie(self.id); // try to get flash movie (inline markup)
    if (!self.o) {
      // try to create
      self._createMovie(self.id,self.url);
      self.o = self.getMovie(self.id);
    }
    if (!self.o) {
      self._writeDebug('SoundManager(): Could not find object/embed element. Sound will be disabled.');
      self.disable();
    } else {
      self._writeDebug('SoundManager(): Got '+self.o.nodeName+' element ('+(self._didAppend?'created via JS':'static HTML')+')');
    }
  }

  this.initComplete = function() {
    if (self._didInit) return false;
    self._didInit = true;
    self._writeDebug('soundManager.initComplete()');
    if (typeof soundManagerLoad != 'undefined') {
      try {
        // call user-defined "onload"
        soundManagerLoad();
      } catch(e) {
        self._writeDebug('soundManagerLoad() threw an exception.');
        return true;
      }
    }
  }

  this.init = function() {
    // called after onload()
    self._initMovie();
    // event cleanup
    if (window.removeEventListener) {
      window.removeEventListener('load',soundManagerInit,false);
    } else if (window.detachEvent) {
      window.detachEvent('onload',soundManagerInit);
    }
    try {
      self.o._externalInterfaceTest(); // attempt to talk to Flash
      self._writeDebug('Flash ExternalInterface call (JS -&gt; Flash) succeeded.');
      if (!self.usePolling) self._writeDebug('Polling (onprogress/whileplaying support) is disabled.');
      self.setPolling(true);
      self.enabled = true;
    }  catch(e) {
      self._failSafely();
      self.initComplete();
      return false;
    }
    self.initComplete();
  }

  this.destructor = function() {
    // not implemented yet
    self.o = null;
    self.oMC = null;
  }

}

function SMSound(oSM,oOptions) {
  var self = this;
  var sm = oSM;
  this.sID = oOptions.id;
  this.url = oOptions.url;
  this.options = sm._mergeObjects(oOptions);
  this.id3 = {
   /* 
    Name/value pairs set via Flash when available - see reference for names:
    http://livedocs.macromedia.com/flash/8/main/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Parts&file=00001567.html
    (eg., this.id3.songname or this.id3['songname'])
   */
  }
  this.bytesLoaded = null;
  this.bytesTotal = null;
  this.position = null;
  this.duration = null;
  this.loaded = false;
  this.loadSuccess = null;
  this.playState = 0;
  this.readyState = 0; // 0 = uninitialised, 1 = loading, 2 = failed/error, 3 = loaded/success

  // --- public methods ---

  this.load = function(oOptions) {
    self.loaded = false;
    self.loadSuccess = null;
    self.readyState = 1;
    var thisOptions = sm._mergeObjects(oOptions);
    if (typeof thisOptions.url == 'undefined') thisOptions.url = self.url;
    try {
      sm.o._load(self.sID,thisOptions.url,thisOptions.stream,thisOptions.autoPlay,thisOptions.onprogress?1:0);
    } catch(e) {
      sm._writeDebug('SMSound().load(): JS-&gt;Flash communication failed.');
    }
  }

  this.play = function(oOptions) {
    if (!oOptions) oOptions = {};
    var thisOptions = sm._mergeObjects(oOptions);
    if (self.playState == 1) {
      // var allowMulti = typeof oOptions.multiShot!='undefined'?oOptions.multiShot:sm.defaultOptions.multiShot;
      var allowMulti = thisOptions.multiShot;
      if (!allowMulti) {
        sm._writeDebug('SMSound.play(): "'+self.sID+'" already playing? (one-shot)');
        return false;
      } else {
        sm._writeDebug('SMSound.play(): "'+self.sID+'" already playing (multi-shot)');
      }
    }
    if (!self.loaded) {
      if (self.readyState == 0) {
        sm._writeDebug('SMSound.play(): .play() before load request. Attempting to load "'+self.sID+'"');
        // try to get this sound playing ASAP
        thisOptions.stream = true;
        thisOptions.autoPlay = true;
        self.load(thisOptions); // try to get this sound playing ASAP
      } else if (self.readyState == 2) {
        sm._writeDebug('SMSound.play(): Could not load "'+self.sID+'" - exiting');
        return false;
      } else {
        sm._writeDebug('SMSound.play(): "'+self.sID+'" is loading - attempting to play..');
      }
    } else {
      sm._writeDebug('SMSound.play(): "'+self.sID+'"');
    }
    self.playState = 1;
    self.position = 0;
    if (thisOptions.onplay) thisOptions.onplay.apply(self);
    self.setVolume(thisOptions.volume);
    self.setPan(thisOptions.pan);
    sm.o._start(self.sID,thisOptions.loop||1,thisOptions.offset||0);
  }

  this.start = this.play; // just for convenience

  this.stop = function(bAll) {
    if (self.playState == 1) {
      self.playState = 0;
      if (sm.defaultOptions.onstop) sm.defaultOptions.onstop.apply(self);
      sm.o._stop(self.sID);
    }
  }

  this.setPan = function(nPan) {
    if (typeof nPan == 'undefined') nPan = 0;
    sm.o._setPan(self.sID,nPan);
    self.options.pan = nPan;
  }

  this.setVolume = function(nVol) {
    if (typeof nVol == 'undefined') nVol = 100;
    sm.o._setVolume(self.sID,nVol);
    self.options.volume = nVol;
  }

  // --- "private" methods called by Flash ---

  this._onprogress = function(nBytesLoaded,nBytesTotal,nDuration) {
    self.bytesLoaded = nBytesLoaded;
    self.bytesTotal = nBytesTotal;
    self.duration = nDuration;
    if (self.readyState != 3 && self.options.onprogress) self.options.onprogress.apply(self);
  }

  this._onid3 = function(oID3PropNames,oID3Data) {
    // oID3PropNames: string array (names)
    // ID3Data: string array (data)
    sm._writeDebug('SMSound()._onid3(): "'+this.sID+'" ID3 data received.');
    var oData = [];
    for (var i=0,j=oID3PropNames.length; i<j; i++) {
      oData[oID3PropNames[i]] = oID3Data[i];
    }
    self.id3 = sm._mergeObjects(self.id3,oData);
    if (self.options.onid3) self.options.onid3.apply(self);
  }

  this._whileplaying = function(nPosition) {
    if (isNaN(nPosition)) return false; // Flash may return NaN at times
    self.position = nPosition;
    if (self.playState == 1 && self.options.whileplaying) self.options.whileplaying.apply(self); // flash may call after actual finish
  }

  this._onload = function(bSuccess) {
    sm._writeDebug('SMSound._onload(): "'+self.sID+'"'+(bSuccess?' loaded.':' failed to load.'));
    self.loaded = bSuccess;
    self.loadSuccess = bSuccess;
    self.readyState = bSuccess?3:2;
    if (self.options.onload) self.options.onload.apply(self);
  }

  this._onfinish = function() {
    // sound has finished playing
    sm._writeDebug('SMSound._onfinish(): "'+self.sID+'" finished playing');
    self.playState = 0;
    self.position = 0;
    if (self.options.onfinish) self.options.onfinish.apply(self);
  }

}