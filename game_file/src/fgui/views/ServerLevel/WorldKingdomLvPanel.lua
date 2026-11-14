local worldKingdomLvDesRead = include("worldKingdomLvDesRead")
local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
local colorValueNormal = "#FFD43E"
local colorValueRed = "#FF0000"
local colorValueGreen = "#FFD43E"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WorldKingdomLvPanel = class("WorldKingdomLvPanel", baseFguiPanel)
function WorldKingdomLvPanel:ctor(...)
	self.super.ctor(self, ...)
	print("WorldKingdomLvPanel:ctor", self.viewName)
end
function WorldKingdomLvPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function WorldKingdomLvPanel:onInit()
	print("=======WorldKingdomLvPanel:onInit")
	_UPVALUE10_ = "=======WorldKingdomLvPanel:onInit"
	;("=======WorldKingdomLvPanel:onInit")[1] = "Button_Lv"
	;("=======WorldKingdomLvPanel:onInit")[2] = "Text_exp_full_tip"
	;("=======WorldKingdomLvPanel:onInit")[3] = "Text_loadDes"
	;("=======WorldKingdomLvPanel:onInit")[4] = "Button_Round_Tip"
	;("=======WorldKingdomLvPanel:onInit")[5] = "Text_my_exp"
	;("=======WorldKingdomLvPanel:onInit")[6] = "Button_Detail"
	;("=======WorldKingdomLvPanel:onInit")[7] = "Text_kingdom_exp"
	;("=======WorldKingdomLvPanel:onInit")[8] = "Label_bigLv"
	;("=======WorldKingdomLvPanel:onInit")[9] = "Label_smallLv"
	;("=======WorldKingdomLvPanel:onInit")[10] = "img_num_buff"
	for i, v in ipairs("=======WorldKingdomLvPanel:onInit") do
		self.fields[v]:fixPos()
	end
	self.fields.Label_subTitle:getChildByName("title"):fixPos()
	self.fields.Label_subTitle:getChildByName("title_last"):fixPos()
	self.fields.Label_subTitle:getChildByName("n9"):fix()
	self.fields.Bar_lv:fixChildrenPos()
	self.canClick = true
	self.fields.Com_title:initData(i18n("common_text_3952"), handler(self, self.onClickClose), handler(self, self.onClick_Button_help))
	self.fields.Button_Round_Tip:addClickListener(handler(self, self.onClick_Button_Round_Tip))
	self.fields.Button_Detail:addClickListener(handler(self, self.onClick_Button_Detail))
	self.fields.Button_left:addClickListener(handler(self, self.onClick_Center_Button_left))
	self.fields.Button_right:addClickListener(handler(self, self.onClick_Center_Button_right))
	self.fields.Button_Lv:addClickListener(handler(self, self.onServerLvClick))
	self.fields.img_num_buff:addClickListener(handler(self, self.onClick_btnBuff))
	self.maxKingdomLv = worldKingdomLvDesRead.getMaxLevel()
	self.curKingdomLv = 0
	self.curKingdomExp = 0
	self.totalKingdomExp = 1
	self.curMyExp = 0
	self.label_big_title = self.fields.Label_subTitle:getChildByName("title")
	self.label_small_title = self.fields.Label_subTitle:getChildByName("title_last")
	self.fields.Text_loadDes:setString(i18n("common_text_3955"))
	self.fields.Text_exp_full_tip:setString(i18n("common_text_4087"))
	self.fields.img_num_buff:setVisible(false)
	self.fields.Bar_lv:setValue(0)
	self.controllers.c1:setSelectedIndex(0)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
	self.fields.List:setNumItems(self.maxKingdomLv - 1)
	self.fields.List:addEventListener(fgui.UIEventType.ScrollEnd, handler(self, self.scrollEndBack))
	self:setEffect()
end
function WorldKingdomLvPanel:onShow()
	print("=======WorldKingdomLvPanel:onShow")
	local gametop = gModuleMgr.getObject("gametop")
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	guideCtrl:updateGuideModule(gGuideModule.KINGDOM_LEVEL)
	SoraDShowLoading(self)
	kingdomLevelDataModuleAPI:getKingdomLevelInfo()
end
function WorldKingdomLvPanel:setEffect(isVisible)
	local frames = display.newFrames("image_fwq_%.2d.png", 1, 7)
	local animation = display.newAnimation(frames, 1.2 / #frames)
	self.fields.Button_Lv:getChildByName("Movie1"):setAnimation(animation)
	self.fields.Button_Lv:getChildByName("Movie2"):setAnimation(animation)
end
function WorldKingdomLvPanel:updateLevelInfo(levelInfo)
	self.levelInfo = levelInfo
	self.curKingdomLv = self.levelInfo.level
	self.maxKingdomLv = math.min(worldKingdomLvDesRead.getMaxLevel(), self.curKingdomLv + 1)
	self.curKingdomExp = self.levelInfo.exp
	self.totalKingdomExp = self.levelInfo.needExp
	self.dailyExp = self.levelInfo.dailyExp
	self.dailyLimit = self.levelInfo.dailyLimit
	self.curMyExp = self.levelInfo.selfDailyExp
	self.curLookLv = self:getLookCurLv(self.curKingdomLv)
	self:setMultiple()
	self:udpateExp()
	self:updateBuff()
	self:initUnderPage()
	self.fields.Button_Lv:setString(self.curKingdomLv)
end
function WorldKingdomLvPanel:setMultiple()
	local gametop = gModuleMgr.getObject("gametop")
	local kingdomLevelCtrl = gametop.playertop_:getModule("kingdomLevelCtrl")
	self.multiple = kingdomLevelCtrl:getMultiple()
	self.serverMul = kingdomLevelCtrl:getServerMulti()
	if self.multiple > 1 then
		self.fields.img_num_buff:setIcon(string.format("icon_9001068_num_%02d.png", self.multiple))
	else
		self.fields.img_num_buff:setVisible(false)
	end
end
function WorldKingdomLvPanel:udpateExp()
	local curKingdomLv = self.curKingdomLv
	local nextKingdomLv = curKingdomLv + 1
	local curMyExp = self.curMyExp
	_ENV = nil
	;(nil).member = string.formatnumberthousands(self.dailyExp)
	;(nil).total = SoraDConvertNumberWithUnit(self.dailyLimit)
	local strDailyExp = i18n("common_text_155", nil)
	local numColor = colorValueNormal
	if self.dailyExp >= self.dailyLimit then
		numColor = colorValueRed
	elseif self.levelInfo.isActOpen then
		numColor = colorValueGreen
	end
	_ENV = nil
	;(nil).name = i18n("common_text_4056")
	_ENV, _ENV, (nil).num = "common_text_4056", i18n("common_text_4056"), strDailyExp
	_ENV, i18n("common_text_4056").num, ("common_text_4056").color = "common_text_4056", "common_text_4056", numColor
	i18n("common_text_4056").name, ("common_text_4056").color = "common_text_4056", "#F0E6D2"
	self.fields.Text_kingdom_exp:setString(i18n_html("common_text_036", nil, (i18n("common_text_4056"))))
	_ENV = i18n_html("common_text_036", nil, (i18n("common_text_4056")))
	i18n_html("common_text_036", nil, (i18n("common_text_4056"))).name = i18n("common_text_4057")
	_ENV, _ENV, i18n_html("common_text_036", nil, (i18n("common_text_4056"))).num = curMyExp, string.formatnumberthousands(curMyExp), string.formatnumberthousands(curMyExp)
	_ENV, string.formatnumberthousands(curMyExp).num, curMyExp.color = curMyExp, curMyExp, "#FFD43E"
	string.formatnumberthousands(curMyExp).name, curMyExp.color = curMyExp, "#F0E6D2"
	self.fields.Text_my_exp:setString(i18n_html("common_text_036", i18n_html("common_text_036", nil, (i18n("common_text_4056")))))
	self.fields.Bar_lv:setMax(self.totalKingdomExp)
	self.fields.Bar_lv:setValue(self.curKingdomExp)
	_ENV = self.curKingdomExp
	self.curKingdomExp.member = self.curKingdomExp
	self.curKingdomExp.total = self.totalKingdomExp
	local strExp = i18n("common_text_155", self.curKingdomExp)
	if curKingdomLv == worldKingdomLvDesRead.getMaxLevel() then
		self.fields.Bar_lv:getChildByName("title_my"):setString("MAX")
		self.fields.Bar_lv:setMax(100)
		self.fields.Bar_lv:setValue(100)
	else
		self.fields.Bar_lv:getChildByName("title_my"):setString(strExp)
	end
	self.fields.Label_smallLv:setString(self:getMaxKingdomLv(curKingdomLv))
	self.fields.Label_bigLv:setString(self:getMaxKingdomLv(nextKingdomLv))
	if curKingdomLv < worldKingdomLvDesRead.getMaxLevel() then
		self:setBigLvGray(true)
		self.controllers.c1:setSelectedIndex(0)
	else
		self:setBigLvGray(false)
		self.controllers.c1:setSelectedIndex(1)
	end
end
function WorldKingdomLvPanel:updateBuff()
	local hasBuff = self.levelInfo.isActOpen
	if hasBuff then
		local _ENV, arrayNodes
		self.fields.Text_activity_Time:setVisible(true)
		self.fields.img_num_buff:setVisible(true)
		self.fields.Text_activity_Time:initActivityTimeStyle(gActivityTimeActivityID.SERVER_EXP_DOUBLE_ACTIVITY, "common_text_4190")
	else
		self.fields.Text_activity_Time:setVisible(false)
		self.fields.img_num_buff:setVisible(false)
		self.fields.Text_activity_Time:endTime()
	end
end
function WorldKingdomLvPanel:initUnderPage()
	local maxNum, _ = self:getLookCurLv(self.maxKingdomLv)
	self.fields.List:setNumItems(maxNum)
	self:setBuffLv(self.curLookLv)
	self:setBtnLeftRight()
	self.fields.List:scrollToView(self:getScrollIndexByLv(self.curLookLv))
end
function WorldKingdomLvPanel:setPageView(minLv)
	self:setBtnLeftRight()
	self.fields.List:scrollToView(self:getScrollIndexByLv(minLv), true)
end
function WorldKingdomLvPanel:setBtnLeftRight()
	local btn_smallLv = SoraDFIsRA() and self.fields.Button_right or self.fields.Button_left
	local btn_bigLv = SoraDFIsRA() and self.fields.Button_left or self.fields.Button_right
	local slv, blv = self:getLookCurLv(self.curLookLv)
	if slv <= 1 then
		btn_smallLv:setVisible(false)
	else
		btn_smallLv:setVisible(true)
	end
	if blv >= self.maxKingdomLv then
		btn_bigLv:setVisible(false)
	else
		btn_bigLv:setVisible(true)
	end
end
function WorldKingdomLvPanel:setBuffLv(minLv)
	local slv, blv = self:getLookCurLv(minLv)
	_ENV = nil
	;(nil).name = i18n("common_text_4062")
	_ENV, _ENV, (nil).num = "common_text_4062", i18n("common_text_4062"), blv
	_ENV, i18n("common_text_4062").num, ("common_text_4062").color = "common_text_4062", "common_text_4062", "#FFD43E"
	i18n("common_text_4062").name, ("common_text_4062").color = "common_text_4062", "#D7C39B"
	self.label_big_title:setString(i18n_html("common_text_036", nil, (i18n("common_text_4062"))))
	_ENV = i18n_html("common_text_036", nil, (i18n("common_text_4062")))
	i18n_html("common_text_036", nil, (i18n("common_text_4062"))).name = i18n("common_text_4062")
	_ENV, _ENV, i18n_html("common_text_036", nil, (i18n("common_text_4062"))).num = "common_text_4062", i18n("common_text_4062"), slv
	_ENV, i18n("common_text_4062").num, ("common_text_4062").color = "common_text_4062", "common_text_4062", "#FFD43E"
	i18n("common_text_4062").name, ("common_text_4062").color = "common_text_4062", "#D7C39B"
	self.label_small_title:setString(i18n_html("common_text_036", i18n_html("common_text_036", nil, (i18n("common_text_4062")))))
end
function WorldKingdomLvPanel:onClick_Button_Detail(sender, event)
	SoraDPlaySound()
	_ENV = nil
	;(nil).logType = gKingdomLevelLogType.LOG_HISTORY
	;(nil).isActOpen = self.levelInfo.isActOpen
	uiManager:show("WorldKingdomLvLog", nil)
end
function WorldKingdomLvPanel:onClick_Center_Button_left(sender, event)
	SoraDPlaySound()
	self:turnPage(SoraDFIsRA())
end
function WorldKingdomLvPanel:onClick_Center_Button_right(sender, event)
	SoraDPlaySound()
	self:turnPage(not SoraDFIsRA())
end
function WorldKingdomLvPanel:onServerLvClick(sender, event)
	SoraDPlaySound()
	local kingdomLookLv = self:getLookCurLv(self.curKingdomLv)
	print("self.curLookLv = ", self.curLookLv, ", cur kingdomLookLv = ", kingdomLookLv, " ,self.curKingdomLv = ", self.curKingdomLv)
	if self.curLookLv == kingdomLookLv then
		print("在当前界面-----")
		return
	end
	print("点击跳转--------", self.curKingdomLv)
	self.curLookLv = kingdomLookLv
	self.fields.Button_Lv:stopAllActionsByTag(1000)
	self.fields.Button_Lv:setScale(1)
	print("self.curLookLv = ", self.curLookLv)
	self:setPageView(self.curLookLv)
	local triggerKey = "Game:MainCityView:guideKingdomLv~integer"
	_ENV = ", cur kingdomLookLv = "
	;(", cur kingdomLookLv = ").byUID = true
	local triggerCount = SoraDConfigGet(triggerKey, ", cur kingdomLookLv = ")
	if 0 < triggerCount then
		triggerCount = triggerCount - 1
		_ENV = " ,self.curKingdomLv = "
		;(" ,self.curKingdomLv = ").byUID = true
		SoraDConfigSet(triggerKey, triggerCount, " ,self.curKingdomLv = ")
		print("set triggerCount = ", triggerCount)
		return
	end
end
function WorldKingdomLvPanel:onClick_Button_help(sender, event)
	SoraDPlaySound()
	print("跳转到faq-----")
	userSDKManager.showFAQSection(gSDKDef.FAQSectionType.SERVER_KINGDOM_LV)
end
function WorldKingdomLvPanel:onClick_Button_Round_Tip(sender, event)
	SoraDPlaySound()
	if not self.levelInfo then
		return
	end
	_ENV = nil
	;(nil).logType = gKingdomLevelLogType.LOG_EVENTS
	;(nil).isActOpen = self.levelInfo.isActOpen
	uiManager:show("WorldKingdomLvLog", nil)
end
function WorldKingdomLvPanel:onClick_btnBuff(sender, event)
	_ENV = nil
	;(nil).limit = self.serverMul * 100
	;(nil).Percent = self.multiple * 100
	SoraDShowMsgTip(i18n("common_text_4191", nil))
end
function WorldKingdomLvPanel:scrollEndBack()
	local itemIndex = self.fields.List:childIndexToItemIndex(0)
	self.curLookLv = self:getLvByScrollIndex(itemIndex) % self.maxKingdomLv
	print("==self.curLookLv==", itemIndex, self.curLookLv)
	if math.abs(self.curKingdomLv - self.curLookLv) >= 5 then
		self:triggerGuide()
	end
	self:setBuffLv(self.curLookLv)
	self:setBtnLeftRight()
end
function WorldKingdomLvPanel:turnPage(small2big)
	local curLookLv = self:returnLookLv(small2big)
	self:setPageView(curLookLv)
end
function WorldKingdomLvPanel:setBigLvGray(isGray)
	self.fields.Label_bigLv:setGrayed(isGray)
end
function WorldKingdomLvPanel:getMaxKingdomLv(kingdomLv)
	return math.min(worldKingdomLvDesRead.getMaxLevel(), kingdomLv)
end
function WorldKingdomLvPanel:triggerGuide()
	local triggerKey = "Game:MainCityView:guideKingdomLv~integer"
	_ENV = nil
	;(nil).byUID = true
	local triggerCount = SoraDConfigGet(triggerKey, nil)
	print("triggerCount = ", triggerCount)
	if triggerCount == 0 then
		return
	end
	local node = self.fields.Button_Lv
	if node:getActionByTag(1000) then
		return
	end
	node:stopAllActionsByTag(1000)
	_UPVALUE5_ = node
	node[1] = ffa.scaleTo(0.05, 1.03)
	node[2] = ffa.scaleTo(0.08, 0.97)
	node[3] = ffa.scaleTo(0.07, 1.01)
	node[4] = ffa.scaleTo(0.06, 0.99)
	node[5] = ffa.scaleTo(0.05, 1)
	node[6] = ffa.delay(3)
	node[7] = ffa.delay(3)
	local seq = ffa.seq(node)
	local repeatAct = ffa.repeatForever(seq)
	repeatAct:setTag(1000)
	node:runAction(repeatAct)
end
function WorldKingdomLvPanel:getLookCurLv(minLv)
	minLv = math.max(math.min(minLv, self.maxKingdomLv - 1), 1)
	print("getLookCurLv: min=", minLv, "max=", minLv + 1)
	return minLv, minLv + 1
end
function WorldKingdomLvPanel:returnLookLv(small2big)
	if small2big then
		self.curLookLv = math.min(self.curLookLv + 1, self.maxKingdomLv - 1)
		return self.curLookLv
	else
		self.curLookLv = math.max(self.curLookLv - 1, 1)
		return self.curLookLv
	end
end
function WorldKingdomLvPanel:getScrollIndexByLv(lv)
	return math.max(SoraDFPosX(self.maxKingdomLv - 1 - lv, self.maxKingdomLv - 2), 0)
end
function WorldKingdomLvPanel:getLvByScrollIndex(index)
	return SoraDFPosX(self.maxKingdomLv - 1 - index, self.maxKingdomLv)
end
function WorldKingdomLvPanel:onItemRender(index, target)
	target:initPageData(self:getLookCurLv(self:getLvByScrollIndex(index)))
end
return WorldKingdomLvPanel
