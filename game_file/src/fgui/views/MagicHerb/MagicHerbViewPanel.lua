local eventQuestRead = include("eventQuestRead")
local magicHerbCtrl = SoraDGetCtrl("magicHerbCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local magicherbRead = include("magicherbRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicHerbViewPanel = class("MagicHerbViewPanel", baseFguiPanel)
function MagicHerbViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	self.activityID = gActivityTimeActivityID.MAGIC_HERB_ACTIVITY
	self.isFirstIn = true
	self.isInitLv = true
	print("MagicHerbViewPanel:ctor", self.viewName)
end
function MagicHerbViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE5_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "MagicHerb"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[5] = self._packageList, "fonts"
	end
	return self._packageList
end
function MagicHerbViewPanel:onInit()
	print("=======MagicHerbViewPanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001361"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	_ENV = i18n("activity_name_9001361")
	i18n("activity_name_9001361").byUID = true
	self.tag = SoraDConfigGet("Game:magicHerb:tab~integer", (i18n("activity_name_9001361"))) or 1
	local isSameA = magicHerbCtrl:isSameAlliance()
	print("isSameA====", isSameA, self.tag)
	self.tag = isSameA and self.tag or 1
	_ENV, self.curLv = isSameA and self.tag or 1, 0
	_ENV, _ENV, (isSameA and self.tag or 1).defaultClick = isSameA, self.tag, self.tag
	isSameA.title = i18n("magic_herb_text_003")
	_ENV, self.tag[1], isSameA.tag = isSameA, isSameA, 1
	isSameA.title = i18n("magic_herb_text_002")
	;(isSameA and self.tag or 1).tabsetArray, self.tag[2], isSameA.tag = self.tag, isSameA, 2
	local (isSameA and self.tag or 1).callback, param = handler(self, self.onClickTab), isSameA and self.tag or 1
	self.fields.tab:initView(param)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_show:setItemRenderer(handler(self, self.onShowRenderer))
	self.fields.Text_tip:setString(i18n("magic_herb_text_004"))
	self.text_activity_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.text_activity_time:setTimeLast(function(strTime)
		return i18n("common_text_2669") .. strTime
	end)
	self.fields.Text_lv:setString(i18n("common_text_748"))
	self.fields.Text_normal:setString(i18n("cityUp_title_03"))
	self.fields.Text_high:setString(i18n("common_text_1225"))
	_ENV = i18n("common_text_1225")
	i18n("common_text_1225").price = magicherbRead.getRechargePrice()
	self.fields.Button_unlock:setTitleText(i18n("magic_herb_text_015", i18n("common_text_1225")))
	self.fields.Button_unlock:addClickListener(handler(self, self.onBtnUnlock))
	self.fields.Button_claim:setTitleText(i18n("ice_carnival_text05"))
	self.fields.Button_claim:addClickListener(handler(self, self.onBtnClaim))
	self.fields.Button_add:addClickListener(handler(self, self.onBtnAdd))
	self.fields.Button_irrigate:setTitleText(i18n("magic_herb_text_010"))
	self.fields.Button_irrigate:addClickListener(handler(self, self.onBtnIrrigate))
	self.fields.Bar_irrigate:fix()
	self.fields.Text_irrigatelv:fixPos()
	self.fields.line:fix()
	self.fields.line1:fixPos()
	self.fields.line2:fixPos()
	self.fields.Text_lv:fixPos()
	self.fields.Text_normal:fixPos()
	self.fields.Text_high:fixPos()
	self.fields.n21:fixPos()
	self.fields.n22:fixPos()
	self.fields.n21:fix()
	self.fields.n22:fix()
	self.fields.Button_unlock:fixPos()
	self.fields.Button_claim:fixPos()
	self.showCount = 2
	if display.height >= 900 then
		self.showCount = math.min(5, self.showCount + math.floor((display.height - 900) / 100))
	end
	self.fields.Effect_bg:setIsAutoCull(false)
	self.fields.Usm_jg:setBlendFunc(gl.ONE, gl.ONE)
	self.fields.Usm_sjb:setBlendFunc(gl.ONE, gl.ONE)
	self.fields.Usm_sjs:setBlendFunc(gl.ONE, gl.ONE)
end
function MagicHerbViewPanel:onShow()
	print("=======MagicHerbViewPanel:onShow")
	self:updateTaskView()
	self:updateIrrigateView()
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.text_activity_time:beginTime(leftTime)
	end
end
function MagicHerbViewPanel:onHide()
	print("=======MagicHerbViewPanel:onHide")
end
function MagicHerbViewPanel:onDispose()
	print("=======MagicHerbViewPanel:onDispose")
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:magicHerb:tab~integer", self.tag, nil)
end
function MagicHerbViewPanel:onBtnUnlock()
	SoraDPlaySound()
	local canPay = magicHerbCtrl:isSameAlliance()
	if not canPay then
		_ENV = nil
		;(nil).confirmString = i18n("magic_herb_text_007")
		;(nil).content = i18n("magic_herb_text_006")
		;(nil).confirmFunc = function()
			SoraDShowLoading(self:displayObject())
			magicHerbCtrl:sendBuyGift()
		end
		uiManager:show("MessageBox", nil)
	else
		SoraDShowLoading(self:displayObject())
		magicHerbCtrl:sendBuyGift()
	end
end
function MagicHerbViewPanel:onBtnClaim()
	SoraDPlaySound()
	local isSameA = magicHerbCtrl:isSameAlliance()
	if not isSameA then
		SoraDShowMsgTip(i18n("magic_herb_text_008"))
		return
	end
	if magicHerbCtrl:getIrrigateRewardNum() then
		SoraDShowLoading(self:displayObject())
		magicHerbCtrl:sendGetAllReward()
	end
end
function MagicHerbViewPanel:onBtnAdd()
	self.tag = 1
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self.fields.tab:setDefaultClick(self.tag, self.tag)
end
function MagicHerbViewPanel:onBtnIrrigate()
	SoraDPlaySound()
	uiManager:show("MagicHerbIrrigateView"):setOwnerKey(self)
end
function MagicHerbViewPanel:updateTaskView()
	self.serverData = activityTaskComponentCtrl:getQuestData(self.activityID)
	self.cfgs = eventQuestRead.getSortList(self.activityID, self.serverData)
	self.fields.List:setNumItems(#self.cfgs)
	self.fields.tab:setBtnRedDot(1, magicHerbCtrl:getTaskRewardNum())
end
function MagicHerbViewPanel:updateIrrigateView(isIrrigate)
	self.awards = magicherbRead.getAward()
	self.fields.List_show:setNumItems(#self.awards)
	self.fields.List_show:resizeToFit(self.showCount, 250)
	local irrigateCount = magicHerbCtrl:getIrrigateCount()
	magicherbRead = nil
	;(nil).var = fguiHelper.getColorString("#FFC864", string.formatnumberthousands(irrigateCount))
	self.fields.Text_irrigate:setString(i18n("magic_herb_text_009", nil))
	self.fields.Button_irrigate:setEnabled(0 < irrigateCount)
	local curPlan = magicHerbCtrl:getCurPlan()
	local nextLv, nextPlan = magicherbRead.getNextLvInfo(curPlan)
	if self.isInitLv then
		self.curLv = nextLv
	end
	if nextLv ~= self.curLv then
		if nextLv == 0 then
			self.fields.Usm_sjb:play()
		else
			self.fields.Usm_sjs:play()
		end
		_UPVALUE3_ = i18n("magic_herb_text_009", nil)
		i18n("magic_herb_text_009", nil)[1] = ffa.delay(0.16666666666666666)
		i18n("magic_herb_text_009", nil)[2] = ffa.fadeOut(0.06666666666666667)
		i18n("magic_herb_text_009", nil)[3] = ffa.callFunc(function()
			local curLv = magicherbRead.getLvByPlan(curPlan)
			self.fields.img_tree:setURL(string.format("frame_tree_%.2d.png", curLv))
		end)
		i18n("magic_herb_text_009", nil)[4] = ffa.fadeIn(0.1)
		i18n("magic_herb_text_009", nil)[5] = ffa.fadeIn(0.1)
		self.fields.img_tree:runAction(ffa.seq(i18n("magic_herb_text_009", nil)))
		self.curLv = nextLv
	else
		local curLv = magicherbRead.getLvByPlan(curPlan)
		self.fields.img_tree:setURL(string.format("frame_tree_%.2d.png", curLv))
	end
	if nextLv == 0 then
		self.fields.Bar_irrigate:setMax(1)
		self.fields.Bar_irrigate:setValue(1)
		magicherbRead = string.format("frame_tree_%.2d.png", curLv)
		string.format("frame_tree_%.2d.png", curLv).member = string.formatnumberthousands(curPlan)
		string.format("frame_tree_%.2d.png", curLv).total = string.formatnumberthousands(magicherbRead.getMaxPlan())
		self.fields.Text_pro:setString(i18n("common_text_155", string.format("frame_tree_%.2d.png", curLv)))
		self.fields.Text_irrigatelv:setString(i18n("MAX"))
	else
		self.fields.Bar_irrigate:setMax(nextPlan)
		self.fields.Bar_irrigate:setValue(curPlan)
		magicherbRead = i18n("MAX")
		i18n("MAX").member = string.formatnumberthousands(curPlan)
		i18n("MAX").total = string.formatnumberthousands(nextPlan)
		self.fields.Text_pro:setString(i18n("common_text_155", i18n("MAX")))
		magicherbRead = i18n("common_text_155", i18n("MAX"))
		i18n("common_text_155", i18n("MAX")).lv = nextLv
		self.fields.Text_irrigatelv:setString(i18n("common_text_2567", i18n("common_text_155", i18n("MAX"))))
	end
	local isUnlock = magicHerbCtrl:isPayUnlock()
	self.controllers.c2:setSelectedIndex(isUnlock and 1 or 0)
	local isSameA = magicHerbCtrl:isSameAlliance()
	local ret = magicHerbCtrl:getIrrigateRewardNum()
	self.fields.Button_claim:setEnabled(isSameA and ret)
	if isSameA then
		self.fields.tab:setBtnRedDot(2, magicHerbCtrl:getIrrigateRewardNum())
	else
		self.fields.tab:setBtnRedDot(2, false, 0)
	end
	if isIrrigate then
		self.fields.Usm_jg:play()
	end
	self.isInitLv = false
end
function MagicHerbViewPanel:onItemRenderer(index, obj)
	obj:initData(self.cfgs[index + 1], self)
end
function MagicHerbViewPanel:onShowRenderer(index, obj)
	obj:initData(self.awards[index + 1], self)
end
function MagicHerbViewPanel:onClickTab(tag)
	if not self.isFirstIn then
		SoraDPlaySound()
	end
	print("点击=======", tag)
	local isSameA = magicHerbCtrl:isSameAlliance()
	if tag == 2 and not isSameA then
		SoraDShowMsgTip(i18n("magic_herb_text_016"))
		self.fields.tab:setToTag(1)
		return
	end
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self.isFirstIn = false
end
function MagicHerbViewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("magic_herb_text_001")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return MagicHerbViewPanel
