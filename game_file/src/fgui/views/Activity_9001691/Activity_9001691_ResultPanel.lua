local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001691_ResultPanel = class("Activity_9001691_ResultPanel", baseFguiPanel)
function Activity_9001691_ResultPanel:ctor(...)
	self.isLRU = true
	Activity_9001691_ResultPanel.super.ctor(self, ...)
	print("Activity_9001691_ResultPanel:ctor", self.viewName)
end
function Activity_9001691_ResultPanel:onInit()
	self.isCanCloseSelf = false
	self.view:fixChildrenPos()
	print("=======Activity_9001691_ResultPanel:onInit")
	self.fields.txt_des1:setString(i18n("surprise_box_036"))
	self.fields.txt_des2:setString(i18n("surprise_box_037"))
	self.fields.txt_des3:setString(i18n("surprise_box_038"))
	self.fields.txt_des4:setString(i18n("surprise_box_039"))
	self.fields.txt_title2:setTitle(i18n("Mermaid_title_10"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_sure:setTitle(i18n("common_text_204"))
	self.fields.Button_sure:addClickEventListener(handler(self, self.close))
end
function Activity_9001691_ResultPanel:endShow()
	print("=======Activity_9001691_ResultPanel:endShow")
	if not self.param.scoreMap then
		_ENV = self.param.scoreMap
	end
	self.scoreMap = self.param.scoreMap
	self.reward = self.param.reward
	self:updateView()
end
function Activity_9001691_ResultPanel:onHide()
	if self.reward and #self.reward > 0 then
		SoraDMailGainItems(self.reward, true)
	end
end
function Activity_9001691_ResultPanel:updateView()
	local score1 = self.scoreMap.myAwardScore or 0
	local score2 = self.scoreMap.myItemScore or 0
	local score3 = (self.scoreMap.myHpScore or 0) + (self.scoreMap.aiLoseHpScore or 0)
	local score4 = score1 + score2 + score3
	self.fields.txt_value1:setString(score1)
	self.fields.txt_value2:setString(score2)
	self.fields.txt_value3:setString(score3)
	self.fields.txt_value4:setString(score4)
	self.fields.List:setNumItems(#self.reward)
	self.fields.title:setString(i18n(0 < (self.scoreMap.myHpScore or 0) and "surprise_box_080" or "surprise_box_035"))
end
function Activity_9001691_ResultPanel:onItemRenderer(index, obj)
	local data = self.reward[index + 1]
	obj:initData(data.id, data.count)
end
return Activity_9001691_ResultPanel
