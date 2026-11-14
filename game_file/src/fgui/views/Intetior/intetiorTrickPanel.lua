local intetiorDef = include("intetiorDef")
local intetiorRead = include("intetiorRead")
local gametop = gModuleMgr.getObject("gametop")
local intetiorCtrl = gametop.playertop_:getModule("intetiorCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local intetiorTrickPanel = class("intetiorTrickPanel", baseFguiPanel)
function intetiorTrickPanel:ctor(...)
	self.super.ctor(self, ...)
	print("intetiorTrickPanel:ctor", self.viewName)
end
function intetiorTrickPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function intetiorTrickPanel:onInit()
	print("=======intetiorTrickPanel:onInit")
	self.fields.Panel_bg:setString(i18n("parliament_btn_14"))
	self.fields.Text_tips:setString(i18n("parliament_text_35"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
end
function intetiorTrickPanel:onShow()
	print("=======intetiorTrickPanel:onShow")
	self:initView()
	self:req4Data()
	self.fields.Label_MyGold:getController("color1"):setSelectedIndex(1)
	self.fields.Label_KingGold:getController("color1"):setSelectedIndex(1)
end
function intetiorTrickPanel:req4Data()
	intetiorCtrl:reqParliamentTrickData()
end
function intetiorTrickPanel:initView()
	self.showList, intetiorRead = nil, nil
	local config = intetiorRead:getTrickSkillTable()
	local trickDataTable = intetiorCtrl:getTrickData()
	for _, v in ipairs(config) do
		local configView = intetiorRead:getTrickSkillView(v.type)
		local trickData = trickDataTable[tostring(v.type)]
		intetiorRead = nil
		;(nil).config = v
		;(nil).configView = configView
		;(nil).trickData = trickData
		table.insert(self.showList, nil)
	end
	self.fields.List:setNumItems(#self.showList)
end
function intetiorTrickPanel:onItemRender(index, target)
	target:initData(self.showList[index + 1], self)
end
return intetiorTrickPanel
