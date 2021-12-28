Class dc.data.rcc.OEX Extends %Persistent
{

/// this class holds the known packages on OEX
/// 
Parameter DEFAULTGLOBAL = "^rcc.OEX";

/// visible pages on OEX
Parameter PAGES = 19;

Parameter MARKER = "<a _ngcontent-sc";

Parameter HSPLIT = "href=""/package/";

Property url As %String(MAXLEN = "");

Property label As %String(MAXLEN = "");

Property author As %String;

Property technology As %String(MAXLEN = "");

Property version As %String;

Property review As %String;

Property verified As %Integer;

Property comment As %String(MAXLEN = "");

Property zpmmodul As %String(MAXLEN = "");

Property month As %Integer;

Property stars As %Numeric(MAXVAL = 5, MINVAL = 0, SCALE = 1) [ Calculated, SqlComputeCode = {set {*}={stars10}/10}, SqlComputed ];

Property stars10 As %Integer;

Property IRIS As %Boolean [ Calculated, SqlComputeCode = { set {*}=($zcvt({technology},"U")["IRIS") }, SqlComputed ];

Property ZPM As %Boolean [ Calculated, SqlComputeCode = { set {*}=$S({zpmmodul}/1={zpmmodul}:{zpmmodul},1:{zpmmodul}]"") break   }, SqlComputed ];

Index url On url [ Unique ];

/// prepare https request
ClassMethod Req() As %Net.HttpRequest
{
	set req=##class(%Net.HttpRequest).%New()
		,req.SSLConfiguration="community"
		,req.Https=1
		,req.Port=443
		,req.Server="openexchange.intersystems.com"
	quit req
}

/// init & scan OEX directory 
ClassMethod Load(fresh = 1)
{
	if fresh do ..%KillExtent()	
	set req=..Req()
	for pg=1:1:..#PAGES {
		set url="/solutions/page/"_pg
			,sc=req.Get(url)
			,res=(req.HttpResponse.Data)
#;			,pr=0
		while 'res.AtEnd {
			set line=res.ReadLine()
			if line[..#MARKER {
				set proj=$LFS(line,..#HSPLIT)
				for m=2:1:$ll(proj) {
					set url="/package/"_$p($li(proj,m),"""")
					set label=$p($p($li(proj,m),"label"">",2),"</")
					write !,pg,?5,url," > ",label
					set obj=..urlOpen(url)
					if 'obj set obj=..%New()
					set obj.url=url
						,obj.label=label
						,sc=obj.%Save()
					if 'sc {
						do $system.OBJ.DisplayError(sc) b 
						}
				}
			}
			if line["</oex-root" quit
		}
	}
}

/// fill content from package details 
ClassMethod Fill(maxid = 0)
{
	set:'maxid maxid=@(..#DEFAULTGLOBAL_"D")  //  ^rcc.OEXD
	set req=..Req()
	for id=1:1:maxid {
		set obj=..%OpenId(id)
		if 'obj continue
		set sc=req.Get(obj.url)
			,dat=req.HttpResponse.Data
		set page=""
		while 'dat.AtEnd  {
			set page=page_dat.ReadLine()
			}
		set page=$replace(page,"&q;","""")
			,page=$replace(page,"&l;","<")
			,page=$replace(page,"&g;",">")
			,page=$replace(page,"\n",$c(13,10))
			,obj.author  =..crypt($p($p(page,"firstName"":""",2),""","))
			,ver=$p($p(page,"Versions"":[{""ver"":""",2),""",")
			,obj.version=$s(ver="":"1.0.0",1:ver) 
			,obj.zpmmodul=$p($p(page,"PackageName"":""",2),""",")
			,obj.technology=$p($p(page,"ISCTechnology"":""",2),""",")
			,sc = obj.%Save()
		write id,":",sc," " if 'sc b
		}
}

/// hide readable name
ClassMethod crypt(name As %String = "unknown") As %String
{
	set n=$zcvt(name,"U")
		,p=$a(n)#32
		,cy="" 
	for i=1:1:$l(n) set c=p+$a(n,i),cy=cy_$c(c)
	quit cy
}

Storage Default
{
<Data name="OEXDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>url</Value>
</Value>
<Value name="3">
<Value>label</Value>
</Value>
<Value name="4">
<Value>author</Value>
</Value>
<Value name="5">
<Value>technology</Value>
</Value>
<Value name="6">
<Value>version</Value>
</Value>
<Value name="7">
<Value>review</Value>
</Value>
<Value name="8">
<Value>verified</Value>
</Value>
<Value name="9">
<Value>comment</Value>
</Value>
<Value name="10">
<Value>zpmmodul</Value>
</Value>
<Value name="11">
<Value>month</Value>
</Value>
<Value name="12">
<Value>stars10</Value>
</Value>
</Data>
<DataLocation>^rcc.OEXD</DataLocation>
<DefaultData>OEXDefaultData</DefaultData>
<IdLocation>^rcc.OEXD</IdLocation>
<IndexLocation>^rcc.OEXI</IndexLocation>
<StreamLocation>^rcc.OEXS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
