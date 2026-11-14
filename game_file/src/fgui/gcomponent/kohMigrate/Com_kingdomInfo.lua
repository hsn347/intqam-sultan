local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local kohMigrateRead = include("kohMigrateRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_kingdomInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://kohMigrate/Com_kingdomInfo", Com_kingdomInfo)
function Com_kingdomInfo:onInit()
	self.highStrength = kohMigrateCtrl:getHighStrength()
	self.isCheckOther = true
	self.isPrivilege = false
	self.isNewKingdom = false
	if not SoraDFIsRA() then
		_UPVALUE8_ = kohMigrateCtrl
		kohMigrateCtrl[1] = self.fields.Com_single1_1
		kohMigrateCtrl[2] = self.fields.Com_single1_2
		kohMigrateCtrl[3] = self.fields.Com_single1_3
		kohMigrateCtrl[4] = self.fields.Com_single2_1
		kohMigrateCtrl[5] = self.fields.Com_single2_2
		kohMigrateCtrl[6] = self.fields.Com_single2_3
		kohMigrateCtrl[7] = self.fields.Com_single3_1
		kohMigrateCtrl[8] = self.fields.Com_myInfo
		for __, v in pairs(kohMigrateCtrl) do
			v:fixChildrenPos()
		end
	end
end
function Com_kingdomInfo:onShow()
end
function Com_kingdomInfo:initKingdomData(param)
	if not param then
		param, kohMigrateCtrl = nil, nil
	end
	self.kingdomData = param.kingdomData or kohMigrateCtrl:getKingdomDataByID()
	local selfKid = gametop.playertop_:getKingdomID()
	self.isCheckOther = self.kingdomData.kid ~= selfKid
	self.isNewKingdom = kohMigrateRead.checkIsNewkingdom(self.kingdomData.kid)
	if self.isNewKingdom then
		self.controllers.c_type:setSelectedIndex(1)
		self:initMyInfo()
		self:initNewKingdom()
	else
		self.controllers.c_type:setSelectedIndex(0)
		self:initMyInfo()
		self:initPlayerT1()
		self:initPlayerT2()
		self:initPlayerT3()
		self:initCondition()
	end
	self.isInit = true
end
function Com_kingdomInfo:initMyInfo(...)
	self.playerType = kohMigrateCtrl:getMyPlayerType()
	self.fields.Com_myInfo:initData()
end
function Com_kingdomInfo:initPlayerT1(...)
	if not self.isInit then
		local playerTypeName = kohMigrateRead.getPlayerTypeName(gKohMigratePlayerType.T1)
		kohMigrateRead = nil
		;(nil).playertype = playerTypeName
		self.fields.Text_title1:setString(i18n("migrant_move_text6", nil))
		local _fields = fguiHelper.get_fields(self.fields.Com_single1_1)
		_fields.Text_key:setString(i18n("migrant_move_text10"))
		_fields.Button_help:addClickListener(function(...)
			SoraDPlaySound()
			_ENV = nil
			;(nil).kid = self.kingdomData.kid
			uiManager:show("kohMigrateRank", nil)
		end)
		_fields.Button_help:setIcon("btn_paihang.png")
		local _fields = fguiHelper.get_fields(self.fields.Com_single1_2)
		_fields.Text_key:setString(i18n("migrant_move_text11"))
		local _fields = fguiHelper.get_fields(self.fields.Com_single1_3)
		_fields.Text_key:setString(i18n("migrant_move_text12"))
		self.fields.Com_single1_4:setString(i18n("migrant_move_text14"))
	end
	local _fields = fguiHelper.get_fields(self.fields.Com_single1_1)
	local kindgomLegend = kohMigrateCtrl:getCurKingdomLegend(self.kingdomData)
	_fields.Text_value:setString(string.formatnumberthousands(kindgomLegend))
	local _fields = fguiHelper.get_fields(self.fields.Com_single1_2)
	local canMoveInLegend = kohMigrateCtrl:getCanMoveInLegend(self.kingdomData)
	_fields.Text_value:setString(string.formatnumberthousands(canMoveInLegend))
	local _fields = fguiHelper.get_fields(self.fields.Com_single1_3)
	local maxNum = kohMigrateRead.getKingdom_legendplayer(self.kingdomData.kid)
	local canMoveInCount = kohMigrateCtrl:getCanMoveInCount(self.kingdomData, gKohMigratePlayerType.T1)
	self:initCanMoveInCount(_fields.Text_value, maxNum, canMoveInCount)
end
function Com_kingdomInfo:initPlayerT2(...)
	if not self.isInit then
		local playerTypeName = kohMigrateRead.getPlayerTypeName(gKohMigratePlayerType.T2)
		kohMigrateRead = nil
		;(nil).playertype = playerTypeName
		self.fields.Text_title2:setString(i18n("migrant_move_text6", nil))
		local _fields = fguiHelper.get_fields(self.fields.Com_single2_1)
		_fields.Text_key:setString(i18n("migrant_move_text15"))
		_fields.Button_help:addClickListener(function(...)
			SoraDPlaySound()
			_ENV = nil
			;(nil).title = i18n("migrant_move_text15")
			;(nil).content = i18n("migrant_move_rule9")
			uiManager:show("RuleView", nil)
		end)
		_fields.Button_help:setIcon("btn_detail.png")
		local _fields = fguiHelper.get_fields(self.fields.Com_single2_2)
		_fields.Text_key:setString(i18n("migrant_move_text16"))
		local _fields = fguiHelper.get_fields(self.fields.Com_single2_3)
		kohMigrateRead = i18n("migrant_move_text16")
		i18n("migrant_move_text16").power = SoraDConvertNumberWithUnit(self.highStrength)
		_fields.Text_key:setString(i18n("migrant_move_text17", i18n("migrant_move_text16")))
	end
	local _fields = fguiHelper.get_fields(self.fields.Com_single2_1)
	local kindgomStrength = kohMigrateCtrl:getCurKingdomStrength(self.kingdomData)
	_fields.Text_value:setString(string.formatnumberthousands(kindgomStrength))
	local _fields = fguiHelper.get_fields(self.fields.Com_single2_2)
	local canMoveInStrength = kohMigrateCtrl:getCanMoveInStrength(self.kingdomData)
	_fields.Text_value:setString(string.formatnumberthousands(canMoveInStrength))
	local _fields = fguiHelper.get_fields(self.fields.Com_single2_3)
	local maxNum = kohMigrateRead.getKingdom_highplayer(self.kingdomData.kid)
	local canMoveInCount = kohMigrateCtrl:getCanMoveInCount(self.kingdomData, gKohMigratePlayerType.T2)
	self:initCanMoveInCount(_fields.Text_value, maxNum, canMoveInCount)
end
function Com_kingdomInfo:initPlayerT3(...)
	if not self.isInit then
		local playerTypeName = kohMigrateRead.getPlayerTypeName(gKohMigratePlayerType.T3)
		kohMigrateRead = nil
		;(nil).playertype = playerTypeName
		self.fields.Text_title3:setString(i18n("migrant_move_text6", nil))
		local _fields = fguiHelper.get_fields(self.fields.Com_single3_1)
		kohMigrateRead = i18n("migrant_move_text6", nil)
		i18n("migrant_move_text6", nil).power = SoraDConvertNumberWithUnit(self.highStrength)
		_fields.Text_key:setString(i18n("migrant_move_text18", i18n("migrant_move_text6", nil)))
	end
	local _fields = fguiHelper.get_fields(self.fields.Com_single3_1)
	local maxNum = kohMigrateRead.getKingdom_lowplayer(self.kingdomData.kid)
	local canMoveInCount = kohMigrateCtrl:getCanMoveInCount(self.kingdomData, gKohMigratePlayerType.T3)
	self:initCanMoveInCount(_fields.Text_value, maxNum, canMoveInCount)
end
function Com_kingdomInfo:initCanMoveInCount(obj, maxNum, canMoveInCount)
	local countStr = tostring(canMoveInCount)
	if 0 < canMoveInCount then
		_ENV = nil
		;(nil).color = "#00FF00"
		countStr = SoraDWrapHtmlTagByStyle(countStr, nil)
	else
		_ENV = nil
		;(nil).color = "#FF0000"
		countStr = SoraDWrapHtmlTagByStyle(countStr, nil)
	end
	_ENV = nil
	;(nil).maxnum = maxNum
	;(nil).num = countStr
	obj:setString(i18n("migrant_move_text13", nil))
end
function Com_kingdomInfo:initCondition(...)
	if not self.isCheckOther then
		return
	end
	local Image_title = self.fields["Image_title" .. self.playerType]
	if Image_title then
		Image_title:setURL("frame_common_biaotidi04.png")
	end
	if self.playerType == gKohMigratePlayerType.T1 then
		local canMoveInLegend = kohMigrateCtrl:getCanMoveInLegend(self.kingdomData)
		local legend = kohMigrateCtrl:getMyLegend() or 0
		local isreach = canMoveInLegend >= legend
		self:setConditionIsReach(self.fields.Com_single1_2, isreach)
		if not self.isPrivilege then
			local canMoveInCount = kohMigrateCtrl:getCanMoveInCount(self.kingdomData, self.playerType)
			local isreach = 0 < canMoveInCount
			self:setConditionIsReach(self.fields.Com_single1_3, isreach)
		end
	elseif self.playerType == gKohMigratePlayerType.T2 then
		local canMoveInStrength = kohMigrateCtrl:getCanMoveInStrength(self.kingdomData)
		local beginStrength = kohMigrateCtrl:getBeginStrength()
		local isreach = canMoveInStrength >= beginStrength
		self:setConditionIsReach(self.fields.Com_single2_2, isreach)
		if not self.isPrivilege then
			local canMoveInCount = kohMigrateCtrl:getCanMoveInCount(self.kingdomData, self.playerType)
			local isreach = 0 < canMoveInCount
			self:setConditionIsReach(self.fields.Com_single2_3, isreach)
		end
	elseif self.playerType == gKohMigratePlayerType.T3 and not self.isPrivilege then
		local canMoveInCount = kohMigrateCtrl:getCanMoveInCount(self.kingdomData, self.playerType)
		local isreach = 0 < canMoveInCount
		self:setConditionIsReach(self.fields.Com_single3_1, isreach)
	end
end
function Com_kingdomInfo:setConditionIsReach(obj, isreach)
	local c_type = obj:getController("c_type")
	if c_type then
		c_type:fix()
		c_type:setSelectedIndex(1)
		local _fields = fguiHelper.get_fields(obj)
		_fields.Icon_yes:setVisible(isreach)
		_fields.Icon_no:setVisible(not isreach)
	end
end
function Com_kingdomInfo:initNewKingdom(...)
	if not self.isInit then
		self.fields.Text_titleNew:setString(i18n("migrant_move_text46"))
		self.fields.Text_desNew:setString(i18n("migrant_move_rule11"))
	end
end
function Com_kingdomInfo:updateHeight(...)
	if not self.isNewKingdom then
		return
	end
end
return Com_kingdomInfo
