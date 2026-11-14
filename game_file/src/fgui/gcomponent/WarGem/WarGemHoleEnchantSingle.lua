local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local warGemltCtrl = include("warGemltCtrl")
local wargemResRead = include("wargemResRead")
local ESL = require_data("enchantment_stone_level", true)
local ESI = require_data("enchantment_stone_intensify", true)
local MAX_LV = table.nums(ESI.data)
_ENV = ESI.data
ESI.data.ENCHANT_EMPTY_LOCK = 1
ESI.data.ENCHANT_EMPTY = 2
ESI.data.ENCHANT_ACTIVE = 3
ESI.data.ENCHANT_NOT_ACTIVE = 4
ESI.data.ENCHANTED_NOT_OPEN = 5
local ESI.data.ENCHANT_COLOR_ERROR, WARGEM_ENCHANTED_STATE = 6, ESI.data
local MAX_LV = table.nums(ESI.data)
_ENV = ESI.data
ESI.data.Normal = 0
ESI.data.NotEnchant = 1
ESI.data.NotValid = 2
ESI.data.Lock = 3
local ESI.data.NotEnchantButActive, state_index = 4, ESI.data
local baseComponent = require("fgui.base.baseComponent")
local WarGemHoleEnchantSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WarGem/WarGemHoleEnchantSingle", WarGemHoleEnchantSingle)
function WarGemHoleEnchantSingle:onInit()
	if self.fields.Button_change then
		self.fields.Movie_bg:setAllFrameName("dh_baoshi_di_%02d.png", 1)
		self.fields.Movie_lvup:setAllFrameName("dh_baoshi_add_%02d.png", 1)
		self.fields.Movie_enchantBg:setAllFrameName("dh_baoshi_kuang_%02d.png", 1)
		self.fields.Movie_enchantHole:setAllFrameName("dh_baoshi_baodian_%02d.png", 1)
		self.fields.Movie_lvup:setBlendFunc(gl.ONE, gl.ONE)
		self.fields.Movie_enchantBg:setBlendFunc(gl.ONE, gl.ONE)
		self.fields.Movie_enchantHole:setBlendFunc(gl.ONE, gl.ONE)
		self.transitions.enchant:setHook("showBg", function()
			self.oldStatus = self.state
			self:updateEnchant()
			self:updateEnchantHole()
			if self.state == WARGEM_ENCHANTED_STATE.ENCHANT_ACTIVE and self.oldStatus ~= self.state then
				self.fields.Movie_enchantHole:setPlaySettings(0, -1, 1, -1, function()
					self.fields.Movie_enchantHole:setVisible(false)
				end)
				self.fields.Movie_enchantHole:setVisible(true)
				self.fields.Movie_enchantHole.playing = true
			end
		end)
		self.transitions.lvup:setHook("lvChange", function()
			self.flagLv = false
			self:updateView()
		end)
		self.fields.Button_enchant:setString(i18n("gemEnchant_text_16"))
		self.fields.Button_strength:setString(i18n("common_text_1340"))
		self.fields.Button_change:addClickListener(handler(self, self.onClickChange))
		self.fields.Button_enchant:addClickListener(handler(self, self.onClickEnchant))
		self.fields.Button_strength:addClickListener(handler(self, self.onClickStrength))
		self.fields.Button_lock:addClickEventListener(handler(self, self.onLockClick))
	end
end
function WarGemHoleEnchantSingle:onClickChange()
	SoraDPlaySound()
	local itemBoxCount = backpackCtrl:getItemCount(722901)
	local color = warGemCtrl:getGemHoleColor(self.idx, self.lv)
	local itemID = warGemCtrl:getEnchantedItemID(self.idx, self.lv)
	local stoneName = wargemResRead.getName(itemID)
	local num = warGemCtrl:getEnchantedItemInBag(itemID) or 0
	if num <= 0 then
		if itemBoxCount == 0 then
			SoraDShowMsgTip(i18n("gemEnchant_text_17"))
		else
			_ENV = i18n("gemEnchant_text_17")
			i18n("gemEnchant_text_17").name = stoneName
			i18n("gemEnchant_text_17").num = itemBoxCount
			SoraDShowMsgBox(i18n("friend_return_text_13", i18n("gemEnchant_text_17")), i18n("common_text_314"), nil, function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					local itemUse = SoraDCreatePanel("commonSelectResourceBox")
					itemUse:initData(722901, itemID)
					itemUse:show()
				end
			end)
		end
		return
	end
	local dailyRemindManager = include("dailyRemindManager")
	if dailyRemindManager.checkNeedRemind(dailyRemindManager.REMIND_TYPE.wargemEnchantChange) then
		local attr = wargemResRead.getEnchantmentAttr(self.info.enchantmentID, self.info.amount, self.info.strengthenLv)
		_ENV = i18n("gemEnchant_text_17")
		_ENV = i18n("gemEnchant_text_17")
		i18n("gemEnchant_text_17").buff = attr
		i18n("gemEnchant_text_17").LV = self.info.strengthenLv
		i18n("gemEnchant_text_17").content = i18n("gemEnchant_text_26", i18n("gemEnchant_text_17"))
		i18n("gemEnchant_text_17").confirmFunc = function()
			if not tolua.isnull(self) then
				self:btnEnchantedCallback()
			end
		end
		i18n("gemEnchant_text_17").remindString = i18n("coffeeCraftsman_text_27")
		i18n("gemEnchant_text_17").remindFunc = function(value)
			if value then
				dailyRemindManager.addRemindToManager(dailyRemindManager.REMIND_TYPE.wargemEnchantChange)
			end
		end
		uiManager:show("MessageBox", i18n("gemEnchant_text_17"))
	else
		self:btnEnchantedCallback()
	end
end
function WarGemHoleEnchantSingle:btnEnchantedCallback()
	local itemBoxCount = backpackCtrl:getItemCount(722901)
	local color = warGemCtrl:getGemHoleColor(self.idx, self.lv)
	local itemID = warGemCtrl:getEnchantedItemID(self.idx, self.lv)
	print("itemIDfjsfdf  " .. itemID)
	local stoneName = wargemResRead.getName(itemID)
	local num = warGemCtrl:getEnchantedItemInBag(itemID) or 0
	if num <= 0 then
		if itemBoxCount == 0 then
			SoraDShowMsgTip(i18n("gemEnchant_text_17"))
		else
			backpackCtrl = i18n("gemEnchant_text_17")
			i18n("gemEnchant_text_17").name = stoneName
			i18n("gemEnchant_text_17").num = itemBoxCount
			SoraDShowMsgBox(i18n("friend_return_text_13", i18n("gemEnchant_text_17")), i18n("common_text_314"), nil, function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					local itemUse = SoraDCreatePanel("commonSelectResourceBox")
					itemUse:initData(722901, itemID)
					itemUse:show()
				end
			end)
		end
		return
	end
	local unlockLv = ESL.data[self.storeIdx].gemlv
	local gemlv = wargemResRead.getLevel(self.gemItemID) or 0
	local optType = self.info and gWarGemOptionType.SHOW or gWarGemOptionType.COVER
	optType = self.state == WARGEM_ENCHANTED_STATE.ENCHANT_COLOR_ERROR and gWarGemOptionType.COVER or optType
	if unlockLv > gemlv then
		SoraDShowMsgBox(i18n("gemEnchant_text_44"), i18n("common_text_204"), nil, function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				warGemCtrl:reqEnchantedAdd(self.idx, self.lv, self.storeIdx, optType)
			end
		end)
		return
	end
	warGemCtrl:reqEnchantedAdd(self.idx, self.lv, self.storeIdx, optType)
end
function WarGemHoleEnchantSingle:onClickEnchant()
	SoraDPlaySound()
	local itemBoxCount = backpackCtrl:getItemCount(722901)
	local color = warGemCtrl:getGemHoleColor(self.idx, self.lv)
	local itemID = warGemCtrl:getEnchantedItemID(self.idx, self.lv)
	print("itemIDfjsfdf  " .. itemID)
	local stoneName = wargemResRead.getName(itemID)
	local num = warGemCtrl:getEnchantedItemInBag(itemID) or 0
	if num <= 0 then
		if itemBoxCount == 0 then
			SoraDShowMsgTip(i18n("gemEnchant_text_17"))
		else
			_ENV = i18n("gemEnchant_text_17")
			i18n("gemEnchant_text_17").name = stoneName
			i18n("gemEnchant_text_17").num = itemBoxCount
			SoraDShowMsgBox(i18n("friend_return_text_13", i18n("gemEnchant_text_17")), i18n("common_text_314"), nil, function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					local itemUse = SoraDCreatePanel("commonSelectResourceBox")
					itemUse:initData(722901, itemID)
					itemUse:show()
				end
			end)
		end
		return
	end
	local unlockLv = ESL.data[self.storeIdx].gemlv
	local gemlv = wargemResRead.getLevel(self.gemItemID) or 0
	if unlockLv > gemlv then
		SoraDShowMsgBox(i18n("gemEnchant_text_44"), i18n("common_text_204"), nil, function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				warGemCtrl:reqEnchantedAdd(self.idx, self.lv, self.storeIdx)
			end
		end)
		return
	end
	warGemCtrl:reqEnchantedAdd(self.idx, self.lv, self.storeIdx)
end
function WarGemHoleEnchantSingle:onClickStrength()
	SoraDPlaySound()
	if not self.info then
		return
	end
	local ESI = require_data("enchantment_stone_intensify", true)
	local cfg = ESI.data[self.info.strengthenLv]
	local bidLv = SoraDGetBuildStarLv(BUILDID.MIRACLE)
	print(self.info.strengthenLv, bidLv, cfg.starlv)
	if bidLv < cfg.starlv then
		_ENV = cfg.starlv
		cfg.starlv.lv = cfg.starlv
		SoraDShowMsgTip(i18n("gemEnchant_text_25", cfg.starlv))
		return
	end
	if self.info.strengthenLv == MAX_LV then
		SoraDShowMsgTip(i18n("gemEnchant_text_24"))
		return
	end
	local itemNum = warGemCtrl:getEssenceCount()
	if warGemCtrl:getEssenceCount() < cfg.expend then
		SoraDShowMsgBox(i18n("gemEnchant_text_23"), i18n("common_text_477"), nil, function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				_ENV = nil
				;(nil).itemType = gItemType.WAR_GEM
				;(nil).itemType2 = gItemType.POWERFUL_ESSENCE
				uiManager:show("vipBuyView", nil)
			end
		end)
		return
	end
	local num = 0
	for i = self.info.strengthenLv, MAX_LV - 1 do
		local cfg = ESI.data[i]
		if bidLv < cfg.starlv then
			break
		end
		itemNum = itemNum - cfg.expend
		if 0 <= itemNum then
			num = num + 1
		end
	end
	if 1 < num then
		local panel = SoraDCreatePanel("wargemInlayStrength")
		panel:initData(self.gemItemID, self.storeIdx, self.info)
		panel:show()
	else
		warGemCtrl:reqEnchantedStrength(self.idx, self.lv, self.storeIdx, 1)
	end
end
function WarGemHoleEnchantSingle:onLockClick()
	SoraDPlaySound()
	if self.info.isLock then
		SoraDCheckSecondaryLock(function()
			warGemCtrl:reqModifyLock(warGemCtrl:getEditPanelId(), self.lv, self.idx, self.storeIdx, false)
		end, gSecondaryLockType.WarGemEnchantUnlock, " WarGemHoleEnchant")
	else
		SoraDIsNeedOpenVerifySecondaryLock(function()
			local dailyRemindManager = include("dailyRemindManager")
			if not dailyRemindManager.checkNeedRemind(dailyRemindManager.REMIND_TYPE.wargemenchant_lock) or not userSDKManager.isNeedVerify() then
				warGemCtrl:reqModifyLock(warGemCtrl:getEditPanelId(), self.lv, self.idx, self.storeIdx, true)
				return
			end
			_ENV = self.lv
			self.lv.content = i18n("Safety_lock_text_26")
			function self.lv.confirmFunc()
				if not tolua.isnull(self) then
					warGemCtrl:reqModifyLock(warGemCtrl:getEditPanelId(), self.lv, self.idx, self.storeIdx, true)
				end
			end
			self.lv.remindString = i18n("coffeeCraftsman_text_27")
			function self.lv.remindFunc(value)
				if value then
					dailyRemindManager.addRemindToManager(dailyRemindManager.REMIND_TYPE.wargemenchant_lock)
				end
			end
			uiManager:show("MessageBox", self.lv)
		end)
	end
end
function WarGemHoleEnchantSingle:onShow()
end
function WarGemHoleEnchantSingle:initData(lv, idx, position)
	self.lv = lv
	self.idx = idx
	self.storeIdx = position
	local unlockLv = ESL.data[self.storeIdx].gemlv
	ESL = nil
	;(nil).lv = unlockLv
	self.fields.Text_unlock:setString(i18n("gemEnchant_text_13", nil))
	self:updateView()
end
function WarGemHoleEnchantSingle:updateView()
	self:updateEnchant()
	self:updateEnchantHole()
end
function WarGemHoleEnchantSingle:updateEnchant()
	self:updateState()
	self:updateInfo()
	self:updateBtn()
end
function WarGemHoleEnchantSingle:updateEnchantHole()
	self.fields.enchant:initData(self.lv, self.idx, self.storeIdx)
end
function WarGemHoleEnchantSingle:updateState()
	local info = warGemCtrl:getEnchantedInfo(self.idx, self.lv, self.storeIdx)
	self.info = info
	self.state = WARGEM_ENCHANTED_STATE.ENCHANT_LOCK
	self.gemItemID = warGemCtrl:getGemID(warGemCtrl:getEditPanelId(), self.lv, self.idx)
	local unlockLv = ESL.data[self.storeIdx].gemlv
	local gemlv = wargemResRead.getLevel(self.gemItemID) or 0
	local bidLv = SoraDGetBuildStarLv(BUILDID.MIRACLE)
	local enchantColor = info and warGemltCtrl:getEnchantedColor(info.enchantmentID) or -1
	local needColor = warGemCtrl:getGemHoleColor(self.lv, self.idx)
	if bidLv == 0 then
		self.state = WARGEM_ENCHANTED_STATE.ENCHANTED_NOT_OPEN
	elseif unlockLv > gemlv then
		if info and self.info.enchantmentID then
			if needColor ~= enchantColor then
				self.state = WARGEM_ENCHANTED_STATE.ENCHANT_COLOR_ERROR
			else
				self.state = WARGEM_ENCHANTED_STATE.ENCHANT_NOT_ACTIVE
			end
		else
			self.state = WARGEM_ENCHANTED_STATE.ENCHANT_EMPTY_LOCK
		end
	elseif self.info and self.info.enchantmentID then
		if needColor ~= enchantColor then
			self.state = WARGEM_ENCHANTED_STATE.ENCHANT_COLOR_ERROR
		else
			self.state = WARGEM_ENCHANTED_STATE.ENCHANT_ACTIVE
		end
	else
		self.state = WARGEM_ENCHANTED_STATE.ENCHANT_EMPTY
	end
	print("state:", self.state)
end
function WarGemHoleEnchantSingle:updateInfo()
	local unlockLv = ESL.data[self.storeIdx].gemlv
	print("self.state====", self.state)
	if self.state == WARGEM_ENCHANTED_STATE.ENCHANTED_NOT_OPEN then
		self.controllers.Ctrl_status:setSelectedIndex(state_index.Lock)
	elseif self.state == WARGEM_ENCHANTED_STATE.ENCHANT_ACTIVE then
		self.controllers.Ctrl_status:setSelectedIndex(state_index.Normal)
		self:updateAttr()
	elseif self.state == WARGEM_ENCHANTED_STATE.ENCHANT_EMPTY then
		self.controllers.Ctrl_status:setSelectedIndex(state_index.NotEnchantButActive)
		self:updateAttr()
	elseif self.state == WARGEM_ENCHANTED_STATE.ENCHANT_EMPTY_LOCK then
		self.controllers.Ctrl_status:setSelectedIndex(state_index.NotEnchant)
		local strKey = unlockLv == 10 and "gemEnchant_text_32" or "gemEnchant_text_30"
		ESL = nil
		;(nil).num = unlockLv
		self.fields.Text_condition:setString(i18n(strKey, nil))
		self:updateAttr()
	elseif self.state == WARGEM_ENCHANTED_STATE.ENCHANT_NOT_ACTIVE then
		self.controllers.Ctrl_status:setSelectedIndex(state_index.NotValid)
		local strKey = unlockLv == 10 and "gemEnchant_text_33" or "gemEnchant_text_31"
		ESL = i18n(strKey, nil)
		i18n(strKey, nil).num = unlockLv
		self.fields.Text_condition:setString(i18n(strKey, i18n(strKey, nil)))
		self:updateAttr()
	elseif self.state == WARGEM_ENCHANTED_STATE.ENCHANT_COLOR_ERROR then
		self.controllers.Ctrl_status:setSelectedIndex(state_index.NotValid)
		self.fields.Text_condition:setString(i18n("gemEnchant_text_51"))
	else
		error("undefined state")
	end
	self:updateAttr()
	WARGEM_ENCHANTED_STATE = self
	self[1] = self.fields.Button_lock
	self[2] = self.info
	dump(self, "self.info")
	if self.fields.Button_change and self.info then
		self.fields.Button_change:setEnabled(not self.info.isLock)
		self.fields.Button_lock:setIcon(self.info.isLock and "icon_lock_gold.png" or "icon_lock_unlock.png")
	end
end
function WarGemHoleEnchantSingle:updateAttr()
	if self.state == WARGEM_ENCHANTED_STATE.ENCHANTED_NOT_OPEN then
		return
	end
	if self.info and self.info.enchantmentID then
		local attr = wargemResRead.getEnchantmentAttrHtml(self.info.enchantmentID, self.info.amount, self:getLv())
		self.fields.Text_attr:setText(attr)
	else
		self.fields.Text_attr:setText(i18n("gemEnchant_text_14"))
	end
	self:updateLv()
end
function WarGemHoleEnchantSingle:updateLv()
	local lv = self:getLv()
	if lv >= MAX_LV then
		self.fields.Text_lv:setString(i18n("hero_text_41"))
	else
		self.fields.Text_lv:setString("LV." .. lv)
	end
end
function WarGemHoleEnchantSingle:getLv()
	if self.info then
		local lv = self.info.strengthenLv
		if self.flagLv then
			print("表现升级特效，修正lv", self.info.strengthenLv, lv)
			lv = lv - 1
		end
		return lv
	end
	return 1
end
function WarGemHoleEnchantSingle:updateBtn()
	if self.fields.Button_change then
		if self.state == WARGEM_ENCHANTED_STATE.ENCHANT_EMPTY or self.state == WARGEM_ENCHANTED_STATE.ENCHANT_EMPTY_LOCK then
			local itemID = warGemCtrl:getEnchantedItemID(self.idx, self.lv)
			local num = warGemCtrl:getEnchantedItemInBag(itemID) or 0
			self.fields.Button_enchant:setCostNum(1, num)
			local icon = wargemResRead.getIcon(itemID)
			self.fields.Button_enchant:setCostIcon(icon)
		elseif self.state ~= WARGEM_ENCHANTED_STATE.ENCHANTED_NOT_OPEN and self.info then
			local cfg = ESI.data[self:getLv()]
			self.fields.Button_strength:setCostNum(cfg.expend, warGemCtrl:getEssenceCount())
		end
	end
end
function WarGemHoleEnchantSingle:showEnchantEffect()
	self.fields.Movie_enchantBg:setPlaySettings(0, -1, 1, -1, function()
		self.fields.Movie_enchantBg:setVisible(false)
	end)
	self.transitions.enchant:play()
end
function WarGemHoleEnchantSingle:showLvupEffect()
	self:updateView()
	self.flagLv = true
	self.fields.Movie_bg:setPlaySettings(0, -1, 1, -1, function()
		self.fields.Movie_bg:setVisible(false)
	end)
	self.fields.Movie_lvup:setPlaySettings(0, -1, 1, -1, function()
		self.fields.Movie_lvup:setVisible(false)
	end)
	self.transitions.lvup:play()
end
return WarGemHoleEnchantSingle
