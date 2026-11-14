local baseFguiPanel = require("fgui.base.baseFguiPanel")
local caveExploreCtrl = SoraDGetCtrl("caveExploreCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local publicRead = include("publicRead")
local CaveExploreActivityPanel = class("CaveExploreActivityPanel", baseFguiPanel)
function CaveExploreActivityPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	print("CaveExploreActivityPanel:ctor", self.viewName)
end
function CaveExploreActivityPanel:getPackageList()
	if not self._packageList then
		_UPVALUE5_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CaveExploreActivity"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[5] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function CaveExploreActivityPanel:onInit()
	SoraDPlaySound("sixYear", "ui_cave")
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	self.itemID = 841701
	self.giftID = 14480
	self.fields.Usm_1:setPrivewImage("#bg_cave_explore.png", cc.size(640, 1136), true, true)
	self.fields.Com_title:initData(i18n("activity_name_9001358"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	print("=======CaveExploreActivityPanel:onInit")
	self.txt_time = SoraDCreateTimerLabel(self, self.fields.txt_time)
	self.txt_time:setTimeLast(function(strTime)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, strTime
		;(nil).time, (nil).color = nil, "#5AB440"
		return i18n_html("common_text_607", nil, nil)
	end)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.CAVE_EXPLORE_ACTIVITY)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.txt_time:setString(SoraDConvertSecondToString(leftTime))
		self.txt_time:beginTime(leftTime)
	end
	self.fields.Button_awardPreview:addClickEventListener(handler(self, self.onAwardClick))
	self.fields.Button_awardPreview:setTitle(i18n("decrypt_text_03"))
	self.fields.Button_bakeOne:addClickEventListener(handler(self, self.onTakeClick), 1)
	self.fields.Button_bakeTen:addClickEventListener(handler(self, self.onTakeClick), 10)
	_ENV = handler(self, self.onTakeClick)
	handler(self, self.onTakeClick).byUID = true
	local isSeleckted = SoraDConfigGet("Game:CaveExploreActivityPanel:isChecked~bool", (handler(self, self.onTakeClick))) == true
	self.fields.button_check:setSelected(isSeleckted)
	self.fields.button_check:setString(i18n("Canyon_Treasur_text_27"))
	self.fields.button_check:addClickListener(function()
		SoraDPlaySound()
		_ENV = self.fields.button_check
		self.fields.button_check.byUID = true
		SoraDConfigSet("Game:CaveExploreActivityPanel:isChecked~bool", self.fields.button_check:isSelected(), self.fields.button_check)
	end)
	_ENV = i18n("Canyon_Treasur_text_27")
	i18n("Canyon_Treasur_text_27").num = 1
	self.fields.Button_bakeOne:setTitle(i18n("Canyon_Treasur_text_15", i18n("Canyon_Treasur_text_27")))
	_ENV = i18n("Canyon_Treasur_text_15", i18n("Canyon_Treasur_text_27"))
	i18n("Canyon_Treasur_text_15", i18n("Canyon_Treasur_text_27")).num = 10
	self.fields.Button_bakeTen:setTitle(i18n("Canyon_Treasur_text_15", i18n("Canyon_Treasur_text_15", i18n("Canyon_Treasur_text_27"))))
	self.fields.Button_add:addClickEventListener(handler(self, self.onAddClick))
	self:setIsBlcakBgShow(false)
	self:updateView()
	caveExploreCtrl:reqInit()
end
function CaveExploreActivityPanel:onShow()
	self.soundId = SoraDPlaySound("sixYear", "amb_cave_loop")
	self.soundId2 = SoraDPlaySound("sixYear", "sfx_golden_light")
end
function CaveExploreActivityPanel:onHide()
	AudioEngine.stopEffect(self.soundId)
	AudioEngine.stopEffect(self.soundId2)
end
function CaveExploreActivityPanel:onDispose()
end
function CaveExploreActivityPanel:playLoopSound()
	AudioEngine.stopEffect(self.soundId2)
	self.soundId2 = SoraDPlaySound("sixYear", "sfx_golden_light")
end
function CaveExploreActivityPanel:updateView()
	self.itemNum = backpackCtrl:getItemCount(self.itemID)
	self.fields.Text_num:setString(self.itemNum)
	self.fields.Button_bakeOne:setCost(self.itemID, caveExploreCtrl:getIsFree() and 0 or 1, true)
	self.fields.Button_bakeTen:setCost(self.itemID, 10, true)
end
function CaveExploreActivityPanel:setIsBlcakBgShow(isShow)
	self.fields.blackBg:setVisible(isShow)
end
function CaveExploreActivityPanel:onClickHelp()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("cave_explore_04"))
end
function CaveExploreActivityPanel:onAwardClick()
	SoraDPlaySound()
	uiManager:show("CaveExploreRewradPreview")
end
function CaveExploreActivityPanel:onTakeClick(sender, params)
	if self.isShowing then
		return
	end
	SoraDPlaySound()
	local isFree = caveExploreCtrl:getIsFree()
	if not isFree and params > self.itemNum or params == 10 and params > self.itemNum then
		_ENV = nil
		_ENV = nil
		;(nil).item = publicRead.getName(self.itemID)
		;(nil).content = i18n("cave_explore_05", nil)
		;(nil).confirmFunc = function()
			self:onAddClick()
		end
		;(nil).cancel = true
		uiManager:show("MessageBox", nil)
		return
	end
	caveExploreCtrl:reqCaveExlore(params == 10)
end
function CaveExploreActivityPanel:onAddClick()
	SoraDPlaySound()
	if GLOBAL_GAME_RECHARGE_MODE then
		_ENV = nil
		;(nil).rechargeID = self.giftID
		uiManager:show("rechargeView", nil)
	else
		local panel = SoraDCreatePanel("rechargeView")
		panel:show()
		panel:expect2SelectTabEx(gRechargeCenterCategory.HOTGIFT, self.giftID)
	end
end
function CaveExploreActivityPanel:showReward(rewards)
	local showFunc = function()
		if #rewards == 1 then
			local rewards, listItem = #rewards, #rewards
			for i, v in ipairs(rewards) do
				for i2, v2 in ipairs(v) do
					SoraDPopGainItem(v2.id, v2.count, true, true)
					return
				end
			end
		else
			rewards = ipairs(rewards)
			ipairs(rewards).rewards = rewards
			uiManager:show("CaveExploreReward", ipairs(rewards))
		end
	end
	if not self.fields.button_check:isSelected() then
		SoraDPlaySound("sixYear", "sfx_open_chest")
		self.isShowing = true
		self.fields.Usm_1:clearEffect()
		self.fields.Usm_1:setEffectPath("fk.usm", false)
		self.fields.Usm_1:setCompleteCallback(function()
			self.fields.Usm_1:clearEffect()
			self.fields.Usm_1:setEffectPath("CT.usm", true)
			self.isShowing = false
			showFunc()
		end)
	else
		showFunc()
	end
end
return CaveExploreActivityPanel
