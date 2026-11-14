local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kohMigrateInviteSearchPanel = class("kohMigrateInviteSearchPanel", baseFguiPanel)
_ENV = "kohMigrateInviteSearchPanel"
;("kohMigrateInviteSearchPanel").name = 1
local ("kohMigrateInviteSearchPanel").uid, SEARCH_TYPE = 2, "kohMigrateInviteSearchPanel"
function kohMigrateInviteSearchPanel:ctor(...)
	kohMigrateInviteSearchPanel.super.ctor(self, ...)
	print("kohMigrateInviteSearchPanel:ctor", self.viewName)
	self.debug = true
	self.isKingPrivilege = true
	self.searchType = SEARCH_TYPE.name
end
function kohMigrateInviteSearchPanel:onInit()
	print("=======kohMigrateInviteSearchPanel:onInit")
	self.fields.Panel_bg:setString(i18n("kingPower_invitation_title"))
	self.fields.Button_search:setString(i18n("common_text_166"))
	self.fields.Button_search:addClickListener(handler(self, self.btnSearchClick))
	self.TextField_search = self.fields.input:getChild("input")
	self.fields.Text_tips:setString(i18n("across_invitation_inputTips_desc"))
	self.fields.Text_noInvite:setString(i18n("kingPower_invitation_desc03"))
	self.fields.Text_noResult:setString(i18n("common_text_963"))
	self.fields.Text_noResult:setVisible(false)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	if not SoraDFIsRA() then
		_UPVALUE7_ = self.fields.List
		self.fields.List[1] = self.fields.ComboBox_search
		self.fields.List[2] = self.fields.input
		self.fields.List[3] = self.fields.Button_search
		self.fields.List[4] = self.fields.Text_power
		self.fields.List[5] = self.fields.Text_legend
		self.fields.List[6] = self.fields.Image_num
		self.fields.List[7] = self.fields.Text_num
		for __, v in pairs(self.fields.List) do
			v:fixPos()
		end
	end
end
function kohMigrateInviteSearchPanel:onShow()
	print("=======kohMigrateInviteSearchPanel:onShow")
	self:initData()
end
function kohMigrateInviteSearchPanel:initData()
	self:initComboBoxSearch()
	self:refreshTextPower()
	self:refreshTextNum()
end
function kohMigrateInviteSearchPanel:initComboBoxSearch(...)
	_ENV = nil
	;(nil)[1] = i18n("common_text_3155")
	local (nil)[2], config = i18n("UID"), nil
	_ENV = nil
	;(nil).items = config
	;(nil).changedCallback = handler(self, self.onComboBoxChanged)
	;(nil).selectedIndex = self.searchType - 1
	;(nil).showCurSelect = true
	self:setComboBox(self.fields.ComboBox_search, nil)
end
function kohMigrateInviteSearchPanel:onComboBoxChanged()
	local index = self.fields.ComboBox_search:getSelectedIndex()
	self.searchType = index + 1
end
function kohMigrateInviteSearchPanel:refreshTextPower(...)
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
	local legendStr = i18n_html("migrant_move_text41", canMoveInStrength, (string_fnt(canMoveInLegend)))
	self.fields.Text_legend:setString(legendStr)
end
function kohMigrateInviteSearchPanel:refreshTextNum(...)
	kohMigrateCtrl = nil
	local (nil).color, style = "#F0E6D2", nil
	local inviteCount = kohMigrateCtrl:getKingInviteNum()
	local inviteMax = kohMigrateCtrl:getKingInviteNumMax()
	local inviteNum = math.max(0, inviteMax - inviteCount)
	local countStr = i18n("across_moveDesc_text06") .. " " .. SoraDWrapHtmlTagByStyle(inviteNum, style)
	self.fields.Text_num:setString(countStr)
end
function kohMigrateInviteSearchPanel:btnSearchClick()
	SoraDPlaySound()
	local keyname = string.match(self.TextField_search:getText(), "%s*(.-)%s*$")
	if not keyname or type(keyname) ~= "string" then
		return
	end
	local keyLen = string.utf8len(keyname)
	if keyLen < SEARCH_MIN_LEN then
		SoraDShowMsgTip(i18n("common_text_961"))
		return
	end
	if keyLen > MAX_NICKNAME_LEN then
		SoraDShowMsgTip(i18n("tips_inputLengthLimit"))
		return
	end
	if self.searchType == SEARCH_TYPE.uid then
		kohMigrateCtrl:reqSearchPlayer(nil, true, tonumber(keyname) or 0)
	else
		kohMigrateCtrl:reqSearchPlayer(keyname, true)
	end
	SoraDShowLoading()
end
function kohMigrateInviteSearchPanel:onSearchBack(target, event)
	SoraDCloseLoading()
	self.dataList = event.result
	self.fields.List:setNumItems(#self.dataList)
	self.fields.Text_noResult:setVisible(#self.dataList <= 0)
	self.fields.Text_tips:setVisible(false)
	self.fields.Text_noInvite:setVisible(false)
	if #self.dataList > 0 then
		self.fields.List:scrollToView(0)
	end
end
function kohMigrateInviteSearchPanel:onItemRenderer(index, obj)
	local data = self.dataList[index + 1]
	obj:initData(data)
end
return kohMigrateInviteSearchPanel
