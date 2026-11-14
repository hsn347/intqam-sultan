local artifactRuneRead = include("artifactRuneRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatRuneChoosePanel = class("CheatRuneChoosePanel", baseFguiPanel)
function CheatRuneChoosePanel:ctor(...)
	self.isLRU = true
	CheatRuneChoosePanel.super.ctor(self, ...)
	print("CheatRuneChoosePanel:ctor", self.viewName)
end
function CheatRuneChoosePanel:onInit()
	print("=======CheatRuneChoosePanel:onInit")
	self.fields.Text_name:setString("战纹名")
	self.fields.Text_id:setString("战纹ID")
	self.fields.Text_season:setString("赛季")
	self.fields.Panel_bg:setString("选择战纹")
	self.runeList, _ENV = self.fields.Panel_bg.setString, self.fields.Panel_bg.setString
	local runeList = artifactRuneRead.getRuneConfig()
	for k, v in pairs(runeList) do
		if v.RuneType ~= 5 then
			table.insert(self.runeList, v)
		end
	end
	table.sort(self.runeList, function(a, b)
		return a.ID < b.ID
	end)
	self.fields.List:setItemRenderer(handler(self, self.onRuneRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseRune))
	self.fields.Btn_ok:setString(i18n("common_text_204"))
	self.fields.Btn_ok:addClickListener(handler(self, self.btnClick))
	self.input = self.fields.input:getChild("input")
	self.input:setPromptHolder("战纹名或战纹ID")
	self.fields.Button_search:setString("搜索")
	self.fields.Button_search:addClickListener(handler(self, self.btnSearchClick))
end
function CheatRuneChoosePanel:onRuneRenderer(index, obj)
	local cfg = self.runeShowList[index + 1]
	obj:getChild("Text_ID"):setString(cfg.ID)
	obj:getChild("Text_name"):setString(artifactRuneRead.getRuneName(cfg.ID))
	obj:getChild("Text_season"):setString("S" .. cfg.Season)
	obj:getChild("icon"):setSpriteFrame(artifactRuneRead.getRuneIcon(cfg.ID))
end
function CheatRuneChoosePanel:onChooseRune()
	SoraDPlaySound()
	self.selIndex = self.fields.List:getSelectedIndex() + 1
	self.fields.Btn_ok:setEnabled(true)
end
function CheatRuneChoosePanel:endShow()
	print("=======CheatRuneChoosePanel:endShow")
	self.index = self.param.index
	self.selIndex = nil
	self.fields.Btn_ok:setEnabled(false)
	self.runeShowList = clone(self.runeList)
	self.fields.List:SelectNone()
	self.fields.List:setNumItems(#self.runeShowList)
	self.fields.List:jumpToTop()
end
function CheatRuneChoosePanel:btnClick()
	SoraDPlaySound()
	local levlLimit = artifactRuneRead.getRuneLimitLv(self.runeShowList[self.selIndex].ID)
	_ENV = self.runeShowList[self.selIndex].ID
	self.runeShowList[self.selIndex].ID.rid = self.runeShowList[self.selIndex].ID
	self.runeShowList[self.selIndex].ID.isLock = false
	self.runeShowList[self.selIndex].ID.exp = 0
	self.runeShowList[self.selIndex].ID.level = levlLimit
	self.runeShowList[self.selIndex].ID.extraProperty, _ENV, self.runeShowList[self.selIndex].ID.uid = self.index, self.index, self.index
	local runeInfo = self.runeShowList[self.selIndex].ID
	for k, v in ipairs(self.runeShowList[self.selIndex].InitPool) do
		local rbuffCfg = artifactRuneRead.getRandomBuffCfg(v)
		_UPVALUE3_ = nil
		;(nil)[1] = rbuffCfg.PropertyPool[1]
		;(nil)[2] = 0
		;(nil)[3] = false
		table.insert(runeInfo.extraProperty, nil)
	end
	_ENV = ipairs(self.runeShowList[self.selIndex].InitPool)
	ipairs(self.runeShowList[self.selIndex].InitPool).msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_RUNE"
	ipairs(self.runeShowList[self.selIndex].InitPool).index = self.index
	ipairs(self.runeShowList[self.selIndex].InitPool).runeInfo = runeInfo
	SoraDSendMessage(ipairs(self.runeShowList[self.selIndex].InitPool))
	self:close()
end
function CheatRuneChoosePanel:btnSearchClick()
	SoraDPlaySound()
	local text = self.input:getText()
	local runeID = tonumber(text)
	local _ENV, suitArray = text, text
	if runeID then
		for _, v in ipairs(self.runeList) do
			if string.find(tostring(v.ID), tostring(runeID)) then
				table.insert(suitArray, v)
			end
		end
	else
		for _, v in ipairs(self.runeList) do
			local name = artifactRuneRead.getRuneName(v.ID)
			if string.find(name, text) then
				table.insert(suitArray, v)
			end
		end
	end
	if 0 < #suitArray then
		self.runeShowList = suitArray
		self.fields.List:SelectNone()
		self.fields.List:setNumItems(#self.runeShowList)
		self.fields.List:jumpToTop()
	else
		SoraDShowMsgTip("未搜索到匹配结果！")
	end
end
return CheatRuneChoosePanel
