local gametop = gModuleMgr.getObject("gametop")
local legendMCtrl = gametop.playertop_:getModule("legendMCtrl")
local legendMDesRead = include("legendMDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_story = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ChronicleView/Com_story", Com_story)
function Com_story:onInit()
	self.fields.Button_item:addClickListener(handler(self, self.onClick_buttonInfo))
	self.fields.Button_item:setSwallowTouches(true)
	self.fields.Button:addClickListener(handler(self, self.onBtnItemClick))
end
function Com_story:onShow()
end
function Com_story:initData(data, index)
	self.index = index
	self.data = data
	local modPart = math.fmod(self.index, 2)
	if modPart == 0 then
		if SoraDFIsRA() then
			isAlignLeft = true
		else
			isAlignLeft = false
		end
	elseif modPart == 1 then
		if SoraDFIsRA() then
			isAlignLeft = false
		else
			isAlignLeft = true
		end
	end
	self.controllers.c1:setSelectedIndex(isAlignLeft and 0 or 1)
	self.fields.title:setString(i18n(self.data.name))
	self.fields.icon:setURL(self.data.bg)
	self:updateState()
end
function Com_story:updateState()
	self.fields.Button_item:getTransition("t0"):stop()
	self.isUnlock = legendMCtrl:getIsChapterUnlock(self.index)
	print("self.isUnlock = ", self.isUnlock, ", index = ", self.index)
	if not self.isUnlock then
		self.isCanUnLock, self.unLockLevel, self.unLockPre = legendMCtrl:getIsChapterCanUnlock(self.index)
		print("self.isCanUnLock, self.unLockLevel, self.unLockPre = ", self.isCanUnLock, self.unLockLevel, self.unLockPre)
		if self.isCanUnLock then
			self.fields.Com_Lock:setVisible(true)
			self.fields.Com_Lock:getTransition("t1"):stop()
			self.fields.Com_Lock:getController("c1"):setSelectedIndex(1)
			self.fields.nodeReward:setVisible(true)
			self.fields.Com_Lock:getTransition("t0"):play(-1, 0, 0, -1)
			self.fields.Button_item:getTransition("t0"):play(-1, 0, 0, -1)
		else
			self.fields.Com_Lock:getController("c1"):setSelectedIndex(0)
			self.fields.Com_Lock:setVisible(true)
			self.fields.nodeReward:setVisible(true)
		end
	else
		self.fields.nodeReward:setVisible(false)
		self.fields.Com_Lock:setVisible(false)
	end
end
function Com_story:playUnlockAnim()
	self.fields.Com_Lock:getController("c1"):setSelectedIndex(2)
	self.fields.Com_Lock:getTransition("t1"):play(1, 0, 0, -1)
end
function Com_story:onClick_buttonInfo()
	SoraDPlaySound()
	if not self.isUnlock and self.isCanUnLock then
		print("可以解锁，发起领取奖励请求-----------")
		self:playUnlockAnim()
		self:reqReard()
		return
	end
	print("显示奖品-----")
	local serverCfgItem = legendMDesRead.getChapterServerCfgByIndex(self.index)
	_ENV = nil
	;(nil).rewards = serverCfgItem.award
	uiManager:show("LegendMPopReward", nil)
end
function Com_story:onBtnItemClick()
	SoraDPlaySound()
	if not self.isUnlock then
		if self.isCanUnLock then
			print("可以解锁，发起领取奖励请求-----------")
			self:playUnlockAnim()
			self:reqReard()
			return
		else
			if self.unLockPre then
				SoraDShowMsgTip(i18n("common_text_4435"))
			elseif self.unLockLevel then
				_ENV = i18n("common_text_4435")
				i18n("common_text_4435").lv = self.unLockLevel
				SoraDShowMsgTip(i18n("common_text_1973", i18n("common_text_4435")))
			end
			return
		end
	end
	_ENV = i18n("common_text_1973", i18n("common_text_4435"))
	i18n("common_text_1973", i18n("common_text_4435")).msg = "MESSAGE_UI_LEGENDM_LOADPAGE"
	_ENV, i18n("common_text_1973", i18n("common_text_4435")).pageType = legendMDesRead.PageType.STORYDETAIL, legendMDesRead.PageType.STORYDETAIL
	legendMDesRead.PageType.STORYDETAIL.index = self.index
	i18n("common_text_1973", i18n("common_text_4435")).pageData, legendMDesRead.PageType.STORYDETAIL.pageData = legendMDesRead.PageType.STORYDETAIL, self.data
	SoraDSendMessage(i18n("common_text_1973", i18n("common_text_4435")))
end
function Com_story:reqReard()
	SoraDShowLoading()
	legendMCtrl = nil
	;(nil)[1] = ffa.delay(1)
	;(nil)[2] = ffa.callFunc(function()
		legendMCtrl:reqHistoryReward(self.index)
	end)
	;(nil)[3] = ffa.callFunc(function()
		legendMCtrl:reqHistoryReward(self.index)
	end)
	self:runAction(ffa.seq(nil))
end
return Com_story
