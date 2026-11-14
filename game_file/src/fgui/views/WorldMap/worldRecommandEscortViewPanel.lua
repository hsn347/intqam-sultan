local gametop = gModuleMgr.getObject("gametop")
local escortCtrl = gametop.playertop_:getModule("escortCtrl")
local lordLocalData = include("lordLocalData")
local mailFunctions = include("mailFunctions")
local escortDesRead = include("escortDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local worldRecommandEscortViewPanel = class("worldRecommandEscortViewPanel", baseFguiPanel)
function worldRecommandEscortViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("worldRecommandEscortViewPanel:ctor", self.viewName)
end
function worldRecommandEscortViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function worldRecommandEscortViewPanel:onInit()
	print("=======worldRecommandEscortViewPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("common_text_2321"))
	self.text_currentScort = self.fields.text_currentScort
	self.btn_rob = self.fields.btn_rob
	self.btn_change = self.fields.btn_change
	self.btn_rob:setTitle(i18n("common_text_2325"))
	self.btn_change:setTitle(i18n("common_text_2335"))
	self.btn_rob:addClickEventListener(handler(self, self.btnRob))
	self.btn_change:addClickEventListener(handler(self, self.btnChange))
	self.head = self.fields.CCS_commonHead_head
	self.car = self.fields.CCS_worldEscortCar_car
	self.text_name = self.fields.text_name
	self.text_car_lv = self.fields.text_car_lv
	self.text_count_left = self.fields.text_count_left
	self.text_remainScort = self.fields.text_remainScort
	self.head:fixPos()
	self.car:fixPos()
	self.text_name:fixPos()
	self.text_car_lv:fixPos()
	self.text_count_left:fixPos()
	self.btn_rob:fixPos()
	self.btn_change:fixPos()
	self.text_remainScort:fixPos()
	self.fields.frame_arrow:fixPos()
	self.fields.frame_arrow:setRotation(SoraDFIsRA() and 90 or -90)
	self.btn_Refresh = self.fields.btn_Refresh
	self.btn_Refresh:setTitle(i18n("common_text_911"))
	self.btn_Refresh:addClickEventListener(handler(self, self.btnChange))
	self.text_no_player_tip = self.fields.text_no_player_tip
	self.text_no_player_tip:setString(i18n("common_text_2469"))
	self:requestData()
end
function worldRecommandEscortViewPanel:onShow()
	print("=======worldRecommandEscortViewPanel:onShow")
end
function worldRecommandEscortViewPanel:initWithData(data)
	self.itemData = data
	_ENV = nil
	;(nil).num = self.itemData.escortTotalNum
	self.text_currentScort:setString(i18n("common_text_2333", nil))
	_ENV = i18n("common_text_2333", nil)
	i18n("common_text_2333", nil).count = self.itemData.robDayMax - self.itemData.robCount
	i18n("common_text_2333", nil).max = self.itemData.robDayMax
	self.text_remainScort:setString(i18n("common_text_2334", i18n("common_text_2333", nil)))
	self.text_currentScort:setVisible(true)
	self.text_remainScort:setVisible(true)
	if self.itemData.user and next(self.itemData.user) ~= nil then
		self.controllers.c1:setSelectedIndex(1)
		local imageId = self.itemData.user.imageId
		local avatar = self.itemData.user.avatar
		local playerID = tonumber(self.itemData.user.uid)
		local alliance = self.itemData.user.alliance
		local nickName = self.itemData.user.nickName
		local level = self.itemData.user.level
		self.head:setHeadSprite(imageId, avatar)
		self.head:setPlayerID(playerID)
		local nameStr = mailFunctions:getWrappedName(alliance, nickName)
		_ENV = i18n("common_text_2334", i18n("common_text_2333", nil))
		i18n("common_text_2334", i18n("common_text_2333", nil)).lv = level
		i18n("common_text_2334", i18n("common_text_2333", nil)).name = nameStr
		self.text_name:setString(i18n("common_text_134", i18n("common_text_2334", i18n("common_text_2333", nil))))
		local carLv = self.itemData.user.queue.cartLv
		local car = i18n(escortDesRead.getCarName(carLv))
		if self.itemData.user.queue.buff ~= nil and self.itemData.user.queue.buff ~= 0 then
			car = car .. i18n("escort_text_01")
		end
		self.text_car_lv:setString(car)
		local carColor = escortDesRead.getCarColor(carLv)
		self.text_car_lv:setColor(carColor)
		_ENV = carColor
		carColor.lv = carLv
		self.car:initWithData(carColor)
		local leagueID = self.itemData.user.allianceId
		if leagueID then
			local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
			local allianceMgr = gametop.playertop_:getModule("allianceMgr")
			local lineColor = cc.c3b(215, 195, 155)
			local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(leagueID)
			self.myLeagueID = allianceMgr:getOwnAid()
			if self.myLeagueID == leagueID then
				lineColor = worldMapDefine.getLeagueManorLineColor(true)
			else
				lineColor = worldMapDefine.getLeagueManorLineColor(false, allianceRelationType)
			end
			self.text_name:setColor(lineColor)
		end
		local leftCount = escortCtrl:getEscortAllowRobbedOnceMax() - (self.itemData.user.queue.beRobbedCount or 0)
		_ENV = self.text_name
		self.text_name.num = leftCount .. "/" .. escortCtrl:getEscortAllowRobbedOnceMax()
		self.text_count_left:setString(i18n("escort_text_02", self.text_name))
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function worldRecommandEscortViewPanel:requestData()
	SoraDShowLoading(self)
	escortCtrl:reqGetRobRecommend()
end
function worldRecommandEscortViewPanel:btnRob()
	SoraDPlaySound()
	print("TODO: 掠夺玩家--------------")
	if self.itemData.user.queue == nil then
		SoraDShowMsgTip("Data error! no queue!")
		return
	end
	local moveLineID = self.itemData.user.queue.id
	self.itemData.user.queue.client_queue = true
	SoraDGotoWorldMoveLine(moveLineID, false, self.itemData.user.queue)
	self:close(nil, ccui.TouchEventType.ended)
end
function worldRecommandEscortViewPanel:btnChange()
	SoraDPlaySound()
	print("换一个--------------")
	self:requestData()
end
function worldRecommandEscortViewPanel:sMsgGetRobRecommandSuccess(target, data)
	SoraDCloseLoading(self)
	self:initWithData(data.data)
end
function worldRecommandEscortViewPanel:sMsgGetRobRecommandFailed(target, data)
	SoraDCloseLoading(self)
	self.controllers.c1:setSelectedIndex(0)
end
return worldRecommandEscortViewPanel
