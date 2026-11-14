local htMapMgr = include("htMapMgr")
local htBattleMgr = include("htBattleMgr")
local baseComponent = require("fgui.base.baseComponent")
local Com_gate = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://heroTrial/Com_gate", Com_gate)
function Com_gate:onInit()
	self.fields.new:setVisible(false)
	self.fields.et_fight:setVisible(false)
	self.fields.Btn_touch:addClickListener(handler(self, self.btnClick))
end
function Com_gate:onShow()
end
function Com_gate:initData(gateId, mapId)
	self.mapId = mapId
	local lastMapID = htMapMgr.getLastUnlockMap()
	self.isEnable = lastMapID >= self.mapId
	self.fields.title:setString(gateId)
	self.fields.flag:setGrayed(not self.isEnable)
	self.fields.new:setVisible(not htMapMgr.isAllPass() and self.mapId == lastMapID)
	self.fields.et_fight:setVisible(false)
	if htBattleMgr.curTrialMap then
		local curTrialMapId = htBattleMgr.curTrialMap:getMapID()
		if self.mapId == curTrialMapId then
			self.fields.et_fight:setVisible(true)
		end
	end
end
function Com_gate:btnClick()
	SoraDPlaySound()
	if self.isEnable then
		_ENV = nil
		;(nil).mapId = self.mapId
		uiManager:show("heroTrialMapView", nil)
	end
end
return Com_gate
