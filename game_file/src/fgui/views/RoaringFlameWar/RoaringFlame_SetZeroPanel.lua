local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_SetZeroPanel = class("RoaringFlame_SetZeroPanel", baseFguiPanel)
function RoaringFlame_SetZeroPanel:ctor(...)
	RoaringFlame_SetZeroPanel.super.ctor(self, ...)
	print("RoaringFlame_SetZeroPanel:ctor", self.viewName)
end
function RoaringFlame_SetZeroPanel:onInit()
	print("=======RoaringFlame_SetZeroPanel:onInit")
	self.fields.Com_title:initData(i18n("atlantiswar_text_0346"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_noData:setString(i18n("common_text_3416"))
	local r0Num = roaringFlameWarRead.getConstValue("FLAMES_DUNES_R0_NUM", 50)
	_ENV = i18n("common_text_3416")
	i18n("common_text_3416").val = r0Num
	self.fields.Text_des:setString(i18n("flames_dunes_text93", i18n("common_text_3416")))
	self.fields.Button_add = self.fields.Mod_Bottom:getChild("Button_add")
	self.fields.Button_add:setString(i18n("shopping_text_10"))
	self.fields.Button_add:addClickListener(handler(self, self.onClickBtnAdd))
	self.fields.Com_searchMember:setSearchHandler(handler(self, self.updateMemberList))
end
function RoaringFlame_SetZeroPanel:onShow()
	print("=======RoaringFlame_SetZeroPanel:onShow")
	roaringFlameWarCtrl:reqGetLv0List()
	self.isKick = self.param.isKick or false
	self.fields.Mod_Bottom:setVisible(not self.isKick)
	if self.isKick then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Com_title:setString(i18n("flames_dunes_text351"))
		self.fields.Text_noData:setString(i18n("flames_dunes_text352"))
		self:updateKickPlayerCount()
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Com_title:setString(i18n("atlantiswar_text_0346"))
		self.fields.Text_noData:setString(i18n("common_text_3416"))
	end
end
function RoaringFlame_SetZeroPanel:onItemRenderer(index, obj)
	local data = self.tableMemberList[index + 1]
	_UPVALUE0_ = nil
	;(nil).isKick = self.isKick
	obj:initData(data, nil)
end
function RoaringFlame_SetZeroPanel:onClickBtnAdd(...)
	SoraDPlaySound()
	if not roaringFlameWarUtil.checkPermission(ROARING_FLAME_WAR_PERMISSION.MODIFY_LV0_USER, true) then
		return
	end
	local layer = uiManager:show("LordSelectView").view
	_ENV = nil
	;(nil).title = i18n("atlantiswar_text_0346")
	;(nil).shieldUidMap = self.shieldUidMap
	;(nil).handle = function(tableUID)
		roaringFlameWarCtrl:reqAddLv0User(tableUID[1])
	end
	;(nil).warType = gKingdomClassType.roaringFlame
	layer:setStyleAtlantisSettingZero(nil)
end
function RoaringFlame_SetZeroPanel:onMsgGeLv0List(target, event)
	local self.shieldUidMap, _ENV, _ENV, list
	local lv0List = event.rspdata
	for i, v in pairs(lv0List) do
		table.insert(list, v)
		self.shieldUidMap[v.uid] = true
	end
	table.sort(list, function(a, b)
		if a.time ~= b.time then
			return a.time > b.time
		end
		return a.uid < b.uid
	end)
	self.lv0List = list
	local permission = roaringFlameWarCtrl:getPermission()
	if permission.adminId then
		self.shieldUidMap[permission.adminId] = true
	end
	if not permission.managers then
		local _ENV, managers = permission.managers, permission.managers
	end
	for __, uid in pairs(managers) do
		self.shieldUidMap[uid] = true
	end
	self.fields.Com_searchMember:setMemberList(self.lv0List)
	local memberList = self.fields.Com_searchMember:getTableMemberList()
	self:updateMemberList(memberList)
end
function RoaringFlame_SetZeroPanel:updateMemberList(memberList)
	self.tableMemberList = memberList
	self.fields.List:setNumItems(#self.tableMemberList)
	self.fields.Text_noData:setVisible(#self.tableMemberList <= 0)
end
function RoaringFlame_SetZeroPanel:updateKickPlayerCount()
	local kickCount = roaringFlameWarCtrl:getKickPlayerCount()
	local maxCount = roaringFlameWarRead.getConstValue("FLAMES_DUNES_REMOVE_R0", 5)
	local roaringFlameWarCtrl, style = "FLAMES_DUNES_REMOVE_R0", "FLAMES_DUNES_REMOVE_R0"
	if kickCount >= maxCount then
		roaringFlameWarCtrl, roaringFlameWarCtrl = nil, 5
		roaringFlameWarCtrl, (5).num, (nil).color = nil, nil, "#ff0000"
		style, (5).max, (nil).color = 5, nil, "#ff0000"
	end
	roaringFlameWarCtrl = nil
	;(nil).num = kickCount
	;(nil).max = maxCount
	self.fields.Text_des:setString(i18n_html("flames_dunes_text353", nil, style))
end
function RoaringFlame_SetZeroPanel:onMsgUpdateKickPlayerCount(target, event)
	if not self.isKick then
		return
	end
	self:updateKickPlayerCount()
end
return RoaringFlame_SetZeroPanel
