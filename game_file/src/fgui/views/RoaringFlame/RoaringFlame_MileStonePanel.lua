local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_MileStonePanel = class("RoaringFlame_MileStonePanel", baseFguiPanel)
function RoaringFlame_MileStonePanel:ctor(...)
	self.isLRU = true
	RoaringFlame_MileStonePanel.super.ctor(self, ...)
	print("RoaringFlame_MileStonePanel:ctor", self.viewName)
end
function RoaringFlame_MileStonePanel:onInit()
	print("=======RoaringFlame_MileStonePanel:onInit")
	self.mileStoneCfg = roaringFlameWarRead.getDuneHistoryCfg()
	self.fields.Com_title:initData(i18n("history_text_60"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	fguiHelper.SoraDSetComFields(self)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_stage:setItemRenderer(handler(self, self.onStageRenderer))
	self.fields.Bar:setScaleX(SoraDFIsRA() and -1 or 1)
end
function RoaringFlame_MileStonePanel:onItemRenderer(index, obj)
	obj:initData(self.mileStoneCfg[index + 1])
end
function RoaringFlame_MileStonePanel:onStageRenderer(index, obj)
	obj:initData(self.mileStoneCfg[index + 1])
end
function RoaringFlame_MileStonePanel:endShow()
	print("=======RoaringFlame_MileStonePanel:endShow")
	roaringFlameWarCtrl:reqStateData()
	SoraDShowLoading(self)
end
function RoaringFlame_MileStonePanel:initView(target, data)
	SoraDCloseLoading(self)
	if data and data.key == "jump" then
		self.fields.List:scrollToView(data.index - 1, true)
		return
	end
	self.fields.List:setNumItems(#self.mileStoneCfg)
	self.fields.List_stage:setNumItems(#self.mileStoneCfg)
	local percent = roaringFlameWarRead.getDuneHistoryPrecent()
	self.fields.Bar:setValue(percent)
end
function RoaringFlame_MileStonePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("flames_dunes_second_rule05")
	;(nil).content = i18n("flames_dunes_second_rule06")
	uiManager:show("RuleView", nil)
end
return RoaringFlame_MileStonePanel
