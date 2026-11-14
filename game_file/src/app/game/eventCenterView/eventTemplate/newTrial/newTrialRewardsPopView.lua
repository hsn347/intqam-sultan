local gametop = gModuleMgr.getObject("gametop")
local devilValleyCtrl = gametop.playertop_:getModule("devilValleyCtrl")
local newTrialRead = include("newTrialRead")
local publicRead = include("publicRead")
local newTrialRewardsPopView = class("newTrialRewardsPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("newTrialRewardsPopView")
	end
	return target
end)
function newTrialRewardsPopView:ctor()
	self.tableItem, _UPVALUE0_, self.isAddToPopManager = nil, nil, true
	self:bandWidget()
end
function newTrialRewardsPopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_NEWTRIAL_REFRESH_AWARD", handler(self, self.refreshNewTrialUI))
end
function newTrialRewardsPopView:bandWidget()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_oab")
	self.ccs_bg:setTitleName(i18n("devilvalley_text_27"))
	self.Node_Info = SoraDGetChildByName(self.Center_Node, "Node_Info")
	self.Text_bottom = SoraDGetChildByName(self.Center_Node, "Text_bottom")
	self.Text_bottom:setString(i18n("devilvalley_text_60") .. "\n" .. i18n("devilvalley_text_28"))
	self.Node_item = SoraDGetChildByName(self, "Node_item")
	self.Node_item:setVisible(false)
	self.Button_all = SoraDGetChildByName(self.Center_Node, "Button_all")
	self.Sprite_red = SoraDGetChildByName(self.Center_Node, "Sprite_red")
	self.Button_all:setTitleText(i18n("common_text_3681"))
	SoraDAutoSizeButtonTextByContent(self.Button_all)
	self.Button_all:addTouchEventListener(function(ref, type)
		if type == ccui.TouchEventType.ended then
			SoraDShowLoading(self)
			devilValleyCtrl:sendReqGetReward()
		end
	end)
	local itemH = self:getWidth() / self:getHeight() > 0.7 and 75 or 85
	local itemN = newTrialRead.showCount
	for i = 1, itemN do
		local item = self:createItem(i)
		item:addTo(self.Node_Info)
		item:setPosition(cc.p(0, -itemH * i))
		item:setVisible(true)
		self:updateBtnStatus_imp(item, i)
		table.insert(self.tableItem, item)
	end
	local sizeH = 190 + itemH * itemN
	self.ccs_bg:setSize(cc.size(self.ccs_bg:getContentSize().width, sizeH))
	local topY = sizeH / 2
	local bottomY = -sizeH / 2
	self.ccs_bg:setPositionY(bottomY)
	self.Node_Info:setPositionY(topY - 50)
	self.Text_bottom:setPositionY(bottomY + 140)
	self.Button_all:setPositionY(bottomY + 40)
	self:refreshBtnAll()
end
function newTrialRewardsPopView:refreshBtnAll(...)
	local enableAward = false
	for i, v in ipairs(self.tableItem) do
		if v.Node_box:isVisible() then
			enableAward = true
			break
		end
	end
	self.Button_all:setTouchEnabled(enableAward)
	self.Sprite_red:setVisible(enableAward)
end
function newTrialRewardsPopView:createItem(mtype)
	local item = self.Node_item:clone()
	item.imgBg = SoraDGetChildByName(item, "img_item_bg")
	item.Text_name = SoraDGetChildByName(item, "Text_name")
	item.Sp_yes = SoraDGetChildByName(item, "Sprite_3")
	item.Sp_lock = SoraDGetChildByName(item, "Sprite_4")
	item.Button_des = SoraDGetChildByName(item, "Button_des")
	item.Node_box = SoraDGetChildByName(item, "Node_box")
	local info = newTrialRead.getChallengeInfo(mtype)
	if info then
		SoraChangeSpriteImage(item.imgBg, info.bg)
		item.Text_name:setString(i18n(info.name))
		item.Text_name:setColor(info.color)
	end
	if not newTrialRead.getReward(mtype) then
		local _ENV, reward = newTrialRead.getReward(mtype), newTrialRead.getReward(mtype)
	end
	_UPVALUE2_ = i18n(info.name)
	i18n(info.name)[1] = "id"
	i18n(info.name)[2] = "count"
	reward = serviceFunctions.tableFormat(reward, i18n(info.name))
	for k, v in ipairs(reward) do
		local award = include("commonItemAward").new()
		local size = cc.size(55, 22)
		award:setOwnView(self)
		award:setTextWidthHeight(size)
		award:setScale(0.6)
		award:setBaseScale(1.0)
		award:addTo(item)
		award:initData(v.id, v.count)
		local posX = SoraDFPosX(90 - (k - 1) * 70, 0, 600)
		award:setPosition(cc.p(posX, 40))
	end
	return item
end
function newTrialRewardsPopView:refreshNewTrialUI()
	SoraDCloseLoading(self)
	self:updateBtnStatus()
	self:refreshBtnAll()
end
function newTrialRewardsPopView:updateBtnStatus()
	for i, v in ipairs(self.tableItem) do
		self:updateBtnStatus_imp(v, i)
	end
end
function newTrialRewardsPopView:updateBtnStatus_imp(item, mtype)
	local isLock = not devilValleyCtrl:checkIsUnLock(mtype)
	local isGet = devilValleyCtrl:checkIsGet(mtype)
	local isGetAward = devilValleyCtrl:checkIsGetAward(mtype)
	local enableDes = not isLock and not isGet
	item.Button_des:setVisible(enableDes)
	item.Sp_yes:setVisible(not isLock and isGet and isGetAward)
	local enableAward = not isLock and isGet and not isGetAward
	item.Node_box:setVisible(enableAward)
	item.Sp_lock:setVisible(isLock)
	item.Button_des:setTitleText(i18n("arena_btn_04"))
	if enableAward then
		local img_box = SoraDGetChildByName(item, "img_box")
		img_box:addTouchEventListener(function(ref, type)
			if type == ccui.TouchEventType.ended then
				SoraDShowLoading(self)
				devilValleyCtrl:sendReqGetReward(mtype)
			end
		end)
	elseif enableDes then
		item.Button_des:addTouchEventListener(function(ref, type)
			if type == ccui.TouchEventType.ended then
				if devilValleyCtrl:hasTeams() then
					local panel = SoraDCreatePanel("newTrialMyTeamView")
					panel:initData()
					panel:show()
				elseif not devilValleyCtrl:checkChallengeLv(mtype) then
					SoraDShowMsgTip(i18n("devilvalley_text_51"))
				elseif not devilValleyCtrl:checkCastleCondition(mtype) then
					local lvLimit = newTrialRead.getCastleCondition(mtype)
					local transLevel = function(bLevel)
						local buildLogic = include("buildLogic")
						local warLv = buildLogic.transformBuildLvToWarLv(bLevel)
						if 0 < warLv then
							_ENV = nil
							;(nil).lv = warLv
							return i18n("common_text_1948", nil)
						else
							return math.min(bLevel, _G.CASTLE_MAXLV_NOWAR)
						end
					end
					local lv = transLevel(lvLimit)
					_ENV = i18n("devilvalley_text_51")
					i18n("devilvalley_text_51").lv = lv
					SoraDShowMsgTip(i18n("common_text_3868", i18n("devilvalley_text_51")))
				else
					devilValleyCtrl:sendReqCreateTeam(mtype)
					self:removeFromParent()
				end
			end
		end)
	end
end
return newTrialRewardsPopView
