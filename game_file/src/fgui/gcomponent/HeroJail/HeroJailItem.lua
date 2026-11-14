local heroJailCtrl = SoraDGetCtrl("heroJailCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local HeroJailItem = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://HeroJail/HeroJailItem", HeroJailItem)
function HeroJailItem:onInit()
	self:fixChildrenPos()
	self:addClickListener(handler(self, self.btnItemClick))
	self.txtLoadBar = SoraDCreateTimerLabel(self, self.fields.Text_Time)
	self.fields.Progress_Stage:setScaleX(SoraDFIsRA() and 1 or -1)
end
function HeroJailItem:onShow()
end
function HeroJailItem:checkIsCanExecute()
	if gHeroJailState.waiting == self.state then
		self:refreshData()
		self:initView()
	end
end
function HeroJailItem:initData(heroFlagID)
	self.heroFlagID = heroFlagID
	self:refreshData()
	self:initView()
end
function HeroJailItem:refreshData(...)
	self.heroInfo = heroJailCtrl:getHerosInMyPrisonByID(self.heroFlagID)
	self.state, self.leftTime, self.totalTime = heroJailCtrl.getJailStateWithTime(self.heroInfo)
end
function HeroJailItem:initView(...)
	dump(self.heroInfo, "self.heroInfo======")
	if not self.heroInfo then
		return
	end
	self.fields.Label_Lv:setString(self.heroInfo.level)
	local dressID = self.heroInfo.dressID or heroltCtrl.getHeroDefaultDressID(self.heroInfo.heroID)
	self.fields.Sprite_head:setURL(heroltCtrl:getDressHerIcon(dressID))
	self.fields.Sprite_headBg:setURL(heroltCtrl.getCubeBg(self.heroInfo.quality))
	self.fields.Text_state:setColor(heroltCtrl.getJailStateColor(self.state))
	self.fields.Progress_Stage:getController("c1"):setSelectedIndex(self.state)
	if gHeroJailState.waiting == self.state then
		self.fields.Text_state:setString(i18n("prison_text_06"))
	elseif gHeroJailState.execute == self.state then
		self.fields.Text_state:setString(i18n("prison_text_08"))
	elseif gHeroJailState.escape == self.state then
		self.fields.Text_state:setString(i18n("prison_text_07"))
	end
	local totalTime = self.totalTime or 1
	self.fields.Progress_Stage:setMax(totalTime)
	self.txtLoadBar:setTimeLast(function(showTime, ticket)
		if ticket <= 0 then
			self:checkIsCanExecute()
		end
		self.fields.Progress_Stage:setValue(totalTime - ticket)
		return showTime
	end)
	self.txtLoadBar:beginTime(self.leftTime)
end
function HeroJailItem:btnItemClick(button, eventType)
	SoraDPlaySound()
	_ENV = nil
	;(nil).heroFlagID = self.heroFlagID
	uiManager:show("HeroJailDetail", nil)
end
return HeroJailItem
