var COURSES=[
 {id:1,code:"CS301",name:"Database Management Systems",dept:"CSE",sem:5,n:110},
 {id:2,code:"CS302",name:"Operating Systems",dept:"CSE",sem:5,n:105},
 {id:3,code:"CS303",name:"Computer Networks",dept:"CSE",sem:5,n:108},
 {id:4,code:"EC301",name:"Digital Signal Processing",dept:"ECE",sem:5,n:90},
 {id:5,code:"EC302",name:"VLSI Design",dept:"ECE",sem:5,n:88},
 {id:6,code:"ME301",name:"Thermodynamics",dept:"MECH",sem:5,n:75},
 {id:7,code:"CS201",name:"Data Structures",dept:"CSE",sem:3,n:120},
 {id:8,code:"IT301",name:"Web Technologies",dept:"IT",sem:5,n:55},
 {id:9,code:"IT302",name:"Software Engineering",dept:"IT",sem:5,n:55},
 {id:10,code:"EE301",name:"Power Systems",dept:"EEE",sem:5,n:50},
 {id:11,code:"EE302",name:"Control Systems",dept:"EEE",sem:5,n:50},
 {id:12,code:"CS202",name:"Discrete Mathematics",dept:"CSE",sem:3,n:100},
 {id:13,code:"CS304",name:"Machine Learning",dept:"CSE",sem:5,n:105},
 {id:14,code:"ME302",name:"Fluid Mechanics",dept:"MECH",sem:5,n:75},
 {id:15,code:"EC202",name:"Analog Circuits",dept:"ECE",sem:3,n:65},
 {id:16,code:"ME201",name:"Engineering Mechanics",dept:"MECH",sem:3,n:70}
];
var ROOMS=[
 {id:1,name:"Room A101",bld:"Block A",fl:1,cap:120},
 {id:2,name:"Room A102",bld:"Block A",fl:1,cap:100},
 {id:3,name:"Room B201",bld:"Block B",fl:2,cap:80},
 {id:4,name:"Main Hall",bld:"Admin Block",fl:0,cap:200},
 {id:5,name:"Room B202",bld:"Block B",fl:2,cap:60},
 {id:6,name:"Room C101",bld:"Block C",fl:1,cap:90},
 {id:7,name:"Room C201",bld:"Block C",fl:2,cap:70},
 {id:8,name:"Seminar Hall",bld:"Admin Block",fl:1,cap:150}
];
var INVS=[{id:1,name:"Dr. Meena"},{id:2,name:"Prof. Arun"},{id:3,name:"Dr. Kavitha"},{id:4,name:"Prof. Rahul"},{id:5,name:"Dr. Suresh"},{id:6,name:"Dr. Lakshmi"},{id:7,name:"Prof. Venkat"},{id:8,name:"Dr. Anand"},{id:9,name:"Prof. Nisha"},{id:10,name:"Dr. Prakash"},{id:11,name:"Prof. Geetha"},{id:12,name:"Dr. Ramesh"}];
var STUDENTS=[
 {r:"RA2411003010001",name:"Anita",dept:"CSE",sem:5},
 {r:"RA2411003010002",name:"Bala",dept:"CSE",sem:5},
 {r:"RA2411003010003",name:"Charan",dept:"CSE",sem:5},
 {r:"RA2411003010004",name:"Divya",dept:"CSE",sem:5},
 {r:"RA2411003010005",name:"Ishaan",dept:"CSE",sem:5},
 {r:"RA2411003010006",name:"Janani",dept:"CSE",sem:5},
 {r:"RA2411003010007",name:"Karthik",dept:"CSE",sem:5},
 {r:"RA2411003010008",name:"Lakshmi",dept:"CSE",sem:5},
 {r:"RA2411003010009",name:"Manoj",dept:"CSE",sem:5},
 {r:"RA2411003010010",name:"Nithya",dept:"CSE",sem:5},
 {r:"RA2411004010001",name:"Eshwar",dept:"ECE",sem:5},
 {r:"RA2411004010002",name:"Farah",dept:"ECE",sem:5},
 {r:"RA2411004010003",name:"Omkar",dept:"ECE",sem:5},
 {r:"RA2411004010004",name:"Priya",dept:"ECE",sem:5},
 {r:"RA2411004010005",name:"Qadir",dept:"ECE",sem:5},
 {r:"RA2411004010006",name:"Revathi",dept:"ECE",sem:5},
 {r:"RA2411007010001",name:"Gokul",dept:"MECH",sem:5},
 {r:"RA2411007010002",name:"Surya",dept:"MECH",sem:5},
 {r:"RA2411007010003",name:"Tharun",dept:"MECH",sem:5},
 {r:"RA2411007010004",name:"Uma",dept:"MECH",sem:5},
 {r:"RA2411005010001",name:"Bharath",dept:"IT",sem:5},
 {r:"RA2411005010002",name:"Chitra",dept:"IT",sem:5},
 {r:"RA2411005010003",name:"Dinesh",dept:"IT",sem:5},
 {r:"RA2411005010004",name:"Elango",dept:"IT",sem:5},
 {r:"RA2411005010005",name:"Fathima",dept:"IT",sem:5},
 {r:"RA2411006010001",name:"Gayathri",dept:"EEE",sem:5},
 {r:"RA2411006010002",name:"Hari",dept:"EEE",sem:5},
 {r:"RA2411006010003",name:"Indu",dept:"EEE",sem:5},
 {r:"RA2411006010004",name:"Jeeva",dept:"EEE",sem:5},
 {r:"RA2511003010101",name:"Harini",dept:"CSE",sem:3},
 {r:"RA2511003010102",name:"Vijay",dept:"CSE",sem:3},
 {r:"RA2511003010103",name:"Yamini",dept:"CSE",sem:3},
 {r:"RA2511003010104",name:"Zaid",dept:"CSE",sem:3},
 {r:"RA2511003010105",name:"Aarthi",dept:"CSE",sem:3},
 {r:"RA2511004010001",name:"Kiran",dept:"ECE",sem:3},
 {r:"RA2511004010002",name:"Latha",dept:"ECE",sem:3},
 {r:"RA2511007010001",name:"Mohan",dept:"MECH",sem:3},
 {r:"RA2511007010002",name:"Nandhini",dept:"MECH",sem:3}
];
var DATES=["2026-11-23","2026-11-24","2026-11-25","2026-11-26","2026-11-27","2026-11-28"];
var SLOTS={1:"09:30–12:30",2:"14:00–17:00"};
var SEED=[
 {id:1,course:1,date:"2026-11-23",slot:1,room:1,inv:1},
 {id:2,course:4,date:"2026-11-23",slot:1,room:2,inv:2},
 {id:3,course:2,date:"2026-11-24",slot:1,room:1,inv:3},
 {id:4,course:6,date:"2026-11-24",slot:2,room:3,inv:4},
 {id:5,course:3,date:"2026-11-25",slot:2,room:4,inv:1},
 {id:6,course:7,date:"2026-11-26",slot:1,room:4,inv:5},
 {id:7,course:13,date:"2026-11-27",slot:1,room:1,inv:6},
 {id:8,course:8,date:"2026-11-23",slot:2,room:5,inv:7},
 {id:9,course:9,date:"2026-11-25",slot:1,room:5,inv:7},
 {id:10,course:10,date:"2026-11-23",slot:2,room:3,inv:8},
 {id:11,course:11,date:"2026-11-25",slot:1,room:3,inv:8},
 {id:12,course:12,date:"2026-11-24",slot:2,room:2,inv:9},
 {id:13,course:14,date:"2026-11-26",slot:2,room:6,inv:10},
 {id:14,course:15,date:"2026-11-27",slot:2,room:7,inv:11},
 {id:15,course:16,date:"2026-11-28",slot:1,room:8,inv:12}
];
var KEY="etms-exams-v3",exams;
try{var s=localStorage.getItem(KEY);exams=s?JSON.parse(s):null}catch(e){exams=null}
if(!exams)exams=SEED.slice();
function save(){try{localStorage.setItem(KEY,JSON.stringify(exams))}catch(e){}}
function by(a,id){return a.filter(function(x){return x.id==id})[0]}
function fmt(d){return new Date(d+"T00:00:00").toLocaleDateString("en-IN",{weekday:"short",day:"numeric",month:"short"})}
function $(id){return document.getElementById(id)}
function opt(a,l){return a.map(function(x){return '<option value="'+x.id+'">'+l(x)+'</option>'}).join("")}
function venue(r){return r.bld+(r.fl?", floor "+r.fl:", ground floor")+" · "+r.name}
function classOf(c){return STUDENTS.filter(function(s){return s.dept==c.dept&&s.sem==c.sem})}

$("course").innerHTML=opt(COURSES,function(c){return c.code+" · "+c.name+" ("+c.dept+" sem "+c.sem+")"});
$("room").innerHTML=opt(ROOMS,function(r){return r.name+" (seats "+r.cap+")"});
$("inv").innerHTML=opt(INVS,function(i){return i.name});
$("fdept").innerHTML='<option value="">All departments</option>'+["CSE","ECE","IT","EEE","MECH"].map(function(d){return '<option>'+d+'</option>'}).join("");
$("rolls").innerHTML=STUDENTS.map(function(s){return '<option value="'+s.r+'">'+s.name+'</option>'}).join("");
$("fdept").onchange=render;

function find(){
  var r=$("roll").value.trim().toUpperCase(),st=STUDENTS.filter(function(s){return s.r==r})[0],box=$("result");
  if(!st){box.innerHTML='<p style="color:var(--bad)">No student found with register number “'+r.replace(/</g,"")+'”. Try RA2411003010001, RA2411005010001 or RA2411007010001.</p>';return}
  var mine=exams.filter(function(e){var c=by(COURSES,e.course);return c.dept==st.dept&&c.sem==st.sem}).sort(function(a,b){return a.date<b.date?-1:a.date>b.date?1:a.slot-b.slot});
  var h='<h2 style="font-size:20px;margin-bottom:12px">'+st.name+' · '+st.dept+' semester '+st.sem+'</h2>';
  if(!mine.length)h+='<p>No exams are scheduled for you yet.</p>';
  mine.forEach(function(e){
    var c=by(COURSES,e.course),rm=by(ROOMS,e.room),seat=classOf(c).map(function(x){return x.r}).indexOf(st.r)+1;
    h+='<div class="card"><div><div class="when">'+fmt(e.date)+'</div>'+SLOTS[e.slot]+'<br>'+c.code+' · '+c.name+'</div><div><div class="where">'+rm.name+'</div>'+rm.bld+(rm.fl?', floor '+rm.fl:', ground floor')+'<br><span class="pill">Seat '+seat+'</span> &nbsp;Invigilator: '+by(INVS,e.inv).name+'</div></div>';
  });
  box.innerHTML=h;
}
$("go").onclick=find;
$("roll").onkeydown=function(e){if(e.key==="Enter")find()};

function check(n){
  var c=by(COURSES,n.course),r=by(ROOMS,n.room);
  if(exams.some(function(e){return e.course==n.course}))return c.code+" already has an exam scheduled. Delete it first to move it.";
  if(r.cap<c.n)return r.name+" seats "+r.cap+", but "+c.code+" has "+c.n+" students. Pick a larger room.";
  for(var i=0;i<exams.length;i++){
    var e=exams[i];
    if(e.date!=n.date||e.slot!=n.slot)continue;
    var o=by(COURSES,e.course);
    if(e.room==n.room)return r.name+" is already booked for "+o.code+" in that slot.";
    if(e.inv==n.inv)return by(INVS,n.inv).name+" is already invigilating "+o.code+" in that slot.";
    if(o.dept==c.dept&&o.sem==c.sem)return "Clash: "+o.code+" is in the same slot for "+c.dept+" semester "+c.sem+" students.";
  }
  return null;
}
function show(t,m){var el=$("msg");el.className=t;el.textContent=m}
$("f").onsubmit=function(ev){
  ev.preventDefault();
  var n={course:+$("course").value,date:$("date").value,slot:+$("slot").value,room:+$("room").value,inv:+$("inv").value},err=check(n);
  if(err){show("bad",err);return}
  n.id=Math.max.apply(null,[0].concat(exams.map(function(e){return e.id})))+1;
  exams.push(n);save();render();
  show("ok","Saved: "+by(COURSES,n.course).code+" on "+fmt(n.date)+", slot "+n.slot+", "+by(ROOMS,n.room).name+".");
};
function del(id){exams=exams.filter(function(e){return e.id!=id});save();render();if($("roll").value)find()}
function render(){
  var d=$("fdept").value,sorted=exams.slice().sort(function(a,b){return a.date<b.date?-1:a.date>b.date?1:a.slot-b.slot});
  var h='<div class="grid"><div class="cell head"></div>'+DATES.map(function(x){return '<div class="cell head">'+fmt(x)+'</div>'}).join("");
  [1,2].forEach(function(s){
    h+='<div class="cell slot">Slot '+s+'<br><span style="font-weight:400">'+SLOTS[s]+'</span></div>';
    DATES.forEach(function(x){
      var items=sorted.filter(function(e){return e.date==x&&e.slot==s&&(!d||by(COURSES,e.course).dept==d)});
      h+='<div class="cell">'+items.map(function(e){var c=by(COURSES,e.course),r=by(ROOMS,e.room);return '<div class="ex s'+s+'"><b>'+c.code+'</b>'+c.name+'<br>'+r.name+', '+r.bld+'</div>'}).join("")+'</div>';
    });
  });
  $("gridbox").innerHTML=h+'</div>';
  $("rows").innerHTML=sorted.length?sorted.map(function(e){var c=by(COURSES,e.course);return '<tr><td>'+fmt(e.date)+'</td><td>Slot '+e.slot+'</td><td>'+c.code+' · '+c.name+'</td><td>'+c.dept+' / '+c.sem+'</td><td>'+venue(by(ROOMS,e.room))+'</td><td>'+by(INVS,e.inv).name+'</td><td><button class="btn ghost sm" onclick="del('+e.id+')">Delete</button></td></tr>'}).join(""):'<tr><td colspan="7">No exams yet. Use Schedule exam to add one.</td></tr>';
}
document.querySelectorAll("nav button").forEach(function(b){
  b.onclick=function(){
    document.querySelectorAll("nav button").forEach(function(x){x.setAttribute("aria-selected",x==b)});
    ["find","grid","list","add","schema"].forEach(function(t){$(t).classList.toggle("hidden",t!=b.dataset.tab)});
  };
});
$("roll").value="RA2411003010001";find();render();
