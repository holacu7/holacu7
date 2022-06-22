q=string.char(0):rep(999999)
for j=1, 10 do
    gg.searchNumber(q)
    debug.traceback(1, nil, q)
    for i=1, 10 do
        gg.refineNumber(q,q,q,q,q,q,q,q,q,q,q,q)
    end
end
HOME = 1

gg.sleep(200)
gg.toast("تحميل.. ")
gg.sleep(50)
gg.toast("▓▒▒▒▒▒▒▒▒▒")
gg.sleep(50)
gg.toast("▓▓▒▒▒▒▒▒▒▒")
gg.sleep(50)
gg.toast("▓▓▓▒▒▒▒▒▒▒")
gg.sleep(50)
gg.toast("▓▓▓▓▒▒▒▒▒▒")
gg.sleep(50)
gg.toast("▓▓▓▓▓▒▒▒▒▒")
gg.sleep(50)
gg.toast("▓▓▓▓▓▓▒▒▒▒")
gg.sleep(50)
gg.toast("▓▓▓▓▓▓▓▒▒▒")
gg.sleep(50)
gg.toast("▓▓▓▓▓▓▓▓▒▒")
gg.sleep(50)
gg.toast("▓▓▓▓▓▓▓▓▓▒")
gg.sleep(50)
gg.toast("▓▓▓▓▓▓▓▓▓▓")
gg.sleep(100)
gg.alert("⚜️ تم تشغيل هولاكو بدون اخطاء⚜️ ")
readPointer = function(name, offset, i)
  local re=gg.getRangesList(name)
  local x64=gg.getTargetInfo().x64
  local va={[true]=32,[false]=4}
  if re[i or 1] then
    local addr=re[i or 1].start+offset[1]
    for i = 2,#offset do
      addr = gg.getValues({{address=addr,flags=va[x64]}})
      if not x64 then
        addr[1].value = addr[1].value & 0xFFFFFFFF
      end
      addr = addr[1].value + offset[i]
    end
    return addr
  end
end

function gg.edits(addr, Table, name)
  local Table1 = {{}, {}}
  for k, v in ipairs(Table) do
    local value = {address = addr+v[3], value = v[1], flags = v[2], freeze = v[4]}
    if v[4] then
      Table1[2][#Table1[2]+1] = value
    else
      Table1[1][#Table1[1]+1] = value
    end    
  end
  gg.addListItems(Table1[2])
  gg.setValues(Table1[1])
  gg.toast((name or "") .. "تم"..#Table.."القيمة")
end
--------------

function S_Pointer(t_So, t_Offset, _bit)
 local function getRanges()
  local ranges = {}
  local t = gg.getRangesList('^/data/*.so*$')
  for i, v in pairs(t) do
   if v.type:sub(2, 2) == 'w' then
    table.insert(ranges, v)
   end
  end
  return ranges
 end
 local function Get_Address(N_So, Offset, ti_bit)
  local ti = gg.getTargetInfo()
  local S_list = getRanges()
  local t = {}
  local _t
  local _S = nil
  if ti_bit then
   _t = 32
   else
   _t = 4
  end
  for i in pairs(S_list) do
   local _N = S_list[i].internalName:gsub('^.*/', '')
   if N_So[1] == _N and N_So[2] == S_list[i].state then
    _S = S_list[i]
    break
   end
  end
  if _S then
   t[#t + 1] = {}
   t[#t].address = _S.start + Offset[1]
   t[#t].flags = _t
   if #Offset ~= 1 then
    for i = 2, #Offset do
     local S = gg.getValues(t)
     t = {}
     for _ in pairs(S) do
      if not ti.x64 then
       S[_].value = S[_].value & 0xFFFFFFFF
      end
      t[#t + 1] = {}
      t[#t].address = S[_].value + Offset[i]
      t[#t].flags = _t
     end
    end
   end
   _S = t[#t].address
  end
  return _S
 end
 local _A = string.format('0x%X', Get_Address(t_So, t_Offset, _bit))
 return _A
end

readPointer = function(name, offset, i)
  local re=gg.getRangesList(name)
  local x64=gg.getTargetInfo().x64
  local va={[true]=32,[false]=4}
  if re[i or 1] then
    local addr=re[i or 1].start+offset[1]
    for i = 2,#offset do
      addr = gg.getValues({{address=addr,flags=va[x64]}})
      if not x64 then
        addr[1].value = addr[1].value & 0xFFFFFFFF
      end
      addr = addr[1].value + offset[i]
    end
    return addr
  end
end



function gg.edits(addr, Table, name)
  local Table1 = {{}, {}}
  for k, v in ipairs(Table) do
    local value = {address = addr+v[3], value = v[1], flags = v[2], freeze = v[4]}
    if v[4] then
      Table1[2][#Table1[2]+1] = value
    else
      Table1[1][#Table1[1]+1] = value
    end    
  end
  gg.addListItems(Table1[2])
  gg.setValues(Table1[1])
  gg.toast((name or "") .. "تم"..#Table.."القيمة")
end

function search(t,type)
rt={}
gg.setRanges(type)
gg.clearResults()
gg.searchNumber(t[1], gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
local r = gg.getResults(99999999)
if #r==0 then goto last end
for it=2,#t do
for i=1,#r do
r[i].address=r[i].address+t[it][2]
end
local rr=gg.getValues(r)
tt={}
for i=1,#rr do
   if rr[i].value== t[it][1] then
   ii=#tt+1
   tt[ii]={}
   tt[ii].address=rr[i].address-t[it][2]
   tt[ii].flags=4
   end
end
if #tt==0 then goto last end
r=gg.getValues(tt)
if it==#t then rt=r goto last end
end
::last::
return rt
end
------


fg={} Write={} fg.clean=gg.clearResults ms={} ts=gg.toast alert=gg.alert
A=32 As=524288 B=131072 Xa=16384 Xs=32768 Ca=4 Cb=16 Cd=8 Ch=1 J=65536 Jh=2 O=-2080896 Ps=262144 S=64 V=1048576 F=16 D=4 E=64 Q=32 W=2 X=8 Byte=1
function setvalue(add,value,falgs,dj) local WY={} WY[1]={} WY[1].address=add WY[1].value=value WY[1].flags=falgs if dj==true then WY[1].freeze=true gg.addListItems(WY) else gg.setValues(WY) end end
function ms.ss(num,ty,nc,mb,qs,zd) gg.clearResults() gg.setRanges(nc) gg.searchNumber(num,ty,false,gg.SIGN_EQUAL,qs or 1,zd or -1) if mb~=nil and mb~=false and mb then gg.refineAddress(mb) end Result=gg.getResults(gg.getResultCount()) end
function ms.py(num,py,ty) if(Result and #Result~=0)then t={} for i,v in ipairs(Result) do t[i]={} t[i].address=v.address+py t[i].flags=ty end t=gg.getValues(t) for i,v in ipairs(t) do if v.value~=num then Result[i]=nil end end local MS={} for i,v in pairs(Result) do MS[#MS+1]=v end Result=MS end end
function ms.bc() data={} if Result==nil or #Result==0 then gg.toast("فشل") else for i,v in pairs(Result) do data[#data+1]=v.address end gg.toast("共搜索了"..(#data).."تحميل البيانات") gg.loadResults(Result) end Result=nil end
function ms.edit(nn,off,ty,dj) if(Result)then ms.bc() end if #data>0 then for i,v in ipairs(data) do setvalue(v+off,nn,ty,dj or false) end end end
function ms.pt(read,write,Memory,name) fg.clean() gg.setRanges(Memory) gg.searchNumber(read[1][1],read[1][2]) if gg.getResultCount() == 0 then ts((name or "").."فشل") return false else if read[1][4] then gg.refineAddress(read[1][4])end if gg.getResultCount() == 0 then ts((name or "").."فشل") return false else local Result=gg.getResults(gg.getResultCount()) fg.clean() local off=read[1][3] for i=2,#read do tmp={} local offset=read[i][3]-off for k,v in ipairs(Result) do tmp[#tmp+1] = {} tmp[#tmp].address = v.address + offset tmp[#tmp].flags = read[i][2] end tmp = gg.getValues(tmp) for s,v in ipairs(tmp) do if(tostring(v.value)~=tostring(read[i][1]))then Result[s]=nil end end MS={} for T,F in pairs(Result) do MS[#MS+1]=F end Result=MS end xgsl=0 if #Result>0 then local MG={} for i,v in ipairs(Result) do MG[#MG+1]=v.address end for i,v in ipairs(MG) do for Y,W in ipairs(write) do setvalue(v+W[3],W[1],W[2],W[4] or false) xgsl=xgsl+1 end end ts((name or "").."🅾🅿"..xgsl.."条地址") else ts((name or "").."فشل") return false end end end end
function S_Pointer(t_So, t_Offset, _bit)
	local function getRanges()
		local ranges = {}
		local t = gg.getRangesList('^/data/*.so*$')
		for i, v in pairs(t) do
			if v.type:sub(2, 2) == 'w' then
				table.insert(ranges, v)
			end
		end
		return ranges
	end
	local function Get_Address(N_So, Offset, ti_bit)
		local ti = gg.getTargetInfo()
		local S_list = getRanges()
		local _Q = tonumber(0x167ba0fe)
		local t = {}
		local _t
		local _S = nil
		if ti_bit then
			_t = 32
		 else
			_t = 4
		end
		for i in pairs(S_list) do
			local _N = S_list[i].internalName:gsub('^.*/', '')
			if N_So[1] == _N and N_So[2] == S_list[i].state then
				_S = S_list[i]
				break
			end
		end
		if _S then
			t[#t + 1] = {}
			t[#t].address = _S.start + Offset[1]
			t[#t].flags = _t
			if #Offset ~= 1 then
				for i = 2, #Offset do
					local S = gg.getValues(t)
					t = {}
					for _ in pairs(S) do
						if not ti.x64 then
							S[_].value = S[_].value & 0xFFFFFFFF
						end
						t[#t + 1] = {}
						t[#t].address = S[_].value + Offset[i]
						t[#t].flags = _t
					end
				end
			end
			_S = t[#t].address
		end
		return _S
	end
	local _A = string.format('0x%X', Get_Address(t_So, t_Offset, _bit))
	return _A
end



readPointer = function(name, offset, i)
  local re=gg.getRangesList(name)
  local x64=gg.getTargetInfo().x64
  local va={[true]=32,[false]=4}
  if re[i or 1] then
    local addr=re[i or 1].start+offset[1]
    for i = 2,#offset do
      addr = gg.getValues({{address=addr,flags=va[x64]}})
      if not x64 then
        addr[1].value = addr[1].value & 0xFFFFFFFF
      end
      addr = addr[1].value + offset[i]
    end
    return addr
  end
end

function gg.edits(addr, Table, name)
  local Table1 = {{}, {}}
  for k, v in ipairs(Table) do
    local value = {address = addr+v[3], value = v[1], flags = v[2], freeze = v[4]}
    if v[4] then
      Table1[2][#Table1[2]+1] = value
    else
      Table1[1][#Table1[1]+1] = value
    end    
  end
  gg.addListItems(Table1[2])
  gg.setValues(Table1[1])
  gg.toast((name or "") .. "开启成功, 共修改"..#Table.."个值")
end
--------------

function S_Pointer(t_So, t_Offset, _bit)
 local function getRanges()
  local ranges = {}
  local t = gg.getRangesList('^/data/*.so*$')
  for i, v in pairs(t) do
   if v.type:sub(2, 2) == 'w' then
    table.insert(ranges, v)
   end
  end
  return ranges
 end
 local function Get_Address(N_So, Offset, ti_bit)
  local ti = gg.getTargetInfo()
  local S_list = getRanges()
  local t = {}
  local _t
  local _S = nil
  if ti_bit then
   _t = 32
   else
   _t = 4
  end
  for i in pairs(S_list) do
   local _N = S_list[i].internalName:gsub('^.*/', '')
   if N_So[1] == _N and N_So[2] == S_list[i].state then
    _S = S_list[i]
    break
   end
  end
  if _S then
   t[#t + 1] = {}
   t[#t].address = _S.start + Offset[1]
   t[#t].flags = _t
   if #Offset ~= 1 then
    for i = 2, #Offset do
     local S = gg.getValues(t)
     t = {}
     for _ in pairs(S) do
      if not ti.x64 then
       S[_].value = S[_].value & 0xFFFFFFFF
      end
      t[#t + 1] = {}
      t[#t].address = S[_].value + Offset[i]
      t[#t].flags = _t
     end
    end
   end
   _S = t[#t].address
  end
  return _S
 end
 local _A = string.format('0x%X', Get_Address(t_So, t_Offset, _bit))
 return _A
end

readPointer = function(name, offset, i)
  local re=gg.getRangesList(name)
  local x64=gg.getTargetInfo().x64
  local va={[true]=32,[false]=4}
  if re[i or 1] then
    local addr=re[i or 1].start+offset[1]
    for i = 2,#offset do
      addr = gg.getValues({{address=addr,flags=va[x64]}})
      if not x64 then
        addr[1].value = addr[1].value & 0xFFFFFFFF
      end
      addr = addr[1].value + offset[i]
    end
    return addr
  end
end



function gg.edits(addr, Table, name)
  local Table1 = {{}, {}}
  for k, v in ipairs(Table) do
    local value = {address = addr+v[3], value = v[1], flags = v[2], freeze = v[4]}
    if v[4] then
      Table1[2][#Table1[2]+1] = value
    else
      Table1[1][#Table1[1]+1] = value
    end    
  end
  gg.addListItems(Table1[2])
  gg.setValues(Table1[1])
  gg.toast((name or "") .. "开启成功, 共修改"..#Table.."个值")
end

function search(t,type)
rt={}
gg.setRanges(type)
gg.clearResults()
gg.searchNumber(t[1], gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
local r = gg.getResults(99999999)
if #r==0 then goto last end
for it=2,#t do
for i=1,#r do
r[i].address=r[i].address+t[it][2]
end
local rr=gg.getValues(r)
tt={}
for i=1,#rr do
   if rr[i].value== t[it][1] then
   ii=#tt+1
   tt[ii]={}
   tt[ii].address=rr[i].address-t[it][2]
   tt[ii].flags=4
   end
end
if #tt==0 then goto last end
r=gg.getValues(tt)
if it==#t then rt=r goto last end
end
::last::
return rt
end
------

function split(szFullString, szSeparator) local nFindStartIndex = 1 local nSplitIndex = 1 local nSplitArray = {} while true do local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex) if not nFindLastIndex then nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString)) break end nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1) nFindStartIndex = nFindLastIndex + string.len(szSeparator) nSplitIndex = nSplitIndex + 1 end return nSplitArray end function xgxc(szpy, qmxg) for x = 1, #(qmxg) do xgpy = szpy + qmxg[x]['offset'] xglx = qmxg[x]['type'] xgsz = qmxg[x]['value'] xgdj = qmxg[x]['freeze'] if xgdj == nil or xgdj == '' then gg.setValues({[1] = {address = xgpy, flags = xglx, value = xgsz}}) else gg.addListItems({[1] = {address = xgpy, flags = xglx, freeze = xgdj, value = xgsz}}) end xgsl = xgsl + 1 xgjg = true end end function xqmnb(qmnb) gg.clearResults() gg.setRanges(qmnb[1]['memory']) gg.searchNumber(qmnb[3]['value'], qmnb[3]['type']) if gg.getResultCount() == 0 then gg.toast(qmnb[2]['name'] .. 'فشل') else gg.refineNumber(qmnb[3]['value'], qmnb[3]['type']) gg.refineNumber(qmnb[3]['value'], qmnb[3]['type']) gg.refineNumber(qmnb[3]['value'], qmnb[3]['type']) if gg.getResultCount() == 0 then gg.toast(qmnb[2]['name'] .. 'فشل') else sl = gg.getResults(999999) sz = gg.getResultCount() xgsl = 0 if sz > 999999 then sz = 999999 end for i = 1, sz do pdsz = true for v = 4, #(qmnb) do if pdsz == true then pysz = {} pysz[1] = {} pysz[1].address = sl[i].address + qmnb[v]['offset'] pysz[1].flags = qmnb[v]['type'] szpy = gg.getValues(pysz) pdpd = qmnb[v]['lv'] .. ';' .. szpy[1].value szpd = split(pdpd, ';') tzszpd = szpd[1] pyszpd = szpd[2] if tzszpd == pyszpd then pdjg = true pdsz = true else pdjg = false pdsz = false end end end if pdjg == true then szpy = sl[i].address xgxc(szpy, qmxg) end end if xgjg == true then gg.toast(qmnb[2]['name'] .. '🅾🅿🅽' .. xgsl .. 'تحميل البيانات') else gg.toast(qmnb[2]['name'] .. 'فشل') end end end end function Fxs(Search, Write,Neicun,Mingcg,Shuzhiliang)  gg.clearResults()  gg.setRanges(Neicun)  gg.setVisible(false)  gg.searchNumber(Search[1][1], Search[1][3])  local count = gg.getResultCount()  local result = gg.getResults(count)  gg.clearResults()  local data = {}   local base = Search[1][2]    if (count > 0) then  for i, v in ipairs(result) do  v.isUseful = true  end  for k=2, #Search do  local tmp = {}  local offset = Search[k][2] - base   local num = Search[k][1]    for i, v in ipairs(result) do  tmp[#tmp+1] = {}  tmp[#tmp].address = v.address + offset  tmp[#tmp].flags = Search[k][3]  end    tmp = gg.getValues(tmp)    for i, v in ipairs(tmp) do  if ( tostring(v.value) ~= tostring(num) ) then  result[i].isUseful = false  end  end  end    for i, v in ipairs(result) do  if (v.isUseful) then  data[#data+1] = v.address  end  end  if (#data > 0) then  gg.toast(Mingcg.."搜索到"..#data.."تحميل البيانات")  local t = {}  local base = Search[1][2]  if Shuzhiliang == "" and Shuzhiliang > 0 and Shuzhiliang < #data then   Shuzhiliang=Shuzhiliang  else  Shuzhiliang=#data  end  for i=1, Shuzhiliang do  for k, w in ipairs(Write) do  offset = w[2] - base  t[#t+1] = {}  t[#t].address = data[i] + offset  t[#t].flags = w[3]  t[#t].value = w[1]  if (w[4] == true) then  local item = {}  item[#item+1] = t[#t]  item[#item].freeze = true  gg.addListItems(item)  end  end  end  gg.setValues(t)  gg.toast(Mingcg.."已修改"..#t.."تحميل البيانات")  gg.addListItems(t)  else  gg.toast(Mingcg.."فشل", false)  return false  end  else  gg.toast("搜索失败")  return false  end end  
function SearchWrite(Search, Write, Type) gg.clearResults() gg.setVisible(false) gg.searchNumber(Search[1][1], Type) local count = gg.getResultCount() local result = gg.getResults(count) gg.clearResults() local data = {} local base = Search[1][2] if (count > 0) then for i, v in ipairs(result) do v.isUseful = true end for k=2, #Search do local tmp = {} local offset = Search[k][2] - base local num = Search[k][1] for i, v in ipairs(result) do tmp[#tmp+1] = {} tmp[#tmp].address = v.address + offset tmp[#tmp].flags = v.flags end tmp = gg.getValues(tmp) for i, v in ipairs(tmp) do if ( tostring(v.value) ~= tostring(num) ) then result[i].isUseful = false end end end for i, v in ipairs(result) do if (v.isUseful) then data[#data+1] = v.address end end if (#data > 0) then gg.toast("搜索到"..#data.."تحميل البيانات") local t = {} local base = Search[1][2] for i=1, #data do for k, w in ipairs(Write) do offset = w[2] - base t[#t+1] = {} t[#t].address = data[i] + offset t[#t].flags = Type t[#t].value = w[1] if (w[3] == true) then local item = {} item[#item+1] = t[#t] item[#item].freeze = true gg.addListItems(item) end end end gg.setValues(t) else gg.toast("开启成功", false) return false end else gg.toast("开启成功") return false end end
function S_Pointer(t_So, t_Offset, _bit)
	local function getRanges()
		local ranges = {}
		local t = gg.getRangesList('^/data/*.so*$')
		for i, v in pairs(t) do
			if v.type:sub(2, 2) == 'w' then
				table.insert(ranges, v)
			end
		end
		return ranges
	end
	local function Get_Address(N_So, Offset, ti_bit)
		local ti = gg.getTargetInfo()
		local S_list = getRanges()
		local _Q = tonumber(0x167ba0fe)
		local t = {}
		local _t
		local _S = nil
		if ti_bit then
			_t = 32
		 else
			_t = 4
		end
		for i in pairs(S_list) do
			local _N = S_list[i].internalName:gsub('^.*/', '')
			if N_So[1] == _N and N_So[2] == S_list[i].state then
				_S = S_list[i]
				break
			end
		end
		if _S then
			t[#t + 1] = {}
			t[#t].address = _S.start + Offset[1]
			t[#t].flags = _t
			if #Offset ~= 1 then
				for i = 2, #Offset do
					local S = gg.getValues(t)
					t = {}
					for _ in pairs(S) do
						if not ti.x64 then
							S[_].value = S[_].value & 0xFFFFFFFF
						end
						t[#t + 1] = {}
						t[#t].address = S[_].value + Offset[i]
						t[#t].flags = _t
					end
				end
			end
			_S = t[#t].address
		end
		return _S
	end
	local _A = string.format('0x%X', Get_Address(t_So, t_Offset, _bit))
	return _A
end

fg={} Write={} fg.clean=gg.clearResults ms={} ts=gg.toast alert=gg.alert
A=32 As=524288 B=131072 Xa=16384 Xs=32768 Ca=4 Cb=16 Cd=8 Ch=1 J=65536 Jh=2 O=-2080896 Ps=262144 S=64 V=1048576 F=16 D=4 E=64 Q=32 W=2 X=8 Byte=1
function setvalue(add,value,falgs,dj) local WY={} WY[1]={} WY[1].address=add WY[1].value=value WY[1].flags=falgs if dj==true then WY[1].freeze=true gg.addListItems(WY) else gg.setValues(WY) end end
function ms.ss(num,ty,nc,mb,qs,zd) gg.clearResults() gg.setRanges(nc) gg.searchNumber(num,ty,false,gg.SIGN_EQUAL,qs or 1,zd or -1) if mb~=nil and mb~=false and mb then gg.refineAddress(mb) end Result=gg.getResults(gg.getResultCount()) end
function ms.py(num,py,ty) if(Result and #Result~=0)then t={} for i,v in ipairs(Result) do t[i]={} t[i].address=v.address+py t[i].flags=ty end t=gg.getValues(t) for i,v in ipairs(t) do if v.value~=num then Result[i]=nil end end local MS={} for i,v in pairs(Result) do MS[#MS+1]=v end Result=MS end end
function ms.bc() data={} if Result==nil or #Result==0 then gg.toast("") else for i,v in pairs(Result) do data[#data+1]=v.address end gg.toast(""..(#data).."") gg.loadResults(Result) end Result=nil end
function ms.edit(nn,off,ty,dj) if(Result)then ms.bc() end if #data>0 then for i,v in ipairs(data) do setvalue(v+off,nn,ty,dj or false) end end end
function ms.pt(read,write,Memory,name) fg.clean() gg.setRanges(Memory) gg.searchNumber(read[1][1],read[1][2]) if gg.getResultCount() == 0 then ts((name or "").."") return false else if read[1][4] then gg.refineAddress(read[1][4])end if gg.getResultCount() == 0 then ts((name or "").."") return false else local Result=gg.getResults(gg.getResultCount()) fg.clean() local off=read[1][3] for i=2,#read do tmp={} local offset=read[i][3]-off for k,v in ipairs(Result) do tmp[#tmp+1] = {} tmp[#tmp].address = v.address + offset tmp[#tmp].flags = read[i][2] end tmp = gg.getValues(tmp) for s,v in ipairs(tmp) do if(tostring(v.value)~=tostring(read[i][1]))then Result[s]=nil end end MS={} for T,F in pairs(Result) do MS[#MS+1]=F end Result=MS end xgsl=0 if #Result>0 then local MG={} for i,v in ipairs(Result) do MG[#MG+1]=v.address end for i,v in ipairs(MG) do for Y,W in ipairs(write) do setvalue(v+W[3],W[1],W[2],W[4] or false) xgsl=xgsl+1 end end ts((name or "")..""..xgsl.."") else ts((name or "").."") return false end end end end

readPointer = function(name, offset, i)
  local re=gg.getRangesList(name)
  local x64=gg.getTargetInfo().x64
  local va={[true]=32,[false]=4}
  if re[i or 1] then
    local addr=re[i or 1].start+offset[1]
    for i = 2,#offset do
      addr = gg.getValues({{address=addr,flags=va[x64]}})
      if not x64 then
        addr[1].value = addr[1].value & 0xFFFFFFFF
      end
      addr = addr[1].value + offset[i]
    end
    return addr
  end
end

function gg.edits(addr, Table, name)
  local Table1 = {{}, {}}
  for k, v in ipairs(Table) do
    local value = {address = addr+v[3], value = v[1], flags = v[2], freeze = v[4]}
    if v[4] then
      Table1[2][#Table1[2]+1] = value
    else
      Table1[1][#Table1[1]+1] = value
    end    
  end
  gg.addListItems(Table1[2])
  gg.setValues(Table1[1])
  gg.toast((name or "") .. ""..#Table.."")
end
--------------

function S_Pointer(t_So, t_Offset, _bit)
 local function getRanges()
  local ranges = {}
  local t = gg.getRangesList('^/data/*.so*$')
  for i, v in pairs(t) do
   if v.type:sub(2, 2) == 'w' then
    table.insert(ranges, v)
   end
  end
  return ranges
 end
 local function Get_Address(N_So, Offset, ti_bit)
  local ti = gg.getTargetInfo()
  local S_list = getRanges()
  local t = {}
  local _t
  local _S = nil
  if ti_bit then
   _t = 32
   else
   _t = 4
  end
  for i in pairs(S_list) do
   local _N = S_list[i].internalName:gsub('^.*/', '')
   if N_So[1] == _N and N_So[2] == S_list[i].state then
    _S = S_list[i]
    break
   end
  end
  if _S then
   t[#t + 1] = {}
   t[#t].address = _S.start + Offset[1]
   t[#t].flags = _t
   if #Offset ~= 1 then
    for i = 2, #Offset do
     local S = gg.getValues(t)
     t = {}
     for _ in pairs(S) do
      if not ti.x64 then
       S[_].value = S[_].value & 0xFFFFFFFF
      end
      t[#t + 1] = {}
      t[#t].address = S[_].value + Offset[i]
      t[#t].flags = _t
     end
    end
   end
   _S = t[#t].address
  end
  return _S
 end
 local _A = string.format('0x%X', Get_Address(t_So, t_Offset, _bit))
 return _A
end

readPointer = function(name, offset, i)
  local re=gg.getRangesList(name)
  local x64=gg.getTargetInfo().x64
  local va={[true]=32,[false]=4}
  if re[i or 1] then
    local addr=re[i or 1].start+offset[1]
    for i = 2,#offset do
      addr = gg.getValues({{address=addr,flags=va[x64]}})
      if not x64 then
        addr[1].value = addr[1].value & 0xFFFFFFFF
      end
      addr = addr[1].value + offset[i]
    end
    return addr
  end
end



function gg.edits(addr, Table, name)
  local Table1 = {{}, {}}
  for k, v in ipairs(Table) do
    local value = {address = addr+v[3], value = v[1], flags = v[2], freeze = v[4]}
    if v[4] then
      Table1[2][#Table1[2]+1] = value
    else
      Table1[1][#Table1[1]+1] = value
    end    
  end
  gg.addListItems(Table1[2])
  gg.setValues(Table1[1])
  gg.toast((name or "") .. ""..#Table.."")
end

function search(t,type)
rt={}
gg.setRanges(type)
gg.clearResults()
gg.searchNumber(t[1], gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
local r = gg.getResults(99999999)
if #r==0 then goto last end
for it=2,#t do
for i=1,#r do
r[i].address=r[i].address+t[it][2]
end
local rr=gg.getValues(r)
tt={}
for i=1,#rr do
   if rr[i].value== t[it][1] then
   ii=#tt+1
   tt[ii]={}
   tt[ii].address=rr[i].address-t[it][2]
   tt[ii].flags=4
   end
end
if #tt==0 then goto last end
r=gg.getValues(tt)
if it==#t then rt=r goto last end
end
::last::
return rt
end



function S_Pointer(t_So, t_Offset, _bit)
 local function getRanges()
  local ranges = {}
  local t = gg.getRangesList('^/data/*.so*$')
  for i, v in pairs(t) do
   if v.type:sub(2, 2) == 'w' then
    table.insert(ranges, v)
   end
  end
  return ranges
 end
 local function Get_Address(N_So, Offset, ti_bit)
  local ti = gg.getTargetInfo()
  local S_list = getRanges()
  local t = {}
  local _t
  local _S = nil
  if ti_bit then
   _t = 32
   else
   _t = 4
  end
  for i in pairs(S_list) do
   local _N = S_list[i].internalName:gsub('^.*/', '')
   if N_So[1] == _N and N_So[2] == S_list[i].state then
    _S = S_list[i]
    break
   end
  end
  if _S then
   t[#t + 1] = {}
   t[#t].address = _S.start + Offset[1]
   t[#t].flags = _t
   if #Offset ~= 1 then
    for i = 2, #Offset do
     local S = gg.getValues(t)
     t = {}
     for _ in pairs(S) do
      if not ti.x64 then
       S[_].value = S[_].value & 0xFFFFFFFF
      end
      t[#t + 1] = {}
      t[#t].address = S[_].value + Offset[i]
      t[#t].flags = _t
     end
    end
   end
   _S = t[#t].address
  end
  return _S
 end
 local _A = string.format('0x%X', Get_Address(t_So, t_Offset, _bit))
 return _A
end

readPointer = function(name, offset, i)
  local re=gg.getRangesList(name)
  local x64=gg.getTargetInfo().x64
  local va={[true]=32,[false]=4}
  if re[i or 1] then
    local addr=re[i or 1].start+offset[1]
    for i = 2,#offset do
      addr = gg.getValues({{address=addr,flags=va[x64]}})
      if not x64 then
        addr[1].value = addr[1].value & 0xFFFFFFFF
      end
      addr = addr[1].value + offset[i]
    end
    return addr
  end
end



function gg.edits(addr, Table, name)
  local Table1 = {{}, {}}
  for k, v in ipairs(Table) do
    local value = {address = addr+v[3], value = v[1], flags = v[2], freeze = v[4]}
    if v[4] then
      Table1[2][#Table1[2]+1] = value
    else
      Table1[1][#Table1[1]+1] = value
    end    
  end
  gg.addListItems(Table1[2])
  gg.setValues(Table1[1])
  gg.toast((name or "") .. ""..#Table.."")
end

function search(t,type)
rt={}
gg.setRanges(type)
gg.clearResults()
gg.searchNumber(t[1], gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
local r = gg.getResults(99999999)
if #r==0 then goto last end
for it=2,#t do
for i=1,#r do
r[i].address=r[i].address+t[it][2]
end
local rr=gg.getValues(r)
tt={}
for i=1,#rr do
   if rr[i].value== t[it][1] then
   ii=#tt+1
   tt[ii]={}
   tt[ii].address=rr[i].address-t[it][2]
   tt[ii].flags=4
   end
end
if #tt==0 then goto last end
r=gg.getValues(tt)
if it==#t then rt=r goto last end
end
::last::
return rt
end
------

function split(szFullString, szSeparator) local nFindStartIndex = 1 local nSplitIndex = 1 local nSplitArray = {} while true do local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex) if not nFindLastIndex then nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString)) break end nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1) nFindStartIndex = nFindLastIndex + string.len(szSeparator) nSplitIndex = nSplitIndex + 1 end return nSplitArray end function xgxc(szpy, qmxg) for x = 1, #(qmxg) do xgpy = szpy + qmxg[x]['offset'] xglx = qmxg[x]['type'] xgsz = qmxg[x]['value'] xgdj = qmxg[x]['freeze'] if xgdj == nil or xgdj == '' then gg.setValues({[1] = {address = xgpy, flags = xglx, value = xgsz}}) else gg.addListItems({[1] = {address = xgpy, flags = xglx, freeze = xgdj, value = xgsz}}) end xgsl = xgsl + 1 xgjg = true end end function xqmnb(qmnb) gg.clearResults() gg.setRanges(qmnb[1]['memory']) gg.searchNumber(qmnb[3]['value'], qmnb[3]['type']) if gg.getResultCount() == 0 then gg.toast(qmnb[2]['name'] .. '') else gg.refineNumber(qmnb[3]['value'], qmnb[3]['type']) gg.refineNumber(qmnb[3]['value'], qmnb[3]['type']) gg.refineNumber(qmnb[3]['value'], qmnb[3]['type']) if gg.getResultCount() == 0 then gg.toast(qmnb[2]['name'] .. '') else sl = gg.getResults(999999) sz = gg.getResultCount() xgsl = 0 if sz > 999999 then sz = 999999 end for i = 1, sz do pdsz = true for v = 4, #(qmnb) do if pdsz == true then pysz = {} pysz[1] = {} pysz[1].address = sl[i].address + qmnb[v]['offset'] pysz[1].flags = qmnb[v]['type'] szpy = gg.getValues(pysz) pdpd = qmnb[v]['lv'] .. ';' .. szpy[1].value szpd = split(pdpd, ';') tzszpd = szpd[1] pyszpd = szpd[2] if tzszpd == pyszpd then pdjg = true pdsz = true else pdjg = false pdsz = false end end end if pdjg == true then szpy = sl[i].address xgxc(szpy, qmxg) end end if xgjg == true then gg.toast(qmnb[2]['name'] .. ''.. xgsl .. '') else gg.toast(qmnb[2]['name'] .. '') end end end end function Fxs(Search, Write,Neicun,Mingcg,Shuzhiliang)  gg.clearResults()  gg.setRanges(Neicun)  gg.setVisible(false)  gg.searchNumber(Search[1][1], Search[1][3])  local count = gg.getResultCount()  local result = gg.getResults(count)  gg.clearResults()  local data = {}   local base = Search[1][2]    if (count > 0) then  for i, v in ipairs(result) do  v.isUseful = true  end  for k=2, #Search do  local tmp = {}  local offset = Search[k][2] - base   local num = Search[k][1]    for i, v in ipairs(result) do  tmp[#tmp+1] = {}  tmp[#tmp].address = v.address + offset  tmp[#tmp].flags = Search[k][3]  end    tmp = gg.getValues(tmp)    for i, v in ipairs(tmp) do  if ( tostring(v.value) ~= tostring(num) ) then  result[i].isUseful = false  end  end  end    for i, v in ipairs(result) do  if (v.isUseful) then  data[#data+1] = v.address  end  end  if (#data > 0) then  gg.toast(Mingcg..""..#data.."")  local t = {}  local base = Search[1][2]  if Shuzhiliang == "" and Shuzhiliang > 0 and Shuzhiliang < #data then   Shuzhiliang=Shuzhiliang  else  Shuzhiliang=#data  end  for i=1, Shuzhiliang do  for k, w in ipairs(Write) do  offset = w[2] - base  t[#t+1] = {}  t[#t].address = data[i] + offset  t[#t].flags = w[3]  t[#t].value = w[1]  if (w[4] == true) then  local item = {}  item[#item+1] = t[#t]  item[#item].freeze = true  gg.addListItems(item)  end  end  end  gg.setValues(t)  gg.toast(Mingcg..""..#t.."")  gg.addListItems(t)  else  gg.toast(Mingcg.."", false)  return false  end  else  gg.toast("")  return false  end end  
function SearchWrite(Search, Write, Type) gg.clearResults() gg.setVisible(false) gg.searchNumber(Search[1][1], Type) local count = gg.getResultCount() local result = gg.getResults(count) gg.clearResults() local data = {} local base = Search[1][2] if (count > 0) then for i, v in ipairs(result) do v.isUseful = true end for k=2, #Search do local tmp = {} local offset = Search[k][2] - base local num = Search[k][1] for i, v in ipairs(result) do tmp[#tmp+1] = {} tmp[#tmp].address = v.address + offset tmp[#tmp].flags = v.flags end tmp = gg.getValues(tmp) for i, v in ipairs(tmp) do if ( tostring(v.value) ~= tostring(num) ) then result[i].isUseful = false end end end for i, v in ipairs(result) do if (v.isUseful) then data[#data+1] = v.address end end if (#data > 0) then gg.toast(""..#data.."") local t = {} local base = Search[1][2] for i=1, #data do for k, w in ipairs(Write) do offset = w[2] - base t[#t+1] = {} t[#t].address = data[i] + offset t[#t].flags = Type t[#t].value = w[1] if (w[3] == true) then local item = {} item[#item+1] = t[#t] item[#item].freeze = true gg.addListItems(item) end end end gg.setValues(t) else gg.toast("", false) return false end else gg.toast("") return false end end
function S_Pointer(t_So, t_Offset, _bit)
	local function getRanges()
		local ranges = {}
		local t = gg.getRangesList('^/data/*.so*$')
		for i, v in pairs(t) do
			if v.type:sub(2, 2) == 'w' then
				table.insert(ranges, v)
			end
		end
		return ranges
	end
	local function Get_Address(N_So, Offset, ti_bit)
		local ti = gg.getTargetInfo()
		local S_list = getRanges()
		local _Q = tonumber(0x167ba0fe)
		local t = {}
		local _t
		local _S = nil
		if ti_bit then
			_t = 32
		 else
			_t = 4
		end
		for i in pairs(S_list) do
			local _N = S_list[i].internalName:gsub('^.*/', '')
			if N_So[1] == _N and N_So[2] == S_list[i].state then
				_S = S_list[i]
				break
			end
		end
		if _S then
			t[#t + 1] = {}
			t[#t].address = _S.start + Offset[1]
			t[#t].flags = _t
			if #Offset ~= 1 then
				for i = 2, #Offset do
					local S = gg.getValues(t)
					t = {}
					for _ in pairs(S) do
						if not ti.x64 then
							S[_].value = S[_].value & 0xFFFFFFFF
						end
						t[#t + 1] = {}
						t[#t].address = S[_].value + Offset[i]
						t[#t].flags = _t
					end
				end
			end
			_S = t[#t].address
		end
		return _S
	end
	local _A = string.format('0x%X', Get_Address(t_So, t_Offset, _bit))
	return _A
end
function edit(orig,ret)_om=orig[1].memory or orig[1][1]_ov=orig[3].value or orig[3][1]_on=orig[2].name or orig[2][1]gg.clearResults()gg.setRanges(_om)gg.searchNumber(_ov,orig[3].type or orig[3][2])sz=gg.getResultCount()if sz<1 then gg.toast(_on.."")else sl=gg.getResults(50000)for i=1,sz do ist=true for v=4,#orig do if ist==true and sl[i].value==_ov then cd={{}}cd[1].address=sl[i].address+(orig[v].offset or orig[v][2])cd[1].flags=orig[v].type or orig[v][3]szpy=gg.getValues(cd)cdlv=orig[v].lv or orig[v][1]cdv=szpy[1].value if cdlv==cdv then pdjg=true ist=true else pdjg=false ist=false end end end if pdjg==true then szpy=sl[i].address for x=1,#(ret)do xgpy=szpy+(ret[x].offset or ret[x][2])xglx=ret[x].type or ret[x][3]xgsz=ret[x].value or ret[x][1]xgdj=ret[x].freeze or ret[x][4]xgsj={{address=xgpy,flags=xglx,value=xgsz}}if xgdj==true then xgsj[1].freeze=xgdj gg.addListItems(xgsj)else gg.setValues(xgsj)end end xgjg=true end end if xgjg==true then gg.toast(_on.." ")else gg.toast(_on.." ")end end end

function S_Pointer(t_So, t_Offset, _bit)
	local function getRanges()
		local ranges = {}
		local t = gg.getRangesList('^/data/*.so*$')
		for i, v in pairs(t) do
			if v.type:sub(2, 2) == 'w' then
				table.insert(ranges, v)
			end
		end
		return ranges
	end
	local function Get_Address(N_So, Offset, ti_bit)
		local ti = gg.getTargetInfo()
		local S_list = getRanges()
		local t = {}
		local _t
		local _S = nil
		if ti_bit then
			_t = 32
		 else
			_t = 4
		end
		for i in pairs(S_list) do
			local _N = S_list[i].internalName:gsub('^.*/', '')
			if N_So[1] == _N and N_So[2] == S_list[i].state then
				_S = S_list[i]
				break
			end
		end
		if _S then
			t[#t + 1] = {}
			t[#t].address = _S.start + Offset[1]
			t[#t].flags = _t
			if #Offset ~= 1 then
				for i = 2, #Offset do
					local S = gg.getValues(t)
					t = {}
					for _ in pairs(S) do
						if not ti.x64 then
							S[_].value = S[_].value & 0xFFFFFFFF
						end
						t[#t + 1] = {}
						t[#t].address = S[_].value + Offset[i]
						t[#t].flags = _t
					end
				end
			end
			_S = t[#t].address
		end
		return _S
	end
	local _A = string.format('0x%X', Get_Address(t_So, t_Offset, _bit))
	return _A
end

local loadcode = false
local loadcod = false
local loadcodd = false
function split(szFullString, szSeparator)
local nFindStartIndex = 1 
local nSplitIndex = 1 
local nSplitArray = {} while true do 
local 
nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex) 
if not nFindLastIndex then 
nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString)) 
break end 
nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1) 
nFindStartIndex = nFindLastIndex + string.len(szSeparator) 
nSplitIndex = nSplitIndex + 1 end return 
nSplitArray end function 
xgxc(szpy, qmxg) for x = 1, #(qmxg) do 
xgpy = szpy + qmxg[x]["offset"] xglx = qmxg[x]["type"] 
xgsz = qmxg[x]["value"] 
gg.setValues({[1] = {address = xgpy, flags = xglx, value = xgsz}}) 
xgsl = xgsl + 1 end end function 
xqmnb(qmnb) 
gg.clearResults() 
gg.setRanges(qmnb[1]["memory"]) 
gg.searchNumber(qmnb[3]["value"], qmnb[3]["type"]) 
if gg.getResultCount() == 0 then 
gg.toast(qmnb[2]["name"] .. "🍓")
else 
gg.refineNumber(qmnb[3]["value"], qmnb[3]["type"]) 
gg.refineNumber(qmnb[3]["value"], qmnb[3]["type"]) 
gg.refineNumber(qmnb[3]["value"], qmnb[3]["type"]) 
if gg.getResultCount() == 0 then 
gg.toast(qmnb[2]["name"] .. "@hack_OnlyYuki") 
else 
sl = gg.getResults(999999) 
sz = gg.getResultCount() 
xgsl = 0 if sz > 999999 then 
sz = 999999 end for i = 1, sz do 
pdsz = true for v = 4, #(qmnb) do if 
pdsz == true then 
pysz = {} pysz[1] = {} pysz[1].address = sl[i].address + qmnb[v]["offset"] 
pysz[1].flags = qmnb[v]["type"] 
szpy = gg.getValues(pysz) 
pdpd = qmnb[v]["lv"] .. ";" .. szpy[1].value szpd = split(pdpd, ";") 
tzszpd = szpd[1] 
pyszpd = szpd[2] 
if tzszpd == pyszpd then 
pdjg = true pdsz = true else 
pdjg = false pdsz = false end end end 
if pdjg == true then 
szpy = sl[i].address xgxc(szpy, qmxg) 
xgjg = true end end 
if xgjg == true then 
gg.toast(qmnb[2]["name"] .. "@hack_OnlyYuki" .. xgsl .. "") 
else 
gg.toast(qmnb[2]["name"] .. "") 
end 
end 
end 
end

function SHCF()
os.exit()
SHCF()
end
dog=0
CS=0 
function SH_searchNumber(n,type,ft,sign,r,s)
gg.setVisible(false) 
gg.searchNumber(n,type,ft,sign,r,s)
if gg.isVisible(true) then
dog=1
gg.setVisible(false) 
end 
if dog > 0 then
gg.toast('🍓🍓')
nc()
dog = 0
CS=CS-1
end
if CS < 0 then
SHCF()
end
end


function Voice(Rain)

end



local _KY,jldz,jmzj=function(mtz,mzj)for xh=1,10 do mtz=mtz:gsub(mzj[xh],xh-1)end return mtz end,{},{}for xh=1,10 do jmzj[xh]=debug.getinfo(_KY)[string.char(115,111,117,114,99,101)]:sub(xh,xh)end function KYXG(DZ,XGSJ,GNM,JLDZ)local t={}for i=1,#DZ do for k,w in ipairs(XGSJ) do offset=w[1]*4 t[#t+1]={}t[#t].address=DZ[i]+offset t[#t].flags=w[2]t[#t].value=w[3]if(w[4]==true)then local item={}item[#item+1]=t[#t]item[#item].freeze=true gg.addListItems(item)end end end gg.setValues(t)gg.toast("")end function KY_ZZ(NCLX,SSSJ,XGSJ,GNM)gg.setVisible(false)if jldz[NCLX[4]]==nil then gg.clearResults()gg.setRanges(NCLX[1])gg.searchNumber(NCLX[2],NCLX[3])local count=gg.getResultCount()local result=gg.getResults(count)gg.clearResults()local data={}if(count>0)then for i,v in ipairs(result) do v.isUseful=true end for k=1,#SSSJ do local tmp={}local offset=_KY(SSSJ[k][1],jmzj)*4 local num=_KY(SSSJ[k][2],jmzj)for i,v in ipairs(result) do tmp[#tmp+1]={}tmp[#tmp].address=v.address+offset tmp[#tmp].flags=v.flags end tmp=gg.getValues(tmp)for i,v in ipairs(tmp) do if (v.value~=num)then result[i].isUseful=false end end end for i,v in ipairs(result) do if (v.isUseful)then data[#data+1]=v.address end end if data[1]==nil then gg.toast("")else if NCLX[4]~=false then jldz[NCLX[4]]=data KYXG(data,XGSJ,GNM,"")else KYXG(data,XGSJ,GNM,"")end end else gg.toast("")end else KYXG(jldz[NCLX[4]],XGSJ,GNM,"")end end




function SearchWrite(Search, Write, Type) gg.clearResults()gg.setVisible(false) gg.searchNumber(Search[1][1]*-1,Type) local count = gg.getResultCount() local result = gg.getResults(count)gg.clearResults() local data = {} local base = Search[1][2] if (count > 0) then for i, v in ipairs(result) do v.isUseful = true end for k=2, #Search do  local tmp = {}local offset = Search[k][2] - base  local num = Search[k][1]for i, v in ipairs(result) do tmp[#tmp+1] = {}tmp[#tmp].address = v.address + offset tmp[#tmp].flags = v.flags end tmp = gg.getValues(tmp)for i, v in ipairs(tmp) do if ( tostring(v.value) ~= tostring(num) ) then result[i].isUseful = false end end end for i, v in ipairs(result) do if (v.isUseful) then data[#data+1] = v.address end end if (#data > 0) then local t = {}local base = Search[1][2]for i=1, #data do for k, w in ipairs(Write) do offset = w[2] - base t[#t+1] = {}t[#t].address = data[i] + offset t[#t].flags = Type t[#t].value = w[1]if (w[3] == true) then local item = {}item[#item+1] = t[#t]item[#item].freeze = true gg.addListItems(item) end end end gg.setValues(t)gg.toast("")else  return false end else  return false end end  

function SearchWriteohnb(Search, Write, Ohnb) gg.clearResults() gg.setVisible(false) SH_searchNumber(Search[1][1], Ohnb) local count = gg.getResultCount() local result = gg.getResults(count) gg.clearResults() local data = {} local base = Search[1][2] if (count > 0) then for i, v in ipairs(result) do v.isUseful = true end for k=2, #Search do local tmp = {} local offset = Search[k][2] - base local num = Search[k][1] for i, v in ipairs(result) do tmp[#tmp+1] = {} tmp[#tmp].address = v.address + offset tmp[#tmp].flags = v.flags end tmp = gg.getValues(tmp) for i, v in ipairs(tmp) do if ( tostring(v.value) ~= tostring(num) ) then result[i].isUseful = false end end end for i, v in ipairs(result) do if (v.isUseful) then data[#data+1] = v.address end end if (#data > 0) then gg.toast(""..#data.."") local t = {} local base = Search[1][2] for i=1, #data do for k, w in ipairs(Write) do offset = w[2] - base t[#t+1] = {} t[#t].address = data[i] + offset t[#t].flags = Ohnb t[#t].value = w[1] if (w[3] == true) then local item = {} item[#item+1] = t[#t] item[#item].freeze = true gg.addListItems(item) end end end gg.setValues(t) else gg.toast("", false) return false end else gg.toast("") return false end end


function split(szFullString, szSeparator) local nFindStartIndex = 1 local nSplitIndex = 1 local nSplitArray = {} while true do local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex) if not nFindLastIndex then nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString)) break end nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1) nFindStartIndex = nFindLastIndex + string.len(szSeparator) nSplitIndex = nSplitIndex + 1 end return nSplitArray end function xgxc(szpy, qmxg) for x = 1, #(qmxg) do xgpy = szpy + qmxg[x]["offset"] xglx = qmxg[x]["type"] xgsz = qmxg[x]["value"] gg.setValues({[1] = {address = xgpy, flags = xglx, value = xgsz}}) xgsl = xgsl + 1 end end function xqmnb(qmnb) gg.clearResults() gg.setRanges(qmnb[1]["memory"]) gg.searchNumber(qmnb[3]["value"], qmnb[3]["type"]) if gg.getResultCount() == 0 then gg.toast(qmnb[2]["name"] .. "")else gg.refineNumber(qmnb[3]["value"], qmnb[3]["type"]) gg.refineNumber(qmnb[3]["value"], qmnb[3]["type"]) gg.refineNumber(qmnb[3]["value"], qmnb[3]["type"]) if gg.getResultCount() == 0 then gg.toast(qmnb[2]["name"] .. "") else sl = gg.getResults(999999) sz = gg.getResultCount() xgsl = 0 if sz > 999999 then sz = 999999 end for i = 1, sz do pdsz = true for v = 4, #(qmnb) do if pdsz == true then pysz = {} pysz[1] = {} pysz[1].address = sl[i].address + qmnb[v]["offset"] pysz[1].flags = qmnb[v]["type"] szpy = gg.getValues(pysz) pdpd = qmnb[v]["lv"] .. ";" .. szpy[1].value szpd = split(pdpd, ";") tzszpd = szpd[1] pyszpd = szpd[2] if tzszpd == pyszpd then pdjg = true pdsz = true else pdjg = false pdsz = false end end end if pdjg == true then szpy = sl[i].address xgxc(szpy, qmxg) xgjg = true end end if xgjg == true then gg.toast(qmnb[2]["name"] .. "" .. xgsl .. "") else gg.toast(qmnb[2]["name"] .. "") end end end end

function SearchWrite(Search, Write, Type) gg.clearResults() gg.setVisible(false) gg.searchNumber(Search[1][1], Type) local count = gg.getResultCount() local result = gg.getResults(count) gg.clearResults() local data = {} local base = Search[1][2] if (count > 0) then for i, v in ipairs(result) do v.isUseful = true end for k=2, #Search do local tmp = {} local offset = Search[k][2] - base local num = Search[k][1] for i, v in ipairs(result) do tmp[#tmp+1] = {} tmp[#tmp].address = v.address + offset tmp[#tmp].flags = v.flags end tmp = gg.getValues(tmp) for i, v in ipairs(tmp) do if ( tostring(v.value) ~= tostring(num) ) then result[i].isUseful = false end end end for i, v in ipairs(result) do if (v.isUseful) then data[#data+1] = v.address end end if (#data > 0) then gg.toast(""..#data.."") local t = {} local base = Search[1][2] for i=1, #data do for k, w in ipairs(Write) do offset = w[2] - base t[#t+1] = {} t[#t].address = data[i] + offset t[#t].flags = Type t[#t].value = w[1] if (w[3] == true) then local item = {} item[#item+1] = t[#t] item[#item].freeze = true gg.addListItems(item) end end end gg.setValues(t) else gg.toast("", false) return false end else gg.toast("") return false end end

--1. function：函数，功能
--2. gg.alert  弹出提示窗口
--3. gg.toast 屏幕下方弹出提示条( 会自动消失 )
--3. gg.prompt 弹出带有控件的提示窗口
--4. gg.choice 弹出单选列表窗口
--5. gg.clearResults 清除搜索结果
--6. gg.editAll 修改搜索结果
--7. gg.getFile 获取当前脚本所在目录
--8. gg.getResults 获取搜索结果
--9. gg.getResultCount 获取搜索结果数量
--10. gg.setRanges 设置搜索内存
--11. gg.isVisible 判断GG界面是否可见
--12. gg.multiChoice 弹出多选列表窗口
--13. gg.processKill 结束当前选定应用
--14. gg.searchNumber 搜索数据 (重要)
--15. gg.setVisible 设置GG界面是否可见--
--16. getline()读取行数
--17. getlocale0荻取地值
--18. getRanges()洪取内存区域内的
--19. getRangeslist)荻取内存区域列表
--20. getResultCount)荻取結果計数
--21. getResultso :荻取結果井加載
--22. getSpeedo荻取加速
--23. getTargetInfo荻取目棕信息
--24. getTargetPackage0荻取迸程包名GG内存
------------------------------------------------
--------内存范围---------↓↓↓
--Jh内存:	['REGION_JAVA_HEAP'] = 2,--
--Ch内存:	['REGION_C_HEAP'] = 1,
--Ca内存:	['REGION_C_ALLOC'] = 4,
--Cd内存:	['REGION_C_DATA'] = 8,
--Cb内存:	['REGION_C_BSS'] = 16,
--Ps内存:['REGION_PPSSPP'] = 262144,
--A内存:	['REGION_ANONYMOUS'] = 32,
--J内存:	['REGION_JAVA'] = 65536,
--S内存:	['REGION_STACK'] = 64,
--As内存:	['REGION_ASHMEM'] = 524288,
--V内存:	['REGION_VIDEO'] = 1048576,
--O内存	['REGION_OTHER'] = -2080896,
--B内存:	['REGION_BAD'] = 131072,
--Xa内存:	['REGION_CODE_APP'] = 16384,
--Xs内存:	['REGION_CODE_SYS'] = 32768,
------------------------------------------------
--------数据类型---------↓↓↓
--A类搜:	['TYPE_AUTO'] = 127,
--B类搜:	['TYPE_BYTE'] = 1,
--E类搜:	['TYPE_DOUBLE'] = 64,
--D类搜:	['TYPE_DWORD'] = 4,
--F类搜:	['TYPE_FLOAT'] = 16,
--Q类搜:	['TYPE_QWORD'] = 32,
--W类搜:	['TYPE_WORD'] = 2,
--X类搜:	['TYPE_XOR'] = 8,




function edit(orig,ret)_om=orig[1].memory or orig[1][1]_ov=orig[3].value or orig[3][1]_on=orig[2].name or orig[2][1]gg.clearResults()gg.setRanges(_om)gg.searchNumber(_ov,orig[3].type or orig[3][2])sz=gg.getResultCount()if sz<1 then gg.toast(_on.." فشل")else sl=gg.getResults(50000)for i=1,sz do ist=true for v=4,#orig do if ist==true and sl[i].value==_ov then cd={{}}cd[1].address=sl[i].address+(orig[v].offset or orig[v][2])cd[1].flags=orig[v].type or orig[v][3]szpy=gg.getValues(cd)cdlv=orig[v].lv or orig[v][1]cdv=szpy[1].value if cdlv==cdv then pdjg=true ist=true else pdjg=false ist=false end end end if pdjg==true then szpy=sl[i].address for x=1,#(ret)do xgpy=szpy+(ret[x].offset or ret[x][2])xglx=ret[x].type or ret[x][3]xgsz=ret[x].value or ret[x][1]xgdj=ret[x].freeze or ret[x][4]xgsj={{address=xgpy,flags=xglx,value=xgsz}}if xgdj==true then xgsj[1].freeze=xgdj gg.addListItems(xgsj)else gg.setValues(xgsj)end end xgjg=true end end if xgjg==true then gg.toast(_on.." 开启成功")else gg.toast(_on.." فشل")end end end

function S_Pointer(t_So, t_Offset, _bit)
	local function getRanges()
		local ranges = {}
		local t = gg.getRangesList('^/data/*.so*$')
		for i, v in pairs(t) do
			if v.type:sub(2, 2) == 'w' then
				table.insert(ranges, v)
			end
		end
		return ranges
	end
	local function Get_Address(N_So, Offset, ti_bit)
		local ti = gg.getTargetInfo()
		local S_list = getRanges()
		local t = {}
		local _t
		local _S = nil
		if ti_bit then
			_t = 32
		 else
			_t = 4
		end
		for i in pairs(S_list) do
			local _N = S_list[i].internalName:gsub('^.*/', '')
			if N_So[1] == _N and N_So[2] == S_list[i].state then
				_S = S_list[i]
				break
			end
		end
		if _S then
			t[#t + 1] = {}
			t[#t].address = _S.start + Offset[1]
			t[#t].flags = _t
			if #Offset ~= 1 then
				for i = 2, #Offset do
					local S = gg.getValues(t)
					t = {}
					for _ in pairs(S) do
						if not ti.x64 then
							S[_].value = S[_].value & 0xFFFFFFFF
						end
						t[#t + 1] = {}
						t[#t].address = S[_].value + Offset[i]
						t[#t].flags = _t
					end
				end
			end
			_S = t[#t].address
		end
		return _S
	end
	local _A = string.format('0x%X', Get_Address(t_So, t_Offset, _bit))
	return _A
end


local loadcode = false
local loadcod = false
local loadcodd = false
function split(szFullString, szSeparator)
local nFindStartIndex = 1 
local nSplitIndex = 1 
local nSplitArray = {} while true do 
local 
nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex) 
if not nFindLastIndex then 
nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString)) 
break end 
nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1) 
nFindStartIndex = nFindLastIndex + string.len(szSeparator) 
nSplitIndex = nSplitIndex + 1 end return 
nSplitArray end function 
xgxc(szpy, qmxg) for x = 1, #(qmxg) do 
xgpy = szpy + qmxg[x]["offset"] xglx = qmxg[x]["type"] 
xgsz = qmxg[x]["value"] 
gg.setValues({[1] = {address = xgpy, flags = xglx, value = xgsz}}) 
xgsl = xgsl + 1 end end function 
xqmnb(qmnb) 
gg.clearResults() 
gg.setRanges(qmnb[1]["memory"]) 
gg.searchNumber(qmnb[3]["value"], qmnb[3]["type"]) 
if gg.getResultCount() == 0 then 
gg.toast(qmnb[2]["name"] .. "臭宝")
else 
gg.refineNumber(qmnb[3]["value"], qmnb[3]["type"]) 
gg.refineNumber(qmnb[3]["value"], qmnb[3]["type"]) 
gg.refineNumber(qmnb[3]["value"], qmnb[3]["type"]) 
if gg.getResultCount() == 0 then 
gg.toast(qmnb[2]["name"] .. "@ZerroHack") 
else 
sl = gg.getResults(999999) 
sz = gg.getResultCount() 
xgsl = 0 if sz > 999999 then 
sz = 999999 end for i = 1, sz do 
pdsz = true for v = 4, #(qmnb) do if 
pdsz == true then 
pysz = {} pysz[1] = {} pysz[1].address = sl[i].address + qmnb[v]["offset"] 
pysz[1].flags = qmnb[v]["type"] 
szpy = gg.getValues(pysz) 
pdpd = qmnb[v]["lv"] .. ";" .. szpy[1].value szpd = split(pdpd, ";") 
tzszpd = szpd[1] 
pyszpd = szpd[2] 
if tzszpd == pyszpd then 
pdjg = true pdsz = true else 
pdjg = false pdsz = false end end end 
if pdjg == true then 
szpy = sl[i].address xgxc(szpy, qmxg) 
xgjg = true end end 
if xgjg == true then 
gg.toast(qmnb[2]["name"] .. "👑👑" .. xgsl .. "🗡️🗡️") 
else 
gg.toast(qmnb[2]["name"] .. "💎💎") 
end 
end 
end 
end

function SHCF()
os.exit()
SHCF()
end
dog=0
CS=0 
function SH_searchNumber(n,type,ft,sign,r,s)
gg.setVisible(false) 
gg.searchNumber(n,type,ft,sign,r,s)
if gg.isVisible(true) then
dog=1
gg.setVisible(false) 
end 
if dog > 0 then
gg.toast('HAY')
nc()
dog = 0
CS=CS-1
end
if CS < 0 then
SHCF()
end
end


function Voice(Rain)

end



local _KY,jldz,jmzj=function(mtz,mzj)for xh=1,10 do mtz=mtz:gsub(mzj[xh],xh-1)end return mtz end,{},{}for xh=1,10 do jmzj[xh]=debug.getinfo(_KY)[string.char(115,111,117,114,99,101)]:sub(xh,xh)end function KYXG(DZ,XGSJ,GNM,JLDZ)local t={}for i=1,#DZ do for k,w in ipairs(XGSJ) do offset=w[1]*4 t[#t+1]={}t[#t].address=DZ[i]+offset t[#t].flags=w[2]t[#t].value=w[3]if(w[4]==true)then local item={}item[#item+1]=t[#t]item[#item].freeze=true gg.addListItems(item)end end end gg.setValues(t)gg.toast("开启成功")end function KY_ZZ(NCLX,SSSJ,XGSJ,GNM)gg.setVisible(false)if jldz[NCLX[4]]==nil then gg.clearResults()gg.setRanges(NCLX[1])gg.searchNumber(NCLX[2],NCLX[3])local count=gg.getResultCount()local result=gg.getResults(count)gg.clearResults()local data={}if(count>0)then for i,v in ipairs(result) do v.isUseful=true end for k=1,#SSSJ do local tmp={}local offset=_KY(SSSJ[k][1],jmzj)*4 local num=_KY(SSSJ[k][2],jmzj)for i,v in ipairs(result) do tmp[#tmp+1]={}tmp[#tmp].address=v.address+offset tmp[#tmp].flags=v.flags end tmp=gg.getValues(tmp)for i,v in ipairs(tmp) do if (v.value~=num)then result[i].isUseful=false end end end for i,v in ipairs(result) do if (v.isUseful)then data[#data+1]=v.address end end if data[1]==nil then gg.toast("开启成功")else if NCLX[4]~=false then jldz[NCLX[4]]=data KYXG(data,XGSJ,GNM,"已记录")else KYXG(data,XGSJ,GNM,"搜索到")end end else gg.toast("فشل")end else KYXG(jldz[NCLX[4]],XGSJ,GNM,"调用到")end end




function SearchWrite(Search, Write, Type) gg.clearResults()gg.setVisible(false) gg.searchNumber(Search[1][1]*-1,Type) local count = gg.getResultCount() local result = gg.getResults(count)gg.clearResults() local data = {} local base = Search[1][2] if (count > 0) then for i, v in ipairs(result) do v.isUseful = true end for k=2, #Search do  local tmp = {}local offset = Search[k][2] - base  local num = Search[k][1]for i, v in ipairs(result) do tmp[#tmp+1] = {}tmp[#tmp].address = v.address + offset tmp[#tmp].flags = v.flags end tmp = gg.getValues(tmp)for i, v in ipairs(tmp) do if ( tostring(v.value) ~= tostring(num) ) then result[i].isUseful = false end end end for i, v in ipairs(result) do if (v.isUseful) then data[#data+1] = v.address end end if (#data > 0) then local t = {}local base = Search[1][2]for i=1, #data do for k, w in ipairs(Write) do offset = w[2] - base t[#t+1] = {}t[#t].address = data[i] + offset t[#t].flags = Type t[#t].value = w[1]if (w[3] == true) then local item = {}item[#item+1] = t[#t]item[#item].freeze = true gg.addListItems(item) end end end gg.setValues(t)gg.toast("注入成功")else  return false end else  return false end end  

function SearchWriteohnb(Search, Write, Ohnb) gg.clearResults() gg.setVisible(false) SH_searchNumber(Search[1][1], Ohnb) local count = gg.getResultCount() local result = gg.getResults(count) gg.clearResults() local data = {} local base = Search[1][2] if (count > 0) then for i, v in ipairs(result) do v.isUseful = true end for k=2, #Search do local tmp = {} local offset = Search[k][2] - base local num = Search[k][1] for i, v in ipairs(result) do tmp[#tmp+1] = {} tmp[#tmp].address = v.address + offset tmp[#tmp].flags = v.flags end tmp = gg.getValues(tmp) for i, v in ipairs(tmp) do if ( tostring(v.value) ~= tostring(num) ) then result[i].isUseful = false end end end for i, v in ipairs(result) do if (v.isUseful) then data[#data+1] = v.address end end if (#data > 0) then gg.toast("تراجع"..#data.."تم") local t = {} local base = Search[1][2] for i=1, #data do for k, w in ipairs(Write) do offset = w[2] - base t[#t+1] = {} t[#t].address = data[i] + offset t[#t].flags = Ohnb t[#t].value = w[1] if (w[3] == true) then local item = {} item[#item+1] = t[#t] item[#item].freeze = true gg.addListItems(item) end end end gg.setValues(t) else gg.toast("جاري", false) return false end else gg.toast("جاري") return false end end


function split(szFullString, szSeparator) local nFindStartIndex = 1 local nSplitIndex = 1 local nSplitArray = {} while true do local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex) if not nFindLastIndex then nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString)) break end nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1) nFindStartIndex = nFindLastIndex + string.len(szSeparator) nSplitIndex = nSplitIndex + 1 end return nSplitArray end function xgxc(szpy, qmxg) for x = 1, #(qmxg) do xgpy = szpy + qmxg[x]["offset"] xglx = qmxg[x]["type"] xgsz = qmxg[x]["value"] gg.setValues({[1] = {address = xgpy, flags = xglx, value = xgsz}}) xgsl = xgsl + 1 end end function xqmnb(qmnb) gg.clearResults() gg.setRanges(qmnb[1]["memory"]) gg.searchNumber(qmnb[3]["value"], qmnb[3]["type"]) if gg.getResultCount() == 0 then gg.toast(qmnb[2]["name"] .. "....")else gg.refineNumber(qmnb[3]["value"], qmnb[3]["type"]) gg.refineNumber(qmnb[3]["value"], qmnb[3]["type"]) gg.refineNumber(qmnb[3]["value"], qmnb[3]["type"]) if gg.getResultCount() == 0 then gg.toast(qmnb[2]["name"] .. "....") else sl = gg.getResults(999999) sz = gg.getResultCount() xgsl = 0 if sz > 999999 then sz = 999999 end for i = 1, sz do pdsz = true for v = 4, #(qmnb) do if pdsz == true then pysz = {} pysz[1] = {} pysz[1].address = sl[i].address + qmnb[v]["offset"] pysz[1].flags = qmnb[v]["type"] szpy = gg.getValues(pysz) pdpd = qmnb[v]["lv"] .. ";" .. szpy[1].value szpd = split(pdpd, ";") tzszpd = szpd[1] pyszpd = szpd[2] if tzszpd == pyszpd then pdjg = true pdsz = true else pdjg = false pdsz = false end end end if pdjg == true then szpy = sl[i].address xgxc(szpy, qmxg) xgjg = true end end if xgjg == true then gg.toast(qmnb[2]["name"] .. "تم" .. xgsl .. "تحميل البيانات") else gg.toast(qmnb[2]["name"] .. "....") end end end end

function SearchWrite(Search, Write, Type) gg.clearResults() gg.setVisible(false) gg.searchNumber(Search[1][1], Type) local count = gg.getResultCount() local result = gg.getResults(count) gg.clearResults() local data = {} local base = Search[1][2] if (count > 0) then for i, v in ipairs(result) do v.isUseful = true end for k=2, #Search do local tmp = {} local offset = Search[k][2] - base local num = Search[k][1] for i, v in ipairs(result) do tmp[#tmp+1] = {} tmp[#tmp].address = v.address + offset tmp[#tmp].flags = v.flags end tmp = gg.getValues(tmp) for i, v in ipairs(tmp) do if ( tostring(v.value) ~= tostring(num) ) then result[i].isUseful = false end end end for i, v in ipairs(result) do if (v.isUseful) then data[#data+1] = v.address end end if (#data > 0) then gg.toast("🙈"..#data.."🙉") local t = {} local base = Search[1][2] for i=1, #data do for k, w in ipairs(Write) do offset = w[2] - base t[#t+1] = {} t[#t].address = data[i] + offset t[#t].flags = Type t[#t].value = w[1] if (w[3] == true) then local item = {} item[#item+1] = t[#t] item[#item].freeze = true gg.addListItems(item) end end end gg.setValues(t) else gg.toast("🙊", false) return false end else gg.toast("🐵") return false end end




























------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------التفعيلات

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------التفعيلات
HOME = function() 
HM = gg.choice({
"〔العربية〕",
"〔المفتاح والتواصل〕", 
"〔خروج〕",
}, nil, os.date('【 HoLaCu Hack 】 \n  Version【1.0】 \n  [%d/%m/%y | %X] '))

if HM == 1 then 
phpd()
end
if HM == 2 then 
A2()
end
if HM == 3 then 
Ext()end
XXS = -1
end

function TAFE () 
GHN = gg.choice({
"〔تفعيلات الناسخ💯〕",
"〔اتفعيلات الروت فقط 💢〕", 
"〔رجوع〕",
}, nil, os.date('【 HoLaCu Hack 】 \n  Version【1.0】 \n  [%d/%m/%y | %X] '))

if GHN == 1 then phpd() end
if GHN == 2 then Root7()end
if GHN == 3 then HOME() end
GLWW=-1
end

function A1()
Kkk = gg.multiChoice({
"〔انتينا🗼〕",
"〔لون ابيض🐻‍❄️〕", 
"〔🅾جاري التطوير🅾〕",
"〔طيران الفاونديشن🏗️〕", 
"〔النزول تحت الارض♨️ 〕",
"〔ليل نهار🌇〕",
"〔سرعة الاعب🤸〕", 
"〔المشي فوق الماء🤽〕",
"〔اختراق المباني🚧〕",
"〔اختراق ابواب المنزل🧞〕",
"〔🅾جاري التطوير🅾〕",
"〔🅾جاري التطوير🅾〕",
"〔رجوع 🔙〕",
	},nil, os.date(" HoLaCu Hack \n My Account:@RAIZO_RZ  \n [%d/%m/%y | %X] "))
 if Kkk == nil then else 
if Kkk [1] ==  true then anten() end
if Kkk [2] ==  true then pers() end
if Kkk [3] ==  true then sf()end
if Kkk [4] ==  true then fly() end
if Kkk [5] ==  true then select() end
if Kkk [6] ==  true then day() end
if Kkk [7] ==  true then speed() end
if Kkk [8] ==  true then swim() end
if Kkk [9] ==  true then wallhack()end
if Kkk [10] ==  true then A10()end
if Kkk [11] ==  true then A11()end
if Kkk [12] ==  true then A12()end
if Kkk [13] ==  true then  phpd()
end
end
end


function phpd()
potor = gg.choice({
"〔🤸تفعيلات الشخصية🤸〕",
"〔🔫تفعيلات السلاح🔫〕", 
"〔رجوع🔙〕",
}, nil, os.date('【 HoLaCu Hack 】 \n  Version【1.0】 \n  [%d/%m/%y | %X] '))

if potor == 1 then A1() end
if potor == 2 then lool()end
if potor == 3 then HOME () end

end


function lool()
love = gg.choice({
"〔🔫 ثبات سلاح💥〕",
"〔🔫ضرب سريع💥〕",
"〔🔫لوفي💥〕", 
"〔🔫تبديل طلق سريع💥〕",
"〔🔫ايم بوت💥〕", 
"〔🔫طلق سحري☠️〕", 
"〔رجوع🔙〕",
}, nil, os.date('【 HoLaCu Hack 】 \n  Version【1.0】 \n  [%d/%m/%y | %X] '))

if love == 1 then all() end
if love == 2 then speedbulet()end
if love == 3 then AIM() end
if love == 4 then fastchang() end
if love == 5 then aimlok()end
if lobe == 6 then KRAM() end
if love == 7 then phpd() end

GLWW=-1
end
function AIM() 
kjk = gg.choice({
'🇸🇾[سكوب يدوي]🇸🇾',
'🇸🇾[سكوب في السماء]🇸🇾',
'🇸🇾[سكوب تحت الخريطة(غير امن)]🇸🇾',
'رجوع🔙'},
nil,'[اذا ما اشتغلن اطلع من السكربت و ارجع ادخل]')
if kjk == 1 then bar() end
if kjk == 2 then cao() end
if kjk == 3 then dow() end
if kjk == 4 then lool() end
GLWW=-1
end


function KRAM()
SN7 = gg.choice({
"☠️┣ Магические пули 30% [No ban]",
"☠️┣ Магические пули 90%+45%💀",
"☠️┣ Магические пули 200% Head 🆕",
"❎Выход❎",
}, nil,"┣【Новая версия 3.0 Автор @ZerroHack】┫")
if SN7 == 1 then 
IO()
end
if SN7 == 2 then 
OI()
end
if SN7 == 3 then 
IK()
end
if SN7 == 3 then
HOME()
end
XGCK = -1
end
function bar()
Q = gg.prompt({"بدون سكوب: [-50;80] "},{0},{"number"})
if Q == nil then return else
qmnb = {
{["memory"] = 32},
{["name"] = "ON"},
{["value"] = 400.0, ["type"] = 16},
{["lv"] = 8.0, ["offset"] = -8, ["type"] = 16},
{["lv"] = 2.0, ["offset"] = -4, ["type"] = 16},
}
qmxg = {
{["value"] = Q[1], ["offset"] = 56, ["type"] = 16},

}
xqmnb(qmnb)
end
end

function cao()
F = gg.alert("اطلاق في السماء", "سكوب","تعطيل","بدون سكوب") 
    if F == 1 then 
qmnb = {
{["memory"] = 32},
{["name"] = "ON"},
{["value"] = 400.0, ["type"] = 16},
{["lv"] = 8.0, ["offset"] = -8, ["type"] = 16},
{["lv"] = 2.0, ["offset"] = -4, ["type"] = 16},
{["lv"] = 0.0, ["offset"] = 48, ["type"] = 16},
}
qmxg = {
{["value"] = -0.9123456789, ["offset"] = 48, ["type"] = 16},

}
xqmnb(qmnb) 
elseif F == 2 then 
gg.clearResults()
gg.setRanges(32)
gg.searchNumber("0.9123456789", gg.TYPE_FLOAT)
gg.getResults(900)
gg.editAll("0", gg.TYPE_FLOAT)
gg.clearResults()
gg.setRanges(32)
gg.searchNumber("-0.9123456789", gg.TYPE_FLOAT)
gg.getResults(900)
gg.editAll("0", gg.TYPE_FLOAT)
gg.clearResults()
elseif F == 3 then 
qmnb = {
{["memory"] = 32},
{["name"] = "ON"},
{["value"] = 400.0, ["type"] = 16},
{["lv"] = 8.0, ["offset"] = -8, ["type"] = 16},
{["lv"] = 2.0, ["offset"] = -4, ["type"] = 16},
{["lv"] = 0.0, ["offset"] = 56, ["type"] = 16},
}
qmxg = {
{["value"] = 0.9123456789, ["offset"] = 56, ["type"] = 16},

}
xqmnb(qmnb) 
end 
end

function dow()
F = gg.alert("سكوب تحت الارض", "سجوب","OFF","بدون سكوب")
    if F == 1 then
qmnb = {
{["memory"] = 32},
{["name"] = "ON"},
{["value"] = 400.0, ["type"] = 16},
{["lv"] = 8.0, ["offset"] = -8, ["type"] = 16},
{["lv"] = 2.0, ["offset"] = -4, ["type"] = 16},
{["lv"] = 0.0, ["offset"] = 48, ["type"] = 16},
}
qmxg = {
{["value"] = 3.40123456, ["offset"] = 48, ["type"] = 16},

}
xqmnb(qmnb)
elseif F == 2 then
gg.clearResults()
gg.setRanges(32)
gg.searchNumber("3.40123456", gg.TYPE_FLOAT)
gg.getResults(900)
gg.editAll("0", gg.TYPE_FLOAT)
gg.clearResults()
gg.setRanges(32)
gg.searchNumber("-3.40123456", gg.TYPE_FLOAT)
gg.getResults(900)
gg.editAll("0", gg.TYPE_FLOAT)
gg.clearResults()
elseif F == 3 then
qmnb = {
{["memory"] = 32},
{["name"] = "ON"},
{["value"] = 400.0, ["type"] = 16},
{["lv"] = 8.0, ["offset"] = -8, ["type"] = 16},
{["lv"] = 2.0, ["offset"] = -4, ["type"] = 16},
{["lv"] = 0.0, ["offset"] = 56, ["type"] = 16},
}
qmxg = {
{["value"] = -3.40123456, ["offset"] = 56, ["type"] = 16},

}
xqmnb(qmnb)
end
end

function speedbulet()

F = gg.alert("ضرب طلق سريع ", "X8","تعطيل","X4")

    if F == 1 then
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("2.51061000005", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.refineNumber("2.51061000005",16,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(1000)
    gg.editAll("0.00100000005",16)

    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("0.00061000005", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.refineNumber("0.00061000005",16,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(1000)
    gg.editAll("0.00100000005",16)
    
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("0.00100000005", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.refineNumber("0.00100000005",16,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(1000)
    gg.editAll("0.00005120005",16)

    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_SYS)
    gg.searchNumber("2.51061000005", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.refineNumber("2.51061000005",16,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(1000)
    gg.editAll("0.00100000005",16)

    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_SYS)
    gg.searchNumber("0.00061000005", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.refineNumber("0.00061000005",16,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(1000)
    gg.editAll("0.00100000005",16)
    
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_SYS)
    gg.searchNumber("0.00100000005", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.refineNumber("0.00100000005",16,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(1000)
    gg.editAll("0.00005120005",16)
    elseif F == 2 then
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("0.00061000005", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.refineNumber("0.00061000005",16,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(1000)
    gg.editAll("0.00100000005",16)
    
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("0.00005120005", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.refineNumber("0.00005120005",16,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(1000)
    gg.editAll("0.00100000005",16)
  
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_SYS)
    gg.searchNumber("0.00061000005", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.refineNumber("0.00061000005",16,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(1000)
    gg.editAll("0.00100000005",16)
    
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_SYS)
    gg.searchNumber("0.00005120005", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.refineNumber("0.00005120005",16,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(1000)
    gg.editAll("0.00100000005",16)
    
    elseif F == 3 then
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("0.00005120005", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.refineNumber("0.00005120005",16,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(1000)
    gg.editAll("0.00100000005",16)
    
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("2.51061000005", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.refineNumber("2.51061000005",16,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(1000)
    gg.editAll("0.00100000005",16)
    
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("0.00100000005", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.refineNumber("0.00100000005",16,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(1000)
    gg.editAll("0.00061000005",16)

    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_SYS)
    gg.searchNumber("0.00005120005", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.refineNumber("0.00005120005",16,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(1000)
    gg.editAll("0.00100000005",16)
    
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_SYS)
    gg.searchNumber("2.51061000005", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.refineNumber("2.51061000005",16,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(1000)
    gg.editAll("0.00100000005",16)
    
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_SYS)
    gg.searchNumber("0.00100000005", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.refineNumber("0.00100000005",16,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(1000)
    gg.editAll("0.00061000005",16)
end
end

function fastchang()      
    gg.clearResults()
    gg.setRanges(32)
    gg.searchNumber("2.10000014305", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.refineNumber("2.10000014305",16,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(10000)
    gg.editAll("1.3",16)
    gg.toast("50%")
    gg.clearResults()
    gg.setRanges(32)
    gg.searchNumber("1.23314265e-42;1.9~5.5;7.93134931e-43", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.refineNumber("1.9~5.5",16,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(10000)
    gg.editAll("0.0000001",16)
    gg.toast("100% Fast chang")
    gg.clearResults()
    gg.setRanges(32)
    gg.searchNumber("2.83333349228;880D", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.refineNumber("2.83333349228",16,false,gg.SIGN_EQUAL,0,-1)
    gg.getResults(10000)
    gg.editAll("0.00000001",16)
    gg.toast("تم التفعيل")
    gg.clearResults()
end
function aimlok()
F = gg.alert("ايم بوت", "تشغيل","تعطيل") 
    if F == 1 then 
gg.clearResults()
gg.setRanges(gg.REGION_CODE_SYS)
gg.searchNumber("-6.171913993364983E27;-1.0061304023208683E28;-1.220370790326068E21", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
    gg.refineNumber("-1.0061304023208683E28", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
    gg.getResults(9990)
    gg.editAll("10.000123456789", gg.TYPE_FLOAT)
    gg.clearResults()
    
    gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("-6.171913993364983E27;-1.0061304023208683E28;-1.220370790326068E21", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
    gg.refineNumber("-1.0061304023208683E28", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
    gg.getResults(9990)
    gg.editAll("10.000123456789", gg.TYPE_FLOAT)
    gg.clearResults()
elseif F == 2 then
gg.clearResults()
gg.setRanges(gg.REGION_CODE_SYS)
gg.searchNumber("10.000123456789", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
    gg.refineNumber("10.000123456789", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
    gg.getResults(9990)
    gg.editAll("-1.0061304023208683E28", gg.TYPE_FLOAT)
    gg.clearResults()
    
    gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("10.000123456789", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
    gg.refineNumber("10.000123456789", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
    gg.getResults(9990)
    gg.editAll("-1.0061304023208683E28", gg.TYPE_FLOAT)
    gg.clearResults()
end
end
function all()
qmnb = {
{["memory"] = 32},
{["name"] = "[ M4 ] تم تفعيل"},
{["value"] = 830.0, ["type"] = 16},
{["lv"] = 12.0, ["offset"] = -148, ["type"] = 16},
{["lv"] = 24.0, ["offset"] = -144, ["type"] = 16},
{["lv"] = 45.0, ["offset"] = -140, ["type"] = 16},
{["lv"] = 3.5, ["offset"] = -124, ["type"] = 16},
{["lv"] = 4.0, ["offset"] = 16, ["type"] = 16},
{["lv"] = 4.0, ["offset"] = 24, ["type"] = 16},
}
qmxg = {
{["value"] = 99999, ["offset"] = 0, ["type"] = 16},
{["value"] = 0, ["offset"] = -148, ["type"] = 16},
{["value"] = 0, ["offset"] = -144, ["type"] = 16},
{["value"] = 0, ["offset"] = -140, ["type"] = 16},
{["value"] = 1, ["offset"] = -136, ["type"] = 16},
{["value"] = 0, ["offset"] = -124, ["type"] = 16},
{["value"] = 0, ["offset"] = 16, ["type"] = 16},
{["value"] = 0, ["offset"] = 24, ["type"] = 16},
}
xqmnb(qmnb)

qmnb = {
{["memory"] = 32},
{["name"] = "[Akm M762] تم تفعيل"},
{["value"] = 735.0, ["type"] = 16},
{["lv"] = 50.0, ["offset"] = -140, ["type"] = 16},
}
qmxg = {
{["value"] = 99999, ["offset"] = 0, ["type"] = 16},
{["value"] = 0, ["offset"] = -148, ["type"] = 16},
{["value"] = 0, ["offset"] = -144, ["type"] = 16},
{["value"] = 0, ["offset"] = -140, ["type"] = 16},
{["value"] = 0, ["offset"] = -136, ["type"] = 16},
{["value"] = 0, ["offset"] = -124, ["type"] = 16},
{["value"] = 0, ["offset"] = 16, ["type"] = 16},
{["value"] = 0, ["offset"] = 24, ["type"] = 16},
}
xqmnb(qmnb)

qmnb = {
{["memory"] = 32},
{["name"] = "[ Qbz ] تم تفعيل"},
{["value"] = 790.0, ["type"] = 16},
{["lv"] = 12.0, ["offset"] = -148, ["type"] = 16},
{["lv"] = 27.0, ["offset"] = -144, ["type"] = 16},
{["lv"] = 45.0, ["offset"] = -140, ["type"] = 16},
{["lv"] = 3.5, ["offset"] = -124, ["type"] = 16},
{["lv"] = 4.0, ["offset"] = 16, ["type"] = 16},
{["lv"] = 4.0, ["offset"] = 24, ["type"] = 16},
}
qmxg = {
{["value"] = 99999, ["offset"] = 0, ["type"] = 16},
{["value"] = 0, ["offset"] = -148, ["type"] = 16},
{["value"] = 0, ["offset"] = -144, ["type"] = 16},
{["value"] = 0, ["offset"] = -140, ["type"] = 16},
{["value"] = 0, ["offset"] = -136, ["type"] = 16},
{["value"] = 0, ["offset"] = -124, ["type"] = 16},
{["value"] = 0, ["offset"] = 16, ["type"] = 16},
{["value"] = 0, ["offset"] = 24, ["type"] = 16},
}
xqmnb(qmnb)

qmnb = {
{["memory"] = 32},
{["name"] = "[ M249 ] تم تفعيل"},
{["value"] = 480.0, ["type"] = 16},
{["lv"] = 20.0, ["offset"] = -148, ["type"] = 16},
{["lv"] = 40.0, ["offset"] = -144, ["type"] = 16},
{["lv"] = 55.0, ["offset"] = -140, ["type"] = 16},
{["lv"] = 10.0, ["offset"] = -124, ["type"] = 16},
{["lv"] = 7.0, ["offset"] = 16, ["type"] = 16},
{["lv"] = 10.0, ["offset"] = 24, ["type"] = 16},
}
qmxg = {
{["value"] = 99999, ["offset"] = 0, ["type"] = 16},
{["value"] = 0, ["offset"] = -148, ["type"] = 16},
{["value"] = 0, ["offset"] = -144, ["type"] = 16},
{["value"] = 0, ["offset"] = -140, ["type"] = 16},
{["value"] = 0, ["offset"] = -136, ["type"] = 16},
{["value"] = 0, ["offset"] = -124, ["type"] = 16},
{["value"] = 0, ["offset"] = 16, ["type"] = 16},
{["value"] = 0, ["offset"] = 24, ["type"] = 16},
}
xqmnb(qmnb)
  
  qmnb = {
 {memory = 32},
    {
      name = "[ Lewis ] تم تفعيل"},
    {value = "480.0", type = 16},
    {lv = "20.0",offset = -148,type = 16},
    {lv = "40.0",offset = -144,type = 16},
    {lv = "6.0",offset = -136,type = 16},
    {lv = "60.0",offset = -120,type = 16},
    {lv = "0.5",offset = -100,type = 16},
    {lv = "4.0",offset = 16,type = 16},
    {lv = "4.0",offset = 24,type = 16},
    {lv = "1.0",offset = 160,type = 16}}
  qmxg = {
 {value = 0,offset = -148,type = 16},
    {value = 0,offset = -144,type = 16},
    {value = 0,offset = -140,type = 16},
    {value = 0,offset = -136,type = 16},
    {value = 0,offset = -120,type = 16},
    {value = 0,offset = -100,type = 16},
    {value = 99999,offset = 0,type = 16},
    {value = 0,offset = 16,type = 16},
    {value = 0,offset = 24,type = 16},
    {value = 0,offset = 160,type = 16}}

xqmnb(qmnb)

qmnb = {
{["memory"] = 32},
{["name"] = "[ Smg ] تم تفعيل"},
{["value"] = 300.0, ["type"] = 16},
{["lv"] = 15.0, ["offset"] = -148, ["type"] = 16},
{["lv"] = 32.0, ["offset"] = -144, ["type"] = 16},
{["lv"] = 44.0, ["offset"] = -140, ["type"] = 16},
{["lv"] = 2.5, ["offset"] = -124, ["type"] = 16},
{["lv"] = 4.0, ["offset"] = 16, ["type"] = 16},
{["lv"] = 4.0, ["offset"] = 24, ["type"] = 16},
}
qmxg = {
{["value"] = 99999, ["offset"] = 0, ["type"] = 16},
{["value"] = 0, ["offset"] = -148, ["type"] = 16},
{["value"] = 0, ["offset"] = -144, ["type"] = 16},
{["value"] = 0, ["offset"] = -140, ["type"] = 16},
{["value"] = 0, ["offset"] = -136, ["type"] = 16},
{["value"] = 0, ["offset"] = -124, ["type"] = 16},
{["value"] = 0, ["offset"] = 16, ["type"] = 16},
{["value"] = 0, ["offset"] = 24, ["type"] = 16},
}
xqmnb(qmnb)

qmnb = {
{["memory"] = 32},
{["name"] = "[ Uzi ] تم تفعيل"},
{["value"] = 320.0, ["type"] = 16},
{["lv"] = 16.0, ["offset"] = -148, ["type"] = 16},
{["lv"] = 34.0, ["offset"] = -144, ["type"] = 16},
{["lv"] = 42.0, ["offset"] = -140, ["type"] = 16},
{["lv"] = 3.0, ["offset"] = -124, ["type"] = 16},
{["lv"] = 4.0, ["offset"] = 16, ["type"] = 16},
{["lv"] = 4.0, ["offset"] = 24, ["type"] = 16},
}
qmxg = {
{["value"] = 99999, ["offset"] = 0, ["type"] = 16},
{["value"] = 0, ["offset"] = -148, ["type"] = 16},
{["value"] = 0, ["offset"] = -144, ["type"] = 16},
{["value"] = 0, ["offset"] = -140, ["type"] = 16},
{["value"] = 0, ["offset"] = -136, ["type"] = 16},
{["value"] = 0, ["offset"] = -124, ["type"] = 16},
{["value"] = 0, ["offset"] = 16, ["type"] = 16},
{["value"] = 0, ["offset"] = 24, ["type"] = 16},
}
xqmnb(qmnb)

qmnb = {
{["memory"] = 32},
{["name"] = "[ Famas ] تم تفعيل"},
{["value"] = 360.0, ["type"] = 16},
{["lv"] = 14.0, ["offset"] = -148, ["type"] = 16},
{["lv"] = 30.0, ["offset"] = -144, ["type"] = 16},
{["lv"] = 42.0, ["offset"] = -140, ["type"] = 16},
{["lv"] = 2.5, ["offset"] = -124, ["type"] = 16},
{["lv"] = 4.0, ["offset"] = 16, ["type"] = 16},
{["lv"] = 4.0, ["offset"] = 24, ["type"] = 16},
}
qmxg = {
{["value"] = 99999, ["offset"] = 0, ["type"] = 16},
{["value"] = 0, ["offset"] = -148, ["type"] = 16},
{["value"] = 0, ["offset"] = -144, ["type"] = 16},
{["value"] = 0, ["offset"] = -140, ["type"] = 16},
{["value"] = 0, ["offset"] = -136, ["type"] = 16},
{["value"] = 0, ["offset"] = -124, ["type"] = 16},
{["value"] = 0, ["offset"] = 16, ["type"] = 16},
{["value"] = 0, ["offset"] = 24, ["type"] = 16},
}
xqmnb(qmnb)

qmnb = {
{["memory"] = 32},
{["name"] = "[ Bazoka ] تم تفعيل"},
{["value"] = 278.0, ["type"] = 16},
{["lv"] = 15.0, ["offset"] = -196, ["type"] = 16},
{["lv"] = 30.0, ["offset"] = -192, ["type"] = 16},
{["lv"] = 45.0, ["offset"] = -188, ["type"] = 16},
{["lv"] = 35.0, ["offset"] = -172, ["type"] = 16},
{["lv"] = 4.0, ["offset"] = -84, ["type"] = 16},
{["lv"] = 4.0, ["offset"] = -80, ["type"] = 16},
{["lv"] = 40.0, ["offset"] = -48, ["type"] = 16},
{["lv"] = 20.0, ["offset"] = -32, ["type"] = 16},
{["lv"] = 10.0, ["offset"] = -24, ["type"] = 16},
}
qmxg = {
{["value"] = 0, ["offset"] = -196, ["type"] = 16},
{["value"] = 0, ["offset"] = -192, ["type"] = 16},
{["value"] = 0, ["offset"] = -188, ["type"] = 16},
{["value"] = 0, ["offset"] = -172, ["type"] = 16},
{["value"] = 0, ["offset"] = -84, ["type"] = 16},
{["value"] = 0, ["offset"] = -80, ["type"] = 16},
{["value"] = 99999, ["offset"] = -48, ["type"] = 16},
{["value"] = 0, ["offset"] = -32, ["type"] = 16},
{["value"] = 0, ["offset"] = -24, ["type"] = 16},
}
xqmnb(qmnb)

qmnb = {
{["memory"] = 32},
{["name"] = "[ Grenade Launcher ] تم تفعيل"},
{["value"] = 400.0, ["type"] = 16},
{["lv"] = 24.0, ["offset"] = -188, ["type"] = 16},
{["lv"] = 24.0, ["offset"] = -184, ["type"] = 16},
{["lv"] = 24.0, ["offset"] = -180, ["type"] = 16},
{["lv"] = 35.0, ["offset"] = -164, ["type"] = 16},
{["lv"] = 4.0, ["offset"] = -76, ["type"] = 16},
{["lv"] = 4.0, ["offset"] = -72, ["type"] = 16},
{["lv"] = 25.0, ["offset"] = -40, ["type"] = 16},
{["lv"] = 20.0, ["offset"] = -24, ["type"] = 16},
{["lv"] = 10.0, ["offset"] = -12, ["type"] = 16},
}
qmxg = {
{["value"] = 0, ["offset"] = -188, ["type"] = 16},
{["value"] = 0, ["offset"] = -184, ["type"] = 16},
{["value"] = 0, ["offset"] = -180, ["type"] = 16},
{["value"] = 0, ["offset"] = -164, ["type"] = 16},
{["value"] = 0, ["offset"] = -76, ["type"] = 16},
{["value"] = 0, ["offset"] = -72, ["type"] = 16},
{["value"] = 99999, ["offset"] = -40, ["type"] = 16},
{["value"] = 0, ["offset"] = -24, ["type"] = 16},
{["value"] = 0, ["offset"] = -12, ["type"] = 16},
}
xqmnb(qmnb)

qmnb = {
{["memory"] = 32},
{["name"] = "[ Mini-14 ] تم تفعيل"},
{["value"] = 830.0, ["type"] = 16},
{["lv"] = 13.0, ["offset"] = -148, ["type"] = 16},
{["lv"] = 33.0, ["offset"] = -144, ["type"] = 16},
{["lv"] = 50.0, ["offset"] = -140, ["type"] = 16},
{["lv"] = 6.0, ["offset"] = -136, ["type"] = 16},
{["lv"] = 4.0, ["offset"] = 16, ["type"] = 16},
{["lv"] = 4.0, ["offset"] = 24, ["type"] = 16},
}
qmxg = {
{["value"] = 99999, ["offset"] = 0, ["type"] = 16},
{["value"] = 0, ["offset"] = -148, ["type"] = 16},
{["value"] = 0, ["offset"] = -144, ["type"] = 16},
{["value"] = 0, ["offset"] = -140, ["type"] = 16},
{["value"] = 0, ["offset"] = -136, ["type"] = 16},
{["value"] = 0, ["offset"] = -124, ["type"] = 16},
{["value"] = 0, ["offset"] = 16, ["type"] = 16},
{["value"] = 0, ["offset"] = 24, ["type"] = 16},
}
xqmnb(qmnb)

qmnb = {
{["memory"] = 32},
{["name"] = "[ Semi ] تم تفعيل"},
{["value"] = 710.0, ["type"] = 16},
{["lv"] = 15.0, ["offset"] = -148, ["type"] = 16},
{["lv"] = 35.0, ["offset"] = -144, ["type"] = 16},
{["lv"] = 55.0, ["offset"] = -140, ["type"] = 16},
{["lv"] = 5.0, ["offset"] = -124, ["type"] = 16},
{["lv"] = 4.0, ["offset"] = 16, ["type"] = 16},
{["lv"] = 4.0, ["offset"] = 24, ["type"] = 16},
}
qmxg = {
{["value"] = 99999, ["offset"] = 0, ["type"] = 16},
{["value"] = 0, ["offset"] = -148, ["type"] = 16},
{["value"] = 0, ["offset"] = -144, ["type"] = 16},
{["value"] = 0, ["offset"] = -140, ["type"] = 16},
{["value"] = 0, ["offset"] = -136, ["type"] = 16},
{["value"] = 0, ["offset"] = -124, ["type"] = 16},
{["value"] = 0, ["offset"] = 16, ["type"] = 16},
{["value"] = 0, ["offset"] = 24, ["type"] = 16},
}
xqmnb(qmnb)

qmnb = {
 {memory = 32},
    {name = "[ Simple Shotgun ] تم تفعيل"},
    {value = 45, type = 16},
    {lv = "3.0",offset = 12,type = 16},
    {lv = "60.0",offset = 28,type = 16},
    {lv = "300.0",offset = 148,type = 16},
    {lv = "13.0",offset = 164,type = 16},
    {lv = "8.0",offset = 192,type = 16}}
  qmxg = {
 {value = 0,offset = 0,type = 16},
    {value = 0,offset = 12,type = 16},
    {value = 0,offset = 28,type = 16},
    {value = 99999.011,offset = 148,type = 16},
    {value = 0,offset = 164,type = 16},
    {value = 0,offset = 192,type = 16}}
  xqmnb(qmnb)
  
  qmnb = {
 {memory = 32},
    {name = "[ Double Shotgun ] تم تفعيل"},
    {value = 45, type = 16},
    {lv = "3.0",offset = 12,type = 16},
    {lv = "60.0",offset = 28,type = 16},
    {lv = "300.0",offset = 148,type = 16},
    {lv = "15.0",offset = 164,type = 16},
    {lv = "8.0",offset = 192,type = 16}}
  qmxg = {
 {value = 0,offset = 0,type = 16},
    {value = 0,offset = 12,type = 16},
    {value = 0,offset = 28,type = 16},
    {value = 99999.012,offset = 148,type = 16},
    {value = 0,offset = 164,type = 16},
    {value = 0,offset = 192,type = 16}}
  xqmnb(qmnb)

qmnb = {
{["memory"] = 32},
{["name"] = "[ Crossbow ] تم تفعيل"},
{["value"] = 50.0, ["type"] = 16},
{["lv"] = 20.0, ["offset"] = -8, ["type"] = 16},
{["lv"] = 40.0, ["offset"] = -4, ["type"] = 16},
{["lv"] = 10.0, ["offset"] = 16, ["type"] = 16},
{["lv"] = 40.0, ["offset"] = 140, ["type"] = 16},
{["lv"] = 7.0, ["offset"] = 156, ["type"] = 16},
{["lv"] = 10.0, ["offset"] = 164, ["type"] = 16},
}
qmxg = {
{["value"] = 0, ["offset"] = 0, ["type"] = 16},
{["value"] = 0, ["offset"] = -8, ["type"] = 16},
{["value"] = 0, ["offset"] = -4, ["type"] = 16},
{["value"] = 0, ["offset"] = 16, ["type"] = 16},
{["value"] = 99, ["offset"] = 140, ["type"] = 16},
{["value"] = 0, ["offset"] = 156, ["type"] = 16},
{["value"] = 0, ["offset"] = 164, ["type"] = 16},
}
xqmnb(qmnb)

qmnb = {
{["memory"] = 32},
{["name"] = "[ Pistol ] تم تفعيل"},
{["value"] = 300.0, ["type"] = 16},
{["lv"] = 15.0, ["offset"] = -148, ["type"] = 16},
{["lv"] = 30.0, ["offset"] = -144, ["type"] = 16},
{["lv"] = 50.0, ["offset"] = -140, ["type"] = 16},
{["lv"] = 5.0, ["offset"] = -124, ["type"] = 16},
{["lv"] = 5.0, ["offset"] = 16, ["type"] = 16},
{["lv"] = 9.0, ["offset"] = 24, ["type"] = 16},
}
qmxg = {
{["value"] = 99999, ["offset"] = 0, ["type"] = 16},
{["value"] = 0, ["offset"] = -148, ["type"] = 16},
{["value"] = 0, ["offset"] = -144, ["type"] = 16},
{["value"] = 0, ["offset"] = -140, ["type"] = 16},
{["value"] = 0, ["offset"] = -136, ["type"] = 16},
{["value"] = 0, ["offset"] = -124, ["type"] = 16},
{["value"] = 0, ["offset"] = 16, ["type"] = 16},
{["value"] = 0, ["offset"] = 24, ["type"] = 16},
}
xqmnb(qmnb)

qmnb = {
{["memory"] = 32},
{["name"] = "[ Pistol Black ] تم تفعيل"},
{["value"] = 300.0, ["type"] = 16},
{["lv"] = 15.0, ["offset"] = -148, ["type"] = 16},
{["lv"] = 30.0, ["offset"] = -144, ["type"] = 16},
{["lv"] = 50.0, ["offset"] = -140, ["type"] = 16},
{["lv"] = 5.0, ["offset"] = -124, ["type"] = 16},
{["lv"] = 5.0, ["offset"] = 16, ["type"] = 16},
{["lv"] = 9.0, ["offset"] = 24, ["type"] = 16},
}
qmxg = {
{["value"] = 99999, ["offset"] = 0, ["type"] = 16},
{["value"] = 0, ["offset"] = -148, ["type"] = 16},
{["value"] = 0, ["offset"] = -144, ["type"] = 16},
{["value"] = 0, ["offset"] = -140, ["type"] = 16},
{["value"] = 0, ["offset"] = -136, ["type"] = 16},
{["value"] = 0, ["offset"] = -124, ["type"] = 16},
{["value"] = 0, ["offset"] = 16, ["type"] = 16},
{["value"] = 0, ["offset"] = 24, ["type"] = 16},
}
xqmnb(qmnb)

qmnb = {
{["memory"] = 32},
{["name"] = "[ SniperM24 ] تم تفعيل"},
{["value"] = 912.0, ["type"] = 16},
{["lv"] = 20.0, ["offset"] = -148, ["type"] = 16},
{["lv"] = 40.0, ["offset"] = -144, ["type"] = 16},
{["lv"] = 50.0, ["offset"] = -140, ["type"] = 16},
{["lv"] = 10.0, ["offset"] = -124, ["type"] = 16},
{["lv"] = 7.0, ["offset"] = 16, ["type"] = 16},
{["lv"] = 10.0, ["offset"] = 24, ["type"] = 16},
}
qmxg = {
{["value"] = 99999, ["offset"] = 0, ["type"] = 16},
{["value"] = 0, ["offset"] = -148, ["type"] = 16},
{["value"] = 0, ["offset"] = -144, ["type"] = 16},
{["value"] = 0, ["offset"] = -140, ["type"] = 16},
{["value"] = 0, ["offset"] = -136, ["type"] = 16},
{["value"] = 0, ["offset"] = -124, ["type"] = 16},
{["value"] = 0, ["offset"] = 16, ["type"] = 16},
{["value"] = 0, ["offset"] = 24, ["type"] = 16},
}
xqmnb(qmnb)

qmnb = {
{["memory"] = 32},
{["name"] = "[ SniperK31 ] تم تفعيل"},
{["value"] = 720.0, ["type"] = 16},
{["lv"] = 20.0, ["offset"] = -148, ["type"] = 16},
{["lv"] = 40.0, ["offset"] = -144, ["type"] = 16},
{["lv"] = 50.0, ["offset"] = -140, ["type"] = 16},
{["lv"] = 10.0, ["offset"] = -124, ["type"] = 16},
{["lv"] = 7.0, ["offset"] = 16, ["type"] = 16},
{["lv"] = 10.0, ["offset"] = 24, ["type"] = 16},
}
qmxg = {
{["value"] = 99999, ["offset"] = 0, ["type"] = 16},
{["value"] = 0, ["offset"] = -148, ["type"] = 16},
{["value"] = 0, ["offset"] = -144, ["type"] = 16},
{["value"] = 0, ["offset"] = -140, ["type"] = 16},
{["value"] = 0, ["offset"] = -136, ["type"] = 16},
{["value"] = 0, ["offset"] = -124, ["type"] = 16},
{["value"] = 0, ["offset"] = 16, ["type"] = 16},
{["value"] = 0, ["offset"] = 24, ["type"] = 16},
}
xqmnb(qmnb)
end


function anten()
gg.clearResults()
gg.clearResults()
gg.toast("10%") 
      gg.setRanges(32)
      gg.searchNumber('-0.9855342507362366', gg.REGION_C_BSS, false, gg.SIGN_FUZZY_EQUAL, 0, -1)
      gg.getResults(999)
      gg.editAll('-500', gg.REGION_C_BSS)
      gg.clearResults()
      gg.clearResults()
      gg.toast("20%") 
      qmnb = {
{["memory"] = 1048576},
{["name"] = "ON"},
{["value"] = 4.4570662209845934E-29, ["type"] = 16},
{["lv"] = 2.2500014305114746, ["offset"] = 4, ["type"] = 16},
}

gg.toast("30%") 
qmxg = {
{["value"] = 2.26000142097, ["offset"] = 4, ["type"] = 16},

}
gg.toast("50%") 

xqmnb(qmnb)
gg.clearResults()
gg.toast("60%") 
      gg.setRanges(32)
      gg.searchNumber('1.58116769791', gg.REGION_C_BSS, false, gg.SIGN_FUZZY_EQUAL, 0, -1)
      gg.getResults(999)
      gg.toast("70%") 
      gg.editAll('-999', gg.REGION_C_BSS)
gg.clearResults()
gg.toast("80%") 
      gg.setRanges(32)
      gg.searchNumber('0.16947640479', gg.REGION_C_BSS, false, gg.SIGN_FUZZY_EQUAL, 0, -1)
  gg.toast("90%")
      gg.getResults(999)
 gg.toast("100%") 
      gg.editAll('-999', gg.REGION_C_BSS)
    
      gg.clearResults()
      
gg.toast("✔️ الانتينا تعمل بنجاح✔️") 








end

function pers()
F = gg.alert('|شخصية بيضاء|', '[̲̅لون ابيض̲̅]', '[̲̅تعطيل̲̅]', '[̲̅ولهاك سناب دراكو̲̅]')
  if F == 1 then
qmnb = {
{["memory"] = 32},
{["name"] = "✔️تم"},
{["value"] = 82.5, ["type"] = 16},
{["lv"] = 15.0, ["offset"] = 4, ["type"] = 16},
{["lv"] = 5.0, ["offset"] = 12, ["type"] = 16},
{["lv"] = 0.75, ["offset"] = 1316, ["type"] = 16},
}
qmxg = {
{["value"] = 20.0123456789, ["offset"] = 1316, ["type"] = 16},

}
xqmnb(qmnb)
gg.clearResults()
gg.toast("✔️تم")

elseif F == 2 then
gg.clearResults()
gg.setRanges(32)
gg.searchNumber("20.0123456789", gg.TYPE_FLOAT)
gg.getResults(900)
gg.editAll("0.75", gg.TYPE_FLOAT)
gg.clearResults()
gg.toast("تم✔️") 

elseif F == 3 then 
gg.clearResults()
gg.setRanges(gg.REGION_VIDEO)
gg.searchNumber("5.127597087642792E-29", gg.TYPE_FLOAT)
gg.getResults(900)
gg.editAll("5.127597087642792E29", gg.TYPE_FLOAT)
gg.toast("✔️تم")
end
end
------------------------





function andeath()
local t = {"libil2cpp.so:bss", "Cb"}
local tt = {0x140C0, 0x138, 0x1A0, 0x90, 0x18, 0x28}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 4, value = 1, freeze = true}})
local t = {"libil2cpp.so:bss", "Cb"}
local tt = {0x14130, 0x198, 0xA0, 0x90, 0x18, 0x28}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 4, value = 1, freeze = true}})
local t = {"libil2cpp.so:bss", "Cb"}
local tt = {0x234698, 0xB8, 0x10, 0x120, 0x68, 0x28}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 4, value = 1, freeze = true}})
local t = {"libil2cpp.so:bss", "Cb"}
local tt = {0x263FF0, 0xB8, 0x60, 0x80, 0x68, 0x28}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 4, value = 1, freeze = true}})
gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("100;200;-200", gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0, -1)
gg.searchNumber("100", gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0, -1)
gg.getResults(100)
gg.editAll("0",gg.TYPE_FLOAT)
gg.toast("✔️")
end


function fly()
     F = gg.alert(' طيران الفاونديشن ', 'تشغيل', 'تعطيل')
    if F == 1 then   
qmnb = {
      {memory = gg.REGION_ANONYMOUS},
      {name = "✔️"},
      {
        value = "2139095039",
        type = 32
      },
      {
        lv = "24000",
        offset = 20,
        type = 4
      }
    }
    qmxg = {
      {
        value = 0,
        offset = 44,
        type = 32
      }
    }
    xqmnb(qmnb)
gg.clearResults()

    qmnb = {
      {memory = gg.REGION_ANONYMOUS},
      {name = "5͓̽0͓̽%͓̽"},
      {
        value = "2139095039",
        type = 32
      },
      {
        lv = "24004",
        offset = 20,
        type = 4
      }
    }
    qmxg = {
      {
        value = 0,
        offset = 44,
        type = 32
      }
    }
    xqmnb(qmnb)
gg.clearResults()

    qmnb = {
      {memory = gg.REGION_ANONYMOUS},
      {name = "1͓̽0͓̽0͓̽%͓̽ "},
      {
        value = "2139095039",
        type = 32
      },
      {
        lv = "24008",
        offset = 20,
        type = 4
      }
    }
    qmxg = {
      {
        value = 0,
        offset = 44,
        type = 32
      }
    }
    xqmnb(qmnb)
gg.clearResults()

elseif F == 2 then
qmnb = {
      {memory = gg.REGION_ANONYMOUS},
      {name = "❌"},
      {
        value = "2139095039",
        type = 32
      },
      {
        lv = "24000",
        offset = 20,
        type = 4
      }
    }
    qmxg = {
      {
        value = 4294967296,
        offset = 44,
        type = 32
      }
    }
    xqmnb(qmnb)
gg.clearResults()

    qmnb = {
      {memory = gg.REGION_ANONYMOUS},
      {name = "5͓̽0͓̽%͓̽"},
      {
        value = "2139095039",
        type = 32
      },
      {
        lv = "24004",
        offset = 20,
        type = 4
      }
    }
    qmxg = {
      {
        value = 4294967296,
        offset = 44,
        type = 32
      }
    }
    xqmnb(qmnb)
gg.clearResults()

    qmnb = {
      {memory = gg.REGION_ANONYMOUS},
      {name = "1͓̽0͓̽0͓̽%͓̽"},
      {
        value = "2139095039",
        type = 32
      },
      {
        lv = "24008",
        offset = 20,
        type = 4
      }
    }
    qmxg = {
      {
        value = 4294967296,
        offset = 44,
        type = 32
      }
    }
    xqmnb(qmnb)
gg.clearResults()
end
end

function select()
    
    MV = gg.alert("|🅶🅾 🅳🅾🆆🅽|", "[̲̅تشغيل]","[̲̅تعطيل]")
    if MV == 1 then
    
    
   
    gg.setRanges(16384)
gg.searchNumber("100;-200;200",  gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0, -1)
gg.searchNumber("100", gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
gg.getResults(999)
gg.editAll("0",gg.TYPE_FLOAT)

    
local l = {"libunity.so:bss","Cb"}
local ll = {0x9588, 0xB8, 0x60, 0x178, 0x58, 0x10, 0x80}---
local lll = S_Pointer(l, ll, true)
gg.addListItems({{address = lll, flags = 16, value = 1.5, freeze = true}}) 

local l = {"libunity.so:bss","Cb"}
local ll = {0x9588, 0xB8, 0x60, 0x178, 0x58, 0x10, 0x80}---
local lll = S_Pointer(l, ll, true)
gg.addListItems({{address = lll, flags = 16, value = 3, freeze = true}}) 
gg.toast("🇮🇶🅾🅿🅴🅽🇮🇶")

elseif MV == 2 then
local l = {"libunity.so:bss","Cb"}
local ll = {0x9588, 0xB8, 0x60, 0x178, 0x58, 0x10, 0x80}---
local lll = S_Pointer(l, ll, true)
gg.addListItems({{address = lll, flags = 16, value = 1, freeze = true}}) 
gg.toast("🇮🇶🅾🅵🅵🇮🇶")



end
end

function day()
F = gg.alert("تحويل الوقت ", "قفل الوقت فقط","تعطيل الكل","تغير الوقت + قفل الوقت")
  if F == 1 then
    qmnb = {
{["memory"] = 32},
{["name"] = "ON Lock Time"},
{["value"] = 1.0600871291899239E-8, ["type"] = 16},
{["lv"] = 8.968310171678829E-44, ["offset"] = -12, ["type"] = 16},
{["lv"] = 6.1124763362074925E32, ["offset"] = -4, ["type"] = 16},
{["lv"] = 1.0600871291899239E-8, ["offset"] = 4, ["type"] = 16},
{["lv"] = 1.1210387714598537E-44, ["offset"] = 52, ["type"] = 16},
{["lv"] = 1.401298464324817E-45, ["offset"] = 60, ["type"] = 16},
}
qmxg = {
{["value"] = 9.21942286e-41, ["offset"] = 28, ["type"] = 16},
}
xqmnb(qmnb)
    elseif F == 2 then  
        qmnb = {
{["memory"] = 32},
{["name"] = "❌"},
{["value"] = 1.0600871291899239E-8, ["type"] = 16},
{["lv"] = 8.968310171678829E-44, ["offset"] = -12, ["type"] = 16},
{["lv"] = 6.1124763362074925E32, ["offset"] = -4, ["type"] = 16},
{["lv"] = 1.0600871291899239E-8, ["offset"] = 4, ["type"] = 16},
{["lv"] = 1.1210387714598537E-44, ["offset"] = 52, ["type"] = 16},
{["lv"] = 1.401298464324817E-45, ["offset"] = 60, ["type"] = 16},
}
qmxg = {
{["value"] = 0.0066999997943639755, ["offset"] = 28, ["type"] = 16},
{["value"] = 9.219422856485836E-41, ["offset"] = 36, ["type"] = 16},
}
xqmnb(qmnb)

elseif F == 3 then  
qmnb = {
{["memory"] = 32},
{["name"] = "✔️"},
{["value"] = 1.0600871291899239E-8, ["type"] = 16},
{["lv"] = 8.968310171678829E-44, ["offset"] = -12, ["type"] = 16},
{["lv"] = 6.1124763362074925E32, ["offset"] = -4, ["type"] = 16},
{["lv"] = 1.0600871291899239E-8, ["offset"] = 4, ["type"] = 16},
{["lv"] = 1.1210387714598537E-44, ["offset"] = 52, ["type"] = 16},
{["lv"] = 1.401298464324817E-45, ["offset"] = 60, ["type"] = 16},
}
qmxg = {
{["value"] = 9.21942286e-41, ["offset"] = 28, ["type"] = 16},
{["value"] = 999, ["offset"] = 36, ["type"] = 16},
}
xqmnb(qmnb)
    end
    end
    
    function speed()
      F = gg.alert("حدد السرعة", "V2","تعطيل","V1")
  if F == 1 then
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("0.14777720249", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(300)
    gg.editAll("0.14177720249",16)
    
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("4.90000019073", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(1000)
    gg.editAll("6.30000019073",16)
    gg.clearResults()
    
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("0.14177720249", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(300)
    gg.editAll("0.15777720249",16)
    
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("6.30000019073", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(1000)
    gg.editAll("3.100012345",16)
   
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_SYS)
    gg.searchNumber("0.14777720249", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(300)
    gg.editAll("0.14177720249",16)
    
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_SYS)
    gg.searchNumber("4.90000019073", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(1000)
    gg.editAll("6.30000019073",16)
    gg.clearResults()
    
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_SYS)
    gg.searchNumber("0.14177720249", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(300)
    gg.editAll("0.15777720249",16)
    
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_SYS)
    gg.searchNumber("6.30000019073", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(1000)
    gg.editAll("3.100012345",16)
    elseif F == 2 then
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("0.14777720249", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(300)
    gg.editAll("0.14177720249",16)
    
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("4.90000019073", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(1000)
    gg.editAll("6.30000019073",16)
    gg.clearResults()
    
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("0.15777720249", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(300)
    gg.editAll("0.14177720249",16)
  
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("3.100012345", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(1000)
    gg.editAll("6.30000019073",16)
    
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_SYS)
    gg.searchNumber("0.14777720249", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(300)
    gg.editAll("0.14177720249",16)
    
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_SYS)
    gg.searchNumber("4.90000019073", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(1000)
    gg.editAll("6.30000019073",16)
    gg.clearResults()
    
    gg.setRanges(gg.REGION_CODE_SYS)
    gg.searchNumber("0.15777720249", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(300)
    gg.editAll("0.14177720249",16)
  
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_SYS)
    gg.searchNumber("3.100012345", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(1000)
    gg.editAll("6.30000019073",16)
    elseif F == 3 then

    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("0.15777720249", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(300)
    gg.editAll("0.14177720249",16)
  
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("3.100012345", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(1000)
    gg.editAll("6.30000019073",16)
    
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("0.14177720249", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(300)
    gg.editAll("0.14777720249",16)
    gg.clearList() 
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.searchNumber("6.30000019073", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(1000)
    gg.editAll("4.90000019073",16)
    
    gg.setRanges(gg.REGION_CODE_SYS)
    gg.searchNumber("0.15777720249", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(300)
    gg.editAll("0.14177720249",16)
  
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_SYS)
    gg.searchNumber("3.100012345", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(1000)
    gg.editAll("6.30000019073",16)
    
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_SYS)
    gg.searchNumber("0.14177720249", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(300)
    gg.editAll("0.14777720249",16)
    gg.clearList() 
    gg.clearResults()
    gg.setRanges(gg.REGION_CODE_SYS)
    gg.searchNumber("6.30000019073", 16,false,gg.SIGN_EQUAL,0, -1)
    gg.getResults(1000)
    gg.editAll("4.90000019073",16)
    
    qmnb = {
{["memory"] = 32},
{["name"] = "ON"},
{["value"] = 1.233142648605839E-42, ["type"] = 16},
{["lv"] = 4.0, ["offset"] = 12, ["type"] = 16},
{["lv"] = 7.987401246651457E-43, ["offset"] = 60, ["type"] = 16},
}
qmxg = {
{["value"] = 5.2, ["offset"] = 12, ["type"] = 16},

}
xqmnb(qmnb)

qmnb = {
{["memory"] = 32},
{["name"] = "ON"},
{["value"] = 1.233142648605839E-42, ["type"] = 16},
{["lv"] = 8.0, ["offset"] = 12, ["type"] = 16},
{["lv"] = 7.847271400218976E-43, ["offset"] = 60, ["type"] = 16},
}
qmxg = {
{["value"] = 9.5, ["offset"] = 12, ["type"] = 16},

}
xqmnb(qmnb)
end
end

function swim()
mn2 = gg.choice({
	"┌⎙المشي",
	"└⎙القيادة",
	"┤⌲الرجوع",})
if mn2 == 1 then xodit() end
if mn2 == 2 then vojdeni() end
if mn2 == 3 then A1() end
end
  
------------------------
function xodit()
local t = {"libil2cpp.so:bss", "Cb"}
local tt = {0x140C0, 0x138, 0x1A0, 0x90, 0x18, 0x28}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 4, value = 1, freeze = true}})
local t = {"libil2cpp.so:bss", "Cb"}
local tt = {0x14130, 0x198, 0xA0, 0x90, 0x18, 0x28}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 4, value = 1, freeze = true}})
local t = {"libil2cpp.so:bss", "Cb"}
local tt = {0x234698, 0xB8, 0x10, 0x120, 0x68, 0x28}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 4, value = 1, freeze = true}})
local t = {"libil2cpp.so:bss", "Cb"}
local tt = {0x263FF0, 0xB8, 0x60, 0x80, 0x68, 0x28}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 4, value = 1, freeze = true}})
local t = {"libunity.so:bss", "Cb"}
local tt = {0x6EF50, 0x110, 0x58, 0xC0, 0x20, 0x90}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 16, value = 5, freeze = true}})
local t = {"libunity.so:bss", "Cb"}
local tt = {0x72E08, 0xE8, 0x1D8, 0xC8, 0x20, 0x90}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 16, value = 5, freeze = true}})
local t = {"libunity.so:bss", "Cb"}
local tt = {0xC1C0, 0x180, 0x28, 0xC0, 0x20, 0x90}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 16, value = 5, freeze = true}})
local t = {"libunity.so:bss", "Cb"}
local tt = {0xB000, 0xD8, 0xC0, 0x20, 0x90}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 16, value = 5, freeze = true}})
local t = {"libunity.so:bss", "Cb"}
local tt = {0x6EF50, 0x110, 0x58, 0xC0, 0x20, 0x90}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 16, value = 5, freeze = true}})
local t = {"libunity.so:bss", "Cb"}
local tt = {0x72E08, 0xE8, 0x1D8, 0xC8, 0x20, 0x90}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 16, value = 5, freeze = true}})
local t = {"libunity.so:bss", "Cb"}
local tt = {0xC1C0, 0x180, 0x28, 0xC0, 0x20, 0x90}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 16, value = 5, freeze = true}})
local t = {"libunity.so:bss", "Cb"}
local tt = {0xB000, 0xD8, 0xC0, 0x20, 0x90}
local ttt = S_Pointer(t, tt, true)
gg.addListItems({{address = ttt, flags = 16, value = 5, freeze = true}})
gg.clearResults()
gg.setRanges(16384)
gg.searchNumber("100;200;-200", gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0, -1)
gg.searchNumber("100", gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0, -1)
gg.getResults(10)
gg.editAll("0",gg.TYPE_FLOAT)
gg.toast("تم")
end

function vojdeni()
F = gg.alert("|القيادة|", "[̲̅تشغيل]" ,"[̲̅تعطيل]")
if F==1 then
    gg.clearResults()
      gg.setRanges(4)
      gg.searchNumber("1.0F;0.00999999978F;3.7835059e-43F;4.2038954e-45F;10,000.0F;10,000.001953125F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
      gg.searchNumber("10000", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
      gg.getResults(9999)
      gg.editAll("0", gg.TYPE_FLOAT)
      gg.toast("✔️")

   elseif F==2 then
   gg.clearResults()
      gg.setRanges(4)
      gg.searchNumber("1.0F;0.00999999978F;3.7835059e-43F;4.2038954e-45F;0F;10,000.001953125F", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
      gg.searchNumber("0", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
      gg.getResults(9999)
      gg.editAll("10000", gg.TYPE_FLOAT)
      gg.toast("❌")
   
end
end

---------------VIEW---------------
function A6()

end

function A7()

end

---------------اختراق الجدار------------
function wallhack()
F = gg.alert("|اختراق مباني الماب فقط|", "[̲̅تشغيل]","[̲̅تعطيل]")
    if F == 1 then
qmnb = {
{["memory"] = 32},
{["name"] = "5͓̽0͓̽%͓̽"},
{["value"] = 6.699999809265137, ["type"] = 16},
{["lv"] = 0.10000000149011612, ["offset"] = 16, ["type"] = 16},
{["lv"] = 0.10000000149011612, ["offset"] = 24, ["type"] = 16},
}
qmxg = {
{["value"] = -999, ["offset"] = 16, ["type"] = 16},
{["value"] = -999, ["offset"] = 24, ["type"] = 16},
}
xqmnb(qmnb)

qmnb = {
{["memory"] = 32},
{["name"] = "1͓̽0͓̽0͓̽%͓̽"},
{["value"] = 999.0, ["type"] = 16},
{["lv"] = 0.10000000149011612, ["offset"] = 16, ["type"] = 16},
{["lv"] = 0.004999999888241291, ["offset"] = 24, ["type"] = 16},
}
qmxg = {
{["value"] = 8.88479995728, ["offset"] = 20, ["type"] = 16},

}
xqmnb(qmnb)
elseif F == 2 then
  qmnb = {
{["memory"] = 32},
{["name"] = "1͓̽0͓̽0͓̽%͓̽"},
{["value"] = 999.0, ["type"] = 16},
{["lv"] = 0.10000000149011612, ["offset"] = 16, ["type"] = 16},
{["lv"] = 0.004999999888241291, ["offset"] = 24, ["type"] = 16},
}
qmxg = {
{["value"] = 1.00000003e32, ["offset"] = 20, ["type"] = 16},

}
xqmnb(qmnb)
end
end

A2 = function()
info = gg.choice({
"☞【النشئين】☜",
"☞【الاصدار】☜", 
"🔙【الى القائمة】"},nil, os.date("%d/%m/%y | %X"))
if info == 1 then avtor() end 
if info == 2 then versus() end
if info == 3 then HOME () end 
end

function sf()

gg.toast("🅸🆃 🅸🆂 🆄🅽🅳🅴🆁 🅼🅰🅸🅽🆃🅴🅽🅰🅽🅲🅴")


end


function avtor()
gg.alert(" @RAIZO_RZ   ")
end
function versus()
gg.alert("💎Version v1.0💎")
end
function Root7 ()

gg.alert("🅲🅾🅼🅸🅽🅶   🆂🅾🅾🅽")

end

function A10()

GHAG = gg.alert("|🅳🅾🆄🅱🅻🅴 🅳🅾🅾🆁|", "[̲̅تشغيل]","[̲̅تعطيل]")
    if GHAG == 1 then sf()
    
    
    gg.setRanges(16384)
gg.searchNumber("100;-200;200",  gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0, -1)
gg.searchNumber("100", gg.TYPE_FLOAT,false,gg.SIGN_EQUAL,0,-1)
gg.getResults(999)
gg.editAll("0",gg.TYPE_FLOAT)
qmnb=
{
{['memory']=32},
{['name']=''},
{['value']=999.0, ['type']=16},
{['lv']=49.0,['offset']=-12, ['type']=16},
}
qmxg=
{
{['value']=2,['offset']=-32,['type']=16},
}
xqmnb(qmnb,qmxg)
elseif GHAG == 2 then
qmnb=
{
{['memory']=32},
{['name']=''},
{['value']=999.0, ['type']=16},
{['lv']=49.0,['offset']=-12, ['type']=16},
}
qmxg=
{
{['value']=0,['offset']=-32,['type']=16},
}
xqmnb(qmnb,qmxg)

gg.toast("🇮🇶🅾🅵🅵🇮🇶")
end
end


function A11()

gg.toast("🅸🆃 🅸🆂 🆄🅽🅳🅴🆁 🅼🅰🅸🅽🆃🅴🅽🅰🅽🅲🅴")


end
function IO()
  gg["clearResults"](32)
  SearchWrite({
    {1060152279,0,4},
    {1042536202,-4,4}, 
    {1092616192,0,4}
    }, {
     {0, 4}
    }, 4)
  gg["clearResults"](32)
  SearchWrite({
    {1056293519,0,4},
    {1035489772,-4,4}, 
    {1092616192,0,4}
    }, {
     {0, 4,}
    }, 4)

gg["clearResults"](32)
  SearchWrite({
    {1050253722,0,4},
    {1031127695,-4,4}, 
    {1092616192,0,4}
    }, {
     {0, 4}
    }, 4)
  gg["clearResults"](32)
  SearchWrite({
    {1055286886,0,4},
    {1025758986,-4,4}, 
    {1092616192,0,4}
    }, {
     {0, 4}
    }, 4)
  gg["clearResults"](32)
  SearchWrite({
    {1051595899,0,4},
    {1038174126,-4,4}, 
    {1092616192,0,4}
    }, {
     {0, 0,4}
    }, 4)
  gg["clearResults"](32)
  SearchWrite({
    {1057635697,0,4},
    {1035489772,-4,4}, 
    {1092616192,0,4}
    }, {
     {0, 4}
    }, 4)
  gg["clearList"]()
end
function OI()
qmnb = {
  {memory = 32},
  {
    name = "10%"
  },
  {value = 0.5400000214576721, type = 16},
  {
    lv = 0.09000000357627869,
    offset = -4,
    type = 16
  }
}
qmxg = {
  {
    value = 8,
    offset = 0,
    type = 16
  }
}
xqmnb(qmnb)

qmnb = {
  {memory = 32},
  {
    name = "30%"
  },
  {value = 0.6899999976158142, type = 16},
  {
    lv = 0.1599999964237213,
    offset = -4,
    type = 16
  }
}
qmxg = {
  {
    value = 8,
    offset = 0,
    type = 16
  }
}
xqmnb(qmnb)
qmnb = {
  {memory = 32},
  {
    name = "60%"
  },
  {value = 0.47999998927116394, type = 16},
  {
    lv = 0.09000000357627869,
    offset = -4,
    type = 16
  }
}
qmxg = {
  {
    value = 8,
    offset = 0,
    type = 16
  }
}
xqmnb(qmnb)  

qmnb = {
  {memory = 32},
  {
    name = "80%"
  },
  {value = 0.44999998807907104, type = 16},
  {
    lv = 0.03999999910593033,
    offset = -4,
    type = 16
  }
}
qmxg = {
  {
    value = 8,
    offset = 0,
    type = 16
  }
}
xqmnb(qmnb)
qmnb = {
  {memory = 32},
  {name = "100%"},
  {value = 0.3400000035762787, type = 16},
  {
    lv = 0.10999999940395355,
    offset = -4,
    type = 16
  }
}
qmxg = {
  {
    value = 8,
    offset = 0,
    type = 16
  }
}
xqmnb(qmnb)
end
function OI()
qmnb = {
  {memory = 32},
  {
    name = "10%"
  },
  {value = 0.5400000214576721, type = 16},
  {
    lv = 0.09000000357627869,
    offset = -4,
    type = 16
  }
}
qmxg = {
  {
    value = 1,
    offset = 0,
    type = 16
  }
}
xqmnb(qmnb)

qmnb = {
  {memory = 32},
  {
    name = "30%"
  },
  {value = 0.6899999976158142, type = 16},
  {
    lv = 0.1599999964237213,
    offset = -4,
    type = 16
  }
}
qmxg = {
  {
    value = 1,
    offset = 0,
    type = 16
  }
}
xqmnb(qmnb)
qmnb = {
  {memory = 32},
  {
    name = "60%"
  },
  {value = 0.47999998927116394, type = 16},
  {
    lv = 0.09000000357627869,
    offset = -4,
    type = 16
  }
}
qmxg = {
  {
    value = 1,
    offset = 0,
    type = 16
  }
}
xqmnb(qmnb)  

qmnb = {
  {memory = 32},
  {
    name = "80%"
  },
  {value = 0.44999998807907104, type = 16},
  {
    lv = 0.03999999910593033,
    offset = -4,
    type = 16
  }
}
qmxg = {
  {
    value = 1,
    offset = 0,
    type = 16
  }
}
xqmnb(qmnb)
qmnb = {
  {memory = 32},
  {name = "100%"},
  {value = 0.3400000035762787, type = 16},
  {
    lv = 0.10999999940395355,
    offset = -4,
    type = 16
  }
}
qmxg = {
  {
    value = 1,
    offset = 0,
    type = 16
  }
}
xqmnb(qmnb)
end
function IK()
qmnb = {
    {memory = 32},
    {name = "1%"},
    {value = 0.6899999976158142, type = 16},
    {
      lv = 0.1599999964237213,
      offset = -4,
      type = 16
    }
  }
  qmxg = {
    {
      value = 99,
      offset = 0,
      type = 16
    }
  }
  xqmnb(qmnb)
  qmnb = {
    {memory = 32},
    {name = "10%"},
    {value = 0.47999998927116394, type = 16},
    {
      lv = 0.09000000357627869,
      offset = -4,
      type = 16
    }
  }
  qmxg = {
    {
      value = 99,
      offset = 0,
      type = 16
    }
  }
  xqmnb(qmnb)
  qmnb = {
    {memory = 32},
    {name = "20%"},
    {value = 0.30000001192092896, type = 16},
    {
      lv = 0.05999999865889549,
      offset = -4,
      type = 16
    }
  }
  qmxg = {
    {
      value = 99,
      offset = 0,
      type = 16
    }
  }
  xqmnb(qmnb)
  qmnb = {
    {memory = 32},
    {name = "30%"},
    {value = 0.44999998807907104, type = 16},
    {
      lv = 0.03999999910593033,
      offset = -4,
      type = 16
    }
  }
  qmxg = {
    {
      value = 99,
      offset = 0,
      type = 16
    }
  }
  xqmnb(qmnb)
  qmnb = {
    {memory = 32},
    {name = "40%"},
    {value = 0.3400000035762787, type = 16},
    {
      lv = 0.10999999940395355,
      offset = -4,
      type = 16
    }
  }
  qmxg = {
    {
      value = 99,
      offset = 0,
      type = 16
    }
  }
  xqmnb(qmnb)
  qmnb = {
    {memory = 32},
    {name = "50%"},
    {value = 0.5400000214576721, type = 16},
    {
      lv = 0.09000000357627869,
      offset = -4,
      type = 16
    }
  }
  qmxg = {
    {
      value = 99,
      offset = 0,
      type = 16
    }
  }
  xqmnb(qmnb)
  qmnb = {
    {memory = 32},
    {name = "70%"},
    {value = 0.30000001192092896, type = 16},
    {
      lv = 0.05999999865889549,
      offset = -4,
      type = 16
    }
  }
  qmxg = {
    {
      value = 99,
      offset = 0,
      type = 16
    }
  }
  xqmnb(qmnb)
  gg["setRanges"](gg["REGION_ANONYMOUS"])
  gg["searchNumber"]("0.47999998927116394", gg["TYPE_FLOAT"], false, gg["SIGN_EQUAL"], 0, -1)
  gg["getResults"](999)
  gg["editAll"]("99", gg["TYPE_FLOAT"])
  gg["toast"]("80%")
  gg["setRanges"](gg["REGION_ANONYMOUS"])
  gg["refineNumber"]("0.3400000035762787")
  gg["getResults"](999)
  gg["editAll"]("99", gg["TYPE_FLOAT"])
  gg["toast"]("90%")
  gg["setRanges"](gg["REGION_ANONYMOUS"])
  gg["searchNumber"]("0.6899999976158142", gg["TYPE_FLOAT"], false, gg["SIGN_EQUAL"], 0, -1)
  gg["getResults"](999)
  gg["editAll"]("99", gg["TYPE_FLOAT"])
  gg["toast"]("100%")
end

function A12()

gg.toast("🅸🆃 🅸🆂 🆄🅽🅳🅴🆁 🅼🅰🅸🅽🆃🅴🅽🅰🅽🅲🅴")


end


function Ext()
print("══════════क═════════क══════  \n  \n                                        𝚃𝚎𝚕𝚎𝚐𝚛𝚊𝚖 𝙲𝚑𝚊𝚗𝚗𝚎𝚕                   \n                                        𝚝.𝚖𝚎/------                  \n                                              𝚝.𝚖𝚎/-------- \n \n▰▱▰▱▰▱▰▱▰▱▰▱▰▱▰▱▰▱▰▱▰▱▰▱▰▱         \n  \n                                         ︾ My Account in telegram ︾                 \n                                              @RiaZo  \n \n═════क═════HoLaCu Hack═════क════\n")
os.exit()
end

while true do
if gg.isVisible(true) then
XXS = 1
gg.setVisible(false)
end
gg.clearResults()
if XXS == 1 then
HOME ()
end
end