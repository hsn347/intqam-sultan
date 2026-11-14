local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local baseComponent = require("fgui.base.baseComponent")
local kohMigratePrivilegeApply = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://kohMigrate/kohMigratePrivilegeApply", kohMigratePrivilegeApply)
function kohMigratePrivilegeApply:registerEvent()
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_KINGDOM_APPLYLIST", function(target, event)
		SoraDCloseLoading()
		if event.hasMore ~= nil then
			self.hasMore = event.hasMore
		end
		if event.addCount then
			self.iBegin = self.iBegin + event.addCount
		end
		if event.hasNew == nil or event.hasNew == true then
			self:initData()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_REFRESH_KINGDOMDATA", function(target, event)
		self:initBottomText()
	end)
end
function kohMigratePrivilegeApply:onInit()
	self.iBegin = 1
	self.nCount = 15
	_ENV = nil
	;(nil).byUID = true
	self.sort = SoraDConfigGet("Game:kohMigratePrivilegeApply:sort~integer", nil) or 1
	self:initComboBoxApply()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	self.fields.List:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.Text_noApply:setString(i18n("across_approval_noInfo_desc"))
	if not SoraDFIsRA() then
		self.fields.Com_power:fixChildrenPos()
		self.fields.Com_legend:fixChildrenPos()
	end
end
function kohMigratePrivilegeApply:onShow()
end
function kohMigratePrivilegeApply:initBottomText(...)
	_ENV = nil
	local (nil).color, style = "#F0E6D2", nil
	local string_fnt = string.formatnumberthousands
	local kingdomData = kohMigrateCtrl:getKingdomDataByID()
	local _fields = fguiHelper.get_fields(self.fields.Com_power)
	local canMoveInStrength = kohMigrateCtrl:getCanMoveInStrength(kingdomData)
	_ENV = nil
	_ENV, (nil).power = string_fnt(canMoveInStrength), string_fnt(canMoveInStrength)
	string_fnt(canMoveInStrength).power = style
	local powerStr = i18n_html("migrant_move_text40", nil, (string_fnt(canMoveInStrength)))
	_fields.Text_power:setString(powerStr)
	local canMoveInCount = kohMigrateCtrl:getCanMoveInCount(kingdomData, gKohMigratePlayerType.T2)
	local countStr = i18n("migrant_move_text12") .. " " .. SoraDWrapHtmlTagByStyle(canMoveInCount, style)
	_fields.Text_count:setString(countStr)
	local _fields = fguiHelper.get_fields(self.fields.Com_legend)
	local canMoveInLegend = kohMigrateCtrl:getCanMoveInLegend(kingdomData)
	_ENV = nil
	_ENV, (nil).legend = string_fnt(canMoveInLegend), string_fnt(canMoveInLegend)
	string_fnt(canMoveInLegend).legend = style
	local powerStr = i18n_html("migrant_move_text41", nil, (string_fnt(canMoveInLegend)))
	_fields.Text_power:setString(powerStr)
	local canMoveInCount = kohMigrateCtrl:getCanMoveInCount(kingdomData, gKohMigratePlayerType.T1)
	local countStr = i18n("migrant_move_text12") .. " " .. SoraDWrapHtmlTagByStyle(canMoveInCount, style)
	_fields.Text_count:setString(countStr)
end
function kohMigratePrivilegeApply:initComboBoxApply(...)
	_ENV = nil
	;(nil)[1] = i18n("sort_time_name")
	local (nil)[2], config = i18n("sort_power_name"), nil
	_UPVALUE2_ = nil
	;(nil)[1] = "icon_kfqc_time.png"
	;(nil)[2] = "icon_kfqc_warpower.png"
	self.fields.ComboBox_apply:setIcons(nil)
	local view = uiManager:getProxy("kohMigratePrivilegeView").view
	_ENV = "icon_kfqc_warpower.png"
	;("icon_kfqc_warpower.png").items = config
	;("icon_kfqc_warpower.png").changedCallback = handler(self, self.onComboBoxChanged)
	;("icon_kfqc_warpower.png").selectedIndex = self.sort - 1
	view:setComboBox(self.fields.ComboBox_apply, "icon_kfqc_warpower.png")
	local dropdown = self.fields.ComboBox_apply:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox_apply:addClickListener(function()
		self.comboBoxList:setSelectedIndex(self.sort - 1)
	end)
end
function kohMigratePrivilegeApply:onComboBoxChanged()
	local index = self.fields.ComboBox_apply:getSelectedIndex()
	local newSort = index + 1
	print("==onComboBoxChanged==", newSort)
	if self.sort == newSort then
		return
	end
	self.sort = newSort
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:kohMigratePrivilegeApply:sort~integer", self.sort, nil)
	self:reqData()
end
function kohMigratePrivilegeApply:initData(...)
	if not kohMigrateCtrl:getExtraApplyList() then
		kohMigrateCtrl = kohMigrateCtrl:getExtraApplyList()
	end
	self.extraApplyList = kohMigrateCtrl:getExtraApplyList()
	self.fields.Text_noApply:setVisible(#self.extraApplyList <= 0)
	self.fields.Image_default:setVisible(#self.extraApplyList <= 0)
	self.fields.List:setNumItems(#self.extraApplyList)
end
function kohMigratePrivilegeApply:onItemRenderer(index, obj)
	local data = self.extraApplyList[index + 1]
	obj:initPrivilegeApplySingle()
	obj:initData(data)
end
function kohMigratePrivilegeApply:onPullUpRelease()
	if self.hasMore then
		SoraDShowLoading()
		kohMigrateCtrl:reqKingdomExtraApplyList(self.iBegin, self.nCount, self.sort)
	end
end
function kohMigratePrivilegeApply:reqData(...)
	SoraDShowLoading()
	self.iBegin = 1
	kohMigrateCtrl:reqKingdomExtraApplyList(self.iBegin, self.nCount, self.sort)
	kohMigrateCtrl:reqKingdomData()
end
return kohMigratePrivilegeApply
