module DojoHelper
  def dojo_by_cdn
    %Q{
      <link rel="stylesheet" type="text/css" href="#{request.protocol}yui.yahooapis.com/combo?2.7.0/build/reset-fonts-grids/reset-fonts-grids.css" />
      <link rel="stylesheet" href="#{request.protocol}ajax.googleapis.com/ajax/libs/dojo/1.3.1/dijit/themes/tundra/tundra.css" />
      <script src="#{request.protocol}ajax.googleapis.com/ajax/libs/dojo/1.3.1/dojo/dojo.xd.js" type="text/javascript"
        djConfig="parseOnLoad: true, isDebug: (window.location.search.indexOf('debug')>-1), baseUrl:'/javascripts/dojo/'"></script>
      <script type="text/javascript">
      // <![CDATA[
        var D = dojo;
        var ID = D.byId;
        var Q = D.query;
        var C = D.connect;
        var F = function(el){ 
          try{
            return ID(el).value; 
          } catch(e){
            return null; 
          };
        };
        D.registerModulePath("fcg", "./fcg");
        D.require("fcg.basic");
        D.require("dojo.cookie");
        D.require("dijit.form.TextBox");
        D.require("dijit.form.Button");
        D.require("dijit.form.CheckBox");
        D.require("dijit.form.DropDownButton");
        D.require("dijit.Menu");
        D.require("dijit.Dialog");
        #{party_tooltip}
      // ]]>
      </script>
     }
  end
  
  def party_tooltip
    return
    <<-EOL
    D.addOnLoad(function(){
      FCG.rsvp_text = "      <form id='rsvp_form' method='post' action='/rsvp/${id}'>                                                                       \
          <input id='booking_source' name='booking[source]' type='hidden' value='local' />                                                                                       \
            <p>                                                                                                                                                                  \
              <label for='booking_contact_name'>Name:</label> <input id='booking_contact_name' maxlength='45' name='booking[contact_name]' size='20' type='text' />              \
            </p>                                                                                                                                                                 \
                                                                                                                                                                                 \
            <p>                                                                                                                                                                  \
              <label for='booking_contact_email'>Email:</label> <input id='booking_contact_email' maxlength='65' name='booking[contact_email]' size='20' type='text' />          \
            </p>                                                                                                                                                                 \
                                                                                                                                                                                 \
            <p>                                                                                                                                                                  \
              <label for='booking_contact_phone'>Phone:</label> <input id='booking_contact_phone' maxlength='15' name='booking[contact_phone]' size='12' type='text' />          \
            </p>                                                                                                                                                                 \
                                                                                                                                                                                 \
            <p>                                                                                                                                                                  \
              <label for='booking_party_type'>Occassion:</label> <select id='booking_party_type' name='booking[party_type]'><option value=''></option>                           \
      <option value='1'>Birthday Party</option>                                                                                                                                  \
      <option value='10'>Cocktail Party</option>                                                                                                                                 \
      <option value='11'>Concert Show</option>                                                                                                                                   \
      <option value='12'>Happy Hour</option>                                                                                                                                     \
      <option value='13'>New Job Celebration</option>                                                                                                                            \
      <option value='14'>Party</option>                                                                                                                                          \
      <option value='15'>Night on The Town</option>                                                                                                                              \
      <option value='16'>Get Together Party</option>                                                                                                                             \
      <option value='18'>Memorial Day</option>                                                                                                                                   \
      <option value='19'>Independence Day</option>                                                                                                                               \
      <option value='2'>Graduation Party</option>                                                                                                                                \
      <option value='20'>New Year's Eve Celebration</option>                                                                                                                     \
      <option value='21'>Thanksgiving Eve Party</option>                                                                                                                         \
      <option value='22'>Labor Day Party</option>                                                                                                                                \
      <option value='23'>Corporate Event</option>                                                                                                                                \
      <option value='3'>Bachelorette Party</option>                                                                                                                              \
      <option value='4'>Anniversary Party</option>                                                                                                                               \
      <option value='5'>Engagement Party</option>                                                                                                                                \
      <option value='6'>Job Promotion Party</option>                                                                                                                             \
      <option value='7'>Retirement Party</option>                                                                                                                                \
      <option value='8'>Welcome Back Party</option>                                                                                                                              \
      <option value='9'>Bachelor Party</option></select>                                                                                                                         \
            </p>                                                                                                                                                                 \
                                                                                                                                                                                 \
            <p>                                                                                                                                                                  \
              <label for='booking_size'>Number of Guests:</label> <input id='booking_size' maxlength='3' name='booking[size]' size='4' type='text' />                            \
            </p>                                                                                                                                                                 \
                                                                                                                                                                                 \
            <p>                                                                                                                                                                  \
              <label for='booking_bottle_service'>Bottle Service:</label> <input id='booking_bottle_service' name='booking[bottle_service]' type='checkbox' value='1' />         \
              <input name='booking[bottle_service]' type='hidden' value='0' /> Yes                                                                                               \
            </p>                                                                                                                                                                 \
                                                                                                                                                                                 \
            <p>                                                                                                                                                                  \
              <label>&nbsp;&nbsp;</label><input name='submit' value='Submit' type='submit'>                                                                                      \
            </p>                                                                                                                                                                 \
          </form>";
          
      function appendFormElements(form, data) {
        form.innerHTML = D.string.substitute(FCG.rsvp_text, {id: data.name.split(/_/)[1]});
      }
      
      function createProgrammaticTooltipDialog(data) {
        if (!dijit.byId("ttd")){
          FCG.tooltipDialog = new dijit.TooltipDialog(
            { id: 'ttd', 
              title: 'Tooltip text here' 
            });
        }
        // var url = data.href.replace(/\\/party\\//, '/rsvp/') + "?format=js";
        // FCG.tooltipDialog.setHref(url);
        appendFormElements(FCG.tooltipDialog.containerNode, data);
        FCG.tooltipDialog.startup();
        return FCG.tooltipDialog;
      }
        
      function doPopupTooltipDialog(link) {
        FCG.ttd = createProgrammaticTooltipDialog(link);
        dojo.connect(FCG.ttd, "onBlur", function(e) {
          dijit.popup.close(FCG.ttd);
          FCG.ttd.destroyRecursive();
        }, true);

        dijit.popup.open({
          parent: link,
          popup: FCG.ttd,
          around: link,
          onCancel: function() {
            dijit.popup.close(FCG.ttd);
          }
        });
      }
      
      Q("a.party").connect("mouseover", function(ev) {
        doPopupTooltipDialog(ev.target);
      });
    });
    EOL
  end
end