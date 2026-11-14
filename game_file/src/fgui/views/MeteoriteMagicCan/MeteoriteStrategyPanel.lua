local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MeteoriteStrategyPanel = class("MeteoriteStrategyPanel", baseFguiPanel)
local meteorMagicRead = include("meteorMagicRead")
function MeteoriteStrategyPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MeteoriteStrategyPanel:ctor", self.viewName)
end
function MeteoriteStrategyPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MeteoriteStrategyPanel:onInit()
	print("=======MeteoriteStrategyPanel:onInit")
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Panel_bg:setTitle(i18n("meteoritesmagic_text_44"))
	self.cfgs = meteorMagicRead.getStrategy()
	local _ENV, tabsetArray = meteorMagicRead.getStrategy(), meteorMagicRead.getStrategy()
	for i, v in ipairs(self.cfgs) do
		_ENV = i18n("meteoritesmagic_text_44")
		i18n("meteoritesmagic_text_44").title = i18n(v.classifyName)
		table.insert(tabsetArray, i18n("meteoritesmagic_text_44"))
	end
	_UPVALUE2_ = (for generator)
	_ENV, self.titles, ipairs(self.cfgs)[1] = ipairs(self.cfgs)
	_ENV, self.titles, ipairs(self.cfgs)[2] = ipairs(self.cfgs)
	_ENV, self.titles, ipairs(self.cfgs)[3] = ipairs(self.cfgs)
	_ENV, self.titles, ipairs(self.cfgs)[4] = ipairs(self.cfgs)
	_ENV, self.titles, ipairs(self.cfgs)[5] = ipairs(self.cfgs)
	_ENV, self.titles, ipairs(self.cfgs)[6] = ipairs(self.cfgs)
	_ENV, self.titles, ipairs(self.cfgs)[7] = ipairs(self.cfgs)
	_ENV, self.titles, ipairs(self.cfgs)[8] = ipairs(self.cfgs)
	_ENV, self.titles, ipairs(self.cfgs)[9] = ipairs(self.cfgs)
	ipairs(self.cfgs).defaultClick = 1
	ipairs(self.cfgs).tabsetArray = tabsetArray
	ipairs(self.cfgs).callback = handler(self, self.onClickTab)
	local ipairs(self.cfgs).btnSize, param = cc.size(128, 56), ipairs(self.cfgs)
	self.fields.com_Tab:initView(param)
end
function MeteoriteStrategyPanel:onShow()
	print("=======MeteoriteStrategyPanel:onShow")
end
function MeteoriteStrategyPanel:onItemRenderer(index, obj)
	local nebulaList = self.curCfg["nebula" .. index + 1]
	obj:initData(self.titles[index + 1], nebulaList)
end
function MeteoriteStrategyPanel:onClickTab(tag)
	self.curCfg = self.cfgs[tag]
	self.fields.scroll:setNumItems(3)
	self.fields.text_des:setString(i18n(self.curCfg.classifyText))
end
return MeteoriteStrategyPanel
