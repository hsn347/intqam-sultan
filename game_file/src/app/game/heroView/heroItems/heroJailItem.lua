local gametop = gModuleMgr.getObject("gametop")
local heroJailCtrl = gametop.playertop_:getModule("heroJailCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local HeroJailItem = class("heroJailItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroJailItem")
	end
	return target
end)
function HeroJailItem:ctor()
	self.spHead = SoraDGetChildByName(self, "Sprite_head")
	self.spHeadBg = SoraDGetChildByName(self, "Sprite_headBg")
	self.loadBar = SoraDGetChildByName(self, "LoadingBar_loadBar")
	self.txtLoadBar = SoraDGetChildByName(self, "Text_loadBar")
	self.txtLoadBar = SoraDCreateTimerLabel(self, self.txtLoadBar)
	self.txtLv = SoraDGetChildByName(self, "Text_lv")
	self.txtState = SoraDGetChildByName(self, "Text_state")
	self.btnItem = SoraDGetChildByName(self, "Button_item")
	self.btnItem:addTouchEventListener(handler(self, self.btnItemClick))
	self.btnItem:setSwallowTouches(false)
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
	self.txtLv:setString(self.heroInfo.level)
	local dressID = self.heroInfo.dressID or heroltCtrl.getHeroDefaultDressID(self.heroInfo.heroID)
	self.spHead:setSpriteFrame(heroltCtrl:getDressHerIcon(dressID))
	self.spHeadBg:setSpriteFrame(heroltCtrl.getCubeBg(self.heroInfo.quality))
	self.txtState:setColor(heroltCtrl.getJailStateColor(self.state))
	self.loadBar:loadTexture(heroltCtrl.getJailStateLoadBar(self.state), ccui.TextureResType.plistType)
	if gHeroJailState.waiting == self.state then
		self.txtState:setString(i18n("prison_text_06"))
	elseif gHeroJailState.execute == self.state then
		self.txtState:setString(i18n("prison_text_08"))
	elseif gHeroJailState.escape == self.state then
		self.txtState:setString(i18n("prison_text_07"))
	end
	local totalTime = self.totalTime or 1
	self.txtLoadBar:setTimeLast(function(showTime, ticket)
		if ticket <= 0 then
			self:checkIsCanExecute()
		end
		self.loadBar:setPercent(ticket / totalTime * 100)
		return showTime
	end)
	self.txtLoadBar:beginTime(self.leftTime)
end
function HeroJailItem:checkIsCanExecute()
	if gHeroJailState.waiting == self.state then
		self:refreshData()
		self:initView()
	end
end
function HeroJailItem:btnItemClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("heroJailDetailView")
		panel:initData(self.heroFlagID)
		panel:show()
	end
end
return HeroJailItem
