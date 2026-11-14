local constantRead = include("constantRead")
local publicRead = include("publicRead")
local starTreasureCtrl = SoraDGetCtrl("starTreasureCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_ramTreasureMain = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarTreasure/Com_ramTreasureMain", Com_ramTreasureMain)
function Com_ramTreasureMain:onInit()
	self:fixChildrenPos()
	self.mergeItemID = 845001
	self.useItemID = 844901
	self.NEED_NUM = constantRead.getConstValue("RAMADAN_MAP_NUM", 1000)
	self.fields.txt_reward:setString(i18n("decrypt_text_03"))
	self.fields.txt_reward:addClickListener(function(eventContext)
		SoraDPlaySound()
		uiManager:show("StarTreasureReward"):setOwnerKey(self)
	end)
	self.fields.btn_Merge:setTitle(i18n("common_text_1352"))
	self.fields.btn_Use:setTitle(i18n("common_text_314"))
	self.fields.Label_text:setTitle(i18n("ramadanTreasure_text01"))
	self:setActivityTime()
	self.fields.btn_Merge:addClickEventListener(handler(self, self.onClickMerge))
	self.fields.btn_Use:addClickEventListener(handler(self, self.onClickUse))
	self:initData()
end
function Com_ramTreasureMain:initData()
	local mergeNum = backpackCtrl:getItemCount(self.mergeItemID)
	local mergeName = publicRead.getName(self.mergeItemID)
	local color = mergeNum >= self.NEED_NUM and "#FFFFFF" or "#FF0600"
	self.fields.txt_item_num:setString(mergeName .. " " .. fguiHelper.getColorString(color, mergeNum) .. "/" .. self.NEED_NUM)
	if 20 < #mergeName then
		self.fields.txt_item_num:setWidth(250)
		self.fields.txt_item_num:setAutoSize(fgui.AutoSizeType.HEIGHT)
	end
	self.fields.btn_Merge:setTitleColor(mergeNum >= self.NEED_NUM and cc.c3b(255, 255, 255) or cc.c3b(255, 6, 0, 1))
	local useNum = backpackCtrl:getItemCount(self.useItemID)
	color = 0 < useNum and "#FFFFFF" or "#FF0600"
	local useName = publicRead.getName(self.useItemID)
	self.fields.txt_call_num:setString(useName .. " " .. fguiHelper.getColorString(color, useNum))
	if 20 < #useName then
		self.fields.txt_call_num:setWidth(250)
		self.fields.txt_call_num:setAutoSize(fgui.AutoSizeType.HEIGHT)
	end
	if starTreasureCtrl:isOnUsing() then
		self.fields.btn_Use:setTitle(i18n("ramadanTreasure_text06"))
	else
		self.fields.btn_Use:setTitle(i18n("common_text_314"))
	end
end
function Com_ramTreasureMain:setActivityTime()
	SoraDCreateTimerLabel(self, self.fields.txt_time)
	self.fields.txt_time:setTimeLast(function(strTime)
		local str = fguiHelper.getColorString("#FFFFFF", i18n("common_text_2669")) .. fguiHelper.getColorString("#FFFFFF", strTime)
		return str
	end)
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.STAR_TREASURE_EXPLORE)
	if eventTime then
		self.fields.txt_time:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
end
function Com_ramTreasureMain:onClickMerge()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.mergeItemID) >= self.NEED_NUM then
		starTreasureCtrl:sendMergeMsg()
	else
		_ENV = nil
		;(nil).itemID = self.mergeItemID
		uiManager:show("CommonSourceGuide", nil)
	end
end
function Com_ramTreasureMain:onClickUse()
	SoraDPlaySound()
	print("fskdfjslkfsf")
	print(starTreasureCtrl:getPosX())
	print(starTreasureCtrl:getPosY())
	if starTreasureCtrl:isOnUsing() then
		print("noCOmming")
		SoraDGotoWorldMapPoint(cc.p(starTreasureCtrl:getPosX(), starTreasureCtrl:getPosY()), true)
		SoraDRemoveAllPrePanelFromManager(self)
	elseif backpackCtrl:getItemCount(self.useItemID) > 0 then
		starTreasureCtrl:sendUseMsg()
	elseif backpackCtrl:getItemCount(self.mergeItemID) >= self.NEED_NUM then
		starTreasureCtrl:sendUseMsg()
	else
		_ENV = starTreasureCtrl:getPosY()
		starTreasureCtrl:getPosY().itemID = self.mergeItemID
		uiManager:show("CommonSourceGuide", starTreasureCtrl:getPosY())
	end
end
function Com_ramTreasureMain:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("snowWolfLost_001")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function Com_ramTreasureMain:onShow()
	if SoraDGetDefaultLanguage() ~= "ar" then
		self.fields.n12:setPositionX(self.fields.txt_reward:getPositionX() + self.fields.txt_reward:getWidth())
	end
end
return Com_ramTreasureMain
