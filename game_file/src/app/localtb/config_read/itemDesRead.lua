local itemDesRead = include("aAReadClass").new()
local isInited = false
function itemDesRead.init()
	if isInited then
		return
	end
	itemDesRead = nil
	;(nil)[1] = "hallowmas_joke"
	itemDesRead:defineValue("joke", nil)
	itemDesRead = nil
	;(nil)[1] = "item_output_view"
	itemDesRead:defineValue("outputCfg", nil)
	isInited = itemDesRead.defineValue
	itemDesRead.defineValue[0] = cc.c3b(230, 230, 230)
	itemDesRead.defineValue[1] = cc.c3b(0, 255, 0)
	itemDesRead.defineValue[2] = cc.c3b(0, 185, 255)
	itemDesRead.defineValue[3] = cc.c3b(255, 0, 255)
	itemDesRead.defineValue[4] = cc.c3b(255, 190, 60)
	local itemDesRead.defineValue[5], tableColor = cc.c3b(255, 190, 60), itemDesRead.defineValue
	itemDesRead:defineValue("config", function()
		itemDesRead.config = require("app." .. LocalTblPath .. ".config_client.itemdescribe")
		local tableItemData = require_once("app." .. LocalTblPath .. ".config_server.item")
		for i, v in pairs(tableItemData) do
			if itemDesRead.config[v.itemID] then
				itemDesRead.config[v.itemID].bg = "frame_item_base_0" .. v.itemQuality + 1 .. ".png"
				itemDesRead.config[v.itemID].color = tableColor[v.itemQuality]
				itemDesRead.config[v.itemID].itemQuality = v.itemQuality
			elseif next(v) then
				print("道具表数据不一致！！！！ID = " .. v.itemID)
			end
		end
		return itemDesRead.config
	end)
	itemDesRead:defineValue("item_donation", function()
		local itemDonationCfg = require("app." .. LocalTblPath .. ".config_server.item_donation")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.item_donation", "app." .. LocalTblPath .. ".config_server.item_donation"
		for _, v in ipairs(itemDonationCfg) do
			ret[v.itemID] = v
		end
		return ret
	end)
end
function itemDesRead.getOutput(iid)
	iid = tonumber(iid)
	if itemDesRead.outputCfg[iid] then
		return itemDesRead.outputCfg[iid].type
	end
	_ENV = itemDesRead.outputCfg[iid].type
	return itemDesRead.outputCfg[iid].type
end
function itemDesRead.getItemListOutput(itemList)
	local _ENV, ret
	for __, itemID in ipairs(itemList) do
		local sources = itemDesRead.getOutput(itemID)
		for __, source in ipairs(sources) do
			if not table.keyof(ret, source) then
				table.insert(ret, source)
			end
		end
	end
	return ret
end
function itemDesRead.getTypeName(iid)
	iid = tonumber(iid)
	iid = math.floor(iid / 100)
	return i18n("item_type_" .. tostring(iid))
end
function itemDesRead.getColor(iid)
	iid = tonumber(iid)
	local color = cc.c3b(230, 230, 230)
	if itemDesRead.config[iid] then
		return itemDesRead.config[iid].color
	else
		return color
	end
end
function itemDesRead.getName(iid)
	iid = tonumber(iid)
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	local itemType = backpackltCtrl:getItemType(iid)
	if itemDesRead.config[iid] == nil or itemDesRead.config[iid].name == nil or i18n(itemDesRead.config[iid].name) == nil then
		return "???"
	else
		return i18n(itemDesRead.config[iid].name)
	end
end
function itemDesRead.getDes(iid)
	iid = tonumber(iid)
	if itemDesRead.config[iid] == nil or itemDesRead.config[iid].describe == nil or i18n(itemDesRead.config[iid].describe) == nil then
		_ENV = nil
		;(nil).des = "??????"
		return i18n("common_text_1437", nil)
	elseif itemDesRead.config[iid].richDes and next(itemDesRead.config[iid].richDes) then
		return i18n(itemDesRead.config[iid].richDes)
	else
		return i18n(itemDesRead.config[iid].describe)
	end
end
function itemDesRead.isRichDes(iid)
	local ret = false
	if itemDesRead.config[iid] and itemDesRead.config[iid].richDes and next(itemDesRead.config[iid].richDes) then
		ret = true
	end
	return ret
end
function itemDesRead.getIcon(iid, fromMemory)
	iid = tonumber(iid)
	local fileName = "icon_item_common.png"
	if itemDesRead.config[iid] then
		fileName = itemDesRead.config[iid].icon
		if not SoraDFIsRA() and itemDesRead.config[iid].icon_flip ~= "" then
			fileName = itemDesRead.config[iid].icon_flip
		end
	end
	if cc.SpriteFrameCache:getInstance():getSpriteFrame(fileName) == nil then
		fileName = "icon_item_common.png"
	end
	if fromMemory then
		return "#" .. fileName
	end
	return fileName
end
function itemDesRead.getBIcon(iid, fromMemory)
	iid = tonumber(iid)
	local fileName = "icon_item_common.png"
	if itemDesRead.config[iid] then
		fileName = itemDesRead.config[iid].icon
	end
	if fromMemory then
		fileName = "#" .. fileName
	end
	return fileName
end
function itemDesRead.getBg(iid, fromMemory)
	local resultBg = "frame_item_base_01.png"
	if iid == nil then
		if fromMemory then
			resultBg = "#" .. resultBg
		end
		return resultBg
	end
	iid = tonumber(iid)
	if itemDesRead.config[iid] and itemDesRead.config[iid].bg then
		resultBg = itemDesRead.config[iid].bg
	end
	if fromMemory then
		resultBg = "#" .. resultBg
	end
	return resultBg
end
function itemDesRead.getBgByLv(lv)
	lv = tonumber(lv) + 1
	if lv >= BG_MIN_QUALITY and lv <= BG_MAX_QUALITY then
		return "frame_item_base_0" .. lv .. ".png"
	else
		return "frame_item_base_01.png"
	end
end
function itemDesRead.getQuality(iid)
	local defaultQuality = 1
	if itemDesRead.config[iid] and itemDesRead.config[iid].itemQuality then
		defaultQuality = itemDesRead.config[iid].itemQuality
	end
	return defaultQuality
end
function itemDesRead.getJokeDes(jid)
	jid = tonumber(jid)
	if itemDesRead.joke[jid] then
		return i18n(itemDesRead.joke[jid].Content)
	else
		math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
		return i18n(itemDesRead.joke[math.random(1, #itemDesRead.joke)].Content)
	end
end
function itemDesRead.getNumByID(id)
	local num
	id = tonumber(id)
	if itemDesRead.config[id] and itemDesRead.config[id].num and itemDesRead.config[id].num ~= "" then
		num = itemDesRead.config[id].num
	end
	return num
end
function itemDesRead.getGetWayLanKeyByID(id)
	id = tonumber(id)
	if itemDesRead.config[id] and itemDesRead.config[id].tipsText and itemDesRead.config[id].tipsText ~= "" then
		return itemDesRead.config[id].tipsText
	end
	return nil
end
function itemDesRead.getItemConfig()
	return itemDesRead.config
end
function itemDesRead.getItemDonation(itemID)
	return itemDesRead.item_donation[itemID]
end
itemDesRead.init()
return itemDesRead
