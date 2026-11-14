local worldMapWarDef = include("worldMapWarDef")
local collectMapCtrl = SoraDGetCtrl("collectMapCtrl")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local activity_9001573_Ctrl = SoraDGetCtrl("activity_9001573_Ctrl")
local WorldMapBookMarkPopPanel = class("WorldMapBookMarkPopPanel", baseFguiPanel)
_ENV = "WorldMapBookMarkPopPanel"
;("WorldMapBookMarkPopPanel").personal = 1
;("WorldMapBookMarkPopPanel").alliance = 2
local ("WorldMapBookMarkPopPanel").nebulaDefence, viewType = 3, "WorldMapBookMarkPopPanel"
function WorldMapBookMarkPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("WorldMapBookMarkPopPanel:ctor", self.viewName)
end
function WorldMapBookMarkPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function WorldMapBookMarkPopPanel:onInit()
	print("=======WorldMapBookMarkPopPanel:onInit")
	self.curType = viewType.personal
	self.fields.Node_Content:setYesBackHandle(handler(self, self.onClickClose))
end
function WorldMapBookMarkPopPanel:onShow()
	print("=======WorldMapBookMarkPopPanel:onShow")
	self:initData(self.proxy.param.markData, self.proxy.param.title)
	self:initTabBtn()
end
function WorldMapBookMarkPopPanel:initData(markData, title)
	self.controllers.c1:setSelectedIndex(0)
	self.fields.Panel_bg:setString(title)
	self.curType = markData.showAllianceMark and viewType.alliance or viewType.personal
	if markData.isEdit or not worldMapWarDef.isInWarForbidAllianceMark() then
		self.controllers.c1:setSelectedIndex(1)
	end
	self.fields.Node_Content:initData(self.curType, markData)
end
function WorldMapBookMarkPopPanel:initTabBtn(...)
	viewType = nil
	viewType = nil
	;(nil).title = i18n("alliance_mapmark_text_001")
	;(nil)[viewType.personal], (nil).tag = nil, viewType.personal
	viewType = nil
	;(nil).title = i18n("alliance_mapmark_text_002")
	;(nil)[viewType.alliance], (nil).tag = nil, viewType.alliance
	local tabsetArray
	if activity_9001573_Ctrl:getIsActivityOpen() then
		viewType = activity_9001573_Ctrl
		activity_9001573_Ctrl.title = i18n("Celestial_defense_text_014")
		tabsetArray[viewType.nebulaDefence], activity_9001573_Ctrl.tag = activity_9001573_Ctrl, viewType.nebulaDefence
	end
	viewType = viewType.nebulaDefence
	viewType.nebulaDefence.callback = handler(self, self.btnTabClick)
	viewType.nebulaDefence.defaultClick = self.curType
	viewType.nebulaDefence.tabsetArray = tabsetArray
	self.fields.com_TabW:initView(viewType.nebulaDefence)
end
function WorldMapBookMarkPopPanel:btnTabClick(tag, name)
	if tag == viewType.alliance and not collectMapCtrl:showAllianceMark(true, true) then
		self.fields.com_TabW:setToTab(self.curType)
		return
	end
	if tag == viewType.nebulaDefence and not activity_9001573_Ctrl:getIsCommander() then
		SoraDShowMsgTip(i18n("Celestial_defense_text_015"))
		self.fields.com_TabW:setToTab(self.curType)
		return
	end
	self.curType = tag
	self.fields.Node_Content:updateView(self.curType)
end
return WorldMapBookMarkPopPanel
