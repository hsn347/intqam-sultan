local cityltCtrl = include("cityltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroAppointMainPanel = class("HeroAppointMainPanel", baseFguiPanel)
function HeroAppointMainPanel:ctor(...)
	HeroAppointMainPanel.super.ctor(self, ...)
	print("HeroAppointMainPanel:ctor", self.viewName)
end
function HeroAppointMainPanel:onInit()
	print("=======HeroAppointMainPanel:onInit")
	self.buildList, _ENV, self.tag = print, print, 1
	self.fields.Com_title:initData(i18n("hero_appoint_1"), handler(self, self.onClickClose))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onBuildRenderer))
end
function HeroAppointMainPanel:onBuildRenderer(index, obj)
	obj:initData(self.buildList[index + 1])
end
function HeroAppointMainPanel:onShow()
	print("=======HeroAppointMainPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.bid = self.param.bid
	local cfg = cityltCtrl.getBuildHeroAppointCfg(self.bid)
	self.tag = cfg.buildType
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("hero_appoint_2")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("hero_appoint_3")
	_ENV, self.tag[2], (nil).tag = nil, nil, 2
	;(nil).title = i18n("hero_appoint_4")
	_ENV, self.tag[3], (nil).tag = nil, nil, 3
	;(nil).title = i18n("hero_appoint_5")
	;(nil).tabsetArray, self.tag[4], (nil).tag = self.tag, nil, 4
	;(nil).callback = handler(self, self.onTabClick)
	self.fields.Com_Tab:initView(nil)
end
function HeroAppointMainPanel:endShow()
	_ENV = nil
	;(nil).byUID = true
	local isGuide = SoraDConfigGet("Game:HeroAppoint:appointGuide~bool", nil)
	if not heroCtrl:getHaveHerosList() then
		local _ENV, heros = heroCtrl:getHaveHerosList(), heroCtrl:getHaveHerosList()
	end
	if not isGuide and 0 < #heros then
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		;(nil).step = 9990200
		SoraDSendMessage(nil)
	end
end
function HeroAppointMainPanel:onTabClick(tag)
	self.buildList, cityltCtrl, self.tag = nil, nil, tag
	if not cityltCtrl.getBuildTypeAppointCfg(self.tag) then
		local cityltCtrl, cfgList = cityltCtrl.getBuildTypeAppointCfg(self.tag), cityltCtrl.getBuildTypeAppointCfg(self.tag)
	end
	for k, v in ipairs(cfgList) do
		local buildList = cityCtrl:getBuildCellList(v.buildID)
		local isLocked, unlocklevel = include("cityBuildBaseEntity"):getIsLocked(v.buildID)
		if 0 < #buildList and not isLocked then
			if v.buildID ~= self.bid then
				table.insert(self.buildList, v.buildID)
			else
				table.insert(self.buildList, 1, v.buildID)
			end
		end
	end
	self.fields.List:setNumItems(#self.buildList)
	self.fields.List:jumpToTop()
end
function HeroAppointMainPanel:updateView(target, data)
	self.fields.List:setNumItems(#self.buildList)
end
function HeroAppointMainPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "firstBuild" then
		return self.fields.List:getChildAt(0):getBtnHeroTouch()
	else
		return self.fields[itemName]
	end
end
return HeroAppointMainPanel
