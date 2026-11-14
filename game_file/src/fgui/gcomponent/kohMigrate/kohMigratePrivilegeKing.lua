local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local lordLocalData = include("lordLocalData")
local baseComponent = require("fgui.base.baseComponent")
local kohMigratePrivilegeKing = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://kohMigrate/kohMigratePrivilegeKing", kohMigratePrivilegeKing)
function kohMigratePrivilegeKing:registerEvent(...)
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_REFRESH_PRIVILEGE_INVITELIST", function()
		SoraDCloseLoading()
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_REFRESH_KINGDOMDATA", function(target, event)
		self:initBottomText()
	end)
end
function kohMigratePrivilegeKing:onInit()
	self.fields.Text_tip:setString(i18n("migrant_move_text42"))
	self.fields.Text_title:setString(i18n("kingPower_invitationLord_name"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	if not SoraDFIsRA() then
		self.fields.Text_legend:fixPos()
		self.fields.Text_power:fixPos()
	end
end
function kohMigratePrivilegeKing:onShow()
end
function kohMigratePrivilegeKing:initBottomText(...)
	_ENV = nil
	local (nil).color, style = "#F0E6D2", nil
	local string_fnt = string.formatnumberthousands
	local kingdomData = kohMigrateCtrl:getKingdomDataByID()
	local canMoveInStrength = kohMigrateCtrl:getCanMoveInStrength(kingdomData)
	_ENV = nil
	_ENV, (nil).power = string_fnt(canMoveInStrength), string_fnt(canMoveInStrength)
	string_fnt(canMoveInStrength).power = style
	local powerStr = i18n_html("migrant_move_text40", nil, (string_fnt(canMoveInStrength)))
	self.fields.Text_power:setString(powerStr)
	local canMoveInLegend = kohMigrateCtrl:getCanMoveInLegend(kingdomData)
	_ENV = canMoveInStrength
	_ENV, canMoveInStrength.legend = string_fnt(canMoveInLegend), string_fnt(canMoveInLegend)
	string_fnt(canMoveInLegend).legend = style
	local powerStr = i18n_html("migrant_move_text41", canMoveInStrength, (string_fnt(canMoveInLegend)))
	self.fields.Text_legend:setString(powerStr)
end
function kohMigratePrivilegeKing:reqData(...)
	SoraDShowLoading()
	kohMigrateCtrl:reqKingdomSpecInviteList()
	kohMigrateCtrl:reqKingdomData()
end
function kohMigratePrivilegeKing:initData()
	self.inviteData = kohMigrateCtrl:getPrivilegeInviteData()
	local kohMigrateCtrl, inviteList = kohMigrateCtrl:getPrivilegeInviteData(), kohMigrateCtrl:getPrivilegeInviteData()
	local inviteMax = kohMigrateCtrl:getKingInviteNumMax()
	for i = 1, inviteMax do
		if not self.inviteData[i] then
			kohMigrateCtrl = self.inviteData[i]
		end
		table.insert(inviteList, self.inviteData[i])
	end
	self.inviteList = inviteList
	self.fields.List:setNumItems(#self.inviteList)
end
function kohMigratePrivilegeKing:onItemRenderer(index, obj)
	local data = self.inviteList[index + 1]
	obj:initData(data)
end
return kohMigratePrivilegeKing
