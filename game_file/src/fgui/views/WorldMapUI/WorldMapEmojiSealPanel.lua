local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local publicRead = include("publicRead")
local emojiSealList = require("app." .. LocalTblPath .. ".config_client.emojseallist")
local chatDesRead = include("chatDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WorldMapEmojiSealPanel = class("WorldMapEmojiSealPanel", baseFguiPanel)
function WorldMapEmojiSealPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("WorldMapEmojiSealPanel:ctor", self.viewName)
end
function WorldMapEmojiSealPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function WorldMapEmojiSealPanel:onInit()
	print("=======WorldMapEmojiSealPanel:onInit")
	if not SoraDFIsRA() then
		self.view:fixChildrenPos()
	end
	self.selectedPage = 1
	self.instance = nil
	self.moveLineID = nil
	self.sealID = 411501
	self.sealShopItemID = IsArClient and 1000166 or 1000152
	self.emojiArray, _ENV, self.selectID = IsArClient and 1000166 or 1000152, IsArClient and 1000166 or 1000152, nil
	local _ENV, list = IsArClient and 1000166 or 1000152, IsArClient and 1000166 or 1000152
	local _ENV, list2 = self.view, self.view
	for i, v in ipairs(emojiSealList) do
		local setID = math.floor(v.FaceId / 100)
		if not list[setID] then
			_ENV = list[setID]
		end
		list[setID] = list[setID]
		table.insert(list[setID], v)
		list2[v.FaceId] = v
	end
	self.fields.Panel_bg:setTitle(i18n("emoj_btn_01"))
	self.emojiSealSet = list
	self.emojiSealList = list2
	self.Panel_default = SoraDGetChildByName(self, "Panel_default")
	self.Panel_default:setTouchEnabled(true)
	self.Panel_default:addClickEventListener(handler(self, self.onDefaultClick))
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.Text_recentTip = SoraDGetChildByName(self, "Text_recentTip")
	self.Text_recentTip:setString(i18n("emoji_text_02"))
	self.Text_recentTip:setVisible(false)
	self.Button_use = SoraDGetChildByName(self, "Button_use")
	self.Button_use:addClickEventListener(handler(self, self.onUseClick))
	self.Button_buyAndUse = self.fields.Button_buyAndUse
	self.Button_buyAndUse:setTitle(i18n("common_text_426"))
	self.Button_buyAndUse:addClickEventListener(handler(self, self.onBuyAndUseClick))
	self.scroll = SoraDGetChildByName(self, "ScrollView_panel")
	self.scroll:setItemRenderer(handler(self, self.onMenuRenderer))
	self.fields.List_point:setItemRenderer(handler(self, self.onPointRenderer))
	self:setItemInfo()
	self:exaltedPrivilege()
	self:testClick()
end
function WorldMapEmojiSealPanel:onShow()
	print("=======WorldMapEmojiSealPanel:onShow")
end
function WorldMapEmojiSealPanel:initData(instance, moveLineID)
	self.instance = instance
	self.moveLineID = moveLineID
end
function WorldMapEmojiSealPanel:exaltedPrivilege(...)
	local _ENV, lockEmojiSet
	local retVal, retList = SoraDGetCtrl("exaltedPrivilegeCtrl"):checkPrivilege(gExaltedPrivilegeType.EMOJI_STAMP)
	if retVal then
		for k, v in pairs(retList) do
			table.insert(lockEmojiSet, tonumber(k))
		end
		table.sort(lockEmojiSet)
	end
	self.lockEmojiSet = lockEmojiSet
	self.pagePoint = self.fields.List_point
	self.fields.Panel_real_touch:setSwallowTouches(false)
	self.fields.Panel_real_touch:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onPanelTouchBegin))
	self.fields.Panel_real_touch:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onPanelTouchEnd))
	self.scroll:setNumItems(#self.lockEmojiSet + 1)
	if SoraDFIsRA() then
		self.scroll:scrollToView(0)
	end
end
function WorldMapEmojiSealPanel:onMenuRenderer(index, obj)
	if not obj.isAddClick then
		obj:addClickEventListener(handler(self, self.onEmojiClick))
		obj.isAddClick = true
	end
	local data = 0
	if index ~= 0 then
		data = self.lockEmojiSet[index]
		local config = chatDesRead.getEmotionListCfg(data)
		obj:setIcon(config.icon)
	else
		obj:setIcon("icon_bqyz_mrbq.png")
	end
	obj:setTag(data)
	obj:setSelected(data == self.curEmojiSetID)
end
function WorldMapEmojiSealPanel:onPointRenderer(index, obj)
	obj:setSelected(index + 1 == self.selectedPage)
end
function WorldMapEmojiSealPanel:testClick()
	self:onEmojiClick(self, true)
end
function WorldMapEmojiSealPanel:onEmojiPanelClick(target, isTest)
	if not isTest then
		SoraDPlaySound()
	end
	self.scroll:setNumItems(#self.lockEmojiSet + 1)
	self.Panel_default:setSelected(self.curEmojiSetID == -1)
end
function WorldMapEmojiSealPanel:onDefaultClick(target, isTest)
	self.curEmojiSetID = -1
	self:onEmojiPanelClick(target, isTest)
	local list = self:getEmojiSealList()
	self.Text_recentTip:setVisible(table.nums(list) <= 0)
	self.selectedPage = 1
	self.maxPage = 1
	self.pagePoint:setNumItems(1)
	self:refreshPanelTouch()
end
function WorldMapEmojiSealPanel:onEmojiClick(target, isTest)
	self.curEmojiSetID = isTest and 0 or target:getTag()
	self:onEmojiPanelClick(target, isTest)
	local list = self:getEmojiSealList()
	self.Text_recentTip:setVisible(false)
	local maxMap = math.ceil(#list / 9)
	self.selectedPage = 1
	self.maxPage = maxMap
	self.pagePoint:setNumItems(maxMap)
	self:refreshPanelTouch()
end
function WorldMapEmojiSealPanel:refreshPanelTouch(...)
	self.Panel_touch:removeAllChildren()
	self.emojiArray, _ENV = self.Panel_touch.removeAllChildren, self.Panel_touch.removeAllChildren
	local list = self:getEmojiSealList()
	local _ENV, showList = self, self
	local beginIndex = (self.selectedPage - 1) * 8 + 1
	local endIndex = beginIndex + 7
	for i = beginIndex, endIndex do
		table.insert(showList, list[i])
	end
	for k, v in ipairs(showList) do
		local _line = math.ceil(k / 4)
		local _row = k % 4 == 0 and 4 or k % 4
		local imgName = v.Image
		if not SoraDFIsRA() and v.imgEn and v.imgEn ~= "" then
			imgName = v.imgEn
		end
		local emoji = self:getEmojiSingle(v.FaceId, imgName)
		if SoraDFIsRA() then
			emoji:setPosition(276 - _row * 130 + 50, _line * 130 - 50)
		else
			emoji:setPosition(-276 + _row * 130 - 50, _line * 130 - 50)
		end
		emoji:addTo(self.Panel_touch)
		self.emojiArray[k] = emoji
	end
	if next(self.emojiArray) then
		self.selectID = self.emojiArray[1].emojiID
		self.emojiArray[1]:setSelected(true)
	end
end
function WorldMapEmojiSealPanel:getEmojiSealList(emojiSetID)
	emojiSetID = emojiSetID or self.curEmojiSetID
	if self.emojiSealSet[emojiSetID] then
		return self.emojiSealSet[emojiSetID]
	end
	_ENV = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:worldMapEmojiSeal:emoji~table", nil) then
		local _ENV, emoji_table = SoraDConfigGet("Game:worldMapEmojiSeal:emoji~table", nil), SoraDConfigGet("Game:worldMapEmojiSeal:emoji~table", nil)
	end
	table.sort(emoji_table, function(a, b)
		if a.count == b.count then
			return a.time > b.time
		else
			return a.count > b.count
		end
	end)
	local _ENV, list = table.sort, table.sort
	for i = 1, 9 do
		if emoji_table[i] then
			local data = self.emojiSealList[emoji_table[i].emojiID]
			table.insert(list, data)
		end
	end
	return list
end
function WorldMapEmojiSealPanel:onUseClick(target, event)
	SoraDPlaySound()
	if self.moveLineID then
		_ENV = nil
		;(nil).emojiIndex = self.selectID
		;(nil).queueId = self.moveLineID
		;(nil).cost_type = 1
		backpackCtrl:reqUseItem(self.sealID, 1, nil)
	else
		local pos = self.instance:getTilePoint()
		_ENV = self.moveLineID
		self.moveLineID.emojiIndex = self.selectID
		self.moveLineID.x = pos.x
		self.moveLineID.y = pos.y
		self.moveLineID.cost_type = 1
		backpackCtrl:reqUseItem(self.sealID, 1, self.moveLineID)
	end
	self:removeFromParent()
end
function WorldMapEmojiSealPanel:onBuyAndUseClick(target, event)
	SoraDPlaySound()
	local price = gModuleMgr.sharedMgr("shopltCtrl"):getPrice(self.sealShopItemID)
	local reqBuy = function()
		local shopCtrl = gametop.playertop_:getModule("shopCtrl")
		if self.moveLineID then
			gametop = nil
			;(nil).emojiIndex = self.selectID
			;(nil).queueId = self.moveLineID
			;(nil).cost_type = 2
			shopCtrl:reqBuyInItemShop(self.sealShopItemID, 1, true, nil)
		else
			local pos = self.instance:getTilePoint()
			gametop = self.moveLineID
			self.moveLineID.emojiIndex = self.selectID
			self.moveLineID.x = pos.x
			self.moveLineID.y = pos.y
			self.moveLineID.cost_type = 2
			shopCtrl:reqBuyInItemShop(self.sealShopItemID, 1, true, self.moveLineID)
		end
		self:removeFromParent()
	end
	if SoraDEnoughGold(price) then
		local dailyRemindManager = include("dailyRemindManager")
		local ctype = dailyRemindManager.REMIND_TYPE.worldMapEmojiSeal
		if dailyRemindManager.checkNeedRemind(ctype) then
			_ENV = nil
			;(nil).num = price
			;(nil).item = publicRead.getName(self.sealID)
			SoraDShowMsgBox(i18n("common_text_4333", nil), i18n("common_text_204"), nil, function(event)
				if event == MSGBOX_CALLBACK_YES then
					dailyRemindManager.addRemindToManager(ctype)
					reqBuy()
				end
			end)
		else
			reqBuy()
		end
	end
end
function WorldMapEmojiSealPanel:setItemInfo()
	local Text_name = SoraDGetChildByName(self, "Text_name")
	local Text_own = SoraDGetChildByName(self, "Text_own")
	local Text_ownNum = SoraDGetChildByName(self, "Text_ownNum")
	Text_name:setString(publicRead.getName(self.sealID))
	Text_own:setString(i18n("common_text_3456") .. ":")
	local ownCount = backpackCtrl:getItemCount(self.sealID)
	Text_ownNum:setString(ownCount)
	if 0 < ownCount then
		Text_ownNum:setColor(cc.c3b(255, 200, 100))
	else
		Text_ownNum:setColor(cc.c3b(190, 40, 40))
	end
	self.fields.item:initData(self.sealID)
	self:setBtnShow(0 < ownCount)
end
function WorldMapEmojiSealPanel:setBtnShow(isOwn)
	self.Button_use:setVisible(isOwn)
	self.Button_use:setTitleText(i18n("common_text_314"))
	self.Button_buyAndUse:setVisible(not isOwn)
	if not isOwn then
		local price = gModuleMgr.sharedMgr("shopltCtrl"):getPrice(self.sealShopItemID)
		self.Button_buyAndUse:setCostNum(price)
	end
end
function WorldMapEmojiSealPanel:onPanelTouchBegin(eventContext)
	self.toucStartPosition = eventContext:getInput():getPosition()
	eventContext:captureTouch()
	return true
end
function WorldMapEmojiSealPanel:onPanelTouchEnd(eventContext)
	SoraDPlaySound()
	if self.toucStartPosition == nil then
		return
	end
	local touchBeganPoint = self.toucStartPosition
	local touchEndPoint = eventContext:getInput():getPosition()
	_UPVALUE2_ = nil
	;(nil)[1] = touchBeganPoint
	;(nil)[2] = touchEndPoint
	dump(nil, "touchBeganPoint, touchEndPoint")
	local moveDistanceMinX = TOUCH_MOVED_ERROR_VALUE * 4
	local distanceX = touchEndPoint.x - touchBeganPoint.x
	self.toucStartPosition = nil
	if moveDistanceMinX < distanceX then
		print("==Panel_touch=向右滑动=")
		self.selectedPage = SoraDFIsRA() and math.min(self.selectedPage + 1, self.maxPage) or math.max(self.selectedPage - 1, 1)
		self:refreshPanelTouch()
		self.pagePoint:setNumItems(self.maxPage)
		return true
	elseif distanceX < -moveDistanceMinX then
		print("==Panel_touch=向左滑动=")
		self.selectedPage = SoraDFIsRA() and math.max(self.selectedPage - 1, 1) or math.min(self.selectedPage + 1, self.maxPage)
		self:refreshPanelTouch()
		self.pagePoint:setNumItems(self.maxPage)
		return true
	end
	return false
end
function WorldMapEmojiSealPanel:getEmojiSingle(emojiID, emojiImg)
	local emoji = fgui.UIPackage:createObjectFromURL("ui://WorldMapUI/Com_emoji")
	emoji.emojiID = emojiID
	emoji:setIcon(emojiImg)
	emoji:setSwallowTouches(false)
	emoji:addEventListener(fgui.UIEventType.TouchBegin, function(eventContext)
		self:onPanelTouchBegin(eventContext)
	end)
	emoji:addEventListener(fgui.UIEventType.TouchMove, function(eventContext)
	end)
	emoji:addEventListener(fgui.UIEventType.TouchEnd, function(eventContext)
		if not self:onPanelTouchEnd(eventContext) then
			SoraDPlaySound()
			self.selectID = emoji.emojiID
			for k, v in ipairs(self.emojiArray) do
				v:setSelected(false)
			end
		end
	end)
	return emoji
end
return WorldMapEmojiSealPanel
