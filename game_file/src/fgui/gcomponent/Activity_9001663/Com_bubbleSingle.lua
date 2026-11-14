local activityCommonMergeCtrl = SoraDGetCtrl("activityCommonMergeCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_bubbleSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001663/Com_bubbleSingle", Com_bubbleSingle)
fgui.register_extension("ui://Activity_9001663/Com_bubbleSingle_9001692", Com_bubbleSingle)
function Com_bubbleSingle:setActivityID(activityID)
	self.activityID = activityID
end
function Com_bubbleSingle:onInit()
	self.fields.mv_sg:setAllFrameName("9001663_saoguang_%.2d.png", 1)
	self.fields.mv_sg:setVisible(false)
	self.rewardList, _ENV, self.needList, _ENV = self.fields.mv_sg.setVisible, self.fields.mv_sg.setVisible, self.fields.mv_sg.setVisible, self.fields.mv_sg.setVisible
	self.fields.List_need:setItemRenderer(handler(self, self.onNeedRenderer))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardRenderer))
	self.fields.Label_title:setString(i18n("bubble_party_text_29"))
	self.fields.Text_need:setString(i18n("bubble_party_text_30"))
	self.fields.Button_merge:setString(i18n("common_text_1352"))
	self.fields.Button_merge:addClickListener(handler(self, self.btnComposeClick))
	self.fields.Button_merge:setBright(false)
	self:fixChildrenPos()
	self.fields.arrow:setRotation(SoraDFIsRA() and -90 or 90)
	self.fields.nbg:fix()
	self.fields.mv_sg:fix()
end
function Com_bubbleSingle:setSGAct()
	self.fields.mv_sg:setVisible(true)
	self.fields.mv_sg:setPlaySettings(0, -1, 1, -1, function()
		self.fields.mv_sg:setVisible(false)
	end)
end
function Com_bubbleSingle:onNeedRenderer(index, obj)
	local data = self.needList[index + 1]
	obj:initData(data.id, backpackCtrl:getItemCount(data.id), data.count)
end
function Com_bubbleSingle:onRewardRenderer(index, obj)
	obj:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
end
function Com_bubbleSingle:onShow()
end
function Com_bubbleSingle:setBubbleShow()
	_UPVALUE0_, _UPVALUE0_ = nil, nil
	;(nil).b = 0.27
	;(nil).c = 0
	;(nil).s = 0.73
	_UPVALUE0_, (nil)[1], (nil).h = nil, nil, -1
	;(nil).b = -0.16
	;(nil).c = 0.08
	;(nil).s = 0.61
	_UPVALUE0_, (nil)[2], (nil).h = nil, nil, 0.72
	;(nil).b = 0
	;(nil).c = 0
	;(nil).s = 0
	_UPVALUE0_, (nil)[3], (nil).h = nil, nil, 0.32
	;(nil).b = 0
	;(nil).c = 0
	;(nil).s = 0
	_UPVALUE0_, (nil)[4], (nil).h = nil, nil, 0
	;(nil).b = 0
	;(nil).c = 0
	;(nil).s = 0
	;(nil)[5], (nil).h = nil, -0.5
	local cfg
	local showCfg = cfg[self.data.bubbleType] or cfg[1]
	local bubble = self.fields.bubble:getComponent()
	bubble:getChild("icon"):setColorFilter(showCfg.b, showCfg.c, showCfg.s, showCfg.h)
end
function Com_bubbleSingle:setChestShow(...)
	local colorIndex = math.min(self.data.bubbleType - 1, 4)
	local chest = self.fields.bubble:getComponent()
	chest:getController("c1"):setSelectedIndex(colorIndex)
end
function Com_bubbleSingle:initData(data, bubbleType)
	if bubbleType and bubbleType == data.bubbleType then
		self:setSGAct()
	end
	self.data = data
	if #self.data.bubbleName > 0 then
		self.fields.Text_name:setString(i18n(self.data.bubbleName))
	end
	if self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001692 then
		self:setChestShow()
	else
		self:setBubbleShow()
	end
	self.needList = self.data.formula
	self.fields.List_need:setNumItems(#self.needList)
	self.isEnough = true
	for k, v in ipairs(self.needList) do
		if backpackCtrl:getItemCount(v.id) < v.count then
			self.isEnough = false
			break
		end
	end
	self.rewardList = self.data.rewaryd
	self.fields.List_reward:setNumItems(#self.rewardList)
	local composeCount = activityCommonMergeCtrl:getComposeCount(self.activityID, self.data.bubbleType)
	self.leftCount = math.max(self.data.limit - composeCount, 0)
	_ENV = backpackCtrl:getItemCount(v.id)
	backpackCtrl:getItemCount(v.id).num = fguiHelper.getColorString(0 < self.leftCount and "#F0D69C" or "#E02B2B", self.leftCount)
	self.fields.Text_limit:setString(i18n("bubble_party_text_03", (backpackCtrl:getItemCount(v.id))))
	local isBright = 0 < self.leftCount and self.isEnough
	self.fields.Button_merge:setBright(isBright)
	self.fields.Button_merge:setReddot(isBright, -1)
end
function Com_bubbleSingle:btnComposeClick()
	SoraDPlaySound()
	if self.leftCount <= 0 then
		SoraDShowMsgTip(i18n("bubble_party_text_04"))
		return
	end
	if not self.isEnough then
		SoraDShowMsgTip(i18n("bubble_party_text_05"))
		return
	end
	activityCommonMergeCtrl:reqCompose(self.activityID, self.data.bubbleType)
end
return Com_bubbleSingle
