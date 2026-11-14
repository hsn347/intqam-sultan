local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_heroEXPItem = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_heroEXPItem", Com_heroEXPItem)
function Com_heroEXPItem:onInit()
	self:addLongPressListener(handler(self, self.onLongPress))
	self:addClickListener(handler(self, self.onClick))
	self:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onOutClick))
end
function Com_heroEXPItem:onShow()
end
function Com_heroEXPItem:initData(heroID, id, count)
	self.heroID = heroID
	self.id = id
	self.count = count
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.fields.Com_item:initData(id, count)
	self.controllers.c1:setSelectedIndex(0 < count and 0 or 1)
	self:addEXPText()
end
function Com_heroEXPItem:addEXPText()
	local isVisible = clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SUPER_COMMANDER)
	self.fields.Text_EXP:setVisible(isVisible)
	if isVisible then
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local expPlus = activityShowCtrl:getClassType(gActivityTimeActivityID.SUPER_COMMANDER) / 1000
		_ENV = nil
		;(nil).EXP = expPlus
		self.fields.Text_EXP:setString(i18n("hero_text_106", nil))
	end
end
function Com_heroEXPItem:judgeIsCanFeedAndUpgrade()
	local ret = false
	if self.heroInfo and self.heroInfo.state ~= gHeroState.HERO_STATE_DEAD and self.heroInfo.state ~= gHeroState.HERO_STATE_CAPTURED then
		ret = true
	end
	return ret
end
function Com_heroEXPItem:onLongPress()
	self.isLongUse = true
	if self.heroInfo.level >= gHeroMaxLevel and not self.heroInfo.isAwake then
		SoraDShowMsgTip(i18n("hero_text_111"))
	elseif self:judgeIsCanFeedAndUpgrade() then
		local useNum = 1
		backpackCtrl = i18n("hero_text_111")
		i18n("hero_text_111")[1] = ffa.callFunc(function()
			if backpackCtrl:getItemCount(self.id) > 0 then
				if self.heroInfo.level >= gHeroMaxLevel and not self.heroInfo.isAwake then
					SoraDShowMsgTip(i18n("hero_text_111"))
					self.isLongUse = false
					self:stopAllActions()
				else
					heroCtrl:feedHeroReq(self.heroID, self.id, useNum)
				end
			else
				self.isLongUse = false
				backpackCtrl = backpackCtrl:getItemCount(self.id)
				backpackCtrl:getItemCount(self.id).heroID = self.heroID
				uiManager:show("HeroGainExpMethod", backpackCtrl:getItemCount(self.id))
				self:stopAllActions()
			end
		end)
		i18n("hero_text_111")[2] = ffa.delay(0.1)
		i18n("hero_text_111")[3] = ffa.delay(0.1)
		local seq = ffa.seq(i18n("hero_text_111"))
		self:runAction(ffa.repeatForever(seq))
	else
		SoraDShowMsgTip(i18n("hero_text_39"))
	end
end
function Com_heroEXPItem:onClick()
	if self.isLongUse then
		return
	end
	if self.count > 0 then
		if self.heroInfo.level >= gHeroMaxLevel and not self.heroInfo.isAwake then
			SoraDShowMsgTip(i18n("hero_text_111"))
		elseif self:judgeIsCanFeedAndUpgrade() then
			if 0 < backpackCtrl:getItemCount(self.id) then
				heroCtrl:feedHeroReq(self.heroID, self.id, 1)
			end
		else
			SoraDShowMsgTip(i18n("hero_text_39"))
		end
	elseif backpackltCtrl:getResultType(self.id) == gItemEffectDef.HERO_LEADER_POINT then
		_ENV = i18n("hero_text_39")
		i18n("hero_text_39").itemID = self.id
		uiManager:show("CommonSourceGuide", i18n("hero_text_39"))
	else
		_ENV = i18n("hero_text_39")
		i18n("hero_text_39").heroID = self.heroID
		uiManager:show("HeroGainExpMethod", i18n("hero_text_39"))
	end
end
function Com_heroEXPItem:onOutClick()
	self:stopAllActions()
	self.isLongUse = false
end
return Com_heroEXPItem
