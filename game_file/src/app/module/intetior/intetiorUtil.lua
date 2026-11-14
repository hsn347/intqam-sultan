local gametop = gModuleMgr.getObject("gametop")
local intetiorCtrl = gametop.playertop_:getModule("intetiorCtrl")
local mailFunctions = include("mailFunctions")
local officialInfoRead = include("officialInfoRead")
local intetiorRead = include("intetiorRead")
local _ENV, intetiorUtil = "intetiorRead", "intetiorRead"
local intetiorDef = include("intetiorDef")
local gParliamentDecree = intetiorDef.gParliamentDecree
function intetiorUtil:checkEnoughKingdomGold(needGold)
	local gold = intetiorCtrl:getKingdomGold()
	return needGold <= gold
end
function intetiorUtil:checkKingdomGoldFull()
	local gold = intetiorCtrl:getKingdomGold()
	return gold >= intetiorDef.MAX_KINGDOM_GOLD
end
function intetiorUtil:checkEnoughGold(needGold)
	local gold = intetiorCtrl:getMyGold()
	return needGold <= gold
end
function intetiorUtil:showGoldTips(needGold)
	local itemId = 102401
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local itemCount = backpackCtrl:getItemCount(itemId)
	if 0 < itemCount then
		local gold = intetiorCtrl:getMyGold()
		needGold = needGold - gold
		if needGold < 0 then
			needGold = 0
		end
		gametop, gametop = nil, nil
		;(nil).id = itemId
		;(nil).count = itemCount
		;(nil).itemData, (nil).bestNum = nil, math.min(math.ceil(needGold / 10), itemCount)
		uiManager:show("newItemSingleUse", nil)
	else
		SoraDShowMsgTip(i18n("parliament_text_24"))
	end
end
function intetiorUtil:checkResAllocation(resDataAllocation)
	local allocalMax = intetiorRead:getAllocationMax()
	local tableResType = intetiorDef.RES_KEY
	for _, v in ipairs(tableResType) do
		local resAllocation = resDataAllocation[v] or 0
		local resMax = allocalMax[v]
		local max = math.max(0, resMax - resAllocation)
		if 0 < max then
			return true
		end
	end
	return false
end
function intetiorUtil:isCanOpPromise_official(position)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local official = lordInfoCtrl:getSelfOfficial()
	if official then
		official = tonumber(official)
		if position then
			for _, v in ipairs(position) do
				if v == official then
					return true
				end
			end
		else
			return official ~= nil
		end
	end
	return false
end
function intetiorUtil:checkCanOpenView(kid)
	local kingdomId = gametop.playertop_:getKingdomID()
	if kid and kid == kingdomId then
		return true
	end
	return false
end
_ENV, intetiorUtil.openView = function(self, kid)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) < CASTLE_LV6_LIMITED then
		gametop = nil
		;(nil).num = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", nil))
		return
	end
	if kid and not self:checkCanOpenView(kid) then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.kingWarStatus == gKingdomWarStatusType.close then
		SoraDShowMsgTip(i18n("parliament_text_01"))
		return
	end
	uiManager:show("intetiorMain")
end, function(self, kid)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) < CASTLE_LV6_LIMITED then
		gametop = nil
		;(nil).num = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", nil))
		return
	end
	if kid and not self:checkCanOpenView(kid) then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.kingWarStatus == gKingdomWarStatusType.close then
		SoraDShowMsgTip(i18n("parliament_text_01"))
		return
	end
	uiManager:show("intetiorMain")
end
;(function(self, kid)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) < CASTLE_LV6_LIMITED then
		gametop = nil
		;(nil).num = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", nil))
		return
	end
	if kid and not self:checkCanOpenView(kid) then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.kingWarStatus == gKingdomWarStatusType.close then
		SoraDShowMsgTip(i18n("parliament_text_01"))
		return
	end
	uiManager:show("intetiorMain")
end)[gParliamentDecree.EMBEZZLE] = "parliament_text_114"
;(function(self, kid)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) < CASTLE_LV6_LIMITED then
		gametop = nil
		;(nil).num = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", nil))
		return
	end
	if kid and not self:checkCanOpenView(kid) then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.kingWarStatus == gKingdomWarStatusType.close then
		SoraDShowMsgTip(i18n("parliament_text_01"))
		return
	end
	uiManager:show("intetiorMain")
end)[gParliamentDecree.CURE_SOLDIER_SPEED_BOOST] = "parliament_text_115"
;(function(self, kid)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) < CASTLE_LV6_LIMITED then
		gametop = nil
		;(nil).num = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", nil))
		return
	end
	if kid and not self:checkCanOpenView(kid) then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.kingWarStatus == gKingdomWarStatusType.close then
		SoraDShowMsgTip(i18n("parliament_text_01"))
		return
	end
	uiManager:show("intetiorMain")
end)[gParliamentDecree.HOSPITAL_CAPACITY_INCREASE] = "parliament_text_116"
;(function(self, kid)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) < CASTLE_LV6_LIMITED then
		gametop = nil
		;(nil).num = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", nil))
		return
	end
	if kid and not self:checkCanOpenView(kid) then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.kingWarStatus == gKingdomWarStatusType.close then
		SoraDShowMsgTip(i18n("parliament_text_01"))
		return
	end
	uiManager:show("intetiorMain")
end)[gParliamentDecree.CLOSE_ALL_CITY_BURN] = "parliament_text_125"
;(function(self, kid)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) < CASTLE_LV6_LIMITED then
		gametop = nil
		;(nil).num = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", nil))
		return
	end
	if kid and not self:checkCanOpenView(kid) then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.kingWarStatus == gKingdomWarStatusType.close then
		SoraDShowMsgTip(i18n("parliament_text_01"))
		return
	end
	uiManager:show("intetiorMain")
end)[gParliamentDecree.OPEN_PROTECT_LORD] = "parliament_text_117"
;(function(self, kid)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) < CASTLE_LV6_LIMITED then
		gametop = nil
		;(nil).num = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", nil))
		return
	end
	if kid and not self:checkCanOpenView(kid) then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.kingWarStatus == gKingdomWarStatusType.close then
		SoraDShowMsgTip(i18n("parliament_text_01"))
		return
	end
	uiManager:show("intetiorMain")
end)[gParliamentDecree.MOVE_CITY_LORD] = "parliament_text_118"
;(function(self, kid)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) < CASTLE_LV6_LIMITED then
		gametop = nil
		;(nil).num = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", nil))
		return
	end
	if kid and not self:checkCanOpenView(kid) then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.kingWarStatus == gKingdomWarStatusType.close then
		SoraDShowMsgTip(i18n("parliament_text_01"))
		return
	end
	uiManager:show("intetiorMain")
end)[gParliamentDecree.FIND_CITY_LORD] = "parliament_text_119"
;(function(self, kid)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) < CASTLE_LV6_LIMITED then
		gametop = nil
		;(nil).num = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", nil))
		return
	end
	if kid and not self:checkCanOpenView(kid) then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.kingWarStatus == gKingdomWarStatusType.close then
		SoraDShowMsgTip(i18n("parliament_text_01"))
		return
	end
	uiManager:show("intetiorMain")
end)[gParliamentDecree.FORBID_WAR_LORD] = "parliament_text_120"
;(function(self, kid)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) < CASTLE_LV6_LIMITED then
		gametop = nil
		;(nil).num = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", nil))
		return
	end
	if kid and not self:checkCanOpenView(kid) then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.kingWarStatus == gKingdomWarStatusType.close then
		SoraDShowMsgTip(i18n("parliament_text_01"))
		return
	end
	uiManager:show("intetiorMain")
end)[gParliamentDecree.OTHER_KINGDOM_ATTACK_REDUCE] = "parliament_text_121"
;(function(self, kid)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) < CASTLE_LV6_LIMITED then
		gametop = nil
		;(nil).num = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", nil))
		return
	end
	if kid and not self:checkCanOpenView(kid) then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.kingWarStatus == gKingdomWarStatusType.close then
		SoraDShowMsgTip(i18n("parliament_text_01"))
		return
	end
	uiManager:show("intetiorMain")
end)[gParliamentDecree.OTHER_KINGDOM_DEFENSE_REDUCE] = "parliament_text_122"
local (function(self, kid)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) < CASTLE_LV6_LIMITED then
		gametop = nil
		;(nil).num = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", nil))
		return
	end
	if kid and not self:checkCanOpenView(kid) then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.kingWarStatus == gKingdomWarStatusType.close then
		SoraDShowMsgTip(i18n("parliament_text_01"))
		return
	end
	uiManager:show("intetiorMain")
end)[gParliamentDecree.OTHER_KINGDOM_MARCH_BLACKLAND_SPEED_REDUCE], policyDes = "parliament_text_123", function(self, kid)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) < CASTLE_LV6_LIMITED then
		gametop = nil
		;(nil).num = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", nil))
		return
	end
	if kid and not self:checkCanOpenView(kid) then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("parliament_text_02"))
		return
	end
	if worldMapDefine.kingWarStatus == gKingdomWarStatusType.close then
		SoraDShowMsgTip(i18n("parliament_text_01"))
		return
	end
	uiManager:show("intetiorMain")
end
function intetiorUtil:getOrderDes(info)
	local mailFunctions, config
	local name = mailFunctions:getWrappedName(_q(info.allianceAbb), info.name)
	if info.official then
		local officialName = officialInfoRead.getInfoByName(tonumber(info.official))
		if officialName then
			name = officialName .. name
		end
	end
	config.lord = name
	local policyName = intetiorRead:getPolicyOrderName(info.decreeId)
	config.policyName = policyName
	if info.targetName then
		local targetName = mailFunctions:getWrappedName(_q(info.targetAllianceAbb), info.targetName)
		config.targetname = targetName
	end
	local desid = policyDes[info.decreeId]
	config.des = desid and i18n(desid, config) or ""
	local strKey = "parliament_text_62"
	return (i18n(strKey, config))
end
return intetiorUtil
