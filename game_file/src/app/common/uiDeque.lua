function SoraDRemoveTableEx(tab, pos)
	pos = tonumber(pos) or #tab
	if type(tab) ~= "table" then
		return tab
	end
	pos = pos or #tab
	if pos > table.maxn(tab) then
		return tab
	end
	if pos <= 0 then
		return tab
	end
	local _ENV, nTab = table.maxn(tab), table.maxn(tab)
	local len = table.maxn(tab) - 1
	for i = len, 1, -1 do
		if i < pos then
			nTab[i] = tab[i]
		else
			nTab[i] = tab[i + 1]
		end
	end
	tab = nTab
	return nTab
end
_uiDequeInstance = nil
uiDeque = class("uiDeque")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
function uiDeque:getInstance()
	if _uiDequeInstance == nil then
		_uiDequeInstance = uiDeque.new()
	end
	return _uiDequeInstance
end
function uiDeque:ctor()
	self:clean()
	local mytempLoop = function()
		self:_upData()
	end
	self.schedulerId = scheduler.scheduleGlobal(mytempLoop, 1)
end
function uiDeque:destroy()
	print("uiDeque:destroy")
	if self.schedulerId then
		scheduler.unscheduleGlobal(self.schedulerId)
		self.schedulerId = nil
	end
end
function uiDeque:clean()
	self.UIdequeDataTable, _UPVALUE0_, self.isOpenDeque = nil, nil, false
	self.uiDequeObjID = 0
	self.uiDequeOpenKey = nil
end
function uiDeque:_upData(dt)
	if self.isOpenDeque then
		return
	end
	if #self.UIdequeDataTable == 0 then
		return
	end
	if SoraDIsGameGuide() then
		return
	end
	if SoraDCurrentTopPanelFromManager() then
		return
	end
	if not SoraDCurrentSceneShowView("mainCityView") then
		return
	end
	self.isOpenDeque = true
	self.uiDequeObjID = self.UIdequeDataTable[1][1]
	self.uiDequeOpenKey = self.UIdequeDataTable[1][2]
	local tempfunction = self.UIdequeDataTable[1][3]
	if not self.UIdequeDataTable[1][4] then
		local _ENV, tempParameter = self.UIdequeDataTable[1][4], self.UIdequeDataTable[1][4]
	end
	tempfunction(self.UIdequeDataTable[1][1], unpack(tempParameter, 1, table.maxn(tempParameter)))
end
function uiDeque:closeDeque(key)
	if key == nil or key == -1 then
		return
	end
	for k, v in pairs(self.UIdequeDataTable) do
		if v[2] == key then
			print("关闭队列", key)
			table.remove(self.UIdequeDataTable, k)
			self.isOpenDeque = false
			break
		end
	end
end
function uiDeque:checkDeque(key)
	if key == nil or key == -1 then
		return false
	end
	local ret = false
	for k, v in pairs(self.UIdequeDataTable) do
		if v[2] == key then
			print("发现队列", key)
			ret = true
			break
		end
	end
	return ret
end
function uiDeque:addDeque(...)
	_ENV = nil
	;(nil)[1] = ...
	;(nil)[2] = ...
	;(nil)[3] = ...
	;(nil)[4] = ...
	;(nil)[5] = ...
	;(nil)[6] = ...
	;(nil)[7] = ...
	;(nil)[8] = ...
	;(nil)[9] = ...
	local (nil)[10], args = ...
	if table.getn(args) < 3 then
		print("出错啦 参数传入错误啦")
		return
	end
	local _ENV, layerDataTable = print, print
	local _ENV, ParameterTable = "出错啦 参数传入错误啦", "出错啦 参数传入错误啦"
	for i, v in ipairs(args) do
		if i <= 3 then
			table.insert(layerDataTable, v)
		end
	end
	ParameterTable = args
	ParameterTable = SoraDRemoveTableEx(ParameterTable, 1)
	ParameterTable = SoraDRemoveTableEx(ParameterTable, 1)
	_ENV, ParameterTable = SoraDRemoveTableEx(ParameterTable, 1), SoraDRemoveTableEx(ParameterTable, 1)
	if ParameterTable ~= SoraDRemoveTableEx(ParameterTable, 1) then
		table.insert(layerDataTable, ParameterTable)
	end
	table.insert(self.UIdequeDataTable, layerDataTable)
	table.sort(self.UIdequeDataTable, function(a, b)
		if a[1] == b[1] then
			return a[2] < b[2]
		else
			return a[1] < b[1]
		end
	end)
end
