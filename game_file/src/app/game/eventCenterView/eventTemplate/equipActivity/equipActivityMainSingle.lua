local weaponSprctrumCtrl = SoraDGetCtrl("weaponSprctrumCtrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local weaponSprctrumRead = include("weaponSprctrumRead")
local equipActivityMainSingle = class("equipActivityMainSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("equipActivityMainSingle")
	end
	return target
end)
function equipActivityMainSingle:ctor()
	self.activityID = gActivityTimeActivityID.EQUIP_ACTIVITY
	self.frame_bqp_cell = SoraDGetChildByName(self, "frame_bqp_cell")
	self.icon_g = SoraDGetChildByName(self, "icon_g")
	self.Sprite_eType = SoraDGetChildByName(self, "Sprite_eType")
	self.Node_progress = SoraDGetChildByName(self, "Node_progress")
	self.loadingbar = SoraDGetExtendChildFromCCSByName(self, "CCS_equipActivityTypeBar_bar")
	self.Text_percent = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_percent"))
	self.Text_claimed = SoraDGetChildByName(self, "Text_claimed")
	self.Text_claimed:setString(i18n("common_text_2601"))
	self.Node_unity = SoraDGetChildByName(self, "Node_unity")
	self.Node_unity:setVisible(false)
	if G_IS_UNITY then
		self.Node_unity:setPositionX(86)
	end
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.Panel_touch:setTouchEnabled(true)
	self.Panel_touch:setSwallowTouches(false)
	self.Panel_touch:addTouchEventListener(handler(self, self.onPanelTouchClick))
	self.Image_redPoint = SoraDGetChildByName(self, "Image_redPoint")
	self.Text_redPointInt = SoraDGetChildByName(self, "Text_redPointInt")
	self.Image_redPoint:setVisible(false)
	self:initUnityEffect()
end
function equipActivityMainSingle:initUnityEffect()
	for k, v in pairs(weaponSprctrumRead.kuangCfg) do
		SoraDCreateShaderEffect(v, self.Node_unity)
	end
end
function equipActivityMainSingle:initData(data, otherData)
	self.data = data
	self.ownScroll = otherData.scroll
	self.Panel_touch:setTag(self.data.eType)
	self.Sprite_eType:setSpriteFrame(weaponSprctrumRead.getTypeConfig(self.data.eType).icon)
	local showColor = self.data.cur >= self.data.total and "#ffffff" or "#be2828"
	weaponSprctrumRead = nil
	;(nil).num = self.data.cur
	weaponSprctrumRead, weaponSprctrumRead, (nil).maxnum = nil, self.data.total, self.data.total
	weaponSprctrumRead, self.data.total.num, (nil).color = nil, nil, showColor
	self.data.total.__default, (nil).color = nil, "#ffffff"
	self.Text_percent:setString(i18n_html("reurn_text_04", nil, self.data.total))
	self.loadingbar:setPercent(math.min(100, self.data.cur * 100 / self.data.total))
	local isAllClaimed = self:isAllClaimed()
	local ret = self.data.isClaimed and isAllClaimed
	self.icon_g:setVisible(ret)
	self.Text_claimed:setVisible(ret)
	self.Node_progress:setVisible(not ret)
	self.Text_percent:setVisible(not ret)
	self.frame_bqp_cell:setColor(ret and cc.c3b(125, 125, 125) or cc.c3b(255, 255, 255))
	self.Sprite_eType:setColor(ret and cc.c3b(125, 125, 125) or cc.c3b(255, 255, 255))
	self.Node_unity:setVisible(not self.data.isClaimed and 100 <= self.loadingbar:getPercent())
	self.Image_redPoint:setVisible(self:getQuestClaimNum() > 0)
	self.Text_redPointInt:setString(self:getQuestClaimNum())
end
function equipActivityMainSingle:getQuestClaimNum()
	local questData = activityTaskComponentCtrl:getQuestData(self.activityID)
	local questList = weaponSprctrumRead.getTypeTask(self.data.eType)
	local num = 0
	local finishNum = 0
	for k, v in ipairs(questList) do
		if questData.finishedQuest[tostring(v.questID)] and not questData.claimedQuest[tostring(v.questID)] then
			num = num + 1
		end
		if questData.finishedQuest[tostring(v.questID)] then
			finishNum = finishNum + 1
		end
	end
	if 4 <= finishNum and not weaponSprctrumCtrl:isTypeRewardReceived(self.data.eType) then
		num = num + 1
	end
	return num
end
function equipActivityMainSingle:isAllClaimed()
	local questData = activityTaskComponentCtrl:getQuestData(self.activityID)
	local questList = weaponSprctrumRead.getTypeTask(self.data.eType)
	local ret = true
	for k, v in ipairs(questList) do
		if not questData.claimedQuest[tostring(v.questID)] then
			ret = false
			break
		end
	end
	return ret
end
function equipActivityMainSingle:onPanelTouchClick(target, event)
	if event == ccui.TouchEventType.ended then
		self.Sprite_eType:runAction(cca.scaleTo(0.12, 1.0))
		if self.ownScroll and not SoraDIsNodeVisibleOnScroll(target, self.ownScroll, event) then
			print("node is not on view")
			return
		end
		if not self.isIgnoreMove and self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local panel = SoraDCreatePanel("equipActivityTaskView")
		panel:initData(target:getTag())
		panel:show()
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
			self.Sprite_eType:runAction(cca.scaleTo(0.12, 1.0))
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
		self.Sprite_eType:runAction(cca.scaleTo(0.12, 1.0))
	elseif event == ccui.TouchEventType.began then
		self.singleIsMoved = false
		self.Sprite_eType:runAction(cca.scaleTo(0.1, 0.95))
	end
end
return equipActivityMainSingle
