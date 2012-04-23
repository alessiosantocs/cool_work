CITY_ZIPS = {
 :nyc => { :zips => %w{00501 00544 06390 06601 06602 06604 06605 06606 06607 06608 06610 06611 06612 06614 06615 06673 06699 06784 06801 06804 06807 06810 06811 06812 06813 06814 06816 
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
 :hou => { :zips => %w{77001 77002 77003 77004 77005 77006 77007 77008 77009 77010 77011 77012 77013 77014 77015 77016 77017 77018 77019 77020 77021 77022 77023 77024 77025 77026 77027 
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
   77587 77588 77590 77591 77592 77597 77598 77617 77622 77623 77650 77656 77661 77665 77873 78701 78727 } },
 :mia => { :zips => %w{33002 33009 33010 33011 33012 33013 33014 33015 33016 33017 33018 33030 33031 33032 33033 33034 33035 33039 33054 33055 33056 33090 33092 33101 33102 33107 33109 33110 
   33111 33112 33114 33116 33119 33121 33122 33124 33125 33126 33127 33128 33129 33130 33131 33132 33133 33134 33135 33136 33137 33138 33139 33140 33141 33142 33143 33144 33145 33146 33147 33148 
   33149 33150 33151 33152 33153 33154 33155 33156 33157 33158 33159 33160 33161 33162 33163 33164 33165 33166 33167 33168 33169 33170 33172 33173 33174 33175 33176 33177 33178 33179 33180 33181 
   33182 33183 33184 33185 33186 33187 33189 33190 33193 33194 33195 33196 33197 33199 33231 33233 33234 33238 33239 33242 33243 33245 33247 33255 33256 33257 33261 33265 33266 33269 33280 33283 
   33296 33299 33314 34141 } },
 :atl => { :zips => %w{ 30906 30108 30109 30110 30112 30116 30117 30118 30119 30135 30150 30170 30179 30180 30182 30185 30187 30004 30040 30066 30075 30114 30115 30142 30143 30146 30151 30169 30183 30184 30188 30189 30534 30215
   30228 30236 30237 30238 30250 30260 30273 30274 30281 30287 30288 30294 30296 30297 30298 30337 30349 30354 30006 30007 30008 30060 30061 30062 30064 30065 30066 30067 30068 30069 30075 30080 30081 
   30082 30090 30101 30102 30106 30111 30126 30127 30141 30144 30152 30156 30157 30160 30168 30188 30339 30220 30229 30230 30259 30263 30264 30265 30268 30271 30275 30276 30277 30289 30002 30012 30021
   30030 30031 30032 30033 30034 30035 30036 30037 30038 30039 30058 30072 30074 30079 30083 30084 30085 30086 30087 30088 30094 30306 30307 30315 30316 30317 30319 30333 30338 30340 30341 30345 30346 30350 30356 30359 30360 30362 30366 31119 31120 31141 31145 31146
   39901 30106 30122 30127 30133 30134 30135 30154 30168 30180 30185 30187 30052 30205 30213 30214 30215 30238 30269 30276 30296 30004 30005 30024 30028 30040 30041 30097 30107 30506 30534 30004 30005 30009 30022 30023 30024 30075 30076 30077 30092 30097 30098 30213
   30268 30272 30291 30296 30301 30302 30303 30304 30305 30306 30307 30308 30309 30310 30311 30312 30313 30314 30315 30316 30317 30318 30319 30320 30321 30324 30325 30326 30327 30328 30329 30330 30331 30332 30334 30336 30337 30338 30339 30342 30343 30344 30347 30348
   30349 30350 30353 30354 30355 30357 30358 30361 30363 30364 30368 30369 30370 30371 30374 30375 30376 30377 30378 30379 30380 30384 30385 30386 30387 30388 30389 30390 30392 30394 30396 30398 30399 31106 31107 31126 31131 31136 31139 31150 31156 31191 31192 31193
   30003 30010 30011 30012 30017 30019 30024 30026 30029 30039 30042 30043 30044 30045 30046 30047 30048 30049 30052 30058 30071 30078 30084 30087 30091 30092 30093 30095 30096 30097 30099 30340 30360 30515 30517 30518 30519 30548 30620 30904 } },
 :las => { :zips => %w{88901 88905 89004 89005 89006 89007 89009 89011 89012 89014 89015 89016 89018 89019 89021 89024 89025 89027 89028 89029 89030 89031 89032 89033 89036 89039 89040 
   89044 89046 89052 89053 89070 89074 89077 89081 89084 89085 89086 89101 89102 89103 89104 89105 89106 89107 89108 89109 89110 89111 89112 89113 89114 89115 89116 89117 89118 89119 89120 89121 
   89122 89123 89124 89125 89126 89127 89128 89129 89130 89131 89132 89133 89134 89135 89136 89137 89138 89139 89140 89141 89142 89143 89144 89145 89146 89147 89148 89149 89150 89151 89152 89153 
   89154 89155 89156 89157 89159 89160 89162 89163 89164 89165 89166 89170 89173 89177 89178 89179 89180 89185 89191 89193 89199 } },
 :nwo => { :zips => %w{ 70130 70346 } },
 :pit => { :zips => %w{ 15222 } },
 :aus => { :zips => %w{ 78639 73301 73344 78708 78709 78711 78713 78714 78715 78716 78718 78720 78755 78760 78761 78762 78763 78764 78765 78766 78767 78768 78769 78772 78773 78774 78778 78779 78780 
   78781 78783 78785 78789 78799 78701 78712 78702 78705 78703 78704 78722 78741 78751 78721 78756 78723 78746 78752 78742 78745 78731 78757 78710 78744 78735 78724 78725 78749 78758 78748 
   78730 78753 78754 78759 78733 78719 78747 78739 78750 78727 78652 78736 78732 78617 78726 78728 78729 78651 78653 78691 78737 78610 78660 78734 78738 78717 78630 78613 78683 78680 78681 
   78664 78682 78645 78612 78665 78640 78641 78619 78646 78634 78621 78620 78669 78627 78615 78656 78628 78644 78602 78676 78662 78616 78626 78667 78674 } },
 :phx => { :zips => %w{ 85016 85251 85004 } },
 :phl => { :zips => %w{ 19103 19106 19104 } },
 :den => { :zips => %w{ 80238 80203 80111 80202 80205 80216 80207 } },
 #:gso => { :zips => %w{ 27401 27402 27403 27404 27405 27406 27407 27408 27409 27410 27411 27412 27413 27415 27416 27417 27419 27420 27425 27427 27429 27435 27438 27455 27495 27497 27498 27499 } },
 :san => { :zips => %w{ 92054 92049 92051 92052 92058 92055 92018 92008 92068 92057 92056 92085 92083 92084 92009 92013 92003 92024 92069 92079 92096 92023 92007 92078 92088 92026 92028 92075 92067 92029 92091 92030 92033 92046 92014 92025 92127 92130 92027 92059 92082 92590 92674 92672 92129 92128 92121 92673 92589 92593 92126 92061 92064 92624 92038 92039 92074 92092 92131 92122 92564 92037 92592 92562 92093 92591 92675 92693 92629 92117 92563 92595 92109 92111 92694 92677 92124 92123 92060 92145 92110 92065 92108 92531 92107 92071 92530 92690 92120 92692 92679 92651 92584 92691 92688 92116 92103 92656 92072 92609 92106 92607 92652 92654 92637 92119 92532 92653 92140 92587 92678 92104 92133 92147 92040 92115 91942 92596 92101 92105 92134 92112 92137 92138 92142 92143 92149 92150 92158 92159 92160 92161 92162 92163 92164 92165 92166 92167 92168 92169 92170 92171 92172 92174 92175 92176 92177 92179 92184 92186 92187 92190 92191 92192 92193 92194 92195 92196 92197 92198 92199 92132 92630 92020 92152 91943 91944 92135 92586 92102 92022 92090 91941 92136 92536 92155 92021 91946 92178 92118 91945 92113 92070 92610 91976 91979 92618 92114 92709 92585 92019 92657 91951 91977 92086 91950 92883 92650 92625 91978 92548 92570 92603 92139 91947 92676 92612 92572 92599 92662 92661 92604 92545 92616 92619 92623 92697 92698 92182 91902 91909 91912 92660 91908 92620 91910 92614 92606 91903 92543 92602 92658 92659 92544 92571 91921 92663 92546 91914 92628 91913 92627 92552 92782 91911 91901 92567 91933 92881 91932 92877 92781 92626 91935 91915 92780 92582 92153 92707 92539 92581 92705 92154 92583 92066 92725 92701 92735 92646 92702 92711 92712 92799 92508 92882 91916 92704 92518 92878 92869 92879 92551 92173 92710 92615 92728 92703 92866 92708 92706 92648 92856 92857 92859 92863 92864 92503 92036 92861 92867 } },
 :dca => { :zips => %w{ 21201 20001 20002 20003 20004 20005 20006 20007 20008 20009 20010 20011 20012 20013 20015 20016 20017 20018 20019 20020 20022 20023 20024 20026 20027 20029 20030 20032 20033 20035 20036 20037 20038 20039 20040 20041 20042 20043 20044 20045 20046 20047 20049 20050 20051 20052 20053 20055 20056 20057 20058 20059 20060 20061 20062 20063 20064 20065 20066 20067 20068 20069 20070 20071 20073 20074 20075 20076 20077 20078 20080 20081 20082 20088 20090 20091 20097 20098 20201 20202 20203 20204 20206 20207 20208 20210 20211 20212 20213 20214 20215 20216 20217 20218 20219 20220 20221 20222 20223 20224 20226 20227 20228 20229 20230 20232 20233 20235 20237 20238 20239 20240 20241 20242 20244 20245 20250 20251 20254 20260 20261 20262 20265 20266 20268 20270 20277 20289 2029 2029 202 20303 20306 20307 20310 20314 20317 20318 20319 20330 20340 20350 20355 20370 20372 20373 20374 20375 20376 20380 20388 20389 20390 20391 20392 20393 20394 20394 20398 20401 20402 20402 20404 20405 20405 20407 20408 20409 20410 20410 20412 20412 20414 20414 20416 20418 20418 20420 20421 20422 20423 20424 20425 20426 20427 20427 20429 20431 20433 20433 20433 20436 20437 20439 20440 20441 20442 20442 20447 20451 20453 20456 20460 20463 20463 20469 20469 20472 20500 20501 20502 20503 20504 20504 20506 20507 20508 20509 20510 20510 20515 20520 20520 20522 20523 20524 20525 20525 20527 20528 20529 20530 20531 20532 20533 20533 20535 20535 20537 20538 20539 20540 20541 20541 20543 20544 20546 20547 20548 20549 20549 20549 20549 20554 20555 20555 20558 20558 20560 20560 20560 20570 20571 20572 20572 20575 20576 20576 20578 20579 20579 20579 20585 20586 20590 20591 20593 20594 20594 20599 56901 56915 56920 56933 56944 56944 20607 20608 20613 20623 20697 20703 20704 20704 20706 20707 20708 20709 20709 20712 20715 20716 20717 20718 20719 20720 20721 20722 20725 20726 20731 20731 20737 20738 20740 20740 20742 20742 20744 20745 20746 20747 20748 20749 20750 20752 20752 20757 20757 20768 20769 20769 20771 20772 20773 20774 20775 20781 20782 20783 20784 20785 20787 20788 20790 20791 20792 20797 20799 20913 20913 20811 20812 20812 20814 20815 20816 20817 20817 20824 20825 20827 20830 20830 20833 20837 20838 20839 20841 20842 20847 20848 20849 20850 20851 20852 20853 20854 20855 20857 20859 20860 20860 20862 20866 20868 20868 20872 20874 20875 20876 20876 20878 20879 20880 20882 20883 20884 20884 20886 20889 20891 20891 20894 20895 20896 20897 20898 20899 20901 20902 20903 20904 20905 20906 20907 20908 20908 20908 20908 20914 20914 20916 20918 20918 20918 22201 22202 22203 22204 22205 22206 22207 22209 22209 22211 22212 22213 22214 22215 22215 22217 22217 22219 22219 22223 22225 22225 22225 22225 22225 22225 22240 22241 22242 22243 22243 22245 22245 22301 22301 22304 22305 22311 22313 22313 22313 22331 22331 22331 22334 22336 20120 20121 20121 20124 20151 20153 20170 20170 20172 20190 20191 20192 20193 20194 20195 20196 20196 22009 22009 22009 22009 22031 22032 22033 22033 22035 22036 22037 22039 22039 22042 22043 22044 22044 22060 22060 22067 22067 22081 22082 22082 22082 22096 22096 22102 22103 22103 22107 22108 22109 22116 22118 22119 22119 22121 22122 22122 22150 22151 22152 22152 22152 22158 22159 22160 22160 22160 22181 22181 22181 22184 22184 22184 22303 22306 22306 22308 22309 22310 22312 22315 22321 22038 } },
 :lax => { :zips => %w{ 93203 93205 93206 93215 93216 93220 93222 93224 93225 93226 93238 93240 93241 93243 93249 93250 93251 93252 93255 93263 93268 93276 93280 93283 93285 93287 93301 93302 93303 93304 93305 93306 93307 93308 93309 93311 93312 93313 93314 93380 93381 93382 93383 93384 93385 93386 93387 93388 93389 93390 93501 93502 93504 93505 93516 93518 93519 93523 93524 93527 93528 93531 93536 93554 93555 93556 93558 93560 93561 93581 93596 90001 90002 90003 90004 90005 90006 90007 90008 90009 90010 90011 90012 90013 90014 90015 90016 90017 90018 90019 90020 90021 90022 90023 90024 90025 90026 90027 90028 90029 90030 90031 90032 90033 90034 90035 90036 90037 90038 90039 90040 90041 90042 90043 90044 90045 90046 90047 90048 90049 90050 90051 90052 90053 90054 90055 90056 90057 90058 90059 90060 90061 90062 90063 90064 90065 90066 90067 90068 90069 90070 90071 90072 90073 90074 90075 90076 90077 90078 90079 90080 90081 90082 90083 90084 90086 90087 90088 90089 90091 90093 90094 90095 90096 90099 90101 90102 90103 90189 90201 90202 90209 90210 90211 90212 90213 90220 90221 90222 90223 90224 90230 90231 90232 90233 90239 90240 90241 90242 90245 90247 90248 90249 90250 90251 90254 90255 90260 90261 90262 90263 90264 90265 90266 90267 90270 90272 90274 90275 90277 90278 90280 90290 90291 90292 90293 90294 90295 90296 90301 90302 90303 90304 90305 90306 90307 90308 90309 90310 90311 90312 90313 90397 90398 90401 90402 90403 90404 90405 90406 90407 90408 90409 90410 90411 90501 90502 90503 90504 90505 90506 90507 90508 90509 90510 90601 90602 90603 90604 90605 90606 90607 90608 90609 90610 90612 90623 90630 90631 90637 90638 90639 90640 90650 90651 90652 90659 90660 90661 90662 90670 90671 90701 90702 90703 90704 90706 90707 90710 90711 90712 90713 90714 90715 90716 90717 90723 90731 90732 90733 90734 90744 90745 90746 90747 90748 90749 90755 90801 90802 90803 90804 90805 90806 90807 90808 90809 90810 90813 90814 90815 90822 90831 90832 90833 90834 90835 90840 90842 90844 90845 90846 90847 90848 90853 90888 90895 90899 91001 91003 91006 91007 91008 91009 91010 91011 91012 91016 91017 91020 91021 91023 91024 91025 91030 91031 91040 91041 91042 91043 91046 91066 91077 91101 91102 91103 91104 91105 91106 91107 91108 91109 91110 91114 91115 91116 91117 91118 91121 91123 91124 91125 91126 91129 91131 91182 91184 91185 91188 91189 91191 91199 91201 91202 91203 91204 91205 91206 91207 91208 91209 91210 91214 91221 91222 91224 91225 91226 91301 91302 91303 91304 91305 91306 91307 91308 91309 91310 91311 91313 91316 91321 91322 91324 91325 91326 91327 91328 91329 91330 91331 91333 91334 91335 91337 91340 91341 91342 91343 91344 91345 91346 91350 91351 91352 91353 91354 91355 91356 91357 91361 91362 91363 91364 91365 91367 91371 91372 91376 91380 91381 91382 91383 91384 91385 91386 91387 91388 91390 91392 91393 91394 91395 91396 91399 91401 91402 91403 91404 91405 91406 91407 91408 91409 91410 91411 91412 91413 91416 91423 91426 91436 91470 91482 91495 91496 91497 91499 91501 91502 91503 91504 91505 91506 91507 91510 91521 91522 91523 91526 91601 91602 91603 91604 91605 91606 91607 91608 91609 91610 91611 91612 91614 91615 91616 91617 91618 91702 91706 91709 91711 91714 91715 91716 91722 91723 91724 91731 91732 91733 91734 91735 91740 91741 91744 91745 91746 91747 91748 91749 91750 91754 91755 91756 91759 91765 91766 91767 91768 91769 91770 91771 91772 91773 91775 91776 91778 91780 91788 91789 91790 91791 91792 91793 91795 91797 91799 91801 91802 91803 91804 91841 91896 91899 93243 93510 93532 93534 93535 93536 93539 93543 93544 93550 93551 93552 93553 93560 93563 93584 93586 93590 93591 93599 90620 90621 90622 90623 90624 90630 90631 90632 90633 90638 90680 90720 90721 90740 90742 90743 92602 92603 92604 92605 92606 92607 92609 92610 92612 92614 92615 92616 92617 92618 92619 92620 92623 92624 92625 92626 92627 92628 92629 92630 92637 92646 92647 92648 92649 92650 92651 92652 92653 92654 92655 92656 92657 92658 92659 92660 92661 92662 92663 92672 92673 92674 92675 92676 92677 92678 92679 92683 92684 92685 92688 92690 92691 92692 92693 92694 92697 92698 92701 92702 92703 92704 92705 92706 92707 92708 92709 92710 92711 92712 92725 92728 92735 92780 92781 92782 92799 92801 92802 92803 92804 92805 92806 92807 92808 92809 92811 92812 92814 92815 92816 92817 92821 92822 92823 92825 92831 92832 92833 92834 92835 92836 92837 92838 92840 92841 92842 92843 92844 92845 92846 92850 92856 92857 92859 92861 92862 92863 92864 92865 92866 92867 92868 92869 92870 92871 92885 92886 92887 92899 91701 91708 91709 91710 91729 91730 91737 91739 91743 91758 91761 91762 91763 91764 91766 91784 91785 91786 91792 91798 92242 92252 92256 92267 92268 92277 92278 92280 92284 92285 92286 92301 92304 92305 92307 92308 92309 92310 92311 92312 92313 92314 92315 92316 92317 92318 92321 92322 92323 92324 92325 92326 92327 92329 92331 92332 92333 92334 92335 92336 92337 92338 92339 92340 92341 92342 92344 92345 92346 92347 92350 92352 92354 92356 92357 92358 92359 92363 92364 92365 92366 92368 92369 92371 92372 92373 92374 92375 92376 92377 92378 92382 92385 92386 92391 92392 92393 92394 92395 92397 92398 92399 92401 92402 92403 92404 92405 92406 92407 92408 92410 92411 92412 92413 92414 92415 92418 92423 92424 92427 92880 93516 93555 93558 93562 93592 90265 91304 91307 91311 91319 91320 91358 91359 91360 91361 91362 91377 93001 93002 93003 93004 93005 93006 93007 93009 93010 93011 93012 93013 93015 93016 93020 93021 93022 93023 93024 93030 93031 93032 93033 93034 93035 93036 93040 93041 93042 93043 93044 93060 93061 93062 93063 93064 93065 93066 93093 93094 93099 93252 } },
 :chi => { :zips => %w{ 46303 46307 46308 46311 46312 46319 46320 46321 46322 46323 46324 46325 46327 46341 46342 46355 46356 46368 46373 46375 46376 46377 46382 46385 46394 46401 46402 46403 46404 46405 46406 46407 46408 46409 46410 46411 60001 60002 60004 60005 60006 60007 60008 60009 60010 60011 60012 60013 60014 60015 60016 60017 60018 60020 60021 60022 60025 60026 60029 60030 60031 60033 60034 60035 60037 60038 60039 60040 60041 60042 60043 60044 60045 60046 60047 60048 60049 60050 60051 60053 60056 60060 60061 60062 60064 60065 60067 60068 60069 60070 60071 60072 60073 60074 60075 60076 60077 60078 60079 60081 60082 60083 60084 60085 60086 60087 60088 60089 60090 60091 60092 60093 60094 60095 60096 60097 60098 60099 60101 60102 60103 60104 60106 60107 60108 60109 60110 60116 60117 60118 60119 60120 60121 60122 60123 60124 60125 60126 60128 60130 60131 60132 60133 60134 60135 60136 60137 60138 60139 60140 60141 60142 60143 60144 60147 60148 60151 60152 60153 60154 60155 60156 60157 60159 60160 60161 60162 60163 60164 60165 60168 60169 60170 60171 60172 60173 60174 60175 60176 60177 60178 60179 60180 60181 60183 60184 60185 60186 60187 60188 60189 60190 60191 60192 60193 60194 60195 60196 60197 60199 60201 60202 60203 60204 60208 60209 60301 60302 60303 60304 60305 60399 60401 60402 60403 60404 60406 60407 60408 60409 60410 60411 60412 60415 60416 60417 60419 60421 60422 60423 60425 60426 60428 60429 60430 60431 60432 60433 60434 60435 60436 60438 60439 60440 60441 60442 60443 60445 60446 60447 60448 60449 60451 60452 60453 60454 60455 60456 60457 60458 60459 60461 60462 60463 60464 60465 60466 60467 60468 60469 60471 60472 60473 60475 60476 60477 60478 60480 60481 60482 60487 60490 60491 60499 60501 60502 60503 60504 60505 60506 60507 60510 60511 60513 60514 60515 60516 60517 60519 60521 60522 60523 60525 60526 60527 60532 60534 60538 60539 60540 60542 60543 60544 60546 60554 60555 60558 60559 60561 60563 60564 60565 60566 60567 60568 60570 60572 60585 60586 60597 60598 60599 60601 60602 60603 60604 60605 60606 60607 60608 60609 60610 60611 60612 60613 60614 60615 60616 60617 60618 60619 60620 60621 60622 60623 60624 60625 60626 60628 60629 60630 60631 60632 60633 60634 60636 60637 60638 60639 60640 60641 60643 60644 60645 60646 60647 60649 60651 60652 60653 60654 60655 60656 60657 60659 60660 60661 60663 60664 60666 60668 60670 60673 60674 60675 60677 60678 60679 60680 60681 60682 60684 60685 60686 60687 60688 60689 60690 60691 60693 60694 60695 60696 60697 60699 60701 60706 60707 60712 60714 60803 60804 60805 60827 60935 60940 60950 61012 61038 } },
 :dal => { :zips => %w{ 75002 75009 75013 75023 75024 75025 75026 75023 75024 75025 75026 75034 75035 75044 75048 75069 75070 75071 75074 75075 75078 75080 75082 75086 75087 75093 75094 75097 75098 75115 75121 75164 75166 75173 75189 75248 75252 75407 75409 75424 75442 75452 75454 75485 75495 75001 75006 75007 75011 75014 75015 75016 75017 75019 75028 75030 75038 75039 75040 75041 75042 75043 75044 75045 75046 75047 75048 75049 75040 75041 75042 75043 75044 75045 75046 75047 75048 75049 75050 75051 75052 75053 75054 75060 75061 75062 75063 75067 75080 75081 75082 75083 75085 75088 75089 75098 75099 75104 75106 75115 75116 75123 75125 75134 75137 75138 75141 75146 75148 75149 75150 75154 75159 75172 75180 75181 75182 75185 75187 75201 75202 75203 75204 75205 75206 75207 75208 75209 75210 75211 75212 75214 75215 75216 75217 75218 75219 75220 75221 75222 75223 75224 75225 75226 75227 75228 75229 75230 75231 75232 75233 75234 75235 75236 75237 75238 75240 75241 75242 75243 75244 75245 75246 75247 75248 75249 75250 75251 75252 75253 75254 75260 75261 75262 75263 75264 75265 75266 75267 75270 75275 75277 75283 75284 75285 75286 75287 75301 75303 75310 75312 75313 75315 75320 75323 75326 75334 75336 75339 75340 75342 75343 75344 75353 75354 75355 75356 75357 75359 75360 75363 75364 75367 75368 75370 75371 75372 75373 75374 75376 75378 75379 75380 75381 75382 75386 75387 75388 75389 75390 75391 75392 75393 75394 75395 75396 75397 75398 76051 76065 75007 75009 75010 75019 75022 75024 75027 75028 75029 75034 75056 75057 75065 75067 75068 75077 75078 75093 76052 76078 76092 76177 76201 76202 76203 76204 76205 76206 76207 76208 76209 76210 76226 76227 76234 76247 76249 76258 76259 76262 76266 76272 76299 } },
 :nwe => { :zips => %w{ 06001	06002	06006	06010	06011	06013	06016	06019	06020	06022	06023	06025	06026	06027	06028	06030	06032	06033	06034	06035	06037	06040	06041	06042	06043	06045	06050	06051	
   06052 06053 06059 06060 06062 06064 06067 06070 06073 06074 06078 06080 06081 06082 06083 06084 06085 06087 06088 06089 06090 06091 06092 06093 06095 06096 06101 06102 06103 06104 06105
   06106 06107 06108 06109 06110 06111 06112 06114 06115 06117 06118 06119 06120 06123 06126 06127 06128 06129 06131 06132 06133 06134 06137 06138 06140 06141 06142 06143 06144 06145 06146
   06147 06150 06151 06152 06153 06154 06155 06156 06160 06161 06167 06176 06180 06183 06199 06444 06447 06467 06479 06489 02802 02814 02815 02823 02824 02825 02826 02828 02829 02830 02831
   02838 02839 02857 02858 02859 02861 02862 02863 02864 02865 02876 02895 02896 02901 02902 02903 02904 02905 02906 02907 02908 02909 02910 02911 02912 02914 02915 02916 02917 02918 02919
   02920 02921 02940 02108 02109 02110 02111 02112 02113 02114 02115 02116 02117 02118 02119 02120 02121 02122 02123 02124 02125 02126 02127 02128 02129 02130 02131 02132 02133 02134 02135
   02136 02137 02150 02151 02152 02163 02196 02199 02201 02203 02205 02206 02207 02210 02211 02215 02216 02217 02222 02228 02241 02266 02283 02284 02293 02295 02297 02298 02467 01001 01008
   01009 01010 01011 01013 01014 01020 01021 01022 01028 01030 01034 01036 01040 01041 01056 01057 01069 01071 01075 01077 01079 01080 01081 01085 01086 01089 01090 01095 01097 01101 01102
   01103 01104 01105 01106 01107 01108 01109 01111 01115 01116 01118 01119 01128 01129 01133 01138 01139 01144 01151 01152 01199 01223 01521 }
 }
}

module CityByZip
  def get_city_name(zip='00000')
    zip = zip.to_s.rjust(5,'0')
    CITY_ZIPS.each{|key,val| return key if val[:zips].include?(zip) }
    return 0
  end
end

# include CityByZip
# p get_city_name(80216) # :den
