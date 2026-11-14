local footballClothesCtrl = SoraDGetCtrl("footballClothesCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local jerseyScorePanel = class("jerseyScorePanel", baseFguiPanel)
function jerseyScorePanel:ctor(...)
	self.super.ctor(self, ...)
	print("jerseyScorePanel:ctor", self.viewName)
end
function jerseyScorePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function jerseyScorePanel:onInit()
	print("=======jerseyScorePanel:onInit")
	self.fields.panel_normal:setTitle(i18n("footballclothes_text_06"))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Text_NotTips:setString(i18n("common_text_1464"))
	self.fields.Text_NotTips:setVisible(false)
end
function jerseyScorePanel:onShow()
	print("=======jerseyScorePanel:onShow")
	SoraDShowLoading()
	footballClothesCtrl:reqFootballClothesScoreDetail()
end
function jerseyScorePanel:updateView()
	SoraDCloseLoading()
	self.datas = footballClothesCtrl:getAllianceDetailScore()
	dump(self.datas, "self.datas ")
	if next(self.datas) then
		self.fields.scroll:setNumItems(#self.datas)
		self.fields.scroll:setVisible(true)
		self.fields.Text_NotTips:setVisible(false)
	else
		self.fields.scroll:setVisible(false)
		self.fields.Text_NotTips:setVisible(true)
	end
end
function jerseyScorePanel:onItemRederer(index, target)
	target:setString(self.datas[index + 1].nickName)
	target:getChildByName("Text_Score"):setString(self.datas[index + 1].score)
	target:getChildByName("n3"):setVisible(index % 2 == 0)
end
return jerseyScorePanel
