local gametop = gModuleMgr.getObject("gametop")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
local everydayTaskRead = include("everydayTaskRead")
local godRewardsCtrl = SoraDGetCtrl("godRewardsCtrl")
local godRewardsSingle = class("godRewardsSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("godRewardsSingle")
	end
	return target
end)
function godRewardsSingle:ctor()
	self.awardArray, _ENV, self.data, _ENV = nil, nil, nil, nil
	self.btn_operate = SoraDGetChildByName(self, "btn_operate")
	self.text_progress_title = SoraDGetChildByName(self, "text_progress_title")
	self.text_progress_value = SoraDGetChildByName(self, "text_progress_value")
	self.text_progress_total = SoraDGetChildByName(self, "text_progress_total")
	self.text_title = SoraDGetChildByName(self, "text_title")
	self.text_title = SoraDChangeTextToHtml(self.text_title)
	self.text_progress_title:setString(i18n("common_text_3780"))
	self.btn_operate:addTouchEventListener(handler(self, self.onClick_btn_operate))
	self.btn_operate:setSwallowTouches(false)
	self.btn_operate:setTouchEnabled(true)
	local cssFileName = "godRewardsSingle"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, true)
	self:runAction(action)
end
function godRewardsSingle:initData(data, otherData)
	self.data = data
	if otherData then
		self.view = otherData.view
		self.ownScroll = otherData.scroll
		self.activityID = otherData.activityID
	end
	self.taskStatus = self.data.status
	local amount = self.data.finishCount
	local total = self.data.totalNum
	local lang = self.data.textDes
	local lang = SoraDStringsSplit(lang, ";")
	local color = cc.c3b(255, 255, 0)
	if amount < total then
		color = cc.c3b(255, 0, 0)
	end
	_ENV = nil
	_ENV, _ENV, (nil).num = total, SoraDConvertNumberWithUnit(total), SoraDConvertNumberWithUnit(total)
	_ENV, SoraDConvertNumberWithUnit(total).num, total.color = total, total, "#FFFF00"
	SoraDConvertNumberWithUnit(total).__default, total.color = total, "#ffffff"
	self.text_title:setString(i18n_html(lang[1], nil, (SoraDConvertNumberWithUnit(total))))
	self.text_progress_value:setString(SoraDConvertNumberWithUnit(amount))
	self.text_progress_value:setColor(color)
	self.text_progress_total:setString("/" .. SoraDConvertNumberWithUnit(total))
	self.btn_operate:setVisible(self.data.isAct ~= 0 or self.taskStatus ~= gBtnTargetStatusDef.GO)
	local _ENV, nodeArray = self.btn_operate.setVisible, self.btn_operate.setVisible
	local _ENV, paddingArray = self.btn_operate, self.btn_operate
	local align = false
	if SoraDFIsRA() then
		_UPVALUE3_ = SoraDFIsRA()
		_UPVALUE2_, nodeArray, SoraDFIsRA()[1] = SoraDFIsRA(), SoraDFIsRA(), self.text_progress_value
		_UPVALUE2_, nodeArray, SoraDFIsRA()[2] = SoraDFIsRA(), SoraDFIsRA(), self.text_progress_total
		_UPVALUE2_, nodeArray, SoraDFIsRA()[3] = SoraDFIsRA(), SoraDFIsRA(), self.text_progress_title
		paddingArray, SoraDFIsRA()[1] = SoraDFIsRA(), 0
		paddingArray, SoraDFIsRA()[2] = SoraDFIsRA(), 5
		align = false
	else
		_UPVALUE3_ = SoraDFIsRA()
		_UPVALUE2_, nodeArray, SoraDFIsRA()[1] = SoraDFIsRA(), SoraDFIsRA(), self.text_progress_total
		_UPVALUE2_, nodeArray, SoraDFIsRA()[2] = SoraDFIsRA(), SoraDFIsRA(), self.text_progress_value
		_UPVALUE2_, nodeArray, SoraDFIsRA()[3] = SoraDFIsRA(), SoraDFIsRA(), self.text_progress_title
		paddingArray, SoraDFIsRA()[1] = SoraDFIsRA(), 0
		paddingArray, SoraDFIsRA()[2] = SoraDFIsRA(), 5
		align = true
	end
	SoraDAlignNodeArray(nodeArray, align, paddingArray)
	self:setBtnStatus()
	self:setAward()
	if self.view.showLight then
		self:showLightEffect()
	elseif self.nodeEffect then
		self.nodeEffect:setVisible(false)
	end
end
function godRewardsSingle:showLightEffect()
	local node = _G.SoraDCreatAnimationEx("petraRareTreasureEffect", nil, false)
	if node then
		local childs = node:getChildren()
		_G.SoraDSetNodeArrayAdditive(childs)
		self:addChild(node, 99)
	end
	self.nodeEffect = node
	self.nodeEffect:setScale(0.2)
	self.nodeEffect:setPosition(SoraDFPosX(630 - (60 + (self.realNum - 1) * 90)), 45)
	if self.nodeEffect and self.nodeEffect.action then
		self.nodeEffect.action:gotoFrameAndPlay(0, false)
	end
end
function godRewardsSingle:setBtnStatus()
	self.btn_operate:setBright(self.taskStatus ~= gBtnTargetStatusDef.GOT)
	self.btn_operate:setTitleText(self.taskStatus == gBtnTargetStatusDef.GO and i18n("common_text_477") or self.taskStatus == gBtnTargetStatusDef.GET and i18n("common_text_1146") or self.taskStatus == gBtnTargetStatusDef.GOT and i18n("common_text_1892"))
	self.btn_operate:setTitleColor(self.taskStatus == gBtnTargetStatusDef.GOT and cc.c3b(120, 120, 120) or cc.c3b(255, 255, 255))
	self.btn_operate:loadTextureNormal(self.taskStatus == gBtnTargetStatusDef.GOT and "btn_gray_small.png" or self.taskStatus == gBtnTargetStatusDef.GO and "btn_blue_small_01.png" or "btn_green_small_01.png", ccui.TextureResType.plistType)
	SoraDAutoSizeButtonText(self.btn_operate, cc.size(120, 40))
end
function godRewardsSingle:setAward()
	dump(self.data.award)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local reward = serviceFunctions.tableFormat(self.data.award, nil)
	local nowNum = table.nums(self.awardArray)
	self.realNum = table.nums(reward)
	local MAX_AWARD_NUM = nowNum > self.realNum and nowNum or self.realNum
	for i = 1, MAX_AWARD_NUM do
		if not self.awardArray[i] and i <= self.realNum then
			self.awardArray[i] = include("commonItemAward").new()
			self.awardArray[i]:setScale(0.7)
			self.awardArray[i]:setBaseScale(1.0)
			self.awardArray[i]:setOwnView(self.view)
			self.awardArray[i]:setOwnScroll(self.ownScroll)
			self.awardArray[i]:setPosition(SoraDFPosX(630 - (60 + (i - 1) * 90)), 45)
			self.awardArray[i]:setLocalZOrder(99)
			self.awardArray[i]:setTag(999)
			self.awardArray[i]:addTo(self)
		end
		if self.awardArray[i] then
			if i <= self.realNum then
				self.awardArray[i]:initData(reward[i].id, reward[i].count)
			end
			self.awardArray[i]:setVisible(i <= self.realNum)
		end
	end
end
function godRewardsSingle:onClick_btn_operate(button, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.taskStatus == gBtnTargetStatusDef.GET then
			SoraDShowLoading(self.view)
			_ENV = self.scroll
			self.scroll.taskID = self.data.questID
			godRewardsCtrl:sendReqGetReward(self.scroll)
		elseif self.taskStatus == gBtnTargetStatusDef.GO then
			self:skipTo()
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function godRewardsSingle:skipTo(taskID, des)
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(self.data.guideId)
	if not notNeedClose then
		SoraDRemoveAllPanelFromManager()
	end
end
return godRewardsSingle
