local divineBeastMarkRead = include("divineBeastMarkRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatMarkChoosePanel = class("CheatMarkChoosePanel", baseFguiPanel)
function CheatMarkChoosePanel:ctor(...)
	self.isLRU = true
	CheatMarkChoosePanel.super.ctor(self, ...)
	print("CheatMarkChoosePanel:ctor", self.viewName)
end
function CheatMarkChoosePanel:onInit()
	print("=======CheatMarkChoosePanel:onInit")
	self.fields.Text_name:setString("印记名")
	self.fields.Text_id:setString("印记ID")
	self.fields.Text_quality:setString("印记品质")
	self.fields.Panel_bg:setString("选择印记")
	self.markList, _ENV = self.fields.Panel_bg.setString, self.fields.Panel_bg.setString
	local markList = divineBeastMarkRead.getDbMarkCfgs()
	for k, v in pairs(markList) do
		table.insert(self.markList, v)
	end
	table.sort(self.markList, function(a, b)
		return a.ID < b.ID
	end)
	self.fields.List:setItemRenderer(handler(self, self.onMarkRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseMark))
	self.fields.Btn_ok:setString(i18n("common_text_204"))
	self.fields.Btn_ok:addClickListener(handler(self, self.btnClick))
	self.input = self.fields.input:getChild("input")
	self.input:setPromptHolder("印记名或印记ID")
	self.fields.Button_search:setString("搜索")
	self.fields.Button_search:addClickListener(handler(self, self.btnSearchClick))
end
function CheatMarkChoosePanel:onMarkRenderer(index, obj)
	local cfg = self.markShowList[index + 1]
	obj:getChild("Text_ID"):setString(cfg.ID)
	obj:getChild("Text_name"):setString(divineBeastMarkRead.getName(cfg.ID))
	obj:getChild("Text_name"):setColor(gQualityTextColorDef[cfg.quality])
	obj:getChild("Text_quality"):setString(cfg.quality)
end
function CheatMarkChoosePanel:onChooseMark()
	SoraDPlaySound()
	self.selIndex = self.fields.List:getSelectedIndex() + 1
	self.fields.Btn_ok:setEnabled(true)
end
function CheatMarkChoosePanel:endShow()
	print("=======CheatMarkChoosePanel:endShow")
	self.index = self.param.index
	self.divineID = self.param.divineID
	self.fields.Btn_ok:setEnabled(false)
	self.markShowList = self.markList
	self.fields.List:SelectNone()
	self.fields.List:setNumItems(#self.markShowList)
	self.fields.List:jumpToTop()
end
function CheatMarkChoosePanel:btnClick()
	SoraDPlaySound()
	local markID = self.markShowList[self.selIndex].ID
	local maxStar = divineBeastMarkRead.getMaxStar()
	local maxLv = divineBeastMarkRead.getMaxLv(markID, maxStar)
	local randomElem = 0
	local randomBuff1 = 0
	local randomBuff2 = 0
	local mark = divineBeastMarkRead.sCombineKey(markID, maxLv, 0, randomElem, randomBuff1, randomBuff2, maxStar)
	_ENV = maxLv
	maxLv.msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_MARK"
	maxLv.divineID = self.divineID
	maxLv.index = self.index
	maxLv.mark = mark
	SoraDSendMessage(maxLv)
	self:close()
end
function CheatMarkChoosePanel:btnSearchClick()
	SoraDPlaySound()
	local text = self.input:getText()
	local markID = tonumber(text)
	local _ENV, suitArray = text, text
	if markID then
		for _, v in ipairs(self.markList) do
			if string.find(tostring(v.ID), tostring(markID)) then
				table.insert(suitArray, v)
			end
		end
	else
		for _, v in ipairs(self.markList) do
			local name = divineBeastMarkRead.getName(v.ID)
			if string.find(name, text) then
				table.insert(suitArray, v)
			end
		end
	end
	if 0 < #suitArray then
		self.markShowList = suitArray
		self.fields.List:SelectNone()
		self.fields.List:setNumItems(#self.markShowList)
		self.fields.List:jumpToTop()
	else
		SoraDShowMsgTip("未搜索到匹配结果！")
	end
end
return CheatMarkChoosePanel
