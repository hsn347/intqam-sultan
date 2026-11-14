local gameModule = include("GameModule")
local backpack = include("backpack")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local msgCtrl = include("msgCtrl")
local itemLogic = include("itemLogic")
local msgNotice = include("msgNotice")
local backpackCtrl = class("backpackCtrl", gameModule)
backpackCtrl.backpacks, _ENV = "backpackCtrl", "backpackCtrl"
function backpackCtrl:ctor(properties)
	backpackCtrl.super.ctor(self, properties)
	self.backpacks, backpackCtrl = backpackCtrl.super.ctor, backpackCtrl.super.ctor
	local propsBackpack = backpack.new(gBackpackDef.PROPS)
	self.backpacks[gBackpackDef.PROPS] = propsBackpack
	local materialBackpack = backpack.new(gBackpackDef.MATERIAL)
	self.backpacks[gBackpackDef.MATERIAL] = materialBackpack
	self.backpacks[gBackpackDef.MAGIC_LAMP_SKILL] = backpack.new(gBackpackDef.MAGIC_LAMP_SKILL)
	self:resetNewItemInfo()
end
local _ENV, RSP = function(self, properties)
	backpackCtrl.super.ctor(self, properties)
	self.backpacks, backpackCtrl = backpackCtrl.super.ctor, backpackCtrl.super.ctor
	local propsBackpack = backpack.new(gBackpackDef.PROPS)
	self.backpacks[gBackpackDef.PROPS] = propsBackpack
	local materialBackpack = backpack.new(gBackpackDef.MATERIAL)
	self.backpacks[gBackpackDef.MATERIAL] = materialBackpack
	self.backpacks[gBackpackDef.MAGIC_LAMP_SKILL] = backpack.new(gBackpackDef.MAGIC_LAMP_SKILL)
	self:resetNewItemInfo()
end, function(self, properties)
	backpackCtrl.super.ctor(self, properties)
	self.backpacks, backpackCtrl = backpackCtrl.super.ctor, backpackCtrl.super.ctor
	local propsBackpack = backpack.new(gBackpackDef.PROPS)
	self.backpacks[gBackpackDef.PROPS] = propsBackpack
	local materialBackpack = backpack.new(gBackpackDef.MATERIAL)
	self.backpacks[gBackpackDef.MATERIAL] = materialBackpack
	self.backpacks[gBackpackDef.MAGIC_LAMP_SKILL] = backpack.new(gBackpackDef.MAGIC_LAMP_SKILL)
	self:resetNewItemInfo()
end
function RSP:initDataRsp(content)
	if content.err ~= gErrDef.Err_None then
		print("initDataRsp error: ", content.err)
		return
	end
	local data = content.data
	self:initItems(data)
end
function RSP:historyGainRsp(content)
	dump(content, "historyGainRsp", 10)
	if content.err == gErrDef.Err_None then
		self.gainRecord = content.rspdata.historyGainData.gainRecord
	end
end
function RSP:useItemRsp(content)
	dump(content, "useItemRsp", 50)
	_ENV = "useItemRsp"
	;("useItemRsp").err = content.err
	;("useItemRsp").count = content.data.count
	;("useItemRsp").data = content.data
	if itemLogic.checkItemSpecialBackTip(content.data.itemID, "useItemRsp") then
		print("走特殊提示流程")
	elseif content.err ~= gErrDef.Err_None then
		print("useItemRsp error: ", content.err)
		if content.err == gErrDef.Err_ITEM_USE_NOT_OPEN_TIME then
			SoraDShowMsgTip(i18n("presell_notice_01"))
		elseif content.err == gErrDef.Err_PROP_OTHER_RECV_ITEM_COUNT_LIMIT then
			SoraDShowMsgTip(i18n("Snowman_text_05"))
		elseif content.err == gErrDef.Err_ITEM_USE_LORD_HEAD_EXIST then
			SoraDShowMsgTip(i18n("privilege_lord_text_0003"))
		elseif content.err == gErrDef.Err_METEOR_MAGIC_EXP_FULL_LV then
			SoraDShowMsgTip(i18n("lordskill_text_07"))
		elseif content.err == gErrDef.Err_TARGET_STAR_LEVEL_IS_NOT_REACHED then
			local itemID = content.data.itemID
			local itemDesRead = include("itemDesRead")
			local itemDonation = itemDesRead.getItemDonation(itemID)
			_ENV = i18n("lordskill_text_07")
			i18n("lordskill_text_07").itemID = itemID
			i18n("lordskill_text_07").itemDonation = itemDonation
			dump(i18n("lordskill_text_07"))
			if itemDonation then
				_ENV = 10
				;(10).lv = itemDonation.lvLimit[2]
				SoraDShowMsgTip(i18n("common_text_4692", 10))
			else
				_ENV = i18n("common_text_4692", 10)
				i18n("common_text_4692", 10).lv = 44
				SoraDShowMsgTip(i18n("common_text_4692", i18n("common_text_4692", 10)))
			end
		elseif content.err == gErrDef.Err_PROP_CARRIER_PIGEON_COUNT_LIMIT then
			local resultType = backpackltCtrl:getResultType(content.data.itemID)
			if resultType == gItemEffectDef.GIVE_ITEM_NEW then
				local canReceiveNum = content.data.extra.canReceiveNum
				if canReceiveNum <= 0 then
					SoraDShowMsgTip(i18n("common_text_4693"))
				elseif canReceiveNum >= content.data.count then
					local publicRead = include("publicRead")
					_ENV = i18n("common_text_4693")
					i18n("common_text_4693").num = canReceiveNum
					i18n("common_text_4693").name = publicRead.getName(content.data.itemID)
					SoraDShowMsgTip(i18n("common_text_4696", i18n("common_text_4693")))
				else
					_ENV = i18n("common_text_4696", i18n("common_text_4693"))
					i18n("common_text_4696", i18n("common_text_4693")).num = canReceiveNum
					SoraDShowMsgTip(i18n("common_text_4691", i18n("common_text_4696", i18n("common_text_4693"))))
				end
			elseif resultType == gItemEffectDef.GIVE_ITEM then
				local canReceiveNum = content.data.extra.canReceiveNum
				if 0 < canReceiveNum then
					_ENV = i18n("common_text_4691", i18n("common_text_4696", i18n("common_text_4693")))
					i18n("common_text_4691", i18n("common_text_4696", i18n("common_text_4693"))).num = canReceiveNum
					SoraDShowMsgTip(i18n("common_text_4857", i18n("common_text_4691", i18n("common_text_4696", i18n("common_text_4693")))))
				else
					SoraDShowMsgTip(i18n("common_text_4856"))
				end
			else
				local canReceiveNum = content.data.extra.canReceiveNum
				if 0 < canReceiveNum then
					_ENV = i18n("common_text_4856")
					i18n("common_text_4856").num = canReceiveNum
					SoraDShowMsgTip(i18n("pigeon_text_02", i18n("common_text_4856")))
				else
					SoraDShowMsgTip(i18n("pigeon_text_01"))
				end
			end
		end
	else
		local result = content.data.result
		local useItemID = content.data.itemID
		local useCount = content.data.count
		local resultType = backpackltCtrl:getResultType(useItemID)
		local itemType = backpackltCtrl:getItemType(useItemID)
		print("resultType==", resultType, itemType)
		dump(result, "result===")
		if itemType == gItemType.WAR_GEM then
			return
		end
		local showGiftView = function(_result)
			if _result then
				local _ENV, list
				for _, item in ipairs(_result) do
					list[item.id] = item.count
				end
				SoraDOpenGiftView(list)
			end
		end
		if resultType == gItemEffectDef.ITEM or resultType == gItemEffectDef.LUA or resultType == gItemEffectDef.GROUP_ITEM or resultType == gItemEffectDef.OPTIONAL_HERO then
			if result and #result == 1 then
				local itemID = result[1].id
				local count = result[1].count
				local iconType = gNoticeIconTypeDef.ICON_ITEM
				if resultType == gItemEffectDef.LUA or resultType == gItemEffectDef.GROUP_ITEM or resultType == gItemEffectDef.OPTIONAL_HERO then
					if gItemType.RECRUIT_SOLDIERS == backpackltCtrl:getItemType(useItemID) then
						_ENV = backpackltCtrl
						backpackltCtrl.itemID = useItemID
						msgNotice.notice("notice_0053", backpackltCtrl)
					else
						_ENV = backpackltCtrl
						backpackltCtrl.itemID = itemID
						backpackltCtrl.count = count
						msgNotice.notice("notice_0117", backpackltCtrl, iconType, itemID)
					end
				else
					_ENV = backpackltCtrl
					backpackltCtrl.itemID = useItemID
					backpackltCtrl.count = useCount
					msgNotice.notice("notice_0117", backpackltCtrl, iconType, useItemID)
				end
				if itemType == gItemType.EXCLUSIVE_VIP_POINT then
					_ENV = "notice_0117"
					;("notice_0117").msg = "MESSAGE_SECOND_STAR_BUILDING_BTN_REFRESH"
					SoraDSendMessage("notice_0117")
				end
			else
				if result and 1 < #result then
					showGiftView(result)
				else
				end
			end
		elseif backpackltCtrl:checkBuffStackingItem(useItemID) then
			local result = backpackltCtrl:getResult(useItemID)
			local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
			local second = buffltCtrl:getTime(result)
			local constantRead = include("constantRead")
			local buffStackingTime = constantRead.getConstValue("BUFF_STACKING_TIME", 86400)
			_ENV = useItemID
			useItemID.itemID = useItemID
			useItemID.time1 = SoraDConvertSecondToString(second)
			useItemID.time2 = SoraDConvertSecondToStringHour(buffStackingTime)
			msgNotice.notice("common_text_4911", useItemID)
		elseif resultType == gItemEffectDef.RANDOM_GIFT or resultType == gItemEffectDef.CHEST or resultType == gItemEffectDef.GUARANTEE or resultType == gItemEffectDef.OPTIONAL_EXTRA or resultType == gItemEffectDef.LEVEL_REWARD then
			if resultType == gItemEffectDef.RANDOM_GIFT then
				local activity_9001680_Ctrl = SoraDGetCtrl("activity_9001680_Ctrl")
				if activity_9001680_Ctrl:isUseItemID(useItemID) then
					SoraDMailGainItems(result, true)
					return
				end
			end
			showGiftView(result)
		elseif resultType == gItemEffectDef.LOVE_HEART then
		elseif resultType == gItemEffectDef.SUMMON_BOSS or resultType == gItemEffectDef.SUMMON_SEA_MONSTER then
		elseif resultType == gItemEffectDef.LEVEL_REWARD then
			local _ENV, list = gItemEffectDef.LEVEL_REWARD, gItemEffectDef.LEVEL_REWARD
			for _, item in ipairs(result) do
				list[item.id] = item.count
			end
			SoraDOpenGiftView(list)
		elseif resultType == gItemEffectDef.EMOJI_STAMP then
			local emojiIndex = content.data.extra.emojiIndex
			_ENV = ipairs(result)
			ipairs(result).byUID = true
			if not SoraDConfigGet("Game:worldMapEmojiSeal:emoji~table", ipairs(result)) then
				local _ENV, list = SoraDConfigGet("Game:worldMapEmojiSeal:emoji~table", ipairs(result)), SoraDConfigGet("Game:worldMapEmojiSeal:emoji~table", ipairs(result))
			end
			local isExist = false
			for k, v in ipairs(list) do
				if v.emojiID == emojiIndex then
					isExist = true
					list[k].time = os.time()
					list[k].count = list[k].count + 1
					break
				end
			end
			if not isExist then
				_ENV = ipairs(list)
				ipairs(list).emojiID = emojiIndex
				ipairs(list).time = os.time()
				ipairs(list).count = 1
				table.insert(list, ipairs(list))
			end
			_ENV = os.time()
			os.time().byUID = true
			SoraDConfigSet("Game:worldMapEmojiSeal:emoji~table", list, (os.time()))
		elseif resultType == gItemEffectDef.REPAIR_WALL then
			_ENV = SoraDConfigGet("Game:worldMapEmojiSeal:emoji~table", ipairs(result))
			SoraDConfigGet("Game:worldMapEmojiSeal:emoji~table", ipairs(result)).msg = "MESSAGE_WALLS_NOTIFY_UPDATE"
			SoraDSendMessage((SoraDConfigGet("Game:worldMapEmojiSeal:emoji~table", ipairs(result))))
		elseif resultType == gItemEffectDef.SINGLE_TRAIN_ADD_COUNT then
			_ENV = SoraDConfigGet("Game:worldMapEmojiSeal:emoji~table", ipairs(result))
			SoraDConfigGet("Game:worldMapEmojiSeal:emoji~table", ipairs(result)).msg = "MESSAGE_ARMY_TOOL_UPDATE"
			SoraDSendMessage((SoraDConfigGet("Game:worldMapEmojiSeal:emoji~table", ipairs(result))))
		elseif resultType == gItemEffectDef.OPTIONAL then
			local publicRead = include("publicRead")
			_ENV = SoraDConfigSet
			SoraDConfigSet.good = publicRead.getName(result[1].id) .. "*" .. result[1].count
			msgNotice.notice("common_text_3276", SoraDConfigSet)
		elseif resultType == gItemEffectDef.TREASURE_CRYSTAL then
			_ENV = msgNotice.notice
			msgNotice.notice.msg = "MESSAGE_TREASURECRYSTAL_REFRESH"
			msgNotice.notice.infoData = result
			SoraDSendMessage(msgNotice.notice)
		elseif resultType == gItemEffectDef.PANDORABOX then
			local effectType = content.data.extra.effect
			if effectType == gPandoraBoxUseEffect.GET_TREASURE_CRYSTAL then
				local panel = SoraDCreatePanel("getCrystalView")
				panel:initData(result[1])
				panel:show()
			else
				SoraDMailGainItems(result, true)
			end
		elseif resultType == gItemEffectDef.SEND_SNOW_MAN_ITEMS then
			msgNotice.notice("common_text_3656")
			_ENV = "common_text_3656"
			;("common_text_3656").msg = "MESSAGE_NEW_YEARS_SERVER_UPDATE"
			SoraDSendMessage("common_text_3656")
		elseif resultType == gItemEffectDef.RECRUIT_ARMY then
			local armyDesRead = include("armyDesRead")
			local armyName = armyDesRead.getName(result.id)
			_ENV = result[1]
			result[1].num = result.count
			result[1].name = armyName
			msgNotice.notice("common_text_4571", result[1])
		elseif resultType == gItemEffectDef.ARMY_RECRUIT then
			local armyDesRead = include("armyDesRead")
			local armyName = armyDesRead.getName(result[1].id)
			_ENV = result[1]
			result[1].army = result[1].count
			result[1].count = armyName
			msgNotice.notice("common_text_4651", result[1])
		elseif resultType == gItemEffectDef.DRESS then
			if not content.clientData then
				local _ENV, clientData = content.clientData, content.clientData
			end
			local dressID = clientData.dressID
			if dressID then
				local dressCtrl = SoraDGetCtrl("dressCtrl")
				dressCtrl:selectDress(dressID)
			end
		elseif resultType == gItemEffectDef.GIVE_ITEM_NEW then
			local publicRead = include("publicRead")
			_ENV = dressCtrl
			dressCtrl.num = content.data.extra.canReceiveNum
			dressCtrl.name = publicRead.getName(useItemID)
			SoraDShowMsgTip(i18n("common_text_4696", dressCtrl))
		else
			_ENV = i18n("common_text_4696", dressCtrl)
			i18n("common_text_4696", dressCtrl).itemID = useItemID
			msgNotice.notice("notice_0053", i18n("common_text_4696", dressCtrl))
		end
	end
end
function RSP:mergeItemRsp(content)
	dump(content, "RSP.mergeItemRsp", 10)
	if content.err ~= gErrDef.Err_None then
		return
	end
	if 830401 == content.data.mergeID then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_EIDALADHA_FEAST_REFRESH"
		gErrDef.Err_None.subMsg = "Merge"
		SoraDSendMessage(gErrDef.Err_None)
	else
		_ENV = "RSP.mergeItemRsp"
		;("RSP.mergeItemRsp").err = content.err
		;("RSP.mergeItemRsp").count = content.data.count
		;("RSP.mergeItemRsp").from = "mergeItem"
		itemLogic.checkItemSpecialBackTip(content.data.mergeID, "RSP.mergeItemRsp")
	end
	_ENV = content.data.mergeID
	content.data.mergeID.msg = "MESSAGE_ITEM_MERGE_BACK"
	SoraDSendMessage(content.data.mergeID)
end
function RSP:translateItemRsp(content)
	dump(content, "RSP.translateItemRsp", 10)
	if content.err ~= gErrDef.Err_None then
		return
	end
end
function RSP:recycleItemRsp(content)
	dump(content, "RSP.recycleItemRsp", 10)
	if content.err ~= gErrDef.Err_None then
		return
	end
end
function RSP:lockItemRsp(content)
	dump(content, "RSP.lockItemRsp", 10)
	if content.err ~= gErrDef.Err_None then
		return
	end
	local _ENV, itemChangeList = content.err, content.err
	if not content.data.itemIdList then
		_ENV = content.data.itemIdList
	end
	for _, itemID in ipairs(content.data.itemIdList) do
		if not self.lockItemIDMap[itemID] then
			self.lockItemIDMap[itemID] = true
			itemChangeList[itemID] = 0
		end
	end
	self:dispatchItemChangeEvent(itemChangeList)
end
function RSP:unlockItemRsp(content)
	dump(content, "RSP.unlockItemRsp", 10)
	if content.err ~= gErrDef.Err_None then
		return
	end
	local _ENV, itemChangeList = content.err, content.err
	if not content.data.itemIdList then
		_ENV = content.data.itemIdList
	end
	for _, itemID in ipairs(content.data.itemIdList) do
		if self.lockItemIDMap[itemID] then
			self.lockItemIDMap[itemID] = nil
			itemChangeList[itemID] = self:getItemCount(itemID)
		end
	end
	self:dispatchItemChangeEvent(itemChangeList)
end
function RSP:mergeItemAsPossibleRsp(content)
	if content.err ~= gErrDef.Err_None then
		return
	end
	_ENV = nil
	;(nil).err = content.err
	;(nil).count = content.data.count
	;(nil).from = "mergeItem"
	itemLogic.checkItemSpecialBackTip(content.data.mergeID, nil)
	_ENV = content.data.mergeID
	content.data.mergeID.msg = "MESSAGE_ITEM_MERGE_BACK"
	SoraDSendMessage(content.data.mergeID)
end
function RSP:updateHistoryGainRsp(event)
	dump(event, "updateHistoryGainRsp", 5)
	local notifyData = event.data
	for k, v in ipairs(notifyData) do
		if v.historyGainData and v.historyGainData.gainRecord then
			self.gainRecord = v.historyGainData.gainRecord
		end
	end
	_ENV = ipairs(notifyData)
	ipairs(notifyData).msg = "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK"
	SoraDSendMessage(ipairs(notifyData))
end
function RSP:updateDataRsp(event)
	local notifylist = event.data
	dump(notifylist, "updateDataRsp", 5)
	local add = false
	local addItemID
	local addNum = 0
	local use = false
	local _ENV, itemChangeList
	for syncType, list in pairs(notifylist) do
		if syncType == "err" then
			for i, v in ipairs(list) do
				local itemID = v.itemID
				local err = v.err
				if gErrDef.Err_ITEM_COUNT_IS_LIMIT == err then
					do
						local iconType = gNoticeIconTypeDef.ICON_ITEM
						local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
						scheduler.performWithDelayGlobal(function()
							local publicRead = include("publicRead")
							print("weoiurwioeruwioeuriwoer", itemID)
							if IsArClient then
								_ENV = "common_text_676"
								_ENV = nil
								;(nil).item = publicRead.getName(itemID)
								;("common_text_676")[1] = i18n("common_text_2095", nil)
								;("common_text_676")[2] = i18n("common_text_2095", nil)
								;("common_text_676")[3] = i18n("common_text_2095", nil)
								;("common_text_676")[4] = i18n("common_text_2095", nil)
								;("common_text_676")[5] = i18n("common_text_2095", nil)
								SoraDShowFixWindow(i18n("common_text_676"), "common_text_676")
							else
								_ENV = "common_text_676"
								_ENV = i18n("common_text_2095", nil)
								i18n("common_text_2095", nil).itemID = publicRead.getName(itemID)
								;("common_text_676")[1] = i18n("common_text_2095", i18n("common_text_2095", nil))
								;("common_text_676")[2] = i18n("common_text_2095", i18n("common_text_2095", nil))
								;("common_text_676")[3] = i18n("common_text_2095", i18n("common_text_2095", nil))
								;("common_text_676")[4] = i18n("common_text_2095", i18n("common_text_2095", nil))
								;("common_text_676")[5] = i18n("common_text_2095", i18n("common_text_2095", nil))
								SoraDShowFixWindow(i18n("common_text_676"), "common_text_676")
							end
						end, 2)
					end
				end
			end
		else
			for itemID, count in pairs(list) do
				itemID = tonumber(itemID)
				if not backpackltCtrl:isItem(itemID) then
					backpackltCtrl:addUnknowItemConfig(itemID)
				end
				count = tonumber(count)
				local invalidtime
				if notifylist.invalidtimeTabale then
					invalidtime = notifylist.invalidtimeTabale[tostring(itemID)]
				end
				if syncType == "use" then
					self:useItem(itemID, count, true)
					use = true
					itemChangeList[itemID] = itemChangeList[itemID] or 0
					itemChangeList[itemID] = itemChangeList[itemID] - count
					if self:getNewItemInfo(itemID)[itemID] then
						if count >= self:getNewItemInfo(itemID)[itemID] then
							self:clickNewItem(itemID)
						else
							_ENV = itemID
							itemID.id = itemID
							itemID.count = -count
							self:addNewItemInfo(itemID)
							self.newTotal = math.max(0, self.newTotal - count)
						end
					end
				elseif syncType == "add" then
					self:addItem(itemID, count, invalidtime)
					if gBackpackDef.PROPS == backpackltCtrl:getBackpackType(itemID) then
						_ENV = backpackltCtrl
						backpackltCtrl.id = itemID
						backpackltCtrl.count = count
						self:addNewItemInfo(backpackltCtrl)
						self.newTotal = self.newTotal + count
					end
					add = true
					addItemID = itemID
					addNum = count
					itemChangeList[itemID] = itemChangeList[itemID] or 0
					itemChangeList[itemID] = itemChangeList[itemID] + count
					self:checkFullBackPack(addItemID, addNum)
				end
			end
		end
	end
	if add then
		_ENV = pairs(notifylist)
		pairs(notifylist).msg = "MESSAGE_GREEN_POINT_UPDATE"
		pairs(notifylist).type = GREEN_POINT_NOTICE_TYPE.ITEMS
		pairs(notifylist).count = self.newTotal
		SoraDSendMessage(pairs(notifylist))
		if gItemType.HERO_DRESS == backpackltCtrl:getItemType(addItemID) then
			_ENV = backpackltCtrl:getItemType(addItemID)
			backpackltCtrl:getItemType(addItemID).msg = "MESSAGE_GREEN_POINT_UPDATE"
			backpackltCtrl:getItemType(addItemID).type = GREEN_POINT_NOTICE_TYPE.HERO
			SoraDSendMessage((backpackltCtrl:getItemType(addItemID)))
		end
		_ENV = backpackltCtrl:getItemType(addItemID)
		backpackltCtrl:getItemType(addItemID).msg = "MESSAGE_MAINCITYVIEW_ADD_CASTLE_GIFT_TOP_TIP"
		SoraDSendMessage((backpackltCtrl:getItemType(addItemID)))
	end
	if use then
		_ENV = backpackltCtrl:getItemType(addItemID)
		backpackltCtrl:getItemType(addItemID).msg = "MESSAGE_ITEM_UES_FROM_BAG_BACK"
		SoraDSendMessage((backpackltCtrl:getItemType(addItemID)))
	end
	self:dispatchItemChangeEvent(itemChangeList)
end
function backpackCtrl:dispatchItemChangeEvent(itemChangeList)
	_ENV = nil
	;(nil).msg = "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK"
	;(nil).itemMap = itemChangeList
	SoraDSendMessage(nil)
	local _ENV, itemTypeChangeList = SoraDSendMessage, SoraDSendMessage
	for itemID, val in pairs(itemChangeList) do
		if val ~= 0 then
			printInfo("dispatch item(%d) change event", itemID)
			local itemType = backpackltCtrl:getItemType(itemID)
			itemTypeChangeList[itemType] = true
			_ENV = nil
			;(nil).name = "ITEM_CHANGE_" .. itemID
			self:dispatchEvent(nil)
			if 0 < val then
				printInfo("dispatch item(%d) add event", itemID)
				_ENV = itemID
				itemID.name = "ITEM_ADD_" .. itemID
				self:dispatchEvent(itemID)
			elseif val < 0 then
				printInfo("dispatch item(%d) use event", itemID)
				_ENV = itemID
				itemID.name = "ITEM_USE_" .. itemID
				self:dispatchEvent(itemID)
			end
		end
	end
	for itemType, _ in pairs(itemTypeChangeList) do
		_ENV = self.dispatchEvent
		self.dispatchEvent.msg = "MESSAGE_ITEM_CHANGE_TYPE"
		self.dispatchEvent.itemType = itemType
		SoraDSendMessage(self.dispatchEvent)
	end
end
function backpackCtrl:EnterGame()
	backpackCtrl.super.EnterGame(self)
	self:cleanBackpackData()
	msgCtrl.register(gCmd.CMD_BACKPACK_MODULE, gCmd.REQ_INIT_BACKPACKDATA, handler(self, RSP.initDataRsp))
	msgCtrl.register(gCmd.CMD_BACKPACK_MODULE, gCmd.REQ_USE_ITEM, handler(self, RSP.useItemRsp))
	msgCtrl.register(gCmd.CMD_BACKPACK_MODULE, gCmd.REQ_USE_ITEMS, handler(self, RSP.useItemListRsp))
	msgCtrl.register(gCmd.CMD_BACKPACK_MODULE, gCmd.REQ_MERGE_ITEM, handler(self, RSP.mergeItemRsp))
	msgCtrl.register(gCmd.CMD_BACKPACK_MODULE, gCmd.REQ_MERGE_ITEM_AS_POSSIBLE, handler(self, RSP.mergeItemAsPossibleRsp))
	msgCtrl.register(gCmd.CMD_BACKPACK_MODULE, gCmd.REQ_TRANSLATE_ITEM, handler(self, RSP.translateItemRsp))
	msgCtrl.register(gCmd.CMD_BACKPACK_MODULE, gCmd.REQ_RECYCLE_ITEM, handler(self, RSP.recycleItemRsp))
	msgCtrl.register(gCmd.CMD_BACKPACK_MODULE, gCmd.REQ_LOCK_ITEM, handler(self, RSP.lockItemRsp))
	msgCtrl.register(gCmd.CMD_BACKPACK_MODULE, gCmd.REQ_UNLOCK_ITEM, handler(self, RSP.unlockItemRsp))
	msgCtrl.register(gCmd.CMD_HISTORY_GAIN_MODULE, gCmd.REQ_HISTORY_GAIN_INIT, handler(self, RSP.historyGainRsp))
	self:reqHistoryGainInitData()
end
function backpackCtrl:resetData()
	self:cleanBackpackData()
	self.gainRecord, _UPVALUE0_ = self.cleanBackpackData, self.cleanBackpackData
end
function backpackCtrl:Logout()
	backpackCtrl.super.Logout(self)
	self:resetData()
end
function backpackCtrl:cleanBackpackData()
	for k, backpack in pairs(self.backpacks) do
		backpack:clean()
	end
	self:resetNewItemInfo()
end
function backpackCtrl:reqInitData(...)
	serverproxy:Request(gCmd.CMD_BACKPACK_MODULE, gCmd.REQ_INIT_BACKPACKDATA, nil, ...)
end
function backpackCtrl:reqUpdate(...)
	serverproxy = nil
	;(nil).notifyID = gNotifyID.BACKPACK
	serverproxy:Request(gCmd.CMD_NOTIFY_MODULE, gCmd.NOTIFY_BACKPACK_UPDATE, nil, ...)
end
function backpackCtrl:reqUseItem(itemID, count, extra, ...)
	if itemID == nil then
		return
	end
	local _ENV, data
	data.itemID = itemID
	data.count = count
	data.extra = extra
	dump(extra, "extraextra", 10)
	serverproxy:Request(gCmd.CMD_BACKPACK_MODULE, gCmd.REQ_USE_ITEM, data, ...)
end
function backpackCtrl:reqHistoryGainInitData(...)
	serverproxy:Request(gCmd.CMD_HISTORY_GAIN_MODULE, gCmd.REQ_HISTORY_GAIN_INIT)
end
function backpackCtrl:reqUseItemList(data, ...)
	dump(data, "==backpackCtrl:reqUseItemList==", 10)
	serverproxy:Request(gCmd.CMD_BACKPACK_MODULE, gCmd.REQ_USE_ITEMS, data, ...)
end
function RSP:useItemListRsp(content)
	dump(content, "useItemListRsp", 50)
	if content.err == gErrDef.Err_None then
		_ENV = "useItemListRsp"
		;("useItemListRsp").isArray = true
		;("useItemListRsp").title = i18n("quick_use_03")
		SoraDOpenGiftView(content.rspdata, "useItemListRsp")
	end
end
function backpackCtrl:addItemAddEvent(itemID, listener, tag)
	if backpackltCtrl:isItem(itemID) then
		local eventName = "ITEM_ADD_" .. itemID
		local handle = self:addEventListener(eventName, listener, tag)
		printInfo("backpackCtrl.addItemAddEvent success! itemID = %d", itemID)
		return handle
	else
		printError("backpackCtrl.addItemAddEvent failed! itemID(%s) is not a item.", tostring(itemID))
	end
end
function backpackCtrl:addItemUseEvent(itemID, listener, tag)
	if backpackltCtrl:isItem(itemID) then
		local eventName = "ITEM_USE_" .. itemID
		local handle = self:addEventListener(eventName, listener, tag)
		printInfo("backpackCtrl.addItemUseEvent success! itemID = %d", itemID)
		return handle
	else
		printError("backpackCtrl.addItemUseEvent failed! itemID(%s) is not a item.", tostring(itemID))
	end
end
function backpackCtrl:addItemChangeEvent(itemID, listener, tag)
	if backpackltCtrl:isItem(itemID) then
		local eventName = "ITEM_CHANGE_" .. itemID
		local handle = self:addEventListener(eventName, listener, tag)
		printInfo("backpackCtrl.addItemChangeEvent success! itemID = %d", itemID)
		return handle
	else
		print("backpackCtrl.addItemChangeEvent failed! itemID(%s) is not a item.", tostring(itemID))
	end
end
function backpackCtrl:getItemGainRecordNum(id)
	if id == 240801 or id == 240501 or id == 240601 then
		local equipDesRead = include("equipDesRead")
		local godArmsCtrl = SoraDGetCtrl("godArmsCtrl")
		local weaponID = equipDesRead.Item2UnlockEquipID(id)
		if weaponID and godArmsCtrl:isWeaponUnlock(weaponID) then
			return backpackltCtrl:getBuyMax(id)
		else
			return self:getItemCount(id)
		end
	end
	return self.gainRecord[tostring(id)]
end
function backpackCtrl:getNewItemTotal()
	return self.newTotal
end
function backpackCtrl:getNewItemInfo(itemID)
	local bagType = backpackltCtrl:getClassifyType(itemID)
	return self:getNewItemInfoByType(bagType)
end
function backpackCtrl:clickNewItem(itemID)
	local bagType = backpackltCtrl:getClassifyType(itemID)
	self:getNewItemInfoByType(bagType)[itemID] = nil
	self:resetNewItemInfo(true)
end
function backpackCtrl:addNewItemInfo(itemInfo)
	local itemID = itemInfo.id
	local count = itemInfo.count
	local bagType = backpackltCtrl:getClassifyType(itemID)
	if self.newItem[bagType] == nil then
		self.newItem[bagType], backpackltCtrl = itemID, itemID
	end
	if self.newItem[bagType][itemID] == nil then
		self.newItem[bagType][itemID] = 0
	end
	self.newItem[bagType][itemID] = self.newItem[bagType][itemID] + count
end
function backpackCtrl:getNewItemInfoByType(bagType)
	local _ENV, ret
	bagType = tonumber(bagType)
	if self.newItem[bagType] then
		ret = self.newItem[bagType]
	end
	if bagType == gItemClassifyType.ALL then
		self.newItem[bagType], _ENV = bagType, bagType
		for k, v in pairs(self.newItem) do
			if k ~= bagType and v then
				for ki, vi in pairs(v) do
					self.newItem[bagType][ki] = vi
				end
			end
		end
		ret = self.newItem[bagType]
	end
	return ret
end
function backpackCtrl:resetNewItemInfo(update)
	if update == nil then
		self.newItem, _ENV = nil, nil
		self.newTotal = 0
	else
		local newCount = 0
		for k, v in pairs(self.newItem) do
			for id, count in pairs(v) do
				newCount = newCount + count
			end
		end
		self.newTotal = newCount
	end
end
function backpackCtrl:resetNewItemInfoByType(bagType)
	local newCount = 0
	if bagType == gItemClassifyType.ALL then
		self.newItem, _ENV = gItemClassifyType.ALL, gItemClassifyType.ALL
	else
		for k, v in pairs(self.newItem) do
			if k == bagType then
				self.newItem[k], _ENV = nil, nil
			else
				for id, count in pairs(v) do
					newCount = newCount + count
				end
			end
		end
	end
	self.newTotal = newCount
end
local classifyBackpack = function(params)
	local _ENV, ret
	for _, v in pairs(params) do
		local itemID = v.id
		local bType = backpackltCtrl:getBackpackType(itemID)
		if bType then
			if not ret[bType] then
				ret[bType], _ENV = ret[bType], ret[bType]
			end
			local t = ret[bType]
			table.insert(t, v)
		end
	end
	return ret
end
function backpackCtrl:addItem(itemID, count, invalidtime)
	_UPVALUE0_, _UPVALUE1_ = nil, nil
	;(nil).id = itemID
	;(nil).count = count
	;(nil).invalidtime = invalidtime
	;(nil)[1] = nil
	return self:addItems(nil)
end
function backpackCtrl:addItems(params)
	local ret = classifyBackpack(params)
	for bType, items in pairs(ret) do
		local backpack = self:getBackpack(bType)
		local status, err = backpack:checkAddCount(items)
		if not status then
			return status, err
		end
	end
	for bType, items in pairs(ret) do
		local backpack = self:getBackpack(bType)
		local status, err = backpack:addItems(items)
		if not status then
			return status, err
		end
	end
	return true
end
function backpackCtrl:checkAddCount(itemID, count)
	local bType = backpackltCtrl:getBackpackType(itemID)
	local backpack = self:getBackpack(bType)
	if backpack ~= nil then
		backpackltCtrl, _UPVALUE1_ = nil, nil
		;(nil).id = itemID
		;(nil).count = count
		;(nil)[1] = nil
		local status, err = backpack:checkAddCount(nil)
		if not status then
			return status, err
		end
	end
	return true
end
function backpackCtrl:useItem(itemID, count, isServerSync)
	local bType = backpackltCtrl:getBackpackType(itemID)
	local backpack = self:getBackpack(bType)
	if backpack then
		return backpack:useItem(itemID, count, isServerSync)
	else
		print("not found backpack:bType=", bType, ",itemID=", itemID, ",count=", count)
	end
end
function backpackCtrl:getItemCount(itemID)
	if self:isItemLock(itemID) then
		return 0
	end
	local bType = backpackltCtrl:getBackpackType(itemID)
	if not bType then
		return 0
	end
	local backpack = self:getBackpack(bType)
	if not backpack then
		return 0
	end
	return backpack:getItemCount(itemID)
end
function backpackCtrl:getItemsByEffect(resultType)
	local ret = false
	local backpackltCtrl, array
	if not backpackltCtrl:getItemListByType(resultType) then
		local backpackltCtrl, itemCfgs = backpackltCtrl:getItemListByType(resultType), backpackltCtrl:getItemListByType(resultType)
	end
	for k, v in ipairs(itemCfgs) do
		local count = self:getItemCount(v)
		if 0 < count then
			array[tostring(v)] = count
			ret = true
		end
	end
	return ret, array
end
function backpackCtrl:getItemsByGoodType(goodType)
	local _ENV, array
	local itemList = self:getBackpack(gBackpackDef.PROPS):getItemList()
	for k, v in ipairs(itemList) do
		local count = self:getItemCount(v.id)
		if 0 < count and backpackltCtrl:getItemType(v.id) == goodType then
			table.insert(array, v)
		end
	end
	return array
end
function backpackCtrl:getItemsByResultGoodType(goodType)
	local _ENV, array
	local itemList = self:getBackpack(gBackpackDef.PROPS):getItemList()
	for k, v in ipairs(itemList) do
		local count = self:getItemCount(v.id)
		if 0 < count then
			local result = backpackltCtrl:getResult(v.id)
			if backpackltCtrl:getResultType(v.id) == gItemEffectDef.OPTIONAL_BOX then
				_UPVALUE2_ = v.id
				v.id[1] = "id"
				v.id[2] = "count"
				result = serviceFunctions.tableFormat(result, v.id)
			end
			local isRGT = false
			if result and type(result) == "table" then
				for i, m in ipairs(result) do
					if type(m) == "table" and m.id and backpackltCtrl:getItemType(m.id) == goodType then
						isRGT = true
					end
				end
			end
			if isRGT then
				table.insert(array, v)
			end
		end
	end
	return array
end
function backpackCtrl:isThereTheItem(itemID)
	local num = self:getItemCount(itemID)
	if num and 0 < num then
		return true, num
	else
		return false, 0
	end
end
function backpackCtrl:getBackpack(bType)
	if not bType then
		print("backpackCtrl:getBackpack:bType is nil")
		return
	end
	local backpack = self.backpacks[bType]
	if backpack then
		return backpack
	else
		print("not found the backpack, backpackType = ", bType, type(bType))
		local newBackpack = include("backpack").new(bType)
		self.backpacks[bType] = newBackpack
		return newBackpack
	end
end
function backpackCtrl:getMarchSpeedItemList()
	local list = backpackltCtrl:getItemListByType(gItemEffectDef.MARCH_SPEED_UP)
	local backpackltCtrl, ret = backpackltCtrl, backpackltCtrl
	if "table" == type(list) then
		for _, itemID in ipairs(list) do
			local num = self:getItemCount(itemID) or 0
			if 0 < num and itemLogic.checkUseCond(itemID) then
				backpackltCtrl = nil
				;(nil).id = itemID
				;(nil).count = num
				table.insert(ret, nil)
			end
		end
	end
	return ret
end
function backpackCtrl:getAbbrSpeedItemList(speedUpType, isNewSort)
	if not speedUpType then
		return
	end
	local typelist = backpackltCtrl:getItemListByType(gItemEffectDef.ABBR_SPEED_UP)
	local list = typelist[speedUpType]
	local backpackltCtrl, ret = gItemEffectDef.ABBR_SPEED_UP, gItemEffectDef.ABBR_SPEED_UP
	if "table" == type(list) then
		for _, itemID in ipairs(list) do
			local num = self:getItemCount(itemID) or 0
			if 0 < num and itemLogic.checkUseCond(itemID) then
				backpackltCtrl = nil
				;(nil).id = itemID
				;(nil).count = num
				table.insert(ret, nil)
			end
		end
	end
	if isNewSort then
		table.sort(ret, function(l, r)
			local lResult = backpackltCtrl:getResult(l.id)
			local rResult = backpackltCtrl:getResult(r.id)
			if lResult.key == rResult.key then
				return lResult.value > rResult.value
			else
				return lResult.key > rResult.key
			end
		end)
	else
		table.sort(ret, function(l, r)
			local lIndex = backpackltCtrl:getIndex(l.id)
			local rIndex = backpackltCtrl:getIndex(r.id)
			return lIndex < rIndex
		end)
	end
	return ret
end
function backpackCtrl:getSpeedUpTypeByQueueType(queueType)
	_ENV = nil
	;(nil)[gQueueTypeDef.free_build_queue] = gAbbrSpeedUpType.BUILD_UPGRADE
	;(nil)[gQueueTypeDef.charge_build_queue] = gAbbrSpeedUpType.BUILD_UPGRADE
	;(nil)[gQueueTypeDef.build_star_queue] = gAbbrSpeedUpType.BUILD_UPGRADE
	;(nil)[gQueueTypeDef.build_star_queue_privilege] = gAbbrSpeedUpType.BUILD_UPGRADE
	;(nil)[gQueueTypeDef.garden_build_upgrade] = gAbbrSpeedUpType.BUILD_UPGRADE
	;(nil)[gQueueTypeDef.chariot_plant_queue] = gAbbrSpeedUpType.TRAIN_TROOP
	;(nil)[gQueueTypeDef.stables_queue] = gAbbrSpeedUpType.TRAIN_TROOP
	;(nil)[gQueueTypeDef.range_queue] = gAbbrSpeedUpType.TRAIN_TROOP
	;(nil)[gQueueTypeDef.barracks_queue] = gAbbrSpeedUpType.TRAIN_TROOP
	;(nil)[gQueueTypeDef.elite_queue] = gAbbrSpeedUpType.TRAIN_TROOP
	;(nil)[gQueueTypeDef.frotress_queue] = gAbbrSpeedUpType.BUILD_TRAP
	;(nil)[gQueueTypeDef.technology_upgrade_queue] = gAbbrSpeedUpType.TECH
	;(nil)[gQueueTypeDef.war_tech_research] = gAbbrSpeedUpType.TECH
	;(nil)[gQueueTypeDef.nebula_palace_technology] = gAbbrSpeedUpType.TECH
	;(nil)[gQueueTypeDef.garden_technology] = gAbbrSpeedUpType.TECH
	;(nil)[gQueueTypeDef.armor_forging] = gAbbrSpeedUpType.WARFRAME_FORG
	;(nil)[gQueueTypeDef.craft_study] = gAbbrSpeedUpType.CRAFT_STUDY
	;(nil)[gQueueTypeDef.glorious_upgrade] = gAbbrSpeedUpType.BUILD_UPGRADE
	;(nil)[gQueueTypeDef.magic_lamp_jinn_level] = gAbbrSpeedUpType.BUILD_UPGRADE
	;(nil)[gQueueTypeDef.magic_lamp_jinn_class] = gAbbrSpeedUpType.BUILD_UPGRADE
	local (nil)[gQueueTypeDef.magic_lamp_jinn_star], queueType2ItemType = gAbbrSpeedUpType.BUILD_UPGRADE, nil
	local worldMapWarDef = include("worldMapWarDef")
	local warQueueTypeConfig = worldMapWarDef.getWarQueueTypeConfig()
	for _qtype, _itemType in pairs(warQueueTypeConfig) do
		queueType2ItemType[_qtype] = _itemType
	end
	return queueType2ItemType[tonumber(queueType)]
end
function backpackCtrl:getSpeedUpItemListByQueueType(queueType)
	local speedUpType = self:getSpeedUpTypeByQueueType(queueType)
	return self:getSpeedUpItemList(speedUpType)
end
function backpackCtrl:getSpeedUpItemList(speedUpType, isNewSort)
	local _ENV, ret
	if speedUpType == gAbbrSpeedUpType.HERO_TRAIN then
		local generallist = self:getAbbrSpeedItemList(gAbbrSpeedUpType.HERO_TRAIN, isNewSort)
		for _, itemInfo in ipairs(generallist) do
			table.insert(ret, itemInfo)
		end
		return ret
	end
	if speedUpType and gAbbrSpeedUpType.GENERAL ~= speedUpType then
		local list = self:getAbbrSpeedItemList(speedUpType, isNewSort)
		for _, itemInfo in ipairs(list) do
			table.insert(ret, itemInfo)
		end
	end
	if speedUpType == gAbbrSpeedUpType.CRAFT_STUDY then
		local generallist = self:getAbbrSpeedItemList(gAbbrSpeedUpType.TECH, isNewSort)
		for _, itemInfo in ipairs(generallist) do
			table.insert(ret, itemInfo)
		end
	end
	local worldMapWarDef = include("worldMapWarDef")
	local extraType = worldMapWarDef.getItemTypeByQueueTypeExtra(speedUpType)
	if extraType then
		local list = self:getAbbrSpeedItemList(gAbbrSpeedUpType.CURE, isNewSort)
		for _, itemInfo in ipairs(list) do
			table.insert(ret, itemInfo)
		end
	end
	if speedUpType ~= gAbbrSpeedUpType.CURE_WAR then
		local generallist = self:getAbbrSpeedItemList(gAbbrSpeedUpType.GENERAL, isNewSort)
		for _, itemInfo in ipairs(generallist) do
			table.insert(ret, itemInfo)
		end
	end
	return ret
end
function backpackCtrl:getBuffItemList(effectType)
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	local buffArray = buffltCtrl:getCityBuffID(effectType)
	local _ENV, itemArray = buffltCtrl, buffltCtrl
	for _, buffID in ipairs(buffArray) do
		local itemID = backpackltCtrl:getItemIDByBuffID(buffID)
		local num = self:getItemCount(itemID) or 0
		if 0 < num and itemLogic.checkUseCond(itemID) then
			_ENV = nil
			;(nil).id = itemID
			;(nil).count = count
			table.insert(itemArray, nil)
		end
	end
	return itemArray
end
function backpackCtrl:getDressList()
	local list = backpackltCtrl:getItemListByType(gItemEffectDef.DRESS)
	local backpackltCtrl, ret = backpackltCtrl, backpackltCtrl
	if "table" == type(list) then
		for _, itemID in ipairs(list) do
			local num = self:getItemCount(itemID) or 0
			if 0 < num and itemLogic.checkUseCond(itemID) then
				backpackltCtrl = nil
				;(nil).id = itemID
				;(nil).count = num
				table.insert(ret, nil)
			end
		end
	end
	table.sort(ret, function(l, r)
		local lIndex = backpackltCtrl:getIndex(l.id)
		local rIndex = backpackltCtrl:getIndex(r.id)
		return lIndex < rIndex
	end)
	return ret
end
function backpackCtrl:getDJGiftList()
	local shopCtrl = gametop.playertop_:getModule("shopCtrl")
	local list = backpackltCtrl:getItemListByType(gItemEffectDef.DJ_GIFT)
	local gametop, ret = backpackltCtrl, backpackltCtrl
	dump(list, "backpackCtrl:getDJGiftList", 10)
	if "table" == type(list) then
		for _, itemID in ipairs(list) do
			local num = self:getItemCount(itemID) or 0
			local point = backpackltCtrl:getResult(itemID) or 0
			if itemLogic.checkUseCond(itemID) then
				if num <= 0 then
					local shopData = shopCtrl:getShopItemByItemID(itemID)
					if shopData then
						dump(shopData, "shopData", 10)
					end
				end
				gametop = shopData
				shopData.id = itemID
				shopData.count = num
				shopData.point = point
				table.insert(ret, shopData)
			end
		end
	end
	table.sort(ret, function(l, r)
		local lIndex = backpackltCtrl:getIndex(l.id)
		local rIndex = backpackltCtrl:getIndex(r.id)
		return lIndex < rIndex
	end)
	return ret
end
function backpackCtrl:mergeItem(mergeID, count)
	local serverproxy, data
	data.mergeID = mergeID
	data.count = count
	serverproxy:Request(gCmd.CMD_BACKPACK_MODULE, gCmd.REQ_MERGE_ITEM, data)
end
function backpackCtrl:mergeItemAsPossible(mergeID)
	local serverproxy, data
	data.mergeID = mergeID
	serverproxy:Request(gCmd.CMD_BACKPACK_MODULE, gCmd.REQ_MERGE_ITEM_AS_POSSIBLE, data)
end
function backpackCtrl:translateItem(itemId, count)
	local serverproxy, data
	data.itemId = itemId
	data.count = count
	serverproxy:Request(gCmd.CMD_BACKPACK_MODULE, gCmd.REQ_TRANSLATE_ITEM, data)
end
function backpackCtrl:recycleItem(itemId, count)
	local serverproxy, data
	data.itemId = itemId
	data.count = count
	serverproxy:Request(gCmd.CMD_BACKPACK_MODULE, gCmd.REQ_RECYCLE_ITEM, data)
end
function backpackCtrl:lockItem(itemIdList)
	local serverproxy, data
	data.itemIdList = itemIdList
	serverproxy:Request(gCmd.CMD_BACKPACK_MODULE, gCmd.REQ_LOCK_ITEM, data)
end
function backpackCtrl:unlockItem(itemIdList)
	local serverproxy, data
	data.itemIdList = itemIdList
	serverproxy:Request(gCmd.CMD_BACKPACK_MODULE, gCmd.REQ_UNLOCK_ITEM, data)
end
function backpackCtrl:initItems(data)
