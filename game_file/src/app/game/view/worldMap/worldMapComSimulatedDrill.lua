local worldMapViewDef = include("worldMapViewDef")
local simulatedDrillCtrl = SoraDGetCtrl("simulatedDrillCtrl")
local worldMapComSimulatedDrill = class("worldMapComSimulatedDrill", include("worldMapCom"))
function worldMapComSimulatedDrill:ctor()
	worldMapComSimulatedDrill.super.ctor(self, "worldMapComSimulatedDrill")
end
local Z_ORDER = worldMapDefine.Z_ORDER
function worldMapComSimulatedDrill:init()
	self.worldMapCell = self.target_.currentInMapViewCell
	self:initWidget()
end
function worldMapComSimulatedDrill:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SIMULATED_DRILL_WARDATA", handler(self, self.onMsgUpdateWarData))
	self:doReqestData()
end
function worldMapComSimulatedDrill:doReqestData(...)
	simulatedDrillCtrl:reqWarData()
end
function worldMapComSimulatedDrill:initWidget(...)
	local node = display.newNode()
	node:addTo(self.target_, Z_ORDER.topTipView)
	node:setPosition(SoraDFPosX(640, 640), 256)
	self.Node_war = node
	local obj = fguiHelper.createObject("SimulatedDrill", "SimulatedDrillUIBottom")
	obj:addTo(self.Node_war)
	if not SoraDFIsRA() then
		obj:fixChildrenPos()
	end
	local _fields = fguiHelper.get_fields(obj)
	_fields.Button_camp:setString(i18n("nebula_war_text_0001"))
	_fields.Button_camp:addClickListener(handler(self, self.onClickBtnCamp))
	local btnMonsterSearch = SoraDGetChildByName(self.target_, "Button_monsterSearch")
	btnMonsterSearch:setVisible(false)
	self:fitNodeBottom()
end
function worldMapComSimulatedDrill:fitNodeBottom()
	local fitHeight = 1136
	if fitHeight <= display.height then
		self.Node_war:setPositionY(display.iPhoneXBottom + 256)
		return
	end
	local fitWidth = fitHeight / display.height * 640
	local fitScale = 640 / fitWidth
	self.Node_war:setScale(fitScale)
	self.Node_war:setPositionY(display.iPhoneXBottom + 256 * fitScale)
end
function worldMapComSimulatedDrill:onMsgUpdateWarData(...)
	if not self.warInfo then
		local height = display.height + display.iPhoneXBottom
		local offsetY = 50
		if height < 1136 then
			offsetY = offsetY * 1136 / height
		end
		local offsetY = 1136 - height - offsetY
		local obj = fguiHelper.createObject("SimulatedDrill", "Com_warInfo")
		obj:addTo(self.target_, Z_ORDER.topTipView)
		obj:setPosition(display.cx, offsetY)
		self.warInfo = obj
		local obj = fguiHelper.createObject("SimulatedDrill", "Com_warTip")
		obj:setPosition(cc.p(display.cx, offsetY + 50))
		obj:addTo(self.target_, Z_ORDER.topTipView)
		self.warTip = obj
		self.warInfo:setVisible(false)
		self.warTip:updateData(function()
			self.warInfo:setVisible(true)
		end)
	end
end
function worldMapComSimulatedDrill:onClickBtnCamp(...)
	SoraDPlaySound()
	uiManager:show("SimulatedDrillCamp")
end
function worldMapComSimulatedDrill:getNodeWar()
	return self.Node_war
end
function worldMapComSimulatedDrill:exportMethods()
	_UPVALUE1_ = nil
	;(nil)[1] = "getNodeWar"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComSimulatedDrill
