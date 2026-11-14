local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local warGemltCtrl = include("warGemltCtrl")
local warGemData = include("warGemData")
local wargemResRead = include("wargemResRead")
local warGemCtrl = class("warGemCtrl", GameModule)
local ESL = require_data("enchantment_stone_level", true)
local ESI = require_data("enchantment_stone_intensify", true)
local enchantmentStoneLevelCfgData = require_data("enchantment_stone_level", true).data
function warGemCtrl:ctor(properties)
	warGemCtrl.super.ctor(self, properties)
end
function warGemCtrl:EnterGame()
	warGemCtrl.super.EnterGame(self)
	self.gemDataMgr = warGemData.new()
	msgCtrl.register(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_DATA, handler(self, self.onRspWarGemData))
	msgCtrl.register(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_MERGE_IN_BAG, handler(self, self.onRspMergeInBag))
	msgCtrl.register(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_MERGE_ALL_IN_BAG, handler(self, self.onRspMergeAllInBag))
	msgCtrl.register(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_MERGE_IN_PANEL, handler(self, self.onRspMergeInPanel))
	msgCtrl.register(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_MOUNT_IN_PANEL, handler(self, self.onRspMountInPanel))
	msgCtrl.register(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_DISMOUNT_FROM_PANEL, handler(self, self.onRspDismountFromPanel))
	msgCtrl.register(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_REPLACE_TO_PANEL, handler(self, self.onRspReplaceToPanel))
	msgCtrl.register(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_ACTIVE_PANEL, handler(self, self.onRspActivePanel))
	msgCtrl.register(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_CLEAR_PANEL, handler(self, self.onRspClearPanel))
	msgCtrl.register(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_RENAME_PANEL, handler(self, self.onRspRenamePanel))
	msgCtrl.register(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_ENCHANTED_ADD, handler(self, self.onRspEnchantedAdd))
	msgCtrl.register(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_ENCHANTED_STRENGTHEN, handler(self, self.onRspEnchantedStrength))
	msgCtrl.register(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_CHANGE_HOLE_COLOR, handler(self, self.onRspChangeHoleColor))
	msgCtrl.register(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_COPY_PANEL, handler(self, self.onRspCopyPanel))
	msgCtrl.register(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_MODIFY_LOCK, handler(self, self.onRspModifyLock))
	self:reqUpdateData()
	self:resetGemNewInfo()
	self:resetGemFilerType()
end
function warGemCtrl:Logout()
	warGemCtrl.super.Logout(self)
	self.gemDataMgr = nil
end
function warGemCtrl:initClientData(data)
	if not data then
		return
	end
	if not data.gemData then
		_ENV = data.gemData
	end
	self.gemDataMgr:setGemData(data.gemData)
	dump(data.gemData, "wargemdata===", 10)
end
function warGemCtrl:reqWarGemData(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_DATA, nil, ...)
end
function warGemCtrl:reqMergeInBag(gemId, ...)
	serverproxy = nil
	;(nil).gemId = gemId
	serverproxy:Request(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_MERGE_IN_BAG, nil, ...)
end
function warGemCtrl:reqMergeAllInBag(gemId, ...)
	serverproxy = nil
	;(nil).gemId = gemId
	serverproxy:Request(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_MERGE_ALL_IN_BAG, nil, ...)
end
function warGemCtrl:reqMergeInPanel(lv, idx, ...)
	serverproxy = nil
	;(nil).lv = lv
	;(nil).idx = idx
	serverproxy:Request(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_MERGE_IN_PANEL, nil, ...)
end
function warGemCtrl:reqMountInPanel(panelId, gemId, lv, idx, ...)
	serverproxy = nil
	;(nil).panelId = panelId
	;(nil).gemId = gemId
	;(nil).lv = lv
	;(nil).idx = idx
	serverproxy:Request(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_MOUNT_IN_PANEL, nil, ...)
end
function warGemCtrl:reqDismountFromPanel(panelId, lv, idx, ...)
	serverproxy = nil
	;(nil).panelId = panelId
	;(nil).lv = lv
	;(nil).idx = idx
	serverproxy:Request(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_DISMOUNT_FROM_PANEL, nil, ...)
end
function warGemCtrl:ReqReplaceToPanel(panelId, lv, idx, newGemId, ...)
	serverproxy = nil
	;(nil).panelId = panelId
	;(nil).lv = lv
	;(nil).idx = idx
	;(nil).newGemId = newGemId
	serverproxy:Request(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_REPLACE_TO_PANEL, nil, ...)
end
function warGemCtrl:reqActivePanel(panelId, ...)
	serverproxy = nil
	;(nil).panelId = panelId
	serverproxy:Request(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_ACTIVE_PANEL, nil, ...)
end
function warGemCtrl:reqClearPanel(panelId, ...)
	serverproxy = nil
	;(nil).panelId = panelId
	serverproxy:Request(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_CLEAR_PANEL, nil, ...)
end
function warGemCtrl:reqRenamePanel(panelId, name, ...)
	serverproxy = nil
	;(nil).panelId = panelId
	;(nil).name = name
	serverproxy:Request(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_RENAME_PANEL, nil, ...)
end
function warGemCtrl:reqEnchantedAdd(idx, lv, pos, optionType, isAgain, ...)
	print("reqEnchantedAdd:", idx, lv, pos)
	local panelId = self:getEditPanelId()
	_ENV = nil
	;(nil).panelId = panelId
	;(nil).lv = lv
	;(nil).idx = idx
	;(nil).position = pos
	;(nil).optionType = optionType or gWarGemOptionType.COVER
	;(nil).isAgain = isAgain
	serverproxy:Request(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_ENCHANTED_ADD, nil, ...)
end
function warGemCtrl:reqEnchantedStrength(idx, lv, pos, addLv, ...)
	serverproxy = nil
	;(nil).lv = lv
	;(nil).idx = idx
	;(nil).position = pos
	;(nil).addLv = addLv
	serverproxy:Request(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_ENCHANTED_STRENGTHEN, nil, ...)
end
function warGemCtrl:reqChangeHoleColor(panelId, lv, idx, color)
	print("warGemCtrl:reqChangeHoleColor", panelId, lv, idx, color)
	_ENV = idx
	idx.panelId = panelId
	idx.lv = lv
	idx.idx = idx
	idx.color = color
	serverproxy:Request(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_CHANGE_HOLE_COLOR, idx)
end
function warGemCtrl:reqCopyPanel(sourcePanelId, targetPanelId)
	print("warGemCtrl:reqCopyPanel", sourcePanelId, targetPanelId)
	_ENV = nil
	;(nil).sourcePanelId = sourcePanelId
	;(nil).targetPanelId = targetPanelId
	serverproxy:Request(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_COPY_PANEL, nil)
end
function warGemCtrl:reqModifyLock(panelId, lv, idx, pos, isLock)
	print("warGemCtrl:reqModifyLock", panelId, lv, idx, pos, isLock)
	_ENV = idx
	idx.panelId = panelId
	idx.lv = lv
	idx.idx = idx
	idx.position = pos
	idx.isLock = isLock
	serverproxy:Request(gCmd.CMD_WAR_GEM_MODULE, gCmd.REQ_WAR_GEM_MODIFY_LOCK, idx)
end
function warGemCtrl:onRspWarGemData(rsp)
	if rsp.err == gErrDef.Err_None then
		self.gemDataMgr:setGemData(rsp.data.gemData)
	else
	end
	_ENV = self.gemDataMgr
	self.gemDataMgr.msg = "MESSAGE_UI_WARGEM_DATA"
	SoraDSendMessage(self.gemDataMgr)
end
function warGemCtrl:onRspMergeInBag(rsp)
	if rsp.err == gErrDef.Err_None then
	else
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_UI_WARGEM_MERGE_RSP"
	gErrDef.Err_None.err = rsp.err
	SoraDSendMessage(gErrDef.Err_None)
end
function warGemCtrl:onRspMergeAllInBag(rsp)
	if rsp.err == gErrDef.Err_None then
	else
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_UI_WARGEM_MERGE_RSP"
	gErrDef.Err_None.err = rsp.err
	SoraDSendMessage(gErrDef.Err_None)
end
function warGemCtrl:onRspMergeInPanel(rsp)
	if rsp.err == gErrDef.Err_None then
	else
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_UI_WARGEM_MERGE_RSP"
	gErrDef.Err_None.err = rsp.err
	SoraDSendMessage(gErrDef.Err_None)
end
function warGemCtrl:onRspMountInPanel(rsp)
	if rsp.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("common_text_3885"))
	else
	end
	local lv = 0
	local idx = 0
	if rsp.data then
		lv = rsp.data.lv
		idx = rsp.data.idx
	end
	_ENV = i18n("common_text_3885")
	i18n("common_text_3885").msg = "MESSAGE_UI_WARGEM_MOUNT_RSP"
	i18n("common_text_3885").err = rsp.err
	i18n("common_text_3885").lv = lv
	i18n("common_text_3885").idx = idx
	SoraDSendMessage(i18n("common_text_3885"))
end
function warGemCtrl:onRspDismountFromPanel(rsp)
	if rsp.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("common_text_3891"))
	else
	end
	_ENV = i18n("common_text_3891")
	i18n("common_text_3891").msg = "MESSAGE_UI_WARGEM_DISMOUNT_RSP"
	i18n("common_text_3891").err = rsp.err
	SoraDSendMessage(i18n("common_text_3891"))
end
function warGemCtrl:onRspReplaceToPanel(rsp)
	if rsp.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("common_text_3885"))
	else
	end
	_ENV = i18n("common_text_3885")
	i18n("common_text_3885").msg = "MESSAGE_UI_WARGEM_REPLACE_RSP"
	i18n("common_text_3885").err = rsp.err
	SoraDSendMessage(i18n("common_text_3885"))
end
function warGemCtrl:onRspActivePanel(rsp)
	if rsp.err == gErrDef.Err_None then
		local panelId = rsp.data.panelId
		if panelId then
			_ENV = nil
			;(nil).num = panelId
			SoraDShowMsgTip(i18n("gem_text_03", nil))
		end
	else
	end
end
function warGemCtrl:onRspClearPanel(rsp)
	if rsp.err == gErrDef.Err_None then
		self.gemDataMgr:newEmptyPanel(rsp.data.panelId)
		_ENV = self.gemDataMgr
		self.gemDataMgr.msg = "MESSAGE_UI_WARGEM_RESET"
		SoraDSendMessage(self.gemDataMgr)
	else
		_ENV = self.gemDataMgr
		self.gemDataMgr.msg = "MESSAGE_UI_WARGEM_RESET_FAIL"
		SoraDSendMessage(self.gemDataMgr)
	end
end
function warGemCtrl:onRspRenamePanel(rsp)
	if rsp.err == gErrDef.Err_None then
		self.gemDataMgr:setPanelName(rsp.data.panelId, rsp.data.name)
	else
	end
	_ENV = self.gemDataMgr
	self.gemDataMgr.msg = "MESSAGE_UI_WARGEM_RENAME"
	SoraDSendMessage(self.gemDataMgr)
end
function warGemCtrl:onRspEnchantedAdd(rsp)
	dump(rsp, "onRspEnchantedAdd", 10)
	if rsp.err == gErrDef.Err_None then
		if rsp.data.optionType and rsp.data.optionType == gWarGemOptionType.SHOW then
			if rsp.data.isAgain then
				_ENV = gWarGemOptionType.SHOW
				gWarGemOptionType.SHOW.msg = "MESSAGE_UI_WARGEM_UPDATE"
				gWarGemOptionType.SHOW.rspdata = rsp.rspdata
				gWarGemOptionType.SHOW.data = rsp.data
				SoraDSendMessage(gWarGemOptionType.SHOW)
			else
				_ENV = 10
				;(10).rspdata = rsp.rspdata
				;(10).data = rsp.data
				uiManager:show("WarGemReplace", 10)
			end
		else
			self:updateEnchantedData(rsp.rspdata)
			local key = string.format("%d_%d_%d", rsp.data.lv, rsp.data.idx, rsp.data.position)
			local panelId = rsp.data.panelId
			local info = self:getEnchantedData(panelId)[key]
			local attr = wargemResRead.getEnchantmentAttr(info.enchantmentID, info.amount, info.strengthenLv)
			_ENV = info.amount
			info.amount.msg = "MESSAGE_UI_WARGEM_REFREASH_ENCHANTED"
			info.amount.aniType = "enchanted"
			info.amount.pos = rsp.data.position
			SoraDSendMessage(info.amount)
		end
	end
end
function warGemCtrl:onRspEnchantedStrength(rsp)
	dump(rsp, "onRspEnchantedStrength", 10)
	if rsp.err == gErrDef.Err_None then
		self:updateEnchantedData(rsp.rspdata)
		self:updateEnchantedStrength(rsp.data.lv, rsp.data.idx, rsp.data.position)
		_ENV = self
		self.msg = "MESSAGE_UI_WARGEM_REFREASH_ENCHANTED"
		self.aniType = "strenge"
		self.pos = rsp.data.position
		SoraDSendMessage(self)
	else
	end
end
function warGemCtrl:onRspModifyLock(rsp)
	dump(rsp, "onRspModifyLock", 10)
	if rsp.err == gErrDef.Err_None then
		self:updateEnchantedData(rsp.rspdata)
		_ENV = self
		self.msg = "MESSAGE_UI_WARGEM_REFREASH_ENCHANTED"
		self.aniType = "lock"
		self.pos = rsp.data.position
		SoraDSendMessage(self)
	else
	end
end
function warGemCtrl:onRspChangeHoleColor(rsp)
	dump(rsp, "onRspChangeHoleColor", 10)
	if rsp.err == gErrDef.Err_None then
		self:updateEnchantedData(rsp.rspdata)
		SoraDShowMsgTip(i18n("gemEnchant_text_49"))
		_ENV = i18n("gemEnchant_text_49")
		i18n("gemEnchant_text_49").msg = "MESSAGE_UI_WARGEM_CHANGE_COLOR"
		i18n("gemEnchant_text_49").panelId = rsp.data.panelId
		i18n("gemEnchant_text_49").lv = rsp.data.lv
		i18n("gemEnchant_text_49").idx = rsp.data.idx
		i18n("gemEnchant_text_49").color = rsp.data.color
		SoraDSendMessage(i18n("gemEnchant_text_49"))
	else
		_ENV = i18n("gemEnchant_text_49")
		i18n("gemEnchant_text_49").msg = "MESSAGE_UI_WARGEM_CHANGE_COLOR_FAIL"
		SoraDSendMessage(i18n("gemEnchant_text_49"))
	end
end
function warGemCtrl:onRspCopyPanel(rsp)
	dump(rsp, "onRspCopyPanel", 10)
	if rsp.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("gemEnchant_text_69"))
		self.gemDataMgr:setPanelData(rsp.rspdata.panel)
		_ENV = self.gemDataMgr
		self.gemDataMgr.msg = "MESSAGE_UI_WARGEM_COPY"
		SoraDSendMessage(self.gemDataMgr)
	else
		_ENV = self.gemDataMgr
		self.gemDataMgr.msg = "MESSAGE_UI_WARGEM_COPY_FAIL"
		SoraDSendMessage(self.gemDataMgr)
	end
end
function warGemCtrl:reqUpdateData()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.WAR_GEM, handler(self, self.onNotifyMsg))
end
function warGemCtrl:onNotifyMsg(notification)
	dump(notification.data, "warGemCtrl:onNotifyMsg notification", 10)
	for _, msg in ipairs(notification.data) do
		if msg.type == gWarGemMsgType.ADD_TO_BAG then
			self.gemDataMgr:addToBag(msg.data.gemId, msg.data.count)
			_ENV = self.gemDataMgr
			self.gemDataMgr.msg = "MESSAGE_UI_WARGEM_DATA_BAG"
			SoraDSendMessage(self.gemDataMgr)
		elseif msg.type == gWarGemMsgType.DEL_FROM_BAG then
			self.gemDataMgr:delFromBag(msg.data.gemId, msg.data.count)
			_ENV = self.gemDataMgr
			self.gemDataMgr.msg = "MESSAGE_UI_WARGEM_DATA_BAG"
			SoraDSendMessage(self.gemDataMgr)
		elseif msg.type == gWarGemMsgType.ADD_TO_PANEL then
			self.gemDataMgr:addToPanel(msg.data.panelId, msg.data.gemId, msg.data.lv, msg.data.idx)
			_ENV = self.gemDataMgr
			self.gemDataMgr.msg = "MESSAGE_UI_WARGEM_DATA_INLAY"
			self.gemDataMgr.lv = msg.data.lv
			self.gemDataMgr.idx = msg.data.idx
			SoraDSendMessage(self.gemDataMgr)
		elseif msg.type == gWarGemMsgType.DEL_FROM_PANEL then
			self.gemDataMgr:delFromPanel(msg.data.panelId, msg.data.lv, msg.data.idx)
			_ENV = self.gemDataMgr
			self.gemDataMgr.msg = "MESSAGE_UI_WARGEM_DATA_INLAY"
			self.gemDataMgr.lv = msg.data.lv
			self.gemDataMgr.idx = msg.data.idx
			SoraDSendMessage(self.gemDataMgr)
		elseif msg.type == gWarGemMsgType.OPEN_GEM_BOX then
			local _ENV, gemList = msg.type, msg.type
			for gemId, count in pairs(msg.data) do
				local itemID = tonumber(gemId)
				_ENV = nil
				;(nil).id = itemID
				;(nil).count = count
				table.insert(gemList, nil)
				self.newItem[itemID] = true
			end
			if 0 < #gemList then
				_ENV = pairs(msg.data)
				pairs(msg.data).itemType = gItemType.WAR_GEM
				pairs(msg.data).isArray = true
				SoraDOpenGiftView(gemList, pairs(msg.data))
				_ENV = gemList
				gemList.msg = "MESSAGE_UI_WARGEM_DATA_BAG"
				SoraDSendMessage(gemList)
			end
		elseif msg.type == gWarGemMsgType.RESET_WAR_GEM_DATA then
			self.gemDataMgr:setGemData(msg.data)
			_ENV = self.gemDataMgr
			self.gemDataMgr.msg = "MESSAGE_UI_WARGEM_DATA"
			SoraDSendMessage(self.gemDataMgr)
		elseif msg.type == gWarGemMsgType.UPDATE_STRONG_ESSENCE_COUNT then
			self.gemDataMgr:updateEssence(msg.data.strongEssenceCount)
			print("send!!!!!!!MESSAGE_UI_WARGEM_REFREASH_ESSENCE")
			_ENV = "send!!!!!!!MESSAGE_UI_WARGEM_REFREASH_ESSENCE"
			;("send!!!!!!!MESSAGE_UI_WARGEM_REFREASH_ESSENCE").msg = "MESSAGE_UI_WARGEM_REFREASH_ESSENCE"
			SoraDSendMessage("send!!!!!!!MESSAGE_UI_WARGEM_REFREASH_ESSENCE")
		end
	end
end
function warGemCtrl:getSwitchPanelDiff(newPanelId)
	local _ENV, disMountMap
	local _ENV, mountMap
	local newPanel = self.gemDataMgr:getPanel(newPanelId)
	newPanel = newPanel or self.gemDataMgr:newEmptyPanel(newPanelId)
	local oldPanel = self.gemDataMgr:getPanel(self.gemDataMgr:getActPanelId())
	if oldPanel and newPanel then
		for lv, hole in pairs(oldPanel) do
			for idx, oldGemId in pairs(hole) do
				local newGemId = newPanel[lv][idx]
				if 0 < oldGemId and oldGemId ~= newGemId then
					if not disMountMap[lv] then
						disMountMap[lv], _ENV = disMountMap[lv], disMountMap[lv]
					end
					disMountMap[lv][idx] = oldGemId
				end
				if 0 < newGemId and oldGemId ~= newGemId then
					if not mountMap[lv] then
						mountMap[lv], _ENV = mountMap[lv], mountMap[lv]
					end
					mountMap[lv][idx] = newGemId
				end
			end
		end
	end
	return disMountMap, mountMap
end
function warGemCtrl:getPanelDismountCost(panel)
	local _ENV, totalCost
	if panel then
		for lv, hole in pairs(panel) do
			for idx, gemId in pairs(hole) do
				local gemCfg = warGemltCtrl:getGemCfg(gemId)
				if gemCfg and gemCfg.dismountCost then
					for _, cost in pairs(gemCfg.dismountCost) do
						totalCost[cost.id] = (totalCost[cost.id] or 0) - cost.count
					end
				end
			end
		end
	end
	return totalCost
end
function warGemCtrl:getPanelBuffPlus(panelId, panel, buffType)
	if not panel then
		return
	end
	local plus = 0
	local flag = 1
	local cfgData = enchantmentStoneLevelCfgData
	for lv, hole in pairs(panel) do
		for idx, gemId in pairs(hole) do
			if gemId and 0 < gemId then
				local gemCfg = warGemltCtrl:getGemCfg(gemId)
				if gemCfg and gemCfg.buffList and next(gemCfg.buffList) then
					for _, buff in ipairs(gemCfg.buffList) do
						if buff.type == buffType then
							plus = plus + buff.count
							flag = buff.flag
						end
					end
				end
			end
		end
	end
	if not self:getEnchantedData(panelId) then
		enchantmentStoneLevelCfgData = self:getEnchantedData(panelId)
	end
	for k, v in pairs((self:getEnchantedData(panelId))) do
		if v.enchantmentID and self:isEnchantColorValidByInfo(v) then
			local t, value, f = wargemResRead.getEnchantmentAttrValue(v.enchantmentID, v.amount, v.strengthenLv)
			if t == buffType then
				local hole = panel[tostring(v.lv)]
				local gemId = 0
				if hole then
					gemId = hole[v.idx]
				end
				if gemId and 0 < gemId then
					local unlockLv = cfgData[v.position].gemlv
					local gemlv = wargemResRead.getLevel(gemId) or 0
					if unlockLv <= gemlv then
						plus = plus + value
						flag = f
					end
				end
			end
		end
	end
	if 0 == plus then
		plus = nil
	end
	return plus, flag
end
function warGemCtrl:getActPanelId()
	return self.gemDataMgr:getActPanelId()
end
function warGemCtrl:getBuffPlus(buffType)
	if not self.buffPlusCache or self.gemDataMgr:getIsClearBuffCache() then
		self.buffPlusCache, _UPVALUE0_ = self.gemDataMgr:getIsClearBuffCache(), self.gemDataMgr:getIsClearBuffCache()
		self.gemDataMgr:setIsClearBuffCache(false)
	end
	local buffPlusCache = self.buffPlusCache[buffType]
	if buffPlusCache then
		return buffPlusCache.plus, buffPlusCache.flag
	end
	local actPanel = self.gemDataMgr:getPanel(self.gemDataMgr:getActPanelId())
	local plus, flag = self:getPanelBuffPlus(self.gemDataMgr:getActPanelId(), actPanel, buffType)
	_UPVALUE0_ = self.gemDataMgr:getActPanelId()
	self.gemDataMgr:getActPanelId().plus = plus
	buffPlusCache, self.gemDataMgr:getActPanelId().flag = self.gemDataMgr:getActPanelId(), flag
	self.buffPlusCache[buffType] = buffPlusCache
	return plus, flag
end
function warGemCtrl:getActivePanelCost(newPanelId)
	if newPanelId and 0 < newPanelId and newPanelId ~= self.gemDataMgr:getActPanelId() then
		local disMountMap, mountMap = self:getSwitchPanelDiff(newPanelId)
		return self:getPanelDismountCost(disMountMap)
	end
end
function warGemCtrl:getGemID(panelId, lv, idx)
	local panelInfo = self.gemDataMgr:getPanel(panelId)
	return panelInfo[tostring(lv)][idx]
end
function warGemCtrl:getGemData()
	local _ENV, data
	if self.gemDataMgr:getPanel(self.gemDataMgr:getActPanelId()) and next(self.gemDataMgr:getPanel(self.gemDataMgr:getActPanelId())) then
		data = self.gemDataMgr:getGemData()
		_ENV = self.gemDataMgr
		self.gemDataMgr.msg = "MESSAGE_UI_WARGEM_DATA"
		SoraDSendMessage(self.gemDataMgr)
	else
		self:reqWarGemData()
	end
	return data
end
function warGemCtrl:getItemCount(id)
	local bagData = self.gemDataMgr:getBag()
	if bagData and bagData[tostring(id)] then
		return bagData[tostring(id)]
	end
	return 0
end
function warGemCtrl:getItemCountInPanel(panelId)
	local _ENV, itemMap
	local panel = self.gemDataMgr:getPanel(panelId)
	if panel then
		for _, hole in pairs(panel) do
			for _, gemId in pairs(hole) do
				if gemId and 0 < gemId then
					itemMap[tostring(gemId)] = (itemMap[tostring(gemId)] or 0) + 1
				end
			end
		end
	end
	return itemMap
end
function warGemCtrl:getAllGem()
	local allGemMap = self:getItemCountInPanel(self.gemDataMgr:getActPanelId())
	local bagData = self.gemDataMgr:getBag()
	if bagData then
		for gemId, count in pairs(bagData) do
			allGemMap[gemId] = (allGemMap[gemId] or 0) + count
		end
	end
	return allGemMap
end
function warGemCtrl:getGemBagList(panelId)
	local _ENV, showBag
	if panelId and 0 < panelId and panelId ~= self.gemDataMgr:getActPanelId() then
		showBag = self:getAllGem()
		local currPanelItemMap = self:getItemCountInPanel(panelId)
		if currPanelItemMap then
			for gemId, count in pairs(currPanelItemMap) do
				if showBag[gemId] then
					showBag[gemId] = showBag[gemId] - count
					if showBag[gemId] <= 0 then
						showBag[gemId] = nil
					end
				end
			end
		end
	else
		showBag = self.gemDataMgr:getBag()
	end
	local _ENV, gemList = self.gemDataMgr:getBag(), self.gemDataMgr:getBag()
	if next(showBag) then
		local _ENV, sortGemList = next(showBag), next(showBag)
		for gemId, count in pairs(showBag) do
			local id = tonumber(gemId)
			local new = self.newItem[id] or false
			_ENV = nil
			;(nil).id = id
			;(nil).count = count
			;(nil).new = new
			table.insert(sortGemList, nil)
		end
		table.sort(sortGemList, function(v1, v2)
			return v2.id < v1.id
		end)
		for _, gems in ipairs(sortGemList) do
			local fullCellCount = math.floor(gems.count / WAR_GEM_BAG_CELL_OVERLAP_MAX)
			local leftCount = math.floor(gems.count % WAR_GEM_BAG_CELL_OVERLAP_MAX)
			if 0 < fullCellCount then
				for i = 1, fullCellCount do
					_ENV = nil
					;(nil).id = gems.id
					;(nil).count = WAR_GEM_BAG_CELL_OVERLAP_MAX
					table.insert(gemList, nil)
				end
			end
			if 0 < leftCount then
				_ENV = 1
				;(1).id = gems.id
				;(1).count = leftCount
				table.insert(gemList, 1)
			end
		end
	end
	return gemList
end
function warGemCtrl:getGemPanel(panelId)
	panelId = panelId or self.gemDataMgr:getActPanelId()
	if not self.gemDataMgr:getPanel(panelId) then
		_UPVALUE0_ = self.gemDataMgr:getPanel(panelId)
	end
	return (self.gemDataMgr:getPanel(panelId))
end
function warGemCtrl:getGemPanelName(panelId)
	return self.gemDataMgr:getPanelName(panelId)
end
function warGemCtrl:getInActGemPanelAfterAct(panelId)
	local panel = self:getGemPanel(panelId)
	if panelId == self.gemDataMgr:getActPanelId() then
		return panel
	end
	local _ENV, realPanel = self.gemDataMgr:getActPanelId(), self.gemDataMgr:getActPanelId()
	local allGemMap = self:getAllGem()
	for lv, hole in pairs(panel) do
		for idx, gemId in pairs(hole) do
			if allGemMap[tostring(gemId)] and allGemMap[tostring(gemId)] > 0 then
				allGemMap[tostring(gemId)] = allGemMap[tostring(gemId)] - 1
				if not realPanel[lv] then
					realPanel[lv], _ENV = realPanel[lv], realPanel[lv]
				end
				realPanel[lv][idx] = gemId
			end
		end
	end
	return realPanel
end
function warGemCtrl:getGemListMax()
	local maxLevel = 2
	local bagData = self.gemDataMgr:getBag()
	if bagData then
		for gemId, count in pairs(bagData) do
			local level = gemId % 100
			if maxLevel < level then
				maxLevel = level
			end
		end
	end
	return math.min(maxLevel + 1, 10)
end
function warGemCtrl:canGemComposite(id, inlay)
	local toMid = warGemltCtrl:getGemMaterialIDAfterMerge(id)
	local tableM = warGemltCtrl:getGemMaterialList(toMid)
	if tableM then
		local bEnough = true
		for _, v in ipairs(tableM) do
			local hasnum = self:getItemCount(v.id)
			if inlay and v.id == id then
				if hasnum + 1 < v.count then
					bEnough = false
					break
				end
			elseif hasnum < v.count then
				bEnough = false
				break
			end
		end
		return bEnough
	end
	return false
end
function warGemCtrl:addGemNew(id)
	self.newItem[id] = true
end
function warGemCtrl:isGemNew(id)
	return self.newItem[id]
end
function warGemCtrl:resetGemNewInfo()
	self.newItem, _UPVALUE0_ = nil, nil
end
function warGemCtrl:isHasFiler()
	return next(self.filerGemAttrType) ~= nil
end
function warGemCtrl:isGemFiler(gid)
	local filerCfg, filerIndex = wargemResRead.getGemBgFiler()
	if warGemltCtrl:isEnchantedItem(gid) then
		return self.filerGemAttrType[1]
	else
		local attrType = wargemResRead.getAttr(gid)
		local index = filerIndex[attrType]
		return self.filerGemAttrType[index]
	end
end
function warGemCtrl:getGemFilerData()
	return self.filerGemAttrType
end
function warGemCtrl:setGemFilerData(filerGemAttrType)
	self.filerGemAttrType = filerGemAttrType
end
function warGemCtrl:resetGemFilerType()
	self.filerGemAttrType, _UPVALUE0_ = nil, nil
end
function warGemCtrl:checkVip(index, needShowTip)
	index = index or 1
	local condition = warGemltCtrl:getGemSwitchCondition(index)
	if condition == nil then
		return false, -1, -1
	end
	local isOK, needVipLv, needType = serviceFunctions.checkCondtion(condition)
	if needShowTip and not isOK then
		if needVipLv > VIP_SVIP_LV then
			warGemltCtrl = nil
			;(nil).lv = needVipLv - VIP_SVIP_LV
			SoraDShowMsgTip(i18n("common_text_4335", nil))
		else
			warGemltCtrl = i18n("common_text_4335", nil)
			i18n("common_text_4335", nil).lv = needVipLv
			SoraDShowMsgTip(i18n("common_text_3242", i18n("common_text_4335", nil)))
		end
	end
	return isOK, needVipLv, needType
end
function warGemCtrl:isHasEmptyPanel()
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local curLevel = cityCtrl:getBuildMaxLv(BUILDID.MIRACLE)
	local buildLogic = include("buildLogic")
	local warLv = buildLogic.transformBuildLvToWarLv(curLevel)
	local tableData = self:getGemPanel()
	for k = 1, 33 do
		local lv = math.floor((k - 1) / 3)
		local idx = (k - 1) % 3 + 1
		local tid = 0
		if tableData[tostring(lv)] then
			tid = tableData[tostring(lv)][idx]
		end
		local lock = warLv < lv
		if lock then
			break
		end
		if 0 == tid then
			return true
		end
	end
end
function warGemCtrl:getEnchantedInfo(idx, warlv, pos)
	local enchantedData = self:getEnchantedData()
	if enchantedData and next(enchantedData) ~= nil then
		_UPVALUE5_ = enchantedData
		enchantedData[1] = warlv
		enchantedData[2] = "_"
		enchantedData[3] = idx
		enchantedData[4] = "_"
		enchantedData[5] = pos
		local key = table.concat(enchantedData)
		local info = enchantedData[key]
		return info
	end
end
function warGemCtrl:getEnchantedItemInBag(itemID)
	return self.gemDataMgr:getItemFromBag(itemID)
end
function warGemCtrl:getHoldEnchanted(idx, warlv)
	local _UPVALUE0_, info
	for i = 1, 3 do
		local tmp = self:getEnchantedInfo(idx, warlv, i)
		info[i] = tmp and true or false
	end
	return info
end
function warGemCtrl:updateEnchantedData(data)
	self.gemDataMgr:setIsClearBuffCache(true)
	local attrData = self.gemDataMgr:getGemData()
	for i = 1, 8 do
		local key = "enchantmentAttribute" .. i
		if data[key] then
			for k, v in pairs(data[key]) do
				attrData[key][k] = v
			end
		end
		local key = "holeColor" .. i
		if data[key] then
			for k, v in pairs(data[key]) do
				attrData[key][k] = v
			end
		end
	end
end
function warGemCtrl:updateEnchantedStrength(lv, idx, position)
	self.gemDataMgr:setIsClearBuffCache(true)
	local attrData = self.gemDataMgr:getGemData()
	local strKey = lv .. "_" .. idx .. "_" .. position
	print("key", strKey)
	if not attrData.enchantmentAttribute1[strKey] then
		dump(attrData.enchantmentAttribute1, "强化数据错误", 10)
		return
	end
	local strengthenLv = attrData.enchantmentAttribute1[strKey].strengthenLv
	print("更新强化等级", strengthenLv)
	for i = 2, 8 do
		local key = "enchantmentAttribute" .. i
		if attrData[key] then
			if attrData[key][strKey] then
				attrData[key][strKey].strengthenLv = strengthenLv
			else
				_ENV = nil
				;(nil).idx = idx
				;(nil).lv = lv
				;(nil).position = position
				attrData[key][strKey], (nil).strengthenLv = nil, strengthenLv
			end
		end
	end
end
function warGemCtrl:getEssenceCount()
	return self.gemDataMgr:getGemData().strongEssenceCount
end
function warGemCtrl:getEnchantedData(panelId)
	panelId = panelId or self:getEditPanelId()
	print("warGemCtrl:getEnchantedData", panelId)
	return self.gemDataMgr:getGemData()["enchantmentAttribute" .. panelId]
end
function warGemCtrl:getGemHoleColor(lv, idx, panelId)
	panelId = panelId or self:getEditPanelId()
	local key = lv .. "_" .. idx
	return self.gemDataMgr:getGemData()["holeColor" .. panelId][key] or warGemltCtrl:getGemHoleColor(lv, idx)
end
function warGemCtrl:getEditPanelId()
	return self.editPanelId or self:getActPanelId()
end
function warGemCtrl:setEditPanelId(panelId)
	self.editPanelId = panelId
end
function warGemCtrl:isCurPanelActive()
	return self:getEditPanelId() == self:getActPanelId()
end
function warGemCtrl:isEnchantColorValid(lv, idx, position)
	local info = self:getEnchantedInfo(idx, lv, position)
	return self:isEnchantColorValidByInfo(info)
end
function warGemCtrl:isEnchantColorValidByInfo(info)
	if info and info.enchantmentID then
		local enchantColor = info and warGemltCtrl:getEnchantedColor(info.enchantmentID) or -1
		local needColor = self:getGemHoleColor(info.lv, info.idx)
		if enchantColor == needColor then
			return true
		end
	end
	return false
end
function warGemCtrl:getEnchantedItemID(idx, warLv)
	local color = self:getGemHoleColor(warLv, idx)
	return warGemltCtrl:getEnchantedItemIDByColor(color)
end
function warGemCtrl:getEnchantedBuffPlus(panelId)
	local eData = self:getEnchantedData(panelId)
	local cfgData = require_data("enchantment_stone_level", true).data
	local gemData = self:getInActGemPanelAfterAct(self.gemDataMgr:getActPanelId())
	for _, v in pairs(eData) do
		local unlockLv = cfgData[v.position].gemlv
		local gemId = self.gemData[tostring(v.lv)][v.idx]
		local gemlv = wargemResRead.getLevel(gemId) or 0
		if unlockLv <= gemlv then
			local t, value = wargemResRead.getEnchantmentAttrValue(v.enchantmentID, v.amount, v.strengthenLv)
			if not enchantedList[t] then
				enchantedList[t] = value
			else
				enchantedList[t] = enchantedList[t] + value
			end
		end
	end
	return enchantedList
end
function warGemCtrl:isExchangeStoreOpen()
	local lv = SoraDGetBuildLv(BUILDID.MIRACLE)
	local constantRead = include("constantRead")
	local needLv = constantRead.getConstValue("WAR_STONE_CHANGE_LEVLE")
	if lv >= needLv then
		return true
	end
	return false
end
function warGemCtrl:getResParam(lv, idx)
	_ENV, _UPVALUE3_ = nil, nil
	;(nil).icon = "1606.png"
	_ENV, (nil).getCountFunc = function(id)
		return self:getEssenceCount()
	end, function(id)
		return self:getEssenceCount()
	end
	;(function(id)
		return self:getEssenceCount()
	end).id = self:getEnchantedItemID(idx, lv)
	_ENV, (function(id)
		return self:getEssenceCount()
	end).type = gIDType.WAR_STONE, gIDType.WAR_STONE
	gIDType.WAR_STONE.id = gIDDef.MITHRIL
	gIDType.WAR_STONE.type = gIDType.CITYRES
	;(nil)[1] = nil
	;(nil)[2] = function(id)
		return self:getEssenceCount()
	end
	;(nil)[3] = gIDType.WAR_STONE
	return nil
end
return warGemCtrl
