local gametop = gModuleMgr.getObject("gametop")
local alliancePetCtrl = gametop.playertop_:getModule("alliancePetCtrl")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local allianceDesRead = include("allianceDesRead")
local alliancePetRewardPopView = class("alliancePetRewardPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("alliancePetRewardPopView")
	end
	return target
end)
function alliancePetRewardPopView:ctor()
	self.itemList, _ENV, self.scaleActTarget = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node")
	self.petType = nil
	self.maxTrailLv = nil
	self.minTrailLv = nil
	self.curShowLv = nil
	self.curLv = nil
	self:initWidget()
end
function alliancePetRewardPopView:initWidget()
	self.commonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.commonPopBox:setTitleName(i18n("alliance_beast_btn_04"))
	self.Node_content = SoraDGetChildByName(self, "Node_content")
	self.Image_3 = SoraDGetChildByName(self, "Image_3")
	self.Text_lv = SoraDGetChildByName(self, "Text_lv")
	self.Text_des_1 = SoraDGetChildByName(self, "Text_des_1")
	self.Text_des_2 = SoraDGetChildByName(self, "Text_des_2")
	self.Text_des_1:setString(i18n("alliance_beast_text_17"))
	if self.Text_des_1:getContentSize().width > 480 then
		SoraDSetTextWidthHeight(self.Text_des_1, cc.size(480, 50))
		local image_bg = SoraDGetChildByName(self, "Image_des1_bg")
		image_bg:setPositionY(image_bg:getPositionY() - 5)
		self.Text_des_2:setPositionY(self.Text_des_2:getPositionY() - 5)
	end
	self.Button_pre = SoraDGetChildByName(self, "Button_pre")
	self.Button_pre:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		self.curShowLv = self.curShowLv - 1
		if self.curShowLv < self.minTrailLv then
			self.curShowLv = self.maxTrailLv
		end
		self:initData()
	end)
	self.Button_next = SoraDGetChildByName(self, "Button_next")
	self.Button_next:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		self.curShowLv = self.curShowLv + 1
		if self.curShowLv > self.maxTrailLv then
			self.curShowLv = self.minTrailLv
		end
		self:initData()
	end)
	self.Button_trial = SoraDGetChildByName(self, "Button_trial")
	self.Button_trial:setTitleText(i18n("alliance_beast_btn_03"))
	self.Button_trial:addTouchEventListener(handler(self, self.btnTrialCallback))
end
function alliancePetRewardPopView:initData()
	self:checkBtnState()
	_ENV = nil
	;(nil).lv = self.curShowLv
	self.Text_lv:setString(string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", nil)))
	local alliancePetRead = include("alliancePetRead")
	if not alliancePetRead.getRewards(self.petType, self.curShowLv) then
		local _ENV, rewards = alliancePetRead.getRewards(self.petType, self.curShowLv), alliancePetRead.getRewards(self.petType, self.curShowLv)
	end
	local MAX_REWARD = 8
	if IsArClient then
		_UPVALUE2_ = string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", nil))
		string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", nil))[1] = "id"
		string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", nil))[2] = "count"
		rewards = serviceFunctions.tableFormat(rewards, string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", nil)))
	else
		_UPVALUE3_ = string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", nil))
		string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", nil))[1] = "id"
		string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", nil))[2] = "count"
		string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", nil))[3] = "weight"
		rewards = serviceFunctions.tableFormat(rewards, string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", nil)))
	end
	local dataCount = #rewards
	dataCount = math.min(MAX_REWARD, math.floor(dataCount / 2) * 2)
	for k, v in pairs(self.itemList) do
		v:setVisible(false)
	end
	local getItemPosition = function(i)
		_ENV = nil
		;(nil).x = 105 + 110 * ((i - 1) % 4)
		local (nil).y, position = 0 - (math.ceil(i / 4) - 1) * 100, nil
		return position
	end
	local _ENV, positions = pairs(self.itemList)
	for i = 1, MAX_REWARD do
		local position = getItemPosition(i)
		positions[#positions + 1] = position
	end
	if dataCount == 6 then
		for i = 1, dataCount do
			if i <= 2 then
				positions[i] = clone(positions[i + 1])
			else
				positions[i] = clone(positions[i + 2])
			end
		end
	end
	for i = 1, dataCount do
		local singleItem
		if not self.itemList[i] then
			singleItem = include("itemSingleView").new()
			singleItem:addTo(self.Node_content)
			singleItem:setScale(0.65)
			singleItem:setItemClickCallback(handler(self, self.showDetail))
			self.itemList[i] = singleItem
		else
			self.itemList[i]:setVisible(true)
			singleItem = self.itemList[i]
		end
		if positions[i] then
			singleItem:setPosition(positions[i])
		else
			singleItem:setPosition(getItemPosition(i))
		end
		_ENV, _ENV = getItemPosition(i)
		getItemPosition(i).id = rewards[i].id
		getItemPosition(i).itemData, getItemPosition(i).count = getItemPosition(i)
		singleItem:initData(getItemPosition(i))
		singleItem:setButtonTag(rewards[i].id)
	end
	local height = 320 + math.ceil(dataCount / 4) * 100
	self.commonPopBox:setSize(cc.size(542, height))
	self.commonPopBox:setPositionY(190 - height)
	self.Image_3:setContentSize(cc.size(self.Image_3:getContentSize().width, -170 + height))
	self.Text_des_2:setString(alliancePetRead.getWishDesByType(self.petType, self.curShowLv))
	self.Button_trial:setPositionY(255 - height)
	if self.curLv == self.maxTrailLv then
		self.Button_pre:setVisible(false)
		self.Button_next:setVisible(false)
	end
end
function alliancePetRewardPopView:showDetail(button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		button:stopAllActions()
		if self.tips then
			self.tips:removeFromParent()
			self.tips = nil
		end
	elseif type == ccui.TouchEventType.began then
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(0.2)
		;(nil)[2] = cca.callFunc(function()
			self.tips = SoraDCreatePanel("commonItemTips")
			self.tips:initData(button:getTag())
			local dt = 140
			if not SoraDFIsRA() then
				dt = -140
			end
			self.tips:setPosition(cc.p(320 + dt, display.cy + 160))
			self.tips:addTo(self, 99)
		end)
		;(nil)[3] = cca.callFunc(function()
			self.tips = SoraDCreatePanel("commonItemTips")
			self.tips:initData(button:getTag())
			local dt = 140
			if not SoraDFIsRA() then
				dt = -140
			end
			self.tips:setPosition(cc.p(320 + dt, display.cy + 160))
			self.tips:addTo(self, 99)
		end)
		button:runAction(cca.seq(nil))
	end
end
function alliancePetRewardPopView:checkBtnState()
	self.curLv = alliancePetCtrl:getAlliancePetLv()
	if self.curLv < self.curShowLv then
		self.Button_trial:setBright(false)
		return false
	else
		self.Button_trial:setBright(true)
		return true
	end
end
function alliancePetRewardPopView:btnTrialCallback(button, type)
	if type ~= ccui.TouchEventType.ended then
		return
	end
	local checkTrialBeginCond = function()
		if not self:checkBtnState() then
			self = nil
			;(nil).Lvl = self.curShowLv
			SoraDShowMsgTip(i18n("alliance_beast_notice_05", nil))
			return false
		end
		if not permissionCtrl:hasPlayerPermission(gAPermission.ALLIANCE_PET_TRIAL) then
			SoraDShowMsgTip(i18n("notice_0073"))
			return false
		end
		return true
	end
	if not checkTrialBeginCond() then
		return
	end
	SoraDShowMsgBox(i18n("alliance_beast_notice_06"), i18n("common_text_204"), i18n("common_text_185"), function(type)
		if type == MSGBOX_CALLBACK_YES then
			if not checkTrialBeginCond() then
				return
			end
			alliancePetCtrl:sendReqTrial()
		end
	end)
end
function alliancePetRewardPopView:setRewardInfo(petType)
	self.petType = petType
	local alliancePetRead = include("alliancePetRead")
	self.maxTrailLv = alliancePetRead.getMaxTrailLevel(self.petType)
	self.minTrailLv = alliancePetRead.getMinTrailLevel(self.petType)
	self.curLv = alliancePetCtrl:getAlliancePetLv()
	self.curShowLv = math.max(self.curLv, self.minTrailLv)
	self.minTrailLv = self.curShowLv
	self:initData()
end
return alliancePetRewardPopView
