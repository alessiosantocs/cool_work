info["single_video"] = new Array();
info["single_video"]["code"] = "nothing";
info["video"] = new Array();
function singleVideos_form_save(){
       	singleVideos_form_contract();

        var fi = new Array();
        fi["video[swf]"] = $('#videoSWF').val().replace(/&/g,",,,,,").replace("=",",,,,,,,,,,");
	fi["video[company_id]"]=companyID;
	fi["video[height]"]= $('#videoHeight').val();
	fi["video[width]"] = $('#videoWidth').val();
	fi["video[type]"] = $("input[name='vtype']:checked").val();
        var commit = info["video"]["commit"];
        fi["commit"]=commit;
        if(commit == "Update"){
             fi["id"] = info["video"]["actionID"];
        }

        $.ajax({
        type: "POST",
        url: "/videos/create",
        data: returnStringArray(fi),
        datatype: "xml",
        success: function(xml){
        singleVideo_info_get();
        }});
        info["video"]["commit"] = "Create";
        info["video"]["actionID"] = 0;
}

function singleVideos_form_new(){
var fi = new Array();
   fi["id"] = companyID;
   $.ajax({
   type: "GET",
   url: urlProcess("/videos/add_video"),
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
   ModalPopups.Alert('1','Add videos',xml);

}
});
}

function singleVideos_form_cancel(){

	singleVideos_form_contract();
}

function singleVideo_info_get(){

        info["video"] = new Array();
        info["video"]["commit"] = "Create";
        info["video"]["actionID"] = 0;
        singleVideos_form_contract();
        var fi = new Array();
        fi["companyID"] = companyID;
$.ajax({
   type: "GET",
   url: "/videos/find_by_company",
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    var count = 0;

    $(xml).find("video").each(function(){
    var $marker = $(this);
    var videoID = $marker.find("videoID").text();
    var videoIDNormal = videoID;
    videoID = videoID.toLowerCase();
    //alert(videoID);

    info["video"][videoID] = new Array();
    info["video"][videoID]["swf"] = $marker.find("swf").text();
    info["video"][videoID]["thumbnail"] = $marker.find("thumbnail").text();
    info["video"][videoID]["height"] = $marker.find("height").text();
    info["video"][videoID]["width"] = $marker.find("width").text();
    info["video"][videoID]["videoID"] = videoID;
    info["video"][videoID]["id"] = $marker.find("id").text();
    info["video"][videoID]["video_type"] = $marker.find("video-type").text();
    if (info["video"][videoID]["thumbnail"] < 5)
    info["video"][videoID]["thumbnail"] = "http://www.health2con.com/logos/h20tv200.gif";

    count += 1;

    });
    //alert(count);
    //alert(info["video"].length);
    singleVideo_info_update();

}
});
}


function singleVideo_form_update(videoID){
   var maker = info["video"][videoID];
   $("#videoSWF").val(maker["swf"]);
   $('#videoHeight').val(maker["height"]);
   $('#videoWidth').val(maker["width"]);
   $('#vtype').val(maker["video_type"]);

   info["video"]["commit"]= "Update";
   info["video"]["actionID"] = maker["id"];


   singleVideos_form_expand();
}


function singleVideo_form_delete(videoID){
   fi = new Array();
   fi["id"] =  info["video"][videoID]["id"];
$.ajax({
   type: "GET",
   url: "/videos/destroy_item",
   data: returnStringArray(fi),
   datatype: "xml",
   success: function(xml){
    var count = 0;
    singleVideo_info_get();

}
});
}




function HtmlDecode(text) {
 return $('<div/>').html(text).text();
}


function singleVideos_form_cancel(){
	singleVideos_form_contract();
}





function singleVideo_info_update(){
    var outString = "";
    var eval_string = "";
    var count = 0;
    for(k in info["video"]){
    
            if(admin){
                if((k != "commit") && (k != "actionID")){
                    if (info["video"][k]["video_type"]=="youtube"){
                        outString += "<div style='float:left;'> <span id='"+k+"_info'><a href='http://localhost:3000/videos/"+info["video"][k]['id']+"'><embed src='"+info["video"][k]["swf"]+"' type=\"application/x-shockwave-flash\" allowfullscreen=\"true\" allowScriptAccess=\"always\" width=\"300\" height=\"200\"></a></span>&nbsp;";	
                        outString += "<a href=\"javascript:singleVideo_form_delete('"+k+"');\"><img src=\"/images/icons/deleteitem.png\" /></a></div>";
                    //outString += "<a href=\"javascript:singleVideo_form_update('"+k+"');\"><img src=\"css/blueprint/plugins/buttons/icons/pencil.png\" /></a>";
                    }
                    if (info["video"][k]["video_type"]=="vimeo") {
                        outString += "<div style='float:left;'><iframe src='http://player.vimeo.com/video/"+info["video"][k]["videoID"]+"' width='250' height='200' frameborder='0' ></iframe><p><a href='"+info["video"][k]["swf"]+"'></a><a href='http://vimeo.com'></a></p>";
                        outString += "<a href=\"javascript:singleVideo_form_delete('"+k+"');\"><img src='/images/icons/deleteitem.png' /></a></div>";
    
  ;
                    }
                if (info["video"][k]["video_type"]=="brightcove"){
                        outString += "<script type=\"text/javascript\">var bcExp;var modVP;var modExp;var modCon;</script>";

                        outString +="<div style='float:left;'><object id=\"myExperience"+info["video"][k]["videoID"]+"\" class=\"BrightcoveExperience\"><param name=\"bgcolor\" value=\"#FFFFFF\" /><param name=\"width\" value=\"300\" /><param name=\"height\" value=\"200\" /><param name=\"playerID\" value=\"753771389001\" /><param name=\"isVid\" value=\"true\" /><param name=\"@videoPlayer\" value='"+info["video"][k]["videoID"]+"' /></object>";//`alert(outString);
                        outString += "<a href=\"javascript:singleVideo_form_delete('"+k+"');\"><img src=\"/images/icons/deleteitem.png\" /></a></div>";
                 
                    }
            
                }
            }
            count += 1;
    }
  

  $("#singleVideo_info").html(outString);

brightcove.createExperiences();

 
// called when template loads, this function stores a reference to the player and modules.



    
    for(k in info["video"]){
            if((k != "commit") && (k != "actionID")){
                    $('#'+k+"_info a").nyroModal();
    }
    }
}

function onTemplateLoaded(experienceID) {
			alert("EVENT: TEMPLATE_LOAD");bcExp = brightcove.getExperience(experienceID);modVP = bcExp.getModule(APIModules.VIDEO_PLAYER);
			modExp = bcExp.getModule(APIModules.EXPERIENCE);modCon = bcExp.getModule(APIModules.CONTENT);
			modExp.addEventListener(BCExperienceEvent.TEMPLATE_READY, onTemplateReady);
			modExp.addEventListener(BCExperienceEvent.CONTENT_LOAD, onContentLoad);
			modCon.addEventListener(BCContentEvent.VIDEO_LOAD, onVideoLoad); 

			modCon.getMediaAsynch("MyVideoId");

		}
		function onTemplateReady(evt) {
			//alert("EVENT: TEMPLATE_READY"); 
			}
		function onContentLoad(evt) {
			//alert("EVENT: CONTENT_LOAD");

			var currentVideo = modVP.getCurrentVideo();

			//alert("INFO: Currently Loaded videoID: " + currentVideo.id);

		}
		function onVideoLoad(evt) {
			alert("EVENT: VIDEO_LOAD");
		  
			// Show the video that was loaded
			modVP.cueVideo(evt.video.id);
		}

		function onPlaylistLoad(evt) {
			alert("EVENT: PLAYLIST_LOAD");
		  
		}

		/** Custom Playback Functions **/
		function ChangeVideo(videoId)
		{
			alert("EVENT: Changing Video");
			modCon.getMediaAsynch(videoId);
		}

// var bcExp;
// var modVP;
// var getid;
// function GetIdVideo(experienceID) {
// 
//     bcExp = brightcove.getExperience(experienceID);
//     modVP = bcExp.getModule(APIModules.VIDEO_PLAYER);
//     getid = modVP.getCurrentVideo();
//     getid = getid.id;
//     location.href='....../Default.aspx?videoid=' + getid + '&type=add';
//     }
