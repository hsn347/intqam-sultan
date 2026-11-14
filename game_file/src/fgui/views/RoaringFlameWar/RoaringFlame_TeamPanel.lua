local gametop = gModuleMgr.getObject("gametop")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local lordLocalData = include("lordLocalData")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_TeamPanel = class("RoaringFlame_TeamPanel", baseFguiPanel)
function RoaringFlame_TeamPanel:ctor(...)
	RoaringFlame_TeamPanel.super.ctor(self, ...)
	print("RoaringFlame_TeamPanel:ctor", self.viewName)
end
function RoaringFlame_TeamPanel:onInit()
	print("=======RoaringFlame_TeamPanel:onInit")
	self.fields.Com_title:initData(i18n("flames_dunes_text90"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_manager:setString(i18n("atlantiswar_text_0028"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_setZero = self.fields.Mod_Bottom:getChild("Button_add")
	self.fields.Button_setZero:setString(i18n("atlantiswar_text_0346"))
	self.fields.Button_setZero:addClickListener(handler(self, self.onClickBtnSetZero))
	self.fields.Button_kick = self.fields.Mod_Bottom:getChild("Button_kick")
	self.fields.Button_kick:setString(i18n("flames_dunes_text351"))
	self.fields.Button_kick:addClickListener(handler(self, self.onClickBtnKick))
	local _fields = fguiHelper.get_fields(self.fields.Mod_top)
	_fields.Load_player:addClickListener(handler(self, self.onClickLoadPlayer))
end
function RoaringFlame_TeamPanel:onShow()
	print("=======RoaringFlame_TeamPanel:onShow")
	roaringFlameWarCtrl:reqGetManagerInfo()
	if roaringFlameWarUtil.checkPermission(ROARING_FLAME_WAR_PERMISSION.MODIFY_LV0_USER) then
		self.fields.Button_setZero:setVisible(true)
	else
		self.fields.Button_setZero:setVisible(false)
	end
	if roaringFlameWarUtil.checkPermission(ROARING_FLAME_WAR_PERMISSION.KICK_LV0_USER) then
		self.fields.Button_kick:setVisible(true)
	else
		self.fields.Button_kick:setVisible(false)
	end
end
function RoaringFlame_TeamPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("flames_dunes_second_rule11")
	;(nil).content = i18n("flames_dunes_second_rule12")
	uiManager:show("RuleView", nil)
end
function RoaringFlame_TeamPanel:onItemRenderer(index, obj)
	local idx = index + 1
	local data = self.managers[tostring(idx)]
	_ENV = nil
	;(nil).index = idx
	;(nil).shieldUidMap = self.shieldUidMap
	obj:initData(data, nil)
end
function RoaringFlame_TeamPanel:onClickBtnSetZero(...)
	SoraDPlaySound()
	if not roaringFlameWarUtil.checkPermission(ROARING_FLAME_WAR_PERMISSION.MODIFY_LV0_USER, true) then
		return
	end
	uiManager:show("RoaringFlame_SetZero")
end
function RoaringFlame_TeamPanel:onClickBtnKick(...)
	SoraDPlaySound()
	if not roaringFlameWarUtil.checkPermission(ROARING_FLAME_WAR_PERMISSION.KICK_LV0_USER, true) then
		return
	end
	if not worldMapDefine.isInRoaringFlame() then
		SoraDShowMsgTip(i18n("flames_dunes_text358"))
		return
	end
	_ENV = i18n("flames_dunes_text358")
	i18n("flames_dunes_text358").isKick = true
	uiManager:show("RoaringFlame_SetZero", i18n("flames_dunes_text358"))
end
function RoaringFlame_TeamPanel:onClickLoadPlayer(...)
	SoraDPlaySound()
	if self.adminUid then
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
		;(nil).playerID = self.adminUid
		SoraDSendMessage(nil)
	end
end
function RoaringFlame_TeamPanel:onMsgGetManagerInfo(target, event)
	local rspdata = event.rspdata
	local data = rspdata.adminInfo
	local _fields = fguiHelper.get_fields(self.fields.Mod_top)
	local portrait = lordLocalData.getPortrait(data.headid)
	_fields.Load_player:setURL(portrait)
	self.adminUid = data.uid
	local selfCamp = roaringFlameWarCtrl:getSelfCamp()
	local campName = roaringFlameWarRead.getCampName(selfCamp)
	local selfKid = gametop.playertop_:getKingdomID()
	local campStr = textParser.formatAllianceName(nil, campName, selfKid)
	_fields.Text_camp:setString(campStr)
	local playerStr = textParser.formatPlayerName(nil, data.nickName, selfKid)
	_fields.Text_player:setString(playerStr)
	_fields.Text_leader:setString(i18n("flames_dunes_text91"))
	local isOnline = data.online and data.online == 0 or false
	_fields.Text_online:setString(isOnline and i18n("common_text_224") or i18n("common_text_3976"))
	_fields.Text_online:setColor(isOnline and cc.c3b(112, 199, 35) or cc.c3b(134, 127, 111))
	self.shieldUidMap, _ENV, self.managers = rspdata.managers, rspdata.managers, rspdata.managers
	for __, v in pairs(self.managers) do
		self.shieldUidMap[v.uid] = true
	end
	self.fields.List:setNumItems(table.nums(self.managers))
end
return RoaringFlame_TeamPanel
