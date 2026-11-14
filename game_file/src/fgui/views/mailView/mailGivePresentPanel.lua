local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local chatFunctions = include("chatFunctions")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local MAX_NUM = IsArClient and 99 or 10
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local mailGivePresentPanel = class("mailGivePresentPanel", baseFguiPanel)
function mailGivePresentPanel:ctor(...)
	mailGivePresentPanel.super.ctor(self, ...)
	print("mailGivePresentPanel:ctor", self.viewName)
end
function mailGivePresentPanel:onInit()
	print("=======mailGivePresentPanel:onInit")
	_ENV, _UPVALUE1_, self.maxNum = "=======mailGivePresentPanel:onInit", IsArClient and 6 or 1, IsArClient and 6 or 1
	;("=======mailGivePresentPanel:onInit").id = nil
	;("=======mailGivePresentPanel:onInit").count = 0
	self.itemList, (IsArClient and 6 or 1)[1] = IsArClient and 6 or 1, "=======mailGivePresentPanel:onInit"
	self.selectName = ""
	self.strName = ""
	self.fields.Com_title:initData(i18n("mail_text_25"), handler(self, self.onClickClose))
	self.fields.Button_History:addClickListener(handler(self, self.onBtnHistory))
	self.fields.Button_search:addClickListener(handler(self, self.onBtnSearch))
	self.fields.Button_send:addClickListener(handler(self, self.onBtnSend))
	self.fields.Button_send:setString("X1")
	self.fields.Button_send:fixChildrenPos()
	self.fields.Button_send:setEnabled(false)
	self.fields.Text_name:setString(i18n("common_text_087"))
	self.input_name = self.fields.input_name:getChild("input")
	self.input_name:addEventListener(fgui.UIEventType.Submit, handler(self, self.onSubmitName))
	self.fields.Text_name:fixPos()
	self.fields.input_name:fixPos()
	self.fields.Button_search:fixPos()
end
function mailGivePresentPanel:onShow()
	print("=======mailGivePresentPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.itemID = self.param and self.param.itemID or 501901
	if self.param then
		local name = self.param.name
		local abbr = self.param.abbr
		if name then
			self.selectName = name
			self.strName = include("mailFunctions"):getWrappedName(abbr, name)
			self.input_name:setText(self.strName)
		end
	end
	if self.itemID == 501901 then
		self.maxCost = MAX_NUM
	else
		self.maxCost = backpackltCtrl:getUseMax(self.itemID)
	end
	self.fields.Com_give:init(self.itemID)
	self.fields.Com_give:initData(self.itemList)
end
function mailGivePresentPanel:getItemInfo()
	local totalCount = 0
	local totalIndex = 0
	for i, v in ipairs(self.itemList) do
		if v.id then
			totalCount = totalCount + v.count
			totalIndex = totalIndex + 1
		end
	end
	return totalCount, totalIndex
end
function mailGivePresentPanel:getChooseInfo(index)
	local _ENV, ret
	local totalCount = 0
	for i, v in ipairs(self.itemList) do
		if i ~= index and v.id then
			if ret[v.id] then
				ret[v.id] = v.count + ret[v.id]
			else
				ret[v.id] = v.count
			end
			totalCount = totalCount + v.count
		end
	end
	return totalCount, ret
end
function mailGivePresentPanel:updateView()
	local itemCount, itemIndex = self:getItemInfo()
	self.fields.Com_give:initData(self.itemList)
	self.fields.Button_send:setString("X" .. math.max(itemCount, 1))
	self.fields.Button_send:setEnabled(0 < itemCount and 0 < string.len(self.strName))
end
function mailGivePresentPanel:operateGivePanel(target, data)
	if data.isRemove then
		table.remove(self.itemList, data.index)
		local itemCount, itemIndex = self:getItemInfo()
		if itemIndex == self.maxNum - 1 then
			_ENV = nil
			;(nil).id = nil
			;(nil).count = 0
			table.insert(self.itemList, nil)
		end
		self:updateView()
	else
		local totalCount, itemNumInfo = self:getChooseInfo(data.index)
		if totalCount >= self.maxCost then
			SoraDShowMsgTip(i18n("common_text_4847"))
			return
		end
		_ENV = i18n("common_text_4847")
		i18n("common_text_4847").index = data.index
		i18n("common_text_4847").totalCount = totalCount
		i18n("common_text_4847").itemNumInfo = itemNumInfo
		i18n("common_text_4847").itemID = self.itemID
		i18n("common_text_4847").selInfo = self.itemList[data.index]
		uiManager:show("waxLetterView", i18n("common_text_4847"))
	end
end
function mailGivePresentPanel:msgGivePresentItemSelected(target, data)
	local isReplace = self.itemList[data.index].id ~= nil
	_ENV = nil
	;(nil).id = data.itemID
	self.itemList[data.index], (nil).count = nil, data.count
	local itemCount, itemIndex = self:getItemInfo()
	if not isReplace and itemIndex < self.maxNum then
		_ENV = nil
		;(nil).id = nil
		;(nil).count = 0
		table.insert(self.itemList, nil)
	end
	self:updateView()
end
function mailGivePresentPanel:msgGivePresentPeopleSelected(target, data)
	local name = data.name
	local abbr = data.abbr
	self.selectName = name
	self.strName = textParser.formatPlayerName(abbr, name)
	self.input_name:setText(self.strName)
	self:updateView()
end
function mailGivePresentPanel:onBtnHistory()
	SoraDPlaySound()
	uiManager:show("mailGivePresentHistory")
end
function mailGivePresentPanel:onBtnSearch()
	SoraDPlaySound()
	_ENV = nil
	;(nil).isAbbr = true
	;(nil).searchName = self.strName
	uiManager:show("searchInKingdomView", nil)
end
function mailGivePresentPanel:stripAbbr(name)
	local beginIndex = string.find(name, "%(")
	local endIndex = string.find(name, "%)")
	if beginIndex and endIndex and beginIndex == 1 and endIndex == 5 then
		return string.sub(name, endIndex + 1, #name)
	end
	return name
end
function mailGivePresentPanel:onBtnSend()
	SoraDPlaySound()
	local itemCount, itemIndex = self:getItemInfo()
	_ENV = nil
	_ENV = nil
	;(nil).num = itemCount
	;(nil).content = i18n("common_text_2801", nil)
	;(nil).confirmString = i18n("common_text_054")
	;(nil).confirmFunc = function()
		local strContent = i18n("common_text_996")
		local strName = self.strName
		if self.selectName and self.selectName ~= "" then
			strName = self.selectName
		end
		strName = self:stripAbbr(strName)
		if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(strContent) then
			strContent = gModuleMgr.sharedMgr("shieldedWordsltCtrl"):replaceShieldedWords(strContent)
		end
		local playerId = chatFunctions:getSelfId()
		local nickName = chatFunctions:getSelfNickName()
		local iconID = chatFunctions:getSelfImageId()
		_ENV = chatFunctions
		chatFunctions.id = playerId
		chatFunctions.nickName = nickName
		local chatFunctions.iconID, uinfo = iconID, chatFunctions
		local aid = allianceMgr:getOwnAid()
		local abbr = allianceMgr:getAllianceProperty("abbr")
		local allianceInfo
		if aid ~= nil then
			_ENV = "abbr"
			;("abbr").aid = aid
			allianceInfo, ("abbr").abbr = "abbr", abbr
		end
		local _ENV, itemList = "abbr", "abbr"
		for _, v in ipairs(self.itemList) do
			if v.id then
				table.insert(itemList, v)
			end
		end
		if not tolua.isnull(self) then
			SoraDShowLoading(self)
			if IsArClient then
				_ENV = nil
				_ENV, (nil).itemList = table.insert, itemList
				table.insert.uinfo = uinfo
				table.insert.allianceInfo = allianceInfo
				;(nil).data, table.insert.message = table.insert, strContent
				;(nil).receiver = strName
				backpackCtrl:reqUseItem(self.itemID, itemCount, nil)
			else
				_ENV = nil
				_ENV, (nil).itemID = itemList[1].id, itemList[1].id
				itemList[1].id.uinfo = uinfo
				itemList[1].id.allianceInfo = allianceInfo
				;(nil).data, itemList[1].id.message = itemList[1].id, strContent
				;(nil).receiver = strName
				backpackCtrl:reqUseItem(self.itemID, itemCount, nil)
			end
		end
	end
	uiManager:show("MessageBox", nil)
end
function mailGivePresentPanel:onSubmitName()
	local str = self.input_name:getText()
	if self.strName == str then
		return
	else
		self.selectName = str
	end
	self.strName = str or ""
	self:updateView()
end
function mailGivePresentPanel:sMsgGivePresentSuccess(target, data)
	local isSuccess = data.isSuccess
	SoraDCloseLoading(self)
	if isSuccess == true then
		self:close()
	end
end
return mailGivePresentPanel
