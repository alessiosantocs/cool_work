module AdSystem
  def google_admanager_header
    raise "@google_ads is not set" if @google_ads.nil?
    ads = @google_ads.collect{|ad| "GA_googleAddSlot('ca-pub-0178269653059034', '#{SETTING['site']}_#{ad}');" }.join(" ")
    <<-EOL
    <script type="text/javascript" src="http://partner.googleadservices.com/gampad/google_service.js"></script>
    <script type="text/javascript">GS_googleAddAdSenseService("ca-pub-0178269653059034"); GS_googleEnableAllServices();</script>
    <script type="text/javascript">GA_googleAddAttr('subDomain', App.subDomain());</script>
    <script type="text/javascript">
    #{ads}
    GA_googleFetchAds();
    </script>
    EOL
  end
  
  def render_ad(ad, classname="ad")
    %Q{<div class="#{classname} #{ad}"><script type="text/javascript">GA_googleFillSlot("#{SETTING['site']}_#{ad}");</script></div>} if @google_ads.include?(ad)
  end
  
  def inhouse_ads(size, name="ros", ads_shown=1)
    raise "Number of ads shown must a number" unless ads_shown.is_a?(Fixnum) or ads_shown < 1
    if ads_shown > 1
      ads = []
      1.upto(ads_shown) do |i|
        ads << render_ad("#{size}_#{name}#{i}", "flyerad")
      end
      ads.join
    else
      render_ad("#{size}_#{name}", "flyerad")
    end
  end
  
  def show_interstitial
    <<-CODE 
    <!--/* DEPRICATED!!! OpenX Interstitial or Floating DHTML Tag v2.7.25-beta */-->
    <script type="text/javascript">
    (function(){
      var rand_num = 0; // Math.floor(Math.random()*999999);
      var url = "http://d1.openx.org/al.php?zoneid=14760&target=_top&charset=UTF-8&cb="+rand_num+"&layerstyle=simple&align=center&valign=middle&padding=0&charset=UTF-8&closetime=10&padding=0&shifth=0&shiftv=0&closebutton=t&backcolor=FFFFFF&bordercolor=000000";
      document.write(unescape("%3Cscript src='" + url + "' type='text/javascript'%3E%3C/script%3E"));
    }());
    </script>
    CODE
  end
end
