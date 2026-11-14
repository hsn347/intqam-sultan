local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kingdomBattleWarListPanel = class("kingdomBattleWarListPanel", baseFguiPanel)
function kingdomBattleWarListPanel:ctor(...)
	self.isLRU = true
	kingdomBattleWarListPanel.super.ctor(self, ...)
	print("kingdomBattleWarListPanel:ctor", self.viewName)
end
function kingdomBattleWarListPanel:onInit()
	print("=======kingdomBattleWarListPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initData(i18n("common_text_4904"), handler(self, self.onClickClose))
	self.fields.Button_search:setString(i18n("common_text_166"))
	self.fields.Button_search:addClickListener(handler(self, self.btnSearchClick))
	self.input = self.fields.input:getChild("input")
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
	self.fields.Button_search:fixPos()
	self.fields.input:fixPos()
end
function kingdomBattleWarListPanel:onItemRender(index, obj)
	obj:initData(self.listData[index + 1])
end
function kingdomBattleWarListPanel:endShow()
	print("=======kingdomBattleWarListPanel:endShow")
	self.input:setText("")
	self.input:setPromptHolder(i18n("common_text_4905"))
	conquestWarCtrl:reqMatchList()
	SoraDShowLoading(self)
end
function kingdomBattleWarListPanel:initView(target, data)
	SoraDCloseLoading(self)
	self.serverData = data.list
	self.listData = data.list
	self.fields.List:setNumItems(#self.listData)
end
function kingdomBattleWarListPanel:btnSearchClick()
	SoraDPlaySound()
	local kid = tonumber(self.input:getText())
	if kid then
		self.listData, _ENV = self.input:getText()
		for k, v in ipairs(self.serverData) do
			if v.kidInfo.kid == kid or v.matchKidInfo.kid == kid then
				table.insert(self.listData, v)
			end
		end
		self.fields.List:setNumItems(#self.listData)
		if #self.listData == 0 then
			SoraDShowMsgTip(i18n("Anchor_text_06"))
		end
	else
		SoraDShowMsgTip(i18n("Anchor_text_06"))
	end
end
return kingdomBattleWarListPanel
