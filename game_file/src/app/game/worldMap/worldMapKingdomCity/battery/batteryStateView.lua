local kingdomMapUtil = include("kingdomMapUtil")
local gametop = gModuleMgr.getObject("gametop")
local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local palaceInfoRead = include("palaceInfoRead")
local gKWBattery = _G.gKWBattery
local batteryStateView = class("batteryStateView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("batteryStateView")
	end
	return target
end)
function batteryStateView:ctor()
	self:_initData()
	self:_initUI()
end
function batteryStateView:_initData()
	self.myKingInfo, _UPVALUE0_, self.myPlaceInfo, _UPVALUE0_ = nil, nil, nil, nil
end
function batteryStateView:_initUI()
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeStatusCommon = SoraDGetChildByName(self, "Node_status_common")
	self.nodeStatusInfo = SoraDGetChildByName(self, "Node_status_info")
	self.nodeStatusTime = SoraDGetChildByName(self, "Node_status_time")
	self.nodeStatusTips = SoraDGetChildByName(self, "Node_occupyTip")
	self.nodeInfoRule = SoraDGetChildByName(self, "Node_info_rule")
	self.nodeInfoWar = SoraDGetChildByName(self, "Node_info_inwar")
	self.nodeBuild = SoraDGetChildByName(self, "Node_build")
	self.txtInfoTips = SoraDGetChildByName(self, "Text_info_tips")
	self.txtInfoTips:setVisible(false)
	self.spInBattle = SoraDGetChildByName(self, "Sprite_inBattle")
	self.nodelordKing = SoraDGetChildByName(self, "Node_lord_king")
	self.nodelordOccupy = SoraDGetChildByName(self, "Node_lord_occupy")
	self.Node_troop = SoraDGetChildByName(self, "Node_troop")
	self.nodeOccupyTime = SoraDGetChildByName(self, "Node_occupyTime")
	self.txtContinueOccuypTime = SoraDGetChildByName(self, "Text_continueTime")
	self.txtTotalOccuypTime = SoraDGetChildByName(self, "Text_totalOccupyTime")
	self.txtContinueOccuypTime = SoraDCreateTimerLabel(self, self.txtContinueOccuypTime)
	self.txtTotalOccuypTime = SoraDCreateTimerLabel(self, self.txtTotalOccuypTime)
	local txtOccuypTip = SoraDGetChildByName(self, "Text_occupyTip")
	if txtOccuypTip then
		txtOccuypTip:setString(i18n("common_text_4740"))
	end
	self.txtAlliance = SoraDGetChildByName(self.nodelordOccupy, "Text_alliance")
	self.Node_flag = SoraDGetChildByName(self.nodelordOccupy, "Node_flag")
	self.txtPlayer = SoraDGetChildByName(self.nodelordOccupy, "Text_player")
	self.imgPlayerHead = SoraDGetChildByName(self.nodelordOccupy, "Image_playerHead")
	self.imgPlayerHead:setTouchEnabled(true)
	self.imgPlayerHead:addTouchEventListener(handler(self, self.btnPlayerHeadClick))
	self.Button_FlagTouch = SoraDGetChildByName(self.nodelordOccupy, "Button_FlagTouch")
	self.Button_FlagTouch:setTouchEnabled(false)
	self.Button_FlagTouch:addTouchEventListener(handler(self, self.btnFlagClick))
	self.troopCount = SoraDGetChildByName(self, "Text_power")
	self.spInwarNo = SoraDGetChildByName(self, "Sprite_inwar_no")
	self.imgHourglass = SoraDGetChildByName(self, "Image_hourglass")
	self.imgTroop = SoraDGetChildByName(self, "Image_troop")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.btnRecord = SoraDGetChildByName(self, "Button_record")
	self.btnFamous = SoraDGetChildByName(self, "Button_famousRoom")
	self.btnGift = SoraDGetChildByName(self, "Button_gift")
	self.btnIntegral = SoraDGetChildByName(self, "Button_integral")
	_UPVALUE4_, self.integralStatus = SoraDGetChildByName(self, "Button_integral"), nil
	self.tableBtn, SoraDGetChildByName(self, "Button_integral")[1] = SoraDGetChildByName(self, "Button_integral"), self.btnRecord
	self.tableBtn, SoraDGetChildByName(self, "Button_integral")[2] = SoraDGetChildByName(self, "Button_integral"), self.btnFamous
	self.tableBtn, SoraDGetChildByName(self, "Button_integral")[3] = SoraDGetChildByName(self, "Button_integral"), self.btnGift
	self.tableBtn, SoraDGetChildByName(self, "Button_integral")[4] = SoraDGetChildByName(self, "Button_integral"), self.btnIntegral
	SoraDGetChildByName(self, "Text_record"):setString(i18n("common_text_836"))
	SoraDGetChildByName(self, "Text_famousRoom"):setString(i18n("common_text_837"))
	SoraDGetChildByName(self, "Text_gift"):setString(i18n("kindofwar_btn_01"))
	self.txtIntegral = SoraDGetChildByName(self, "Text_integral")
	self.btnRecord:addTouchEventListener(handler(self, self.btnRecordClick))
	self.btnFamous:addTouchEventListener(handler(self, self.btnFamousClick))
	self.btnGift:addTouchEventListener(handler(self, self.btnGiftClick))
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.txtExplain = SoraDGetChildByName(self, "Text_explain")
	self.txtTime:setString(i18n("common_text_699"))
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.txtEffectTitle = SoraDGetChildByName(self, "Text_effect_title")
	self.txtEffectValue = SoraDGetChildByName(self, "Text_effect_value")
	self:_initFireNode()
end
local addFire = function(node)
	local nodeFire = _G.SoraDGetCommonJetFireNode(true)
	nodeFire:setPositionY(100)
	nodeFire:addTo(node)
end
function batteryStateView:_initFireNode()
	local fire = SoraDGetChildByName(self, "Node_fire_L")
	addFire(fire)
	fire = SoraDGetChildByName(self, "Node_fire_R")
	addFire(fire)
	local nodeContent = SoraDGetChildByName(self, "Top_Node_Content")
	local preViewHeight = self:getContentSize().height
	local height = preViewHeight - 960
	local contetnheight = math.min(50, height)
	nodeContent:setPositionY(nodeContent:getPositionY() - contetnheight)
end
function batteryStateView:fixNodePos()
	local preViewHeight = self:getContentSize().height
	local height = math.max(0, preViewHeight - 960)
	local nodeBg = SoraDGetChildByName(self, "Node_flag_bg")
	local maxHeitht = 50
	local instanceType = self.argList.instanceType
	if gMapObjTypeDef.mapObjTypeBattery == instanceType then
		maxHeitht = 100
	end
	local bgHeight = math.max(0, maxHeitht - height)
	nodeBg:setPositionY(nodeBg:getPositionY() + bgHeight)
	nodeBg:setLocalZOrder(-1)
	if gMapObjTypeDef.mapObjTypeCastale ~= self.argList.instanceType then
		local nodeInfo = SoraDGetChildByName(self, "Node_info")
		local infoHeight = math.max(0, 20 - height)
		nodeInfo:setPositionY(nodeInfo:getPositionY() + infoHeight)
		local nodeTroop = SoraDGetChildByName(self, "Node_troop")
		nodeTroop:setPositionY(nodeTroop:getPositionY() + 60)
		if self.danNode and preViewHeight < 960 then
			self.danNode:setPositionY(-100)
		end
	end
end
function batteryStateView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED", handler(self, self.reqInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEONWERCHANGED", handler(self, self.reqInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEINFOBACK", handler(self, self.reqInfoRsp))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_GETLOG_PALACECHANGE", handler(self, self.occupyChange))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
end
function batteryStateView:initData(mapInstance, argList)
