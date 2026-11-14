local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Actiivty_9001573_MoveDetailPanel = class("Actiivty_9001573_MoveDetailPanel", baseFguiPanel)
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
function Actiivty_9001573_MoveDetailPanel:ctor(...)
	Actiivty_9001573_MoveDetailPanel.super.ctor(self, ...)
	print("Actiivty_9001573_MoveDetailPanel:ctor", self.viewName)
	self.debug = true
end
function Actiivty_9001573_MoveDetailPanel:onInit()
	self.fields.txt_title:fixPos()
	print("=======Actiivty_9001573_MoveDetailPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("Celestial_defense_text_084"))
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Label_time:setTimeLast(function(timeStr)
		_ENV = nil
		;(nil).time = timeStr
		return i18n("common_text_295", nil)
	end)
	self.fields.Label_time:setTimeEndListener(function()
		if tolua.isnull(self.mapInstance) then
			self:close()
			return
		end
		local tilePoint = self.mapInstance:getTilePoint()
		local instanceID = self.mapInstance:getInstanceID()
		local kingdomID = self.mapInstance:getWorldMapCell().kingdomID
		kingdomMapCtrl:reqMapObjInfo(tilePoint.x, tilePoint.y, instanceID, kingdomID)
	end)
	self.mapInstance = self.param.mapInstance
	self.moveData = self.param.moveData
end
function Actiivty_9001573_MoveDetailPanel:onShow()
	print("=======Actiivty_9001573_MoveDetailPanel:onShow")
	self:initData()
end
function Actiivty_9001573_MoveDetailPanel:updateData(data)
	dump(data, "Actiivty_9001573_MoveDetailPanel:updateData")
	if not data.data or not data.data.build then
		return
	end
	if not data.data or not data.data.build.moveData then
		_ENV = data.data.build.moveData
	end
	self.moveData = data.data.build.moveData
	self:initData()
end
function Actiivty_9001573_MoveDetailPanel:initData()
	self.listDatas, _ENV = nil, nil
	local focusData
	for i, v in ipairs(self.moveData) do
		local lastTime = v.statusEndTime - serviceFunctions.systemTime()
		if 0 < lastTime then
			table.insert(self.listDatas, v)
			if focusData == nil or lastTime < focusData.statusEndTime - serviceFunctions.systemTime() then
				focusData = v
			end
		end
	end
	if #self.listDatas == 0 then
		self:close()
		return
	end
	_ENV = nil
	;(nil).cur = #self.listDatas
	self.fields.txt_title:setString(i18n("common_text_297", nil))
	self.fields.Label_time:beginTime(focusData.statusEndTime - serviceFunctions.systemTime())
	self.fields.list:setNumItems(#self.listDatas)
end
function Actiivty_9001573_MoveDetailPanel:onItemRenderer(index, obj)
	obj:initData(self.listDatas[index + 1])
end
return Actiivty_9001573_MoveDetailPanel
