var days = new Array('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday');
var months = new Array('January','February','March','April','May','June','July','August','September','October','November','December');

//Constructor
function calendar(id, startDate, weekStart, heat){
	this.id = id;
	this.weekStart = weekStart;
	this.heat = heat;
	this.dateObject = startDate;
	this.write = writeCalendar;
	this.length = getMonthLength;
	this.month = startDate.getMonth();
	this.date = startDate.getDate();
	this.day = startDate.getDay();
	this.year = startDate.getFullYear();
	this.getFormattedDate = getFormattedDate;
	//get the first day of the month's day
	startDate.setDate(1);
	this.firstDay = startDate.getDay();
	//then reset the date object to the correct date
	startDate.setDate(this.date);
}

function getFormattedDate(){
	month = this.month + 1;
	return this.year + '-' + month + '-' + this.date;
}

function writeCalendar(){
	var calString = '<div id="calContainer">';
	calString += '<table id="cal' + this.id + '" cellspacing="0" width="170">';
	//write month and year at top of table
	calString += '<tr><th colspan="7" class="month">' + months[this.month] + ', ' + this.year + '</th></tr>';
	//write a row containing days of the week
	calString += '<tr>';
	for(i=this.weekStart; i<days.length; i++){
		calString += '<th class="dayHeader">' + days[i].substring(0,1) + '</th>';
	}
	for(i=0; i<this.weekStart; i++){
		calString += '<th class="dayHeader">' + days[i].substring(0,1) + '</th>';
	}
	calString += '</tr>';
	
	//month		
	m = this.month+1
		
	//write the body of the calendar
	calString += '<tr>';
	//create 6 rows so that the calendar doesn't resize
	//offset for weekstart
	offset = 7-this.weekStart;
	for(j=7; j<42; j++){
		var displayNum = (j-this.firstDay+1-offset);
		if(j<this.firstDay+offset){
			//write the leading empty cells
			calString += '<td class="empty">&nbsp;</td>';
		}else if(displayNum==this.date){
			calString += '<td style="background-color:'+ this.heat[displayNum+'/'+m]+ '"id="' + this.id +'selected" class="date" onClick="javascript:changeDate(this,\'' + this.id + '\')">' + displayNum + '</td>';
		}else if(displayNum > this.length()){
			//Empty cells at bottom of calendar
			calString += '<td>&nbsp;</td>';
		}else{
			//the rest of the numbered cells
			calString += '<td style="background-color:'+ this.heat[displayNum+'/'+m]+ '" id="" class="days" onClick="javascript:changeDate(this,\'' + this.id + '\')">' + displayNum + '</td>';
		}
		if(j%7==6){
			calString += '</tr><tr>';
		}
	}
	//close the last number row
	calString += '</tr>';
	
	//write the nav row
	calString += '<tr>';
	calString += '<td class="nav" style="text-decoration:underline;" onClick="changeMonth(-12,\'' + this.id + '\')">&lt;</td>';
	calString += '<td class="nav" onClick="changeMonth(-1,\'' + this.id + '\')">&lt;</td>';
	calString += '<td class="nav" colspan="3" style="text-decoration:underline;" onClick="changeToToday(\'' + this.id + '\')" >Today</td>';
	calString += '<td class="nav" onClick="changeMonth(1,\'' + this.id + '\')">&gt;</td>';
	calString += '<td class="nav" style="text-decoration:underline;" onClick="changeMonth(12,\'' + this.id + '\')">&gt;</td>';
	calString += '</tr>';

	calString += '</table>';
	calString += '</div>';
	return calString;
}

function getMonthLength(){
	switch(this.month){
		case 1:
			if((this.dateObject.getFullYear()%4==0&&this.dateObject.getFullYear()%100!=0)||this.dateObject.getFullYear()%400==0)
				return 29; //leap year
			else
				return 28;
		case 3:
		case 5:
		case 8:
		case 10:
			return 30
		default:
			return 31;
	}
}

function changeDate(td,cal){
	cal = eval(cal);
	cal.dateObject.setDate(td.firstChild.nodeValue);
	cal = new calendar(cal.id, cal.dateObject, cal.weekStart);
	document.location = "?date=" + cal.getFormattedDate();
}

function changeMonth(month, cal){
	cal = eval(cal);
	cal.dateObject.setMonth(cal.dateObject.getMonth() + month);
	cal = new calendar(cal.id, cal.dateObject, cal.weekStart);
	cal.formattedDate = cal.getFormattedDate();
	document.location = "?date=" + cal.getFormattedDate();
//	document.getElementById('calContainer').innerHTML = cal.write();
}

function changeToToday(cal){
	cal = eval(cal);
	cal = new calendar(cal.id, new Date(), cal.weekStart);
	document.location = "?date=" + cal.getFormattedDate();
}