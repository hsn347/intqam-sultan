local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ExtremelySkillfulBuffPanel = class("ExtremelySkillfulBuffPanel", baseFguiPanel)
function ExtremelySkillfulBuffPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ExtremelySkillfulBuffPanel:ctor", self.viewName)
end
function ExtremelySkillfulBuffPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ExtremelySkillfulBuffPanel:onInit()
	print("=======ExtremelySkillfulBuffPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("GloriousDecree_32"))
	_ENV, self.tag = self.proxy.param and self.proxy.param.tag or 1, self.proxy.param and self.proxy.param.tag or 1
	_ENV, _ENV, (self.proxy.param and self.proxy.param.tag or 1).defaultClick = i18n("GloriousDecree_32")
	i18n("GloriousDecree_32").title = i18n("MarvelousWorkmanship_05")
	_ENV, self.tag[1], i18n("GloriousDecree_32").tag = i18n("GloriousDecree_32")
	i18n("GloriousDecree_32").title = i18n("MarvelousWorkmanship_06")
	_ENV, self.tag[2], i18n("GloriousDecree_32").tag = i18n("GloriousDecree_32")
	i18n("GloriousDecree_32").title = i18n("MarvelousWorkmanship_07")
	;(self.proxy.param and self.proxy.param.tag or 1).tabsetArray, self.tag[3], i18n("GloriousDecree_32").tag = self.tag, i18n("GloriousDecree_32")
	local (self.proxy.param and self.proxy.param.tag or 1).callback, param = handler(self, self.onClickTab), self.proxy.param and self.proxy.param.tag or 1
	self.fields.Com_Tab:initView(param)
end
function ExtremelySkillfulBuffPanel:onShow()
	print("=======ExtremelySkillfulBuffPanel:onShow")
end
function ExtremelySkillfulBuffPanel:onClickTab(tag)
	self.tag = tag
	self.fields.Com_buff:initData(tag)
end
return ExtremelySkillfulBuffPanel
