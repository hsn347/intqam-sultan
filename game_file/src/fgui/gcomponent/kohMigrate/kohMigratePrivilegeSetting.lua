local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local kohMigrateRead = include("kohMigrateRead")
local AKC = kohMigrateRead.getMigrantKingConfig()
local baseComponent = require("fgui.base.baseComponent")
local kohMigratePrivilegeSetting = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://kohMigrate/kohMigratePrivilegeSetting", kohMigratePrivilegeSetting)
function kohMigratePrivilegeSetting:registerEvent(...)
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_REFRESH_KINGDOMDATA", function(event)
		SoraDCloseLoading()
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_REFRESH_SETTING", function(event)
		SoraDCloseLoading()
		self:initData()
	end)
end
function kohMigratePrivilegeSetting:onInit()
	self.setup, kohMigrateCtrl = nil, nil
	self.singleList, kohMigrateCtrl, self.isAllowMoveIn = nil, nil, true
	self.coolingTime = 0
	self.settingCD = kohMigrateCtrl:getAcrossParam("across_powerset_cd")
	self.fields.Text_tip:setString(i18n("across_move_powerLimit_desc02"))
	self.fields.Node_moveIn:setString(i18n("across_move_agree_name"))
	self.ccs_switch = self.fields.CCS_commonSettingSwitchView_1
	kohMigrateCtrl = i18n("across_move_agree_name")
	i18n("across_move_agree_name").content = i18n("across_move_agree_desc")
	i18n("across_move_agree_name").handle = function(isSwitch, tag)
		if self.coolingTime > 0 then
			self.ccs_switch:setVal(not isSwitch)
			SoraDShowMsgTip(i18n("tips_changeCD"))
			return
		end
		self.isAllowMoveIn = isSwitch
		self:refreshBtnSave()
	end
	self.ccs_switch:initLabelAndSwitch(i18n("across_move_agree_name"))
	self.Node_fcLimit = SoraDGetChildByName(self.node_content, "Node_fcLimit")
	self.fields.Node_fcLimit:setString(i18n("across_powerSet_name"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setNumItems(#AKC)
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	self.Text_cooling = self.fields.Text_cooling
	self.Text_cooling = SoraDCreateTimerLabel(self, self.Text_cooling)
	self.Button_save = self.fields.Button_save
	self.Button_save:setString(i18n("common_text_195"))
	self.Button_save:addClickListener(handler(self, self.btnSaveClick))
end
function kohMigratePrivilegeSetting:onShow()
end
function kohMigratePrivilegeSetting:onItemRenderer(index, obj)
	local cfg = AKC[index + 1]
	obj:setTag(index + 1)
	local _fields = fguiHelper.get_fields(obj)
	_fields.Text_power:setString(string.format(">%s", string.formatnumberthousands(cfg.power)))
	_fields.Image_white:setVisible(index % 2 == 0)
	obj.CheckBox = _fields.CheckBox_item
	if cfg.power == self.setup.playerStrengthLimit then
		_fields.Text_power:setColor(cc.c3b(255, 212, 62))
		_fields.CheckBox_item:setSelected(true)
		_fields.CheckBox_item:setBright(false)
	else
		_fields.Text_power:setColor(cc.c3b(240, 230, 210))
		_fields.CheckBox_item:setSelected(false)
		_fields.CheckBox_item:setBright(true)
	end
	if not SoraDFIsRA() and not obj.isInit then
		obj.isInit = true
		obj:fixChildrenPos()
	end
end
function kohMigratePrivilegeSetting:onClickItem(EventContext)
	SoraDPlaySound()
	local obj = EventContext:getGObjectData()
	local childIndex = self.fields.List:getChildIndex(obj)
	if self.curSetupIndex == childIndex then
		return
	end
	if self.coolingTime > 0 then
		SoraDShowMsgTip(i18n("tips_changeCD"))
		return
	end
	if self.preCheckImage then
		self:setCheckImageSelect(self.preCheckImage, true)
	end
	self:setCheckImageSelect(obj, false)
	self.preCheckImage = obj
	self:refreshBtnSave()
end
function kohMigratePrivilegeSetting:initData(...)
	self:refreshData()
	self.ccs_switch:setVal(self.isAllowMoveIn)
	self.fields.List:setNumItems(#AKC)
	self.Button_save:setEnabled(false)
	if self.settingCD > 0 then
		AKC = nil
		;(nil).var1 = math.ceil(self.settingCD / 60)
		self.Text_cooling:setString(i18n("across_powerSet_button_desc", nil))
		self.Text_cooling:setColor(cc.c3b(215, 195, 155))
		if 0 < self.coolingTime then
			self.Text_cooling:setColor(display.COLOR_WHITE)
			self.Text_cooling:setTimeLast(function(timeStr)
				_ENV = nil
				_ENV, _ENV, (nil).var1 = nil, nil, timeStr
				_ENV, (nil).var1, (nil).color = nil, nil, "#BE2828"
				;(nil).__default, (nil).color = nil, "#D7C39B"
				return i18n_html("across_powerSet_CD_name", nil, nil)
			end)
			self.Text_cooling:setTimeEndListener(function()
				self.coolingTime = 0
				self = nil
				;(nil).var1 = math.ceil(self.settingCD / 60)
				self.Text_cooling:setString(i18n("across_powerSet_button_desc", nil))
				self.Text_cooling:setColor(cc.c3b(215, 195, 155))
			end)
			self.Text_cooling:beginTime(self.coolingTime)
		end
	else
		self.Text_cooling:setVisible(false)
	end
end
function kohMigratePrivilegeSetting:checkImageClick(target, event)
	if self.coolingTime > 0 then
		SoraDShowMsgTip(i18n("tips_changeCD"))
		return
	end
	if self.preCheckImage then
		self:setCheckImageSelect(self.preCheckImage, true)
	end
	self:setCheckImageSelect(target, false)
	self.preCheckImage = target
	self:refreshBtnSave()
end
function kohMigratePrivilegeSetting:btnSaveClick(button, event)
	SoraDPlaySound()
	self:saveSet(true)
end
function kohMigratePrivilegeSetting:saveSet(showBox)
	local power = self.setup.playerStrengthLimit
	if self.preCheckImage then
		local tag = self.preCheckImage:getTag()
		power = AKC[tag].power
	end
	if power == self.setup.playerStrengthLimit and self.isAllowMoveIn == not self.setup.isCloseMoveIn then
		return
	end
	local reqSetup = function()
		SoraDShowLoading()
		kohMigrateCtrl:reqSetup(not self.isAllowMoveIn, power)
	end
	if not showBox or self.settingCD <= 0 then
		reqSetup()
		return
	end
	AKC = nil
	AKC, AKC, (nil).var1 = self.settingCD / 60, math.ceil(self.settingCD / 60), math.ceil(self.settingCD / 60)
	AKC, math.ceil(self.settingCD / 60).var1, (self.settingCD / 60).color = self.settingCD / 60, self.settingCD / 60, "#FFFFFF"
	math.ceil(self.settingCD / 60).__default, (self.settingCD / 60).color = self.settingCD / 60, "#D7C39B"
	local str = i18n_html("across_powerSet_changeSure_desc", nil, (math.ceil(self.settingCD / 60)))
	AKC = nil
	;(nil).align = SoraDFLabelR()
	;(nil).useHtml = true
	SoraDShowMsgBoxNew(str, i18n("common_text_204"), i18n("common_text_185"), function(exitType)
		if exitType == MSGBOX_CALLBACK_YES then
			reqSetup()
		end
	end, nil)
end
function kohMigratePrivilegeSetting:setCheckImageSelect(widget, isSelect)
	if isSelect then
		widget.CheckBox:setSelected(false)
	else
		widget.CheckBox:setSelected(true)
	end
end
function kohMigratePrivilegeSetting:cleanSet(...)
	if self.preCheckImage then
		self:setCheckImageSelect(self.preCheckImage, true)
		self.preCheckImage = nil
	end
	self.isAllowMoveIn = not self.setup.isCloseMoveIn
	self.ccs_switch:setVal(self.isAllowMoveIn)
	self.Button_save:setEnabled(false)
end
function kohMigratePrivilegeSetting:refreshBtnSave(...)
	self.Button_save:setEnabled(self:isSetChange())
end
function kohMigratePrivilegeSetting:isSetChange(...)
	return self.preCheckImage ~= nil or self.isAllowMoveIn ~= not self.setup.isCloseMoveIn
end
function kohMigratePrivilegeSetting:refreshData(...)
	self.setup = kohMigrateCtrl:getSetup()
	self.isAllowMoveIn = not self.setup.isCloseMoveIn
	if self.preCheckImage then
		self.preCheckImage = nil
	end
	self.coolingTime = 0
	if self.setup.t ~= 0 and 0 < self.settingCD then
		local lefttime = self.settingCD - (serviceFunctions.systemTime() - self.setup.t)
		if 0 < lefttime then
			self.coolingTime = lefttime
		end
	end
	self.curSetupIndex = nil
	for i, cfg in ipairs(AKC) do
		if cfg.power == self.setup.playerStrengthLimit then
			self.curSetupIndex = i - 1
			break
		end
	end
end
function kohMigratePrivilegeSetting:reqData(...)
end
return kohMigratePrivilegeSetting
