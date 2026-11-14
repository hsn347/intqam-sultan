local gametop = gModuleMgr.getObject("gametop")
local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local worldMapComLegend = class("worldMapComLegend", include("worldMapCom"))
function worldMapComLegend:ctor()
	worldMapComLegend.super.ctor(self, "worldMapComLegend")
end
function worldMapComLegend:init()
	local Z_ORDER = worldMapDefine.Z_ORDER
	local height = display.height + display.iPhoneXBottom
	local pyramidTip = include("worldMapPyramidTip").new()
	pyramidTip:setPosition(cc.p(display.cx, height - 270))
	pyramidTip:addTo(self.target_, Z_ORDER.topTipView)
	local legendTip = include("worldMapLegendTip").new()
	legendTip:setPosition(cc.p(display.cx, height - 115))
	legendTip:addTo(self.target_, Z_ORDER.topTipView)
	self.btnFieldIntegral = SoraDGetChildByName(self.target_, "Button_FieldIntegral")
	self.btnFieldIntegral:setPositionY(160 + display.iPhoneXBottom)
	self.btnFieldIntegral:addTouchEventListener(handler(self, self.btnFieldIntegralCall))
	local icon = SoraDGetChildByName(self.btnFieldIntegral, "icon_fight_block")
	if icon then
		icon:setSpriteFrame("btn_world_kingrank.png")
		icon:setScale(0.6)
	end
	self.buttonLegendShop = SoraDGetChildByName(self.target_, "Button_legendShop")
	if self.buttonLegendShop then
		self:initLegendShopBtn()
		self.buttonLegendShop:setPositionY(255 + display.iPhoneXBottom)
		self.buttonLegendShop:addTouchEventListener(handler(self, self.buttonLegendShopCall))
	end
end
function worldMapComLegend:initLegendShopBtn()
	if worldMapDefine.isLegendLordKingdomID() and worldMapDefine.isInLegendLord() then
		self.buttonLegendShop:setVisible(true)
	else
		self.buttonLegendShop:setVisible(false)
	end
end
function worldMapComLegend:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED", handler(self, self.kingdomStatusChange))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.refreshEventModule))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_WAR_DATA", handler(self, self.updateLegendData))
	self:updateFieldIntral()
end
function worldMapComLegend:refreshEventModule(target, redata)
	self:updateFieldIntral()
end
function worldMapComLegend:kingdomStatusChange(target, data)
	self:updateFieldIntral()
end
function worldMapComLegend:onEnter()
	self:reqSyncRW()
end
function worldMapComLegend:reqSyncRW()
	legendLordWarCtrl:reqLegendLordData(worldMapDefine.currentMapKindomID)
end
function worldMapComLegend:doReqestData()
	self:reqSyncRW()
end
function worldMapComLegend:btnFieldIntegralCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		SoraDSendMessage(nil)
		local bid = legendLordWarCtrl:getOpenBuildID(worldMapDefine.currentMapKindomID)
		if bid and 0 < bid then
			self:open_legendaryKingRank()
		else
			local loading = SoraDShowLoading(self.btnFieldIntegral, cc.size(50, 50))
			loading:setPosition(cc.p(50, 50))
		end
	end
end
function worldMapComLegend:updateFieldIntral()
	local legendLordActivityStatus = activityShowCtrl:getStateByID(gActivityTimeActivityID.LEGEND_LORD)
	if legendLordActivityStatus == gActivityState.OPEN then
		self.btnFieldIntegral:setVisible(true)
		return
	end
	local legendLordActivityStatus = activityShowCtrl:getStateByID(gActivityTimeActivityID.KING_STAR_BATTLE)
	if legendLordActivityStatus == gActivityState.OPEN then
		self.btnFieldIntegral:setVisible(true)
		return
	end
	if legendLordWarCtrl:isInWar() then
		self.btnFieldIntegral:setVisible(true)
		return
	end
	self.btnFieldIntegral:setVisible(false)
end
function worldMapComLegend:updateLegendData()
	if SoraDGetLoading(self.btnFieldIntegral) then
		SoraDCloseLoading(self.btnFieldIntegral)
		self:open_legendaryKingRank()
	end
end
function worldMapComLegend:open_legendaryKingRank()
	local bid = legendLordWarCtrl:getOpenBuildID(worldMapDefine.currentMapKindomID)
	if bid and 0 < bid then
		local panel = SoraDCreatePanel("legendaryKingRank")
		panel:init(bid, worldMapDefine.currentMapKindomID)
		panel:show()
	end
end
function worldMapComLegend:buttonLegendShopCall(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) then
			SoraDCreatePanelByFixName("kingStarShopView"):show()
		else
			SoraDCreatePanel("legendaryShopView"):show()
		end
	end
end
return worldMapComLegend
