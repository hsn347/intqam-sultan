local baseComponent = require("fgui.base.baseComponent")
local caracalmian = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewServerReturn/caracalmian", caracalmian)
local newServerPetRead = include("newServerPetRead")
local newServerPetCtrl = SoraDGetCtrl("newServerPetCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
function caracalmian:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self.controllers.c1:setSelectedIndex(1)
	self.controllers.c2:setSelectedIndex(2)
	self.listData, _ENV = self.controllers.c2.setSelectedIndex, self.controllers.c2.setSelectedIndex
	self.curPetLv = 0
	self.isUnlock = false
	self.eachLv = newServerPetRead.getReturnCatRewardConfig().lv
	self.itemIDFeed = 848001
	self.itemIDWalk = 849001
	self.itemFeedCost = 1
	self.itemWalkCost = 1
	self.itemFeedCount = 0
	self.itemWalkCount = 0
	local iconPng = publicRead.getIcon(self.itemIDFeed)
	self.fields.feed_icon:setURL(iconPng)
	iconPng = publicRead.getIcon(self.itemIDWalk)
	self.fields.walk_icon:setURL(iconPng)
	self.listData = newServerPetRead.getReturnCatExpConfig()
	self.fields.Text_time:initActivityTime(gActivityTimeActivityID.VICIOUS_PET_ACTIVITY)
	self.fields.Button_info:addClickListener(handler(self, self.onClickInfo))
	self.fields.Button_award:addClickListener(handler(self, self.onClickAward))
	self.fields.Button_award:setTitle(i18n("return_lcks_btn_012"))
	self.fields.Button_receive:addClickListener(handler(self, self.onClickReceive))
	self.fields.Text_walking = SoraDCreateTimerLabel(self, self.fields.Text_walking)
	self.fields.Text_walking:setTimeLast(function(ticket)
		return string.format([[
%s
%s]], i18n("return_lcks_text_023"), ticket)
	end)
	self.fields.Button_unlock:setTitle(i18n("pet_name_13"))
	fguiHelper.get_fields(self.fields.Button_unlock).Text_lvCondi:setString(i18n("return_lcks_text_014"))
	self.fields.Button_unlock:addClickListener(handler(self, self.onClickUnlock))
	self.fields.Text_level_title:setString(i18n("common_text_748"))
	self.fields.Text_youmao:setString(i18n("return_lcks_title_016"))
	self.fields.Text_zhanmao:setString(i18n("return_lcks_title_017"))
	self.fields.Button_feed:addClickListener(handler(self, self.onClickFeed))
	self.fields.Button_feed:setTitle(i18n("return_lcks_btn_019"))
	self.fields.Button_walk:addTouchEventListener(handler(self, self.onClickWalk))
	self.fields.Button_walk:setTitle(i18n("return_lcks_btn_020"))
	self.fields.Button_add:addClickListener(handler(self, self.onClickAdd))
	self.fields.Ani_cat:setAllFrameName("img_viciouscat_run_%02d.png", 1)
	self.fields.Ani_cat:setPlaySettings(0, -1, -1)
	self.fields.scroll:setVirtual()
	self.fields.scroll:setItemRenderer(handler(self, self.onCellRender))
end
function caracalmian:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_HONOR_PET_INIT", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_SERVER_HONOR_PET_REFRESH", handler(self, self.recviceData))
	SoraDAddMessage(self, "MESSAGE_SERVER_HONOR_PET_ITEM", handler(self, self.refreshItemCount))
end
function caracalmian:onShow()
	self:refreshItemCount()
	self:refreshData()
end
function caracalmian:recviceData(target, data)
	SoraDCloseLoading()
	if data.name == "upgrade" then
		self:refreshLv()
		self:popLevelUpView(data.reward)
		self:showExpEffect()
	elseif data.name == "exp" then
		self:refreshExp()
		self:showExpEffect()
	elseif data.name == "patrol" then
		self:refreshWalk()
	elseif data.name == "unlock" then
		self:afterUnlock()
		self:popUnlockView(data.reward)
	end
end
function caracalmian:showExpEffect(...)
end
function caracalmian:refreshData(...)
	local initData = newServerPetCtrl:getInitData()
	self.curPetExp = initData.curPetExp
	self.curPetLv = initData.curPetLv
	self.isAdopt = initData.isAdopt
	self.isUnlock = initData.isUnlock
	self.patrolEndtime = initData.patrolEndtime
	if not self.isAdopt then
		uiManager:show("caracalTack")
		return
	end
	self:refreshLv()
	self:refreshWalk()
	self.controllers.c1:setSelectedIndex(self.isUnlock and 0 or 1)
end
function caracalmian:onClickInfo(button, eventType)
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("newstart_text_61"))
end
function caracalmian:onClickAward(button, eventType)
	SoraDPlaySound()
	uiManager:show("CheckReward")
end
function caracalmian:onClickFeed(button, eventType)
	if self.expTimer then
		return
	end
	SoraDPlaySound()
	if self.itemFeedCount >= self.itemFeedCost then
		newServerPetCtrl:sendReqUpgrade()
	else
		self:popItemGuideView()
	end
end
function caracalmian:onClickWalk(button, eventType)
	SoraDPlaySound()
	if self.fields.Button_walk:isBright() then
		if self.itemWalkCount >= self.itemWalkCost then
			newServerPetCtrl:sendReqPatrol()
		else
			SoraDShowMsgBox(i18n("return_lcks_text_021"), i18n("common_text_204"))
		end
	elseif self.patrolEndtime == 0 then
		SoraDShowMsgBox(i18n("pet_text_54"), i18n("common_text_204"), nil, function(type, target)
			if MSGBOX_CALLBACK_CANCEL ~= type then
				newServerPetCtrl:sendReqReceivePatrol()
			end
		end)
	else
		local petName = i18n("pet_name_14")
		if self.isUnlock then
			petName = i18n("pet_name_13")
		end
		function _ENV(type, target)
			if MSGBOX_CALLBACK_CANCEL ~= type then
				newServerPetCtrl:sendReqReceivePatrol()
			end
		end
		;(function(type, target)
			if MSGBOX_CALLBACK_CANCEL ~= type then
				newServerPetCtrl:sendReqReceivePatrol()
			end
		end).name = petName
		SoraDShowMsgTip(i18n("pet_text_53", function(type, target)
			if MSGBOX_CALLBACK_CANCEL ~= type then
				newServerPetCtrl:sendReqReceivePatrol()
			end
		end))
	end
end
function caracalmian:onClickReceive(button, eventType)
	SoraDPlaySound()
	newServerPetCtrl:sendReqReceivePatrol()
end
function caracalmian:onClickUnlock(button, eventType)
	SoraDPlaySound()
	uiManager:show("caracalUpgrade")
end
function caracalmian:onClickAdd(button, eventType)
	SoraDPlaySound()
	self:popItemGuideView()
end
function caracalmian:popItemGuideView(...)
	_ENV = nil
	;(nil).itemID = self.itemIDFeed
	uiManager:show("CommonSourceGuide", nil)
end
function caracalmian:refreshLv(...)
	local initData = newServerPetCtrl:getInitData()
	self.curPetLv = initData.curPetLv
	if self.curPetLv >= 2 then
		fguiHelper.get_fields(self.fields.Button_unlock).Text_lvCondi:setVisible(false)
	end
	self.fields.Text_level:setString(tostring(self.curPetLv))
	self.fields.Text_level:setPosition(cc.p(self.fields.heart:getPositionX(), self.fields.heart:getPositionY() + 3))
	self:refreshExp()
	local normalLv = #self.listData - 1 + self.eachLv
	local lv2 = normalLv - self.curPetLv
	if lv2 < 0 then
		lv2 = lv2 % self.eachLv
	end
	if lv2 == 0 then
		lv2 = self.eachLv
	end
	newServerPetCtrl = cc.p(self.fields.heart:getPositionX(), self.fields.heart:getPositionY() + 3)
	cc.p(self.fields.heart:getPositionX(), self.fields.heart:getPositionY() + 3).lv1 = self.eachLv
	cc.p(self.fields.heart:getPositionX(), self.fields.heart:getPositionY() + 3).lv2 = lv2
	self.tipStr = i18n("return_lcks_text_018", cc.p(self.fields.heart:getPositionX(), self.fields.heart:getPositionY() + 3))
	self.fields.scroll:setNumItems(#self.listData)
end
function caracalmian:refreshExp(...)
	local initData = newServerPetCtrl:getInitData()
	self.curPetExp = initData.curPetExp
	local maxValue = newServerPetRead.getLvNeedExp(self.curPetLv)
	self.fields.progressExp:setMax(maxValue)
	self.fields.progressExp:setValue(self.curPetExp)
end
function caracalmian:refreshItemCount(...)
	self.itemFeedCount = backpackCtrl:getItemCount(self.itemIDFeed)
	self.itemFeedCost = newServerPetCtrl:getItemFeedCost()
	if self.itemFeedCount ~= 0 then
		self.fields.Button_feed:setCost(self.itemIDFeed, self.itemFeedCount)
	else
		self.fields.Button_feed:setCost(self.itemIDFeed, 1)
	end
	self.fields.Text_feed_num:setString(tostring(self.itemFeedCount))
	self.itemWalkCount = backpackCtrl:getItemCount(self.itemIDWalk)
	self.fields.Button_walk:setCost(self.itemIDWalk, self.itemWalkCost)
	self.fields.Text_walk_num:setString(tostring(self.itemWalkCount))
	self:refreshBtnRedP()
end
function caracalmian:refreshBtnRedP(...)
	self.fields.Button_feed:showRedPoint(newServerPetCtrl:showFeedRedP())
	self.fields.Button_walk:showRedPoint(newServerPetCtrl:showWalkRedP())
	newServerPetCtrl = self.fields.Button_walk
	self.fields.Button_walk.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	SoraDSendMessage(self.fields.Button_walk)
end
function caracalmian:popLevelUpView(reward)
	local panel = SoraDCreatePanel("honorBackPetLevelUp")
	panel:initLevelUpReward(reward, true)
	panel:show()
end
function caracalmian:popUnlockView(reward)
	local panel = SoraDCreatePanel("honorBackPetLevelUp")
	panel:initUnlockReward(reward, true)
	panel:show()
end
function caracalmian:afterUnlock(...)
	local initData = newServerPetCtrl:getInitData()
	self.isUnlock = initData.isUnlock
	self.controllers.c1:setSelectedIndex(self.isUnlock and 0 or 1)
	self.fields.scroll:setNumItems(#self.listData)
end
function caracalmian:refreshWalk(...)
	local initData = newServerPetCtrl:getInitData()
	self.patrolEndtime = initData.patrolEndtime
	if self.patrolEndtime > 0 then
		self.controllers.c2:setSelectedIndex(0)
		self.fields.Text_walking:beginTime(self.patrolEndtime - serviceFunctions.systemTime())
		self.fields.Button_walk:setBright(false)
	elseif self.patrolEndtime == 0 then
		self.controllers.c2:setSelectedIndex(1)
		self.fields.Button_walk:setBright(false)
	else
		self.controllers.c2:setSelectedIndex(2)
		self.fields.Button_walk:setBright(true)
	end
	self:refreshBtnRedP()
end
function caracalmian:onCellRender(index, obj)
	local data = self.listData[index + 1]
	obj:initData(data, self.isUnlock, self.curPetLv >= data.lv, self.tipStr)
end
return caracalmian
