local rechargeRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	rechargeRead = nil
	;(nil)[1] = "recharge_promo_icon"
	rechargeRead:defineValue("promoIcon", nil)
	rechargeRead = nil
	;(nil)[1] = "monthlerecommend"
	rechargeRead:defineValue("monthlerecommend", nil)
	rechargeRead = nil
	;(nil)[1] = "moonth_card_view"
	rechargeRead:defineValue("buffMonthConfig", nil)
	rechargeRead = nil
	;(nil)[1] = "weekly_card_view"
	rechargeRead:defineValue("buffWeekConfig", nil)
	rechargeRead = nil
	;(nil)[1] = "recharge_label_config"
	rechargeRead:defineValue("categoryConfig", nil)
	rechargeRead = nil
	;(nil)[1] = "label_type"
	rechargeRead:defineValue("label_type", nil)
	rechargeRead = nil
	;(nil)[1] = "rechargepageview"
	rechargeRead:defineValue("pageView", nil)
	_ENV = nil
	;(nil)[1] = "recharge_activityconf"
	;(nil)[2] = true
	rechargeRead:defineValue("activityconf", nil)
	rechargeRead = nil
	;(nil)[1] = "rechargeAD"
	rechargeRead:defineValue("rechargeAD", nil)
	rechargeRead = nil
	;(nil)[1] = "alliance_recharge_name"
	rechargeRead:defineValue("rechargeGift", nil)
	rechargeRead = nil
	;(nil)[1] = "recharge_client_config"
	rechargeRead:defineValue("bullets", nil)
	_ENV = nil
	;(nil)[1] = "exchange_store_gift"
	;(nil)[2] = true
	rechargeRead:defineValue("rechargePresent", nil)
	rechargeRead = nil
	;(nil)[1] = "exchange_store_gift_view"
	rechargeRead:defineValue("rechargePresentPageView", nil)
	_ENV = nil
	;(nil)[1] = "exchange_store_gift_newyear"
	;(nil)[2] = true
	rechargeRead:defineValue("newyearPresent", nil)
	rechargeRead = nil
	;(nil)[1] = "exchange_store_view_newyear"
	rechargeRead:defineValue("newyearPresentPageView", nil)
	_ENV = nil
	;(nil)[1] = "inherit_gift"
	;(nil)[2] = true
	rechargeRead:defineValue("inheritGift", nil)
	rechargeRead = nil
	;(nil)[1] = "inherit_giftview"
	rechargeRead:defineValue("inheritGiftView", nil)
	rechargeRead:defineValue("rankHideList", function()
		_UPVALUE3_, _UPVALUE0_ = nil, nil
		_UPVALUE3_, (nil)["0.99"], (nil)[1] = nil, nil, 1
		_UPVALUE3_, (nil)["0.99"], (nil)[2] = nil, nil, 2
		_UPVALUE3_, (nil)["0.99"], (nil)[3] = nil, nil, 6
		_UPVALUE3_, (nil)["1.99"], (nil)[1] = nil, nil, 2
		_UPVALUE3_, (nil)["1.99"], (nil)[2] = nil, nil, 3
		_UPVALUE3_, (nil)["1.99"], (nil)[3] = nil, nil, 6
		_UPVALUE3_, (nil)["2.99"], (nil)[1] = nil, nil, 2
		_UPVALUE3_, (nil)["2.99"], (nil)[2] = nil, nil, 3
		_UPVALUE3_, (nil)["2.99"], (nil)[3] = nil, nil, 6
		_UPVALUE3_, (nil)["3.99"], (nil)[1] = nil, nil, 2
		_UPVALUE3_, (nil)["3.99"], (nil)[2] = nil, nil, 3
		_UPVALUE3_, (nil)["3.99"], (nil)[3] = nil, nil, 6
		_UPVALUE3_, (nil)["4.99"], (nil)[1] = nil, nil, 2
		_UPVALUE3_, (nil)["4.99"], (nil)[2] = nil, nil, 3
		_UPVALUE3_, (nil)["4.99"], (nil)[3] = nil, nil, 6
		_UPVALUE3_, (nil)["9.99"], (nil)[1] = nil, nil, 3
		_UPVALUE3_, (nil)["9.99"], (nil)[2] = nil, nil, 4
		_UPVALUE3_, (nil)["9.99"], (nil)[3] = nil, nil, 6
		_UPVALUE3_, (nil)["19.99"], (nil)[1] = nil, nil, 4
		_UPVALUE3_, (nil)["19.99"], (nil)[2] = nil, nil, 5
		_UPVALUE3_, (nil)["19.99"], (nil)[3] = nil, nil, 6
		_UPVALUE3_, (nil)["24.99"], (nil)[1] = nil, nil, 4
		_UPVALUE3_, (nil)["24.99"], (nil)[2] = nil, nil, 5
		_UPVALUE3_, (nil)["24.99"], (nil)[3] = nil, nil, 6
		_UPVALUE3_, (nil)["49.99"], (nil)[1] = nil, nil, 4
		_UPVALUE3_, (nil)["49.99"], (nil)[2] = nil, nil, 5
		_UPVALUE3_, (nil)["49.99"], (nil)[3] = nil, nil, 6
		;(nil)["99.99"], (nil)[1] = nil, 4
		;(nil)["99.99"], (nil)[2] = nil, 5
		;(nil)["99.99"], (nil)[3] = nil, 6
		return nil
	end)
	rechargeRead:defineValue("classEffect", function()
		_ENV = nil
		_UPVALUE2_ = nil
		;(nil)[gRechargeClassEffect.GREEN], (nil)[1] = nil, "et_ziyuanpz_01.plist"
		;(nil)[gRechargeClassEffect.GREEN], (nil)[2] = nil, "et_ziyuanpz_02.plist"
		_UPVALUE2_ = nil
		;(nil)[gRechargeClassEffect.BLUE], (nil)[1] = nil, "et_ziyuanpz_03.plist"
		;(nil)[gRechargeClassEffect.BLUE], (nil)[2] = nil, "et_ziyuanpz_04.plist"
		_UPVALUE2_ = nil
		;(nil)[gRechargeClassEffect.PURPLES], (nil)[1] = nil, "et_ziyuanpz_05.plist"
		;(nil)[gRechargeClassEffect.PURPLES], (nil)[2] = nil, "et_ziyuanpz_06.plist"
		_UPVALUE2_ = nil
		;(nil)[gRechargeClassEffect.ORANGE], (nil)[1] = nil, "et_ziyuanpz_07.plist"
		;(nil)[gRechargeClassEffect.ORANGE], (nil)[2] = nil, "et_ziyuanpz_08.plist"
		return nil
	end)
	rechargeRead:defineValue("buff_config", function()
		rechargeRead.buff_config, rechargeRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.recharge_buff_config")
		for k, v in ipairs(cfg) do
			rechargeRead.buff_config[v.buffID] = v
		end
		return rechargeRead.buff_config
	end)
	rechargeRead:defineValue("buff_view", function()
		rechargeRead.buff_view, rechargeRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.recharge_buff_view")
		for k, v in ipairs(cfg) do
			rechargeRead.buff_view[v.rechargeID] = v
		end
		return rechargeRead.buff_view
	end)
	rechargeRead:defineValue("recharge_special", function()
		rechargeRead.recharge_special, rechargeRead = nil, nil
		local cfg = require_data("recharge_special", false, true).data
		for k, v in ipairs(cfg) do
			rechargeRead.recharge_special[v.rechargeID] = v
		end
		return rechargeRead.recharge_special
	end)
end
init()
function rechargeRead.initAndRepalceBaseData()
	if userSDKManager.isAR() then
		local info = rechargeRead.pageView[13515]
		if info then
			if GameLanguageCopy == "en" then
				info.popBanner = string.gsub(info.popBanner, "_ar.png", "_en.png")
				info.activeBg = string.gsub(info.activeBg, "_ar.png", "_en.png")
				info.tinyBg = string.gsub(info.tinyBg, "_ar.png", "_en.png")
			else
				info.popBanner = string.gsub(info.popBanner, "_en.png", "_ar.png")
				info.activeBg = string.gsub(info.activeBg, "_en.png", "_ar.png")
				info.tinyBg = string.gsub(info.tinyBg, "_en.png", "_ar.png")
			end
		end
	end
end
function rechargeRead.getPageViewData(eid)
	eid = tonumber(eid)
	local info = rechargeRead.pageView[eid]
	info = info or rechargeRead.rechargePresentPageView[eid]
	info = info or gModuleMgr.sharedMgr("rechargeExtraltCtrl"):getGiftPageViewDataByID(eid)
	return info
end
function rechargeRead.getInheritPageViewData(rid)
	rid = tonumber(rid)
	for i, v in pairs(rechargeRead.inheritGiftView) do
		if v.rechargeID == rid then
			print("fskfjdkfjkdfr   " .. rid)
			dump(v, "rechargeRead.getInheritPageViewData")
			return v
		end
	end
end
function rechargeRead.returnAllEid()
	local _ENV, eidList
	for k, _ in pairs(rechargeRead.pageView) do
		table.insert(eidList, k)
	end
	return eidList
end
function rechargeRead.hasRechargeItem(eid)
	eid = tonumber(eid)
	if eid and rechargeRead.pageView[eid] then
		return true
	elseif eid and gModuleMgr.sharedMgr("rechargeExtraltCtrl"):getGiftPageViewDataByID(eid) then
		return true
	else
		return false
	end
end
function rechargeRead.isADOpen(ccsFile)
	local ret = false
	for i, v in ipairs(rechargeRead.rechargeAD) do
		if getCCSPath(v.className) == ccsFile then
			ret = true
			break
		end
	end
	return ret
end
function rechargeRead.getPromoIcon(id)
	local ret = rechargeRead.promoIcon[id]
	return ret or rechargeRead.promoIcon[1]
end
function rechargeRead.getRecargeGiftName(gid)
	for i, v in ipairs(rechargeRead.rechargeGift) do
		if v.ID == gid then
			return v.name
		end
	end
end
function rechargeRead.getBuffMonthInfoByID(id)
	id = tonumber(id)
	local _ENV, info = tonumber(id), tonumber(id)
	for _, v in ipairs(rechargeRead.buffMonthConfig) do
		if v.rewardID == id then
			info = v
			break
		end
	end
	return info
end
function rechargeRead.getBuffWeekInfoByID(id)
	id = tonumber(id)
	local _ENV, info = tonumber(id), tonumber(id)
	for _, v in ipairs(rechargeRead.buffWeekConfig) do
		if v.rewardID == id then
			info = i18n(v.rewardName)
			break
		end
	end
	return info
end
function rechargeRead.getMonthlyRecommend(gid)
	return rechargeRead.monthlerecommend[gid]
end
function rechargeRead.getRechargePopBg(eid)
	eid = tonumber(eid)
	if rechargeRead.pageView[eid] then
		return SoraDCheckPNG(rechargeRead.pageView[eid].popBanner, gDefaultPNG.RECHARGE_POPBG)
	elseif gModuleMgr.sharedMgr("rechargeExtraltCtrl"):getGiftPageViewDataByID(eid) then
		return SoraDCheckPNG(gModuleMgr.sharedMgr("rechargeExtraltCtrl"):getGiftPageViewDataByID(eid).popBanner, gDefaultPNG.RECHARGE_POPBG)
	else
		return gDefaultPNG.RECHARGE_POPBG
	end
end
function rechargeRead.getCategoryConfig(cid)
	local ret
	for k, v in pairs(rechargeRead.categoryConfig) do
		if cid == v.category then
			ret = v
			break
		end
	end
	return ret or rechargeRead.categoryConfig[1]
end
function rechargeRead.getCategoryList(labelType)
	local _ENV, ret
	for k, v in pairs(rechargeRead.categoryConfig) do
		if labelType == v.labelType then
			table.insert(ret, v)
		end
	end
	table.sort(ret, function(a, b)
		return a.category < b.category
	end)
	return ret
end
function rechargeRead.isCanHideCategory(categoryMap)
	local ret = true
	for k, v in pairs(rechargeRead.categoryConfig) do
		if categoryMap[v.category] and v.labelType == 0 then
			ret = false
			break
		end
	end
	return ret
end
function rechargeRead.getLabelTypeCfg()
	return rechargeRead.label_type
end
function rechargeRead.getRankHideListByID(label)
	local gametop = gModuleMgr.getObject("gametop")
	local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
	local rank = rechargeActivityCtrl:getRechargeAbility()
	rank = tostring(rank)
	local rankList = rechargeRead.rankHideList[rank]
	local ret = false
	if rankList then
		for _, v in pairs(rankList) do
			if label and v == label then
				ret = true
				break
			end
		end
	end
	return ret
end
function rechargeRead.getRechargeClassEffectNode(classType)
	local config = rechargeRead.classEffect[classType]
	if config then
		rechargeRead, rechargeRead = nil, nil
		;(nil).plist = config[1]
		rechargeRead, (nil)[1], (nil).scale = nil, nil, 1.8
		;(nil).plist = config[2]
		;(nil)[2], (nil).scale = nil, 1.5
		local param
		local effectNode = SoraDCreateEffectNode(param)
		effectNode:setName("class_effect")
		return effectNode
	end
end
function rechargeRead.getGiftConfig(id)
	local rs
	for k, v in ipairs(rechargeRead.activityconf) do
		if v.ID == id then
			rs = v
			break
		end
	end
	return rs
end
function rechargeRead.getGiftBuyType(id)
	return rechargeRead.bullets[id] and rechargeRead.bullets[id].isActive
end
function rechargeRead.getRechargePresentCfgByID(id)
	local rs
	for _, v in ipairs(rechargeRead.rechargePresent) do
		if v.rechargeID == id then
			rs = v
			break
		end
	end
	return rs
end
function rechargeRead.getRechargePresentCfgByGroup(group)
	local _ENV, rs
	for _, v in ipairs(rechargeRead.rechargePresent) do
		if v.group == group then
			table.insert(rs, v)
		end
	end
	return rs
end
function rechargeRead.getSultanPresentCfgByGroup(group)
	local _ENV, rs
	for _, v in ipairs(rechargeRead.inheritGift) do
		if v.group == group then
			table.insert(rs, v)
		end
	end
	return rs
end
function rechargeRead.getRechargePresentPageViewData(eid)
