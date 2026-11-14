local constantRead = include("constantRead")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_operate = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_operate", Com_operate)
function Com_operate:onInit()
	self.fields.btn_share:addClickListener(handler(self, self.btnShareClick))
	self.fields.btn_story:addClickListener(handler(self, self.btnStoryClick))
	self.fields.red_story:setVisible(false)
	self.fields.btn_reforge:addClickListener(handler(self, self.btnReforgeClick))
	self.fields.btn_exchange:addClickListener(handler(self, self.btnExchangeClick))
end
function Com_operate:onShow()
end
function Com_operate:initData(heroID)
	self.heroID = tonumber(heroID)
	local rarity = heroltCtrl:getHeroRarity(self.heroID)
	local index = 0
	local reshapeTime = constantRead.getConstValue("HERO_RESHAPE_LIMIT_TIME")
	if not heroltCtrl:getAwakeInfo(self.heroID) then
		local _ENV, cfg = heroltCtrl:getAwakeInfo(self.heroID), heroltCtrl:getAwakeInfo(self.heroID)
	end
	if cfg.ifReshape and cfg.ifReshape == 1 then
		local isOpen = reshapeTime < serviceFunctions.systemTime()
		local isCanReforge = GAME_HERO_REFORGE_MODE and isOpen
		if isCanReforge then
			index = GAME_HERO_EXCHANGE_MODE and 0 or 3
		else
			index = GAME_HERO_EXCHANGE_MODE and isOpen and 2 or 1
		end
	else
		index = 1
	end
	self.controllers.c1:setSelectedIndex(index)
end
function Com_operate:setStoryRed(ret)
	self.fields.red_story:setVisible(ret)
end
function Com_operate:btnShareClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).shareHid = self.heroID
	uiManager:show("HeroShareBox", nil)
end
function Com_operate:btnStoryClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).heroID = self.heroID
	uiManager:show("HeroStory", nil)
end
function Com_operate:btnReforgeClick()
	SoraDPlaySound()
	local items = heroCtrl:getReforgeItem(self.heroID)
	if #items <= 0 then
		SoraDShowMsgTip(i18n("Hero_reshape_12"))
		return
	end
	local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	if heroInfo.state == gHeroState.HERO_STATE_NORMAL then
		_ENV = i18n("Hero_reshape_12")
		i18n("Hero_reshape_12").heroID = self.heroID
		uiManager:show("HeroReforge", i18n("Hero_reshape_12"))
	else
		SoraDShowMsgTip(i18n("Hero_reshape_11"))
	end
end
function Com_operate:btnExchangeClick()
	SoraDPlaySound()
	uiManager:show("HeroExchangeShop")
end
return Com_operate
