local sultansBackCtrl = SoraDGetCtrl("sultansBackCtrl")
local sultansBackRead = include("sultansBackRead")
local sultansBackRebateUtil = include("sultansBackRebateUtil")
local AWARD_STATUES = sultansBackRebateUtil.AWARD_STATUES
local buffDesRead = include("buffDesRead")
local constantRead = include("constantRead")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local sultansBackRebateMainView = class("sultansBackRebateMainView", function()
	local target = SoraDCreateBasePanel("sultansBackRebateMainView")
	SoraDDeviceFitOffset(target)
	return target
end)
function sultansBackRebateMainView:ctor()
	self.buffArray, _ENV, self.targetArray, _ENV = nil, nil, nil, nil
	self.Size_bg = SoraDGetChildByName(self, "Size_bg")
	self.Node_head = SoraDGetChildByName(self, "Node_head")
	self.scroll = SoraDGetChildByName(self, "ScrollView_show")
	self.Node_show = SoraDGetChildByName(self, "Node_show")
	self.Node_bar = SoraDGetChildByName(self, "Node_bar")
	self.Panel_bar = SoraDGetChildByName(self, "Panel_bar")
	self.Node_target = SoraDGetChildByName(self, "Node_target")
	self.targetArray[1] = self.Node_target
	self.Node_singles = SoraDGetChildByName(self, "Node_singles")
	self.Node_buffItem = SoraDGetChildByName(self, "Node_buffItem")
	self.buffArray[1] = self.Node_buffItem
	self.btnRecharge = SoraDGetChildByName(self, "Button_recharge")
	self.btnRecharge:setTitleText(i18n("back_recharge_text02"))
	self.btnRecharge:addTouchEventListener(handler(self, self.onClickRecharge))
	self.txtHelpInfo = SoraDGetChildByName(self, "Text_help_info")
	SoraDChangeTextToHtml(self.txtHelpInfo)
	local var1 = string.formatnumberthousands(constantRead.getConstValue("SUDAN_BACK_HGFL_VAR1"))
	local var2 = string.formatnumberthousands(constantRead.getConstValue("SUDAN_BACK_HGFL_VAR2"))
	_ENV = constantRead.getConstValue("SUDAN_BACK_HGFL_VAR2")
	_ENV = constantRead.getConstValue("SUDAN_BACK_HGFL_VAR2")
	constantRead.getConstValue("SUDAN_BACK_HGFL_VAR2").color = "#FFFF00"
	constantRead.getConstValue("SUDAN_BACK_HGFL_VAR2").size = 24
	constantRead.getConstValue("SUDAN_BACK_HGFL_VAR2").var1 = SoraDWrapHtmlTagByStyle(var1, constantRead.getConstValue("SUDAN_BACK_HGFL_VAR2"))
	_ENV = constantRead.getConstValue("SUDAN_BACK_HGFL_VAR2")
	constantRead.getConstValue("SUDAN_BACK_HGFL_VAR2").color = "#FFFF00"
	constantRead.getConstValue("SUDAN_BACK_HGFL_VAR2").size = 24
	constantRead.getConstValue("SUDAN_BACK_HGFL_VAR2").var2 = SoraDWrapHtmlTagByStyle(var2, constantRead.getConstValue("SUDAN_BACK_HGFL_VAR2"))
	self.txtHelpInfo:setString(i18n("friend_back_text19", constantRead.getConstValue("SUDAN_BACK_HGFL_VAR2")))
	self.Text_totalRecharge = SoraDGetChildByName(self, "Text_totalRecharge")
	self.btnHelpInfo = SoraDGetChildByName(self, "Button_help_info")
	self.btnHelpInfo:addTouchEventListener(handler(self, self.onClickHelpInfo))
	self:suitView()
end
function sultansBackRebateMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SULTANSBACK_RREBATE_REFRESH", handler(self, self.updateData))
end
function sultansBackRebateMainView:suitView()
	self.Size_bg:setContentSize(cc.size(640, display.height - 470))
	self.btnRecharge:setPositionY(-display.height + 505)
	self.scroll:setContentSize(cc.size(display.width, display.height - 660))
end
function sultansBackRebateMainView:init()
	self:updateData()
end
function sultansBackRebateMainView:setParentView(parent)
	self.parentView = parent
end
function sultansBackRebateMainView:updateData()
	self:updateDataBox()
	self:initTarget()
	self:updataScroll()
end
function sultansBackRebateMainView:updataScroll(target, data)
	local boxData = sultansBackRead.getBackRechargeCfg()
	local newH = math.max(self.scroll:getContentSize().height, 82 * #boxData)
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, newH))
	self.Node_show:setPositionY(newH)
	AWARD_STATUES = self.Node_show.setPositionY
	self.Node_show.setPositionY[1] = 2
	self.Node_show.setPositionY[2] = 3
	self.Node_show.setPositionY[3] = 5
	self.Node_show.setPositionY[4] = 6
	local self.Node_show.setPositionY[5], boxIndex = 8, self.Node_show.setPositionY
	for k, v in ipairs(boxData) do
		if not self.buffArray[k] then
			self.buffArray[k] = self.Node_buffItem:clone()
			self.buffArray[k]:addTo(self.Node_singles)
		end
		self.buffArray[k]:setPosition(0, -82 * (k - 1))
		local Text_buff = SoraDGetChildByName(self.buffArray[k], "Text_buff")
		local Text_buffValue = SoraDGetChildByName(self.buffArray[k], "Text_buffValue")
		local Node_et = SoraDGetChildByName(self.buffArray[k], "Node_et")
		local icon_bg = SoraDGetChildByName(self.buffArray[k], "icon_bg")
		local icon_box = SoraDGetChildByName(self.buffArray[k], "icon_box")
		local Button_box = SoraDGetChildByName(self.buffArray[k], "Button_box")
		Button_box:setSwallowTouches(false)
		Button_box.data = v
		Button_box:addTouchEventListener(handler(self, self.onClickBox))
		local buffType = buffltCtrl:getEffectType(v.buff)
		local buffValue = buffltCtrl:getEffect(v.buff)
		Text_buff:setString(buffDesRead.getTitleBase(buffType))
		Text_buffValue:setString(buffDesRead.getTitleValueWithValue(buffType, buffValue))
		icon_bg:setSpriteFrame(sultansBackRebateUtil.getBuffImg(v.buff))
		local statues = sultansBackRebateUtil.getRoundStatues(v)
		if statues == AWARD_STATUES.AWARD_STATUES_NORMAL then
			SoraDGetCommonBox(boxIndex[k], 2, icon_box)
			Node_et:setVisible(false)
		elseif statues == AWARD_STATUES.AWARD_STATUES_COMPLETE then
			SoraDGetCommonBox(boxIndex[k], 1, icon_box)
			SoraDCreatAnimation("animationSDGLHGFL"):addTo(Node_et)
			Node_et:setVisible(true)
		else
			SoraDGetCommonBox(boxIndex[k], 3, icon_box)
			Node_et:setVisible(false)
		end
	end
end
function sultansBackRebateMainView:onClickBox(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("sultansBackRebateAwardView")
		panel:initViewBox(button.data)
		panel:show()
	end
end
function sultansBackRebateMainView:initTarget()
	local boxData = sultansBackRead.getBackRechargeCfg()
	for i, v in ipairs(boxData) do
		if not self.targetArray[i] then
			self.targetArray[i] = self.Node_target:clone()
			self.targetArray[i]:addTo(self.Node_bar)
		end
		self.targetArray[i]:setPosition(0, -41 - (i - 1) * 82)
		local statues = sultansBackRebateUtil.getRoundStatues(v)
		local frame_done = SoraDGetChildByName(self.targetArray[i], "frame_done")
		local Text_target = SoraDGetChildByName(self.targetArray[i], "Text_target")
		Text_target:setString(string.formatnumberthousands(SoraDPreciseDecimal(v.score, 1)))
		if statues == AWARD_STATUES.AWARD_STATUES_NORMAL then
			frame_done:setVisible(false)
			Text_target:setColor(cc.c3b(170, 154, 119))
		else
			frame_done:setVisible(true)
			Text_target:setColor(cc.c3b(255, 210, 74))
		end
	end
end
function sultansBackRebateMainView:getStagePercent(score, stageList)
	local percent = 0
	local minVar = stageList[1]
	local maxVar = stageList[#stageList]
	local per = 100 / ((#stageList - 1) * 2 + 1)
	local index = 1
	for k, v in ipairs(stageList) do
		if score < v then
			index = k
			break
		end
	end
	if score <= minVar then
		percent = score / minVar * per
	elseif score >= maxVar then
		percent = 100
	elseif index < 3 then
		percent = per + (score - stageList[index - 1]) * per * 2 / (stageList[index] - stageList[index - 1])
	else
		percent = per + 2 * per * (index - 2) + (score - stageList[index - 1]) * per * 2 / (stageList[index] - stageList[index - 1])
	end
	return percent
end
function sultansBackRebateMainView:updateDataBox()
	local boxData = sultansBackRead.getBackRechargeCfg()
	local cur = sultansBackCtrl:getCurPrice()
	local sultansBackRead, stageList = sultansBackCtrl, sultansBackCtrl
	for k, v in ipairs(boxData) do
		table.insert(stageList, v.score)
	end
	local percent = self:getStagePercent(cur, stageList)
	self.Panel_bar:setContentSize(cc.size(15, 369 * percent / 100))
	sultansBackRead = cc.size(15, 369 * percent / 100)
	cc.size(15, 369 * percent / 100).price = "$" .. string.formatnumberthousands(cur)
	self.Text_totalRecharge:setString(i18n("back_recharge_text10", cc.size(15, 369 * percent / 100)))
end
function sultansBackRebateMainView:onClickRecharge(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
	end
end
function sultansBackRebateMainView:onClickHelpInfo(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("sultansBackRebateHelpView"):show()
	end
end
return sultansBackRebateMainView
