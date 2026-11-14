local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_heroSkill = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_heroSkill", Com_heroSkill)
function Com_heroSkill:onInit()
	self.isLong = false
	self:addClickListener(handler(self, self.onClick))
	self:addLongPressListener(handler(self, self.onLongPress))
end
function Com_heroSkill:onShow()
end
function Com_heroSkill:initData(data)
	self.data = data
	local bgPng = string.format("img_soldierrush_quality_%.2d.png", self.data.SkillQuality)
	self.fields.icon_bg:setSpriteFrame(bgPng)
	self.fields.icon_hero:setSpriteFrame(heroltCtrl.getHeroInfoHerIcon(self.data.HeroId))
	_ENV = heroltCtrl.getHeroInfoHerIcon(self.data.HeroId)
	heroltCtrl.getHeroInfoHerIcon(self.data.HeroId).id = self.data.Index
	self.fields.skill:setData(heroltCtrl.getHeroInfoHerIcon(self.data.HeroId))
	self.fields.Text_name:setString(self.data.none and i18n("common_text_2274") or i18n(self.data.SkillName))
	self.controllers.c1:setSelectedIndex(self.data.none and 1 or 0)
	self.fields.icon_g:setVisible(soldierRushCtrl:isSkillInSlot(self.data.Index))
end
function Com_heroSkill:onClick()
	SoraDPlaySound()
	if self.isLong then
		self.isLong = false
		return
	end
	if self.data.none then
		SoraDShowMsgTip(i18n("soldier_rush_text_13"))
	elseif soldierRushCtrl:isSkillInSlot(self.data.Index) then
	else
		_ENV = soldierRushCtrl
		soldierRushCtrl.msg = "MESSAGE_SOLDIERRUSH_UI_SKILL_CHOOSE"
		soldierRushCtrl.index = self.data.Index
		SoraDSendMessage(soldierRushCtrl)
	end
end
function Com_heroSkill:onLongPress()
	SoraDPlaySound()
	self.isLong = true
	_ENV = nil
	;(nil).msg = "MESSAGE_SOLDIERRUSH_UI_SKILL_INFO"
	;(nil).index = self.data.Index
	SoraDSendMessage(nil)
end
return Com_heroSkill
