require "rubygems"
require 'mysql'
require "yaml"
require 'find'
require 'RMagick'
require 'digest/md5'
require "lib/utils"
include Utils

SETTING = YAML::load(File.open("./config/settings.yml"))
EY_DB = YAML::load(File.open("./config/database.yml"))

DB_HOST = "db1.fcgmedia.com"
DB = {
  :ibf => {
    :host => DB_HOST,
    :username => "fcginc3",
    :password => "Ifejika9",
    :database => "fcg"
  },
  :source => {
    :host => DB_HOST,
    :username => "fcginc3",
    :password => "Ifejika9",
    :database => "alltheparties"
  },
  :dest   => {
    :host => DB_HOST,
    :username => "shopnight",
    :password => "",
    :database => "atp_dev"
  }
}

ROOT = "/data/frstclan/current"
IMG_PATH = "/home/shopnight/sites/atp_anc/i"

FLYER_PATH = IMG_PATH + "/flyer/"

GALLERY_PATH = IMG_PATH + "/g/"

WATERMARK = "/data/frstclan/current/watermark.gif"
MAGICK_MARK = Magick::ImageList.new(WATERMARK)

CITY_ZIPS = {
 :nyc => { :id => 1, :zips => %w{00501 00544 06390 06601 06602 06604 06605 06606 06607 06608 06610 06611 06612 06614 06615 06673 06699 06784 06801 06804 06807 06810 06811 06812 06813 06814 06816 
   06817 06820 06824 06825 06828 06829 06830 06831 06836 06838 06840 06842 06850 06851 06852 06853 06854 06855 06856 06857 06858 06859 06860 06870 06875 06876 06877 06878 06879 06880 06881 06883 
   06888 06889 06890 06896 06897 06901 06902 06903 06904 06905 06906 06907 06910 06911 06912 06913 06920 06921 06922 06925 06926 06927 06928 07001 07002 07003 07004 07005 07006 07007 07008 07009 
   07010 07011 07012 07013 07014 07015 07016 07017 07018 07019 07020 07021 07022 07023 07024 07026 07027 07028 07029 07030 07031 07032 07033 07034 07035 07036 07039 07040 07041 07042 07043 07043 
   07044 07045 07046 07047 07050 07051 07052 07054 07055 07057 07058 07060 07061 07062 07063 07064 07065 07066 07067 07068 07070 07071 07072 07073 07074 07075 07076 07077 07078 07079 07080 07081 
   07082 07083 07086 07087 07088 07090 07091 07092 07093 07094 07095 07096 07097 07099 07101 07102 07103 07104 07105 07106 07107 07108 07109 07110 07111 07112 07114 07175 07184 07188 07189 07191 
   07192 07193 07194 07195 07198 07199 07201 07202 07203 07204 07205 07206 07207 07208 07302 07303 07304 07305 07306 07307 07308 07309 07310 07311 07399 07401 07403 07405 07407 07410 07417 07420 
   07421 07423 07424 07430 07432 07435 07436 07438 07438 07440 07442 07444 07446 07450 07451 07452 07456 07457 07458 07460 07460 07463 07465 07470 07474 07477 07480 07481 07495 07501 07502 07503 
   07504 07505 07506 07507 07508 07509 07510 07511 07512 07513 07514 07522 07524 07533 07538 07543 07544 07601 07602 07603 07604 07605 07606 07607 07608 07620 07621 07624 07626 07627 07628 07630 
   07631 07632 07640 07641 07642 07643 07644 07645 07646 07647 07648 07649 07650 07652 07653 07656 07657 07660 07661 07662 07663 07666 07670 07675 07676 07677 07699 07701 07702 07703 07704 07709 
   07710 07711 07712 07715 07716 07717 07718 07719 07720 07721 07722 07723 07724 07726 07727 07728 07730 07731 07732 07733 07734 07735 07735 07737 07738 07739 07740 07746 07747 07747 07748 07750 
   07751 07752 07753 07754 07755 07756 07757 07758 07760 07762 07763 07764 07765 07777 07799 07801 07802 07803 07806 07828 07830 07834 07836 07840 07842 07845 07847 07849 07850 07852 07853 07856 
   07857 07866 07869 07870 07876 07878 07885 07901 07902 07920 07922 07926 07927 07928 07930 07931 07932 07933 07934 07935 07936 07940 07945 07946 07950 07960 07961 07962 07963 07970 07974 07976 
   07980 07981 07983 07999 08501 08510 08512 08514 08520 08526 08535 08536 08540 08555 08562 08691 08720 08724 08730 08736 08750 08810 08812 08812 08816 08817 08818 08820 08824 08828 08830 08831 
   08832 08837 08840 08846 08850 08852 08854 08855 08857 08859 08861 08862 08863 08871 08872 08879 08882 08884 08899 08901 08902 08903 08904 08905 08906 08922 08933 08988 08989 10001 10002 10003 
   10004 10005 10006 10007 10008 10009 10010 10011 10012 10013 10014 10016 10017 10018 10019 10020 10021 10022 10023 10024 10025 10026 10027 10028 10029 10030 10031 10032 10033 10034 10035 10036 
   10037 10038 10039 10040 10041 10043 10044 10045 10047 10048 10055 10069 10072 10080 10081 10082 10087 10095 10101 10102 10103 10104 10105 10106 10107 10108 10109 10110 10111 10112 10113 10114 
   10115 10116 10117 10118 10119 10120 10121 10122 10123 10124 10125 10126 10128 10129 10130 10131 10132 10133 10138 10149 10150 10151 10152 10153 10154 10155 10156 10157 10158 10159 10160 10162 
   10163 10164 10165 10166 10167 10168 10169 10170 10171 10172 10173 10174 10175 10176 10177 10178 10179 10185 10199 10213 10242 10249 10256 10259 10260 10261 10265 10268 10269 10270 10271 10272 
   10273 10274 10275 10276 10277 10278 10279 10280 10281 10282 10285 10286 10301 10302 10303 10304 10305 10306 10307 10308 10309 10310 10311 10312 10313 10314 10451 10452 10453 10454 10455 10456 
   10457 10458 10459 10460 10461 10462 10463 10464 10465 10466 10467 10468 10469 10470 10471 10472 10473 10474 10475 10501 10502 10503 10504 10505 10506 10507 10510 10511 10514 10517 10518 10519 
   10520 10521 10522 10523 10526 10527 10528 10530 10532 10533 10535 10536 10538 10540 10541 10543 10545 10546 10547 10548 10549 10550 10551 10552 10553 10557 10558 10560 10562 10566 10567 10570 
   10571 10572 10573 10576 10577 10578 10579 10580 10583 10587 10588 10589 10590 10591 10594 10595 10596 10597 10598 10601 10602 10603 10604 10605 10606 10607 10610 10701 10702 10703 10704 10705 
   10706 10707 10708 10709 10710 10801 10802 10803 10804 10805 10901 10911 10913 10920 10923 10927 10931 10952 10954 10956 10960 10962 10964 10965 10968 10970 10974 10976 10977 10980 10982 10983 
   10984 10986 10989 10993 10994 11001 11001 11002 11003 11004 11005 11010 11020 11021 11022 11023 11024 11030 11040 11040 11042 11050 11051 11052 11053 11054 11055 11096 11096 11101 11102 11103 
   11104 11105 11106 11109 11201 11202 11203 11204 11205 11206 11207 11208 11209 11210 11211 11212 11213 11214 11215 11216 11217 11218 11219 11220 11221 11222 11223 11224 11225 11226 11228 11229 
   11230 11231 11232 11233 11234 11235 11236 11237 11238 11239 11241 11242 11243 11245 11247 11251 11252 11256 11351 11352 11354 11355 11356 11357 11358 11359 11360 11361 11362 11363 11364 11365 
   11366 11367 11368 11369 11370 11371 11372 11373 11374 11375 11377 11378 11379 11380 11381 11385 11386 11405 11411 11412 11413 11414 11415 11416 11417 11418 11419 11420 11421 11422 11423 11424 
   11425 11426 11427 11428 11429 11430 11431 11432 11433 11434 11435 11436 11439 11451 11501 11507 11509 11510 11514 11516 11518 11520 11530 11531 11535 11536 11542 11545 11547 11548 11549 11550 
   11551 11552 11553 11554 11555 11556 11557 11558 11559 11560 11561 11563 11565 11566 11568 11569 11570 11571 11572 11575 11576 11577 11579 11580 11581 11582 11590 11592 11594 11595 11596 11597 
   11598 11599 11690 11691 11692 11693 11694 11695 11697 11701 11702 11703 11704 11705 11706 11707 11708 11709 11710 11713 11714 11715 11716 11717 11718 11719 11720 11721 11722 11724 11725 11726 
   11727 11729 11730 11731 11732 11733 11735 11735 11736 11737 11738 11739 11740 11741 11742 11743 11746 11747 11749 11750 11751 11752 11753 11754 11755 11756 11757 11758 11758 11760 11762 11763 
   11764 11765 11766 11767 11768 11769 11770 11771 11772 11773 11774 11775 11776 11777 11778 11779 11780 11782 11783 11784 11786 11787 11788 11789 11790 11791 11792 11793 11794 11795 11796 11797 
   11798 11801 11802 11803 11804 11815 11854 11855 11901 11930 11931 11932 11933 11934 11935 11937 11939 11940 11941 11942 11944 11946 11947 11948 11949 11950 11951 11952 11953 11954 11955 11956 
   11957 11958 11959 11960 11961 11962 11963 11964 11965 11967 11968 11969 11970 11971 11972 11973 11975 11976 11977 11978 11980 } },
 :hou => { :id => 2, :zips => %w{77001 77002 77003 77004 77005 77006 77007 77008 77009 77010 77011 77012 77013 77014 77015 77016 77017 77018 77019 77020 77021 77022 77023 77024 77025 77026 77027 
   77028 77029 77030 77031 77032 77033 77034 77035 77036 77037 77038 77039 77040 77041 77042 77043 77044 77045 77046 77047 77047 77048 77049 77050 77051 77052 77053 77053 77054 77055 77056 77057 
   77058 77059 77060 77061 77062 77063 77064 77065 77066 77067 77068 77069 77070 77071 77072 77073 77074 77075 77076 77077 77078 77079 77080 77081 77082 77082 77083 77083 77084 77085 77085 77086 
   77087 77088 77089 77090 77091 77092 77093 77094 77095 77096 77098 77099 77099 77201 77202 77203 77204 77205 77206 77207 77208 77210 77212 77213 77215 77216 77217 77218 77219 77220 77221 77222 
   77223 77224 77225 77226 77227 77228 77229 77230 77231 77233 77234 77235 77236 77237 77238 77240 77241 77242 77243 77244 77245 77248 77249 77251 77252 77253 77254 77255 77256 77257 77258 77259 
   77261 77262 77263 77265 77266 77267 77268 77269 77270 77271 77272 77273 77274 77275 77277 77279 77280 77282 77284 77287 77288 77289 77290 77291 77292 77293 77297 77298 77299 77301 77302 77303 
   77304 77305 77306 77315 77316 77318 77325 77327 77327 77328 77328 77333 77336 77338 77339 77339 77345 77346 77347 77353 77354 77355 77355 77356 77357 77357 77357 77358 77362 77363 77365 77365 
   77368 77369 77371 77372 77372 77373 77375 77377 77378 77379 77380 77381 77381 77382 77382 77383 77384 77385 77386 77387 77388 77389 77391 77393 77396 77401 77402 77406 77410 77411 77413 77417 
   77420 77422 77423 77423 77429 77430 77430 77431 77433 77435 77441 77444 77444 77445 77446 77447 77447 77447 77449 77450 77450 77451 77459 77461 77463 77464 77466 77469 77471 77476 77477 77477 
   77478 77479 77480 77481 77484 77484 77485 77486 77487 77489 77489 77491 77492 77493 77493 77493 77494 77494 77494 77496 77497 77501 77502 77503 77504 77505 77506 77507 77508 77510 77511 77511 
   77512 77514 77515 77516 77517 77518 77520 77520 77521 77521 77522 77530 77531 77532 77532 77533 77534 77535 77535 77535 77536 77538 77539 77539 77541 77542 77545 77546 77546 77546 77547 77549 
   77550 77551 77552 77553 77554 77555 77560 77561 77562 77563 77564 77565 77566 77568 77568 77571 77572 77573 77574 77575 77575 77577 77578 77578 77580 77581 77581 77582 77583 77583 77584 77586 
   77587 77588 77590 77591 77592 77597 77598 77617 77622 77623 77650 77656 77661 77665 77873 } }
}

ZONE = {
      "4"=>"Eastern Time (US & Canada)", 
			"5"=>"Indiana (East)", 
			"6"=>"Central Time (US & Canada)",
			"7"=>"Mountain Time (US & Canada)",
			"8"=>"Pacific Time (US & Canada)", 
			"9"=>"Alaska", 
			"10"=>"Hawaii", 
			"11"=>"Midway Island", 
			"12"=>"International Date Line West" }
			
MUSIC = {
        "4" => 'Acid Jazz',
        "5" => 'Alternative',
        "6" => 'Ambient',
        "2" => 'Bashment',
        "47" => 'Bhangra',
        "7" => 'Blues',
        "8" => 'Cabaret', 
        "9" => 'Calypso',
        "10" => 'Classics', 
        "11" => 'Country',
        "37" => 'Deep House',
        "12" => 'Disco',
        "43" => 'Downbeat House',
        "13" => 'Electronica',
        "40" => 'Filter House',
        "44" => 'Funk',
        "42" => 'Garage',
        "14" => 'Glam Rock',
        "15" => 'Hip-Hop',
        "46" => 'House',
        "16" => 'Industrial',
        "17" => 'Jungle',
        "18" => 'Latin',
        "31" => 'Latin Soul',
        "19" => 'Lounge',
        "20" => 'Metal',
        "21" => 'New Wave',
        "45" => 'NY Underground House',
        "22" => 'Old School',
        "38" => 'Progressive House',
        "23" => 'Psychedelic',
        "25" => 'Reggae',
        "24" => 'Rhythm and Blues',
        "35" => 'Rock\'n\'Roll',
        "34" => 'Salsa',
        "33" => 'Samba',
        "26" => 'Smooth Jazz',
        "39" => 'Soulful House',
        "32" => 'Spanish',
        "27" => 'Swing',
        "28" => 'Techno/Rave',
        "29" => 'Top 40',
        "36" => 'Trance',
        "41" => 'Tribal House',
        "30" => 'Trip-Hop'
      }

TRACKER_TYPES = {
      'pic' => 'ImageSet',
      'par' => 'Party',
      'ven' => 'Venue'
    }
      			
class Mysql
  alias :query_no_block :query
  def query(sql)
    res = query_no_block(sql)
    return res unless block_given?
    begin
      yield res
    ensure
      res.free if res
    end
  end
end

def with_db(opt={})
  options = DB[:source].merge(opt)
  
  #old users is in fcg
  #new stuff are in atp_dev
  #old stuff in alltheparties
  
  dbh = Mysql.real_connect(options[:host], options[:username], options[:password], options[:database])
  begin
    yield dbh 
  ensure
    dbh.close
  end
end

def find_location_by_zip(zip)
  with_db(DB[:dest]) do |db|
    stmt = "select City, State from postal_codes where ZipCode='#{zip}' and PrimaryRecord='P' limit 1"
    res = db.query(stmt)
    return nil if res.num_rows() == 0
    res.each { |r| return "#{(r[0])}, #{r[1]}".initial_caps }
  end
end
			
def find_time_zone_by_zip(zip)
  time_zone = nil
  dst = nil
  with_db(DB[:dest]) do |db|
    stmt = "select TimeZone, DayLightSaving from postal_codes where ZipCode='#{zip}' and PrimaryRecord='P' limit 1"
    res = db.query(stmt)
    #puts "\nQuery: #{stmt}\n\nResults found: #{res.num_rows()}"
    return nil if res.nil?
    res.each { |r| time_zone = r[0].to_i; dst = r[1] }
  end
	return find_time_zone_by_number(time_zone, dst)
end

def find_time_zone_by_number(time_zone, dst)
  time_zone -= 1 if dst == 'Y'
	return ZONE[time_zone.to_s]
end

def add_image_to_db(img_data)
  atp_columns = []
  insert_values = []
  # if id exists, add to record
  unless img_data[:id].nil?
    atp_columns << "id"
    insert_values << img_data[:id]
  end
  #add file name
  atp_columns << "name"
  insert_values << img_data[:name]
  #add caption
  atp_columns << "caption"
  insert_values << img_data[:caption].strip_slashes.escape_quotes
  #add comments_allowed
  atp_columns << "comments_allowed"
  insert_values << img_data[:comments_allowed]
  #add created_on
  atp_columns << "created_on"
  insert_values << img_data[:created_on]
  #add updated_on
  atp_columns << "updated_on"
  insert_values << img_data[:updated_on]
  #add extension
  atp_columns << "extension"
  insert_values << img_data[:extension]
  #add path
  atp_columns << "path"
  insert_values << img_data[:path]
  #add url
  atp_columns << "url"
  insert_values << img_data[:url]
  #add server
  atp_columns << "server"
  insert_values << img_data[:server]
  #add user_id
  atp_columns << "user_id"
  insert_values << img_data[:user_id]
  begin
    #Get Image data via rmagick
    img = Magick::Image::read(img_data[:file]).first
    w, h = img.columns, img.rows
    #add width
    atp_columns << "width"
    insert_values << w
    #add height
    atp_columns << "height"
    insert_values << h
    #add size
    atp_columns << "size"
    insert_values << File.stat(img_data[:file]).size
    process_for_storage(img_data)
  rescue Exception => err
    puts err
  end
  #insert into image table
  stmt = "INSERT INTO images (#{atp_columns.join(", ")}) VALUES ('#{insert_values.join("','")}')"
  return insertRecord(stmt)
end

def which_site(id)
  atp = [6,11,13]
  all = [7,9,14]
  return 2 if all.include?(id.to_i)
  return 1
end

def promoter?(id)
  pro = [13,14]
  return true if pro.include?(id.to_i)
  return false
end

def addToNewDb(stmt)
  res = nil
  with_db(DB[:dest]) do |db|
    #clean out all users except admin
    res = db.query(stmt)
  end
  return res
end

def insertRecord(stmt)
  res = nil
  with_db(DB[:dest]) do |db|
    #clean out all users except admin
    res = db.prepare(stmt)
    res.execute
  end
  return res.insert_id()
end

def musicname(music)
  m = music.collect { |m| MUSIC[m.to_s] }.compact
  case m.size
    when 3
      "#{m[0]}, #{m[1]}, and #{m[2]}"
    when 2
      "#{m[0]} and #{m[1]}"
    when 1
      m[0]
    when 0
      ''
  end
end

def get_photographer_by_event(event_id)
  with_db({:database => 'alltheparties'}) do |db|
    res = db.query("select ev2.photographer, ev.uid from ev2 join ev on ev2.eid = ev.id where ev2.id=#{event_id}")
    res.each do |r|
      return (r[0].to_i > 0 ? r[0] : r[1])
    end
    return nil
  end
end

def get_photographer_by_party(party_id)
  with_db({:database => 'alltheparties'}) do |db|
    res = db.query("select uid from ev where id=#{party_id}")
    res.each do |r|
      return r[0]
    end
    return nil
  end
end

def process_img(file, img={}, opt={})
  return "File does not exist!" if file.nil?
  max = {:width=> SETTING['image']['max']['width'], :height=> SETTING['image']['max']['height']}.merge(opt)
  watermark = false
  begin
    new_img = Magick::Image::read(file).first
    return "Image is too big (Height can be bigger than #{max[:height]} and width can't be wider than #{max[:width]}.)" if max[:width] < new_img.columns or max[:height] < new_img.rows
	  new_img.density = "72x72"
  
    #create destination and image dimensions
    img001 = img[:path]+img[:name]+img[:extension]
    if !img[:width].nil? and !img[:height].nil?
      dimensions = "#{img[:width]}x#{img[:height]}"
		  #Crop only thumbnail sized images
		  if img[:width] < 150 || img[:height] < 150
		    new_img = crop(new_img, img[:width], img[:height])
		  else
		    watermark = true
		  end
      new_img.change_geometry!(dimensions) { |cols, rows, image|
        image.resize!(cols, rows)
      }
    end
    new_img.composite!(MAGICK_MARK, Magick::NorthEastGravity, 5, 5, Magick::OverCompositeOp) if watermark == true
    new_img.write(img001){ self.quality = 90 }
  rescue Exception => err
    return 'Could not process your image file.  Please try again. ' + err
  else
    return new_img
  end
end

def crop(img, w, h)
	aspectRatio = w.to_f / h.to_f
	
	imgRatio = img.columns.to_f / img.rows.to_f

	if img.columns > img.rows
	  img.crop!(Magick::CenterGravity, img.rows, img.rows).scale(h,h)
	else
	  img.crop!(Magick::CenterGravity, img.columns, img.columns).scale(w,w)
	end
	imgRatio > aspectRatio ? scaleRatio = w.to_f / img.columns : scaleRatio = h.to_f / img.rows

  img.resize!(scaleRatio)
  return img
end

def process_for_storage(img)
	filename = img[:name] || generate_challenge(6) #create a random filename
	s = SETTING['image'] #shorten setting constant
	case img[:type]
	  when 'User'
	    image_array = ['small', 'large', 'tiny']
	  when 'Event'
	    image_array = ['small', 'large', 'tiny']
	  when 'CoverImage'
	    image_array = ['cover_image']
	  when 'Flyer'
	    image_array = ['flyer', 'large', 'tiny']
	  else
	    return
	end
	
	# create original image
	original_image = process_img(img[:file], {
		:server => SETTING['image_server']['host'], 
		:path => img[:path], 
		:extension => SETTING['image_server']['extension'],  
		:name => filename})

	# Create additional images from image_array
	image_array.each do |size|
		new_image = process_img(img[:file], {
			:server => SETTING['image_server']['host'], 
			:path => img[:path], 
			:extension => SETTING['image_server']['extension'],  
			:name => filename + '_' + size,
			:width => s[size]['width'],
			:height => s[size]['height'] })
	end
end

def assign_city_id
  CITY_ZIPS.each do |key,val|
    query = <<-EOL
    UPDATE venues set city_id=#{val[:id]} where postal_code in (#{val[:zips].join(',')})
    EOL
    addToNewDb query
  end
end

def move_users
  addToNewDb "delete from users where id > 1"
  addToNewDb "delete from roles_users where user_id >1"

  switchboard = {
    'id' => 'id',
    'username' => 'name',
    'email' => 'email',
    'full_name' => 'fullname',
    'company_name' => 'companyname',
    'sex' => 'sex',
    'mobile' => 'mobile',
    'country' => 'country',
    'ip_address' => 'ip_address',
    'password_hash' => 'converge_pass_hash',
    'password_salt' => 'converge_pass_salt',
    'member_login_key' => 'member_login_key',
    'allow_admin_mails' => 'allow_admin_mails'
  }

  with_db(DB[:ibf]) do |db|
    #users
    res = db.query("select * from ibf_members join ibf_members_converge on ibf_members.id = ibf_members_converge.converge_id where ibf_members.id > 1 and last_visit > 0")
    res.each_hash do |r|
      insert_values = []
      fcg_columns = []
      atp_columns = []    
      switchboard.each do |atp,fcg| 
        insert_values << r[fcg] #add raw data
        atp_columns << atp
      end
      #add site_data
      atp_columns << 'site_id'
      insert_values << which_site(r['mgroup'])
      #add created_on
      atp_columns << 'created_on'
      insert_values << Time.at(r['joined'].to_i).gmtime.db
      #add updated_on
      atp_columns << 'updated_on'
      insert_values << Time.now.gmtime.db
      #add defaults
      atp_columns << "email_messages_allowed"
      insert_values << 1
      if r['country'] == 'us'
        zip = r['zip'].rjust(5,'0')
        #add postal code
        atp_columns << "postal_code"
        insert_values << zip
        #add location
        atp_columns << "location"
        insert_values << find_location_by_zip(zip)
        #add time_zone
        atp_columns << "time_zone"
        insert_values << find_time_zone_by_zip(zip)
      end
      #escape insert values for db
      insert_values = insert_values.collect { |i| i.to_s.escape_quotes }
      #add user
      addToNewDb "INSERT INTO users (#{atp_columns.join(", ")}) VALUES ('#{insert_values.join("','")}')"
      #add roles
      addToNewDb "INSERT INTO roles_users (role_id, user_id) VALUES (3, #{r['id'].to_i});" if promoter?(r['mgroup'])
      puts r['id']
    end
  end
end

def move_friends
  with_db(DB[:source]) do |db|
    res = db.query("select id, fp, fc, a from friends")
    val = []
    res.each do |r|
      val << "(#{r[0]},#{r[1]},#{r[2]},#{r[3]})"
    end
    addToNewDb "truncate friends"
    addToNewDb "INSERT IGNORE INTO friends (id, fp, fc, a) VALUES " + val.join(',')
  end
end

def move_services
  #clear services table
  addToNewDb "truncate services"
  #create switchboard
  switchboard = {
    'id' => 'id',
    'user_id' => 'uid',
    'business_name' => 'bizname',
    'category_id' => 'cat',
    'name' => 'name',
    'email' => 'email',
    'phone' => 'phone',
    'fax' => 'fax',
    'url' => 'url',
    'address' => 'address',
    'city' => 'city',
    'state' => 'state',
    'postal_code' => 'postalcode',
    'country'=> 'country',
    'description' => 'description',
    'published' => 'published',
    'created_on' => 'created'
  }
  with_db(DB[:source]) do |db|
    res = db.query("select * from services")
    res.each_hash do |r|
      insert_values = []
      atp_columns = []
      switchboard.each do |atp,fcg| 
        insert_values << r[fcg].to_s.escape_quotes #add raw data
        atp_columns << atp
      end
      addToNewDb "INSERT INTO services (#{atp_columns.join(", ")}) VALUES ('#{insert_values.join("','")}')"
      puts r['id']
    end
  end
end

def move_guestlist
  #clear guestlist table
  addToNewDb "truncate guestlists"
  # create switchboard  
  switchboard = {
    'id' => 'gid',
    'event_id' => 'ev2id',
    'user_id' => 'uid',
    'full_name' => 'gname',
    'number_of_guests' => 'num_ppl'
  }
  with_db(DB[:source]) do |db|
    res = db.query("select gid, ev2id, uid, gname, num_ppl from guestlist")
    val = []
    res.each do |r|
      val << "(#{r[0]},#{r[1]},#{r[2]},'#{r[3].to_s.strip_slashes.escape_quotes}',#{r[4].to_i})"
    end
    addToNewDb "INSERT IGNORE INTO guestlists (id, event_id, user_id, full_name, number_of_guests) VALUES " + val.join(',')
    addToNewDb "update guestlists set created_on = now()"
  end
end

def move_venue
  #clear guestlist table
  addToNewDb "truncate venues"
  # create venues  
  switchboard = {
    'id' => 'id',
    'name' => 'name',
    'user_id' => 'creator',
    'address' => 'address',
    'cross_street' => 'crostreet',
    'country' => 'country',
    'phone' => 'phone',
    'active' => 'live',
    'created_on' => 'created'
  }
  
  with_db(DB[:source]) do |db|
    res = db.query("select * from venue")
    res.each_hash do |r|
      insert_values = []
      atp_columns = []
      switchboard.each do |atp,fcg| 
        insert_values << r[fcg].to_s.escape_quotes #add raw data
        atp_columns << atp
      end
      if r['country'] == 'us'
        zip = r['zipcode'].rjust(5,'0')
        #add postal code
        atp_columns << "postal_code"
        insert_values << zip
        #add city, state
        location = find_location_by_zip(zip)
        unless location.nil?
          city, state = location.split(/,/)
          atp_columns << "city"
          insert_values << city
          atp_columns << "state"
          insert_values << state
          #add time_zone
          atp_columns << "time_zone"
          insert_values << find_time_zone_by_zip(zip)
        else
          atp_columns << "city"
          insert_values << r['city']
          atp_columns << "state"
          insert_values << r['state']
          #add time zone
          atp_columns << "time_zone"
          dst = (r['DST'].to_i == 1 ? 'Y' : 'N')
          insert_values << find_time_zone_by_number(r['GMTOffset'].to_i.abs, dst)
        end
      else  
        atp_columns << "city"
        insert_values << r['city']
        atp_columns << "state"
        insert_values << r['state']
      end
      stmt = "INSERT INTO venues (#{atp_columns.join(", ")}) VALUES ('#{insert_values.join("','")}')"
      #puts stmt
      addToNewDb stmt
      puts r['id']
    end
  end
  assign_city_id
end

def move_parties
  #clear parties table
  addToNewDb "truncate parties"
  addToNewDb "truncate parties_sites"
  # create parties  
  switchboard = {
    'id' => 'id',
    'user_id' => 'uid',
    'venue_id' => 'vid',
    'current_event_id' => 'nextev',
    'last_event_id' => 'lastev',
    'title' => 'eventtitle',
    'hosted_by' => 'hostedby',
    'end_date' => 'enddate',
    'length_in_hours' => 'eventlengthhours',
    'dress_code' => 'dresscode',
    'age_male' => 'agemale',
    'age_female' => 'agefemale',
    'dj' => 'dj',
    'description' => 'description',
    'wotm' => 'wotm',
    'tf' => 'tf',
    'timeframecount' => 'timeframecount',
    'recur' => 'recur',
    'dotw' => 'dotw',
    'pics_left' => 'pics_remaining',
    'days_paid' => 'days_remaining',
    'photographer' => 'photographer',
    'premium' => 'premium',
    'active' => 'live',
    'created_on' => 'created',
    'updated_on' => 'updated'
  }
  with_db(DB[:source]) do |db|
    res = db.query("select * from ev")
    res.each_hash do |r|
      insert_values = []
      atp_columns = []
      switchboard.each do |atp,fcg| 
        insert_values << r[fcg].to_s.strip_slashes.escape_quotes #add raw data
        atp_columns << atp
      end
      #add door charge
      atp_columns << "door_charge"
      insert_values << r['doorcharge'].to_i*100
      #add guestlist charge
      atp_columns << "guestlist_charge"
      insert_values << r['guestlistcharge'].to_i*100
      #add music
      atp_columns << "music"
      insert_values << musicname([r['music1'], r['music2'], r['music3']]).escape_quotes
      #add comments allowed
      atp_columns << "comments_allowed"
      insert_values << 1
      #add days free
      atp_columns << "days_free"
      insert_values << 0
      stmt = "INSERT INTO parties (#{atp_columns.join(", ")}) VALUES ('#{insert_values.join("','")}')"
      addToNewDb stmt
      addToNewDb "INSERT INTO parties_sites (party_id, site_id, created_on) VALUES (#{r['id']}, #{r['site'] == 'ATP' ? 1 : 2}, '#{r['created']}')"
    end
  end
end

def move_events
  #clear events table
  addToNewDb "truncate events"
  # create parties  
  switchboard = {
    'id' => 'id',
    'party_id' => 'eid',
    'venue_id' => 'vid',
    'happens_at' => 'eventdatetime',
    'search_date' => 'searchdate',
    'created_on' => 'created',
    'active' => 'status',
    'picture_uploaded' => 'pic',
    'image_sets_count' => 'piccount',
    'photographer_id' => 'photographer',
    'picture_upload_time' => 'pic_upload',
    'synopsis' => 'synopsis',
    'hosted_by' => 'hostedby'
  }
  with_db(DB[:source]) do |db|
    res = db.query("select * from ev2")
    res.each_hash do |r|
      insert_values = []
      atp_columns = []
      switchboard.each do |atp,fcg| 
        insert_values << r[fcg].to_s.strip_slashes.escape_quotes #add raw data
        atp_columns << atp
      end
      #add comments allowed
      atp_columns << "comments_allowed"
      insert_values << 1
      #add updated_on
      atp_columns << "updated_on"
      insert_values << Time.now.db
      stmt = "INSERT INTO events (#{atp_columns.join(", ")}) VALUES ('#{insert_values.join("','")}')"
      #puts stmt
      addToNewDb stmt
      #create pic fir if pics exist
      system "mkdir -p " + SETTING['image_server']['path'] + "/party/#{r['eid']}/#{r['id']}" if r['pic'].to_i == 1
    end
  end
end

def move_images_and_image_sets
  #clear images and image_sets tables
  addToNewDb "truncate images"
  addToNewDb "truncate image_sets"
  res = []
  with_db(DB[:source]) do |db|
    res = db.query("select evg.* from evg join ev2 on ev2.id = evg.ev2id")
  end
  res.each_hash do |r|
    begin
      original_file = GALLERY_PATH + "#{r['eid']}/#{r['ev2id']}/#{Digest::MD5.hexdigest(r['fn'])}" + SETTING['image_server']['extension']
      img = {
        :type => "Event",
        :caption => r['caption'],
        :id => r['id'], 
        :name => r['fn'], 
        :comments_allowed => 1,
        :created_on => File.new(original_file).mtime.db,
        :updated_on => File.new(original_file).ctime.db,
        :extension => SETTING['image_server']['extension'], 
        :path => SETTING['image_server']['path'] + "/party/#{r['eid']}/#{r['ev2id']}/",
        :url => SETTING['image_server']['base_url'] + "/party/#{r['eid']}/#{r['ev2id']}",
        :server => SETTING['image_server']['host'],
        :user_id => get_photographer_by_event(r['ev2id']),
        :file => original_file
      }
      img_res = add_image_to_db(img)
      #insert into image_set table
      stmt = "INSERT INTO image_sets (id, obj_type, obj_id, image_id, position, comments_allowed, created_on, updated_on)
                              VALUES (#{r['id']}, 'Event', #{r['ev2id']}, #{r['id']}, #{r['rank']}, 1, now(), now() )"
      addToNewDb stmt
    rescue Exception => err
      puts "#{err}: " + " bad image (#{r.inspect})"
    end
  end
end

# def add_watermarks(orig,dest)
#   #watermark file
#   image = Magick::ImageList.new(orig)
#   image.composite!(MAGICK_MARK, Magick::NorthEastGravity, 10, 10, Magick::OverCompositeOp)
#   image.write(dest)
# end

def move_faves
  #clear faves tables
  addToNewDb "truncate faves"
  with_db(DB[:source]) do |db|
    res = db.query("select o,oid,uid,created from tracker")
    res.each do |r|
      insert_values = []
      atp_columns = []
      #add user id
      atp_columns << "user_id"
      insert_values << r[2]
      #add created
      atp_columns << "created_on"
      insert_values << r[3]
      #add obj_type
      atp_columns << "obj_type"
      insert_values << TRACKER_TYPES[r[0]]
      #add obj_id
      atp_columns << "obj_id"
      insert_values << r[1]
      #insert into faves table
      stmt = "INSERT INTO faves (#{atp_columns.join(", ")}) VALUES ('#{insert_values.join("','")}')"
      addToNewDb stmt
    end   
  end
end

def move_comments
  #clear comments tables
  addToNewDb "truncate comments"
  with_db(DB[:source]) do |db|
    res = db.query("select pic_id,body,uid,created from picture_comments")
    res.each do |r|
      insert_values = []
      atp_columns = []
      #add user id
      atp_columns << "user_id"
      insert_values << r[2]
      #add created
      atp_columns << "created_at"
      insert_values << r[3]
      #add commentable_type
      atp_columns << "commentable_type"
      insert_values << "ImageSet"
      #add commentable_id
      atp_columns << "commentable_id"
      insert_values << r[0]
      #add comment
      atp_columns << "comment"
      insert_values << r[1].strip_slashes.escape_quotes
      
      stmt = "INSERT INTO comments (#{atp_columns.join(", ")}) VALUES ('#{insert_values.join("','")}')"
      addToNewDb stmt
    end   
  end  
end

def move_flyers
  #clear flyers table
  addToNewDb "truncate flyers"
  #FIXME: delete all images
  addToNewDb "delete from images where caption = 'special_flyers'"
  #create created_on and updated_on
  time4db = Time.now.db
  #Go to flyer dir and get all files
  all_imgs = []
  event_ids = []
  party_ids = []
  Dir.chdir(FLYER_PATH) do
    #find only images
    all_imgs = Dir.glob("*.jpg").collect{|f| f.gsub(/.jpg/, "") }
  end
  #separate party flyers from event flyers
  event_imgs, party_imgs = all_imgs.partition{|f| f =~ /flyer_e/ } 
  #insert each party flyer into db
  party_ids = party_imgs.collect{ |f| f.gsub(/flyer_/,'').to_i }.uniq!
  
  party_ids.each do |party_id|
    begin
      filename = generate_challenge(6)
      original_file = FLYER_PATH + "flyer_#{party_id}" + SETTING['image_server']['extension']
      img = {
        :type => "Flyer",
        :caption => 'special_flyers',
        :id => nil, 
        :name => filename, 
        :comments_allowed => 0,
        :created_on => File.new(original_file).mtime.db,
        :updated_on => File.new(original_file).ctime.db,
        :extension => SETTING['image_server']['extension'], 
        :path => SETTING['image_server']['path'] + "/flyer/",
        :url => SETTING['image_server']['base_url'] + "/flyer/",
        :server => SETTING['image_server']['host'],
        :user_id => get_photographer_by_party(party_id),
        :file => original_file
      }
      new_img_id = add_image_to_db(img)
      #process flyer w/ RMagick
      stmt = "INSERT INTO flyers (obj_id,obj_type,image_id,days_left,active,created_on) VALUES (#{party_id},'Party',#{new_img_id}, 0, 0, '#{time4db}')"
      addToNewDb stmt
      puts "P#{party_id}"
    rescue Exception => err
      puts "#{err}: " + " bad image (#{party_id})"
    end
  end
  
  #insert each event flyer into db
  event_ids = event_imgs.collect{ |f| f.gsub(/flyer_e/,'').to_i }.uniq!
  
  event_ids.each do |event_id|
    begin
      filename = generate_challenge(6)
      img = {
        :type => "Flyer",
        :caption => 'special_flyers',
        :id => nil, 
        :name => filename, 
        :comments_allowed => 0,
        :created_on => time4db,
        :updated_on => time4db,
        :extension => SETTING['image_server']['extension'], 
        :path => SETTING['image_server']['path'] + "/flyer/",
        :url => SETTING['image_server']['base_url'] + "/flyer/",
        :server => SETTING['image_server']['host'],
        :user_id => get_photographer_by_event(event_id),
        :file => FLYER_PATH + "flyer_e#{event_id}" + SETTING['image_server']['extension']
      }
      new_img_id = add_image_to_db(img)
      #process flyer w/ RMagick
      stmt = "INSERT INTO flyers (obj_id,obj_type,image_id,days_left,active,created_on) VALUES (#{event_id},'Event',#{new_img_id}, 0, 0, '#{time4db}')"
      addToNewDb stmt
      puts "E#{event_id}"
    rescue Exception => err
      puts "#{err}: " + " bad image (#{event_id})"
    end
  end
end

def clean_up_gallery_imgs
  ids =[]
  ids = (1..4000).to_a
  # with_db({:database => 'alltheparties'}) do |db|
  #   res = db.query("select id from ev")
  #   res.each { |r| ids << r[0] }
  # end
  Dir.chdir(GALLERY_PATH) do
    #go to party
    ids.each do |id|
      begin
        Dir.chdir(id.to_s) do
          imgs = Dir.glob("*.jpg")
          puts "#{Dir.pwd} has #{imgs.length} imgs.\n\n" if imgs.length > 0
          Dir.glob("*.jpg").each do |file|
            File.delete(file)
          end
        end
      rescue Exception => err
        #puts 'ERROR: ' + err
      end
    end
  end
end

def backup_db(db)
  stmt = "mysqldump -h #{db[:host]} -u #{db[:username]} #{db[:database]} > #{ROOT}/#{db[:database]}.sql"
  puts stmt
  system stmt
end

def restore_db
  system "mysql -u sadmin -p pass21 Customers < #{ROOT}/#{db[:dest][:database]}.sql"
end

