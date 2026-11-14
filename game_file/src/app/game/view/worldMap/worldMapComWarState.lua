local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local worldMapComWarState = class("worldMapComWarState", include("worldMapCom"))
function worldMapComWarState:ctor()
	worldMapComWarState.super.ctor(self, "worldMapComWarState")
end
function worldMapComWarState:init()
	self.btnWarState = ccui.Button:create("icon_warbuff_01.png", "icon_warbuff_01.png", "icon_warbuff_01.png", ccui.TextureResType.plistType)
	self.btnWarState:setPosition(cc.p(58, 340))
	self.btnWarState:addTo(self.target_)
	self.txtWarState = ccui.Text:create()
	self.txtWarState:setFontSize(18)
	self.txtWarState:setColor(cc.c3b(255, 255, 255))
	self.txtWarState:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	self.txtWarState:setAnchorPoint(cc.p(0.5, 0.5))
	self.txtWarState:setPosition(cc.p(63, 20))
	self.txtWarState:addTo(self.btnWarState)
	self.txtWarState = SoraDCreateTimerLabel(self, self.txtWarState)
	if self.btnWarState then
		self.btnWarState:addTouchEventListener(handler(self, self.buttonWarStateCall))
		local red, blue = kingdomMapCtrl:getWatchTowerLightInfo()
		if red <= 0 and blue <= 0 then
			self.btnWarState:setPositionY(270 + display.iPhoneXBottom)
		else
			self.btnWarState:setPositionY(360 + display.iPhoneXBottom)
		end
	end
	self:checkInWarState()
end
function worldMapComWarState:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WAR_STATE_REFRESH_BACK", handler(self, self.checkInWarState))
end
function worldMapComWarState:buttonWarStateCall(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local speed = kingdomMapCtrl.kingdomMapCell:getInWarStateSpeed() / 10
		_ENV = nil
		;(nil).Percent = speed
		_ENV = "war_buff_des_01"
		;("war_buff_des_01").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("war_buff_des_01", nil), "war_buff_des_01")
	end
end
function worldMapComWarState:checkInWarState()
	local remainTime = kingdomMapCtrl.kingdomMapCell:getInwarStateTime()
	if 0 < remainTime then
		self.btnWarState:setVisible(true)
		self.txtWarState:setTimeEndListener(function()
			self.btnWarState:setVisible(false)
			self.msgPanel = SoraDSearchPanelFromManagerByName("commonHelpMsgBox")
			if self.msgPanel ~= nil then
				SoraDRemoveAllAfterPanelFromManager(self.msgPanel)
			end
		end)
		self.txtWarState:beginTime(remainTime)
	else
		self.btnWarState:setVisible(false)
	end
end
return worldMapComWarState
