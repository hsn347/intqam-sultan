local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local nationalFlagRead = include("nationalFlagRead")
local baseComponent = require("fgui.base.baseComponent")
local kohMigrateKingdomSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://kohMigrate/kohMigrateKingdomSingle", kohMigrateKingdomSingle)
function kohMigrateKingdomSingle:onInit()
	self.fields.Text_close:setString(i18n("across_move_wayClosed_desc02"))
	self.fields.Button_see:setString(i18n("common_text_829"))
	self.fields.Button_see:addClickListener(handler(self, self.btnSeeClick))
	self.fields.Image_power:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onEventTouchBegin))
	self.fields.Image_power:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onEventTouchEnd))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.Image_flag:setPositionX(12)
		self.fields.Image_kid:fix()
	end
end
function kohMigrateKingdomSingle:onShow()
end
function kohMigrateKingdomSingle:initData(kid, otherData)
	self.kid = kid
	self.data = kohMigrateCtrl:getKingdomDataByID(self.kid)
	self.isPrivilege = otherData.isPrivilege
	local imageName = nationalFlagRead.getAcrossListImageByID(self.data.kingdomFlag)
	if imageName then
		self.fields.Image_flag:setURL(imageName)
	end
	self:refreshFlagPoint()
	self.fields.Text_kid:setString(string.format("#%d", self.data.kid))
	local kingName = ""
	if self.data.kingUid and self.data.kingUid > 0 then
		kingName = self.data.kingName
		if self.data.kingAbbr then
			kohMigrateCtrl = string.format("#%d", self.data.kid)
			string.format("#%d", self.data.kid).abbr = self.data.kingAbbr
			string.format("#%d", self.data.kid).name = kingName
			kingName = i18n("common_text_186", string.format("#%d", self.data.kid))
		end
	else
		kohMigrateCtrl = string.format("#%d", self.data.kid)
		string.format("#%d", self.data.kid).abbr = i18n("common_text_480")
		string.format("#%d", self.data.kid).name = ""
		kingName = i18n("common_text_186", string.format("#%d", self.data.kid))
	end
	kohMigrateCtrl = "common_text_480"
	;("common_text_480").kingName = kingName
	self.fields.Text_king:setString(i18n("common_text_529", "common_text_480"))
	_UPVALUE3_ = self.fields.Text_king
	self.fields.Text_king[1] = self.fields.Text_close
	self.fields.Text_king[2] = self.fields.Image_power
	self.fields.Text_king[3] = self.fields.Text_power
	for i, v in ipairs(self.fields.Text_king) do
		v:setVisible(false)
	end
	if self.isPrivilege or self.data.isSpecInvited then
	else
		local playerStrengthLimit = self.data.setup.playerStrengthLimit
		if self.data.setup.isCloseMoveIn then
			self.fields.Text_close:setVisible(true)
		else
			self.fields.Image_power:setVisible(true)
			self.fields.Text_power:setVisible(true)
			self.fields.Text_power:setString(string.formatnumberthousands(playerStrengthLimit))
		end
	end
end
function kohMigrateKingdomSingle:refreshFlagPoint(...)
	if kohMigrateCtrl:checkFlagPoint(self.data, self.isPrivilege) then
		self.fields.Sprite_point:setURL("frame_zhuangshi_01.png")
	else
		self.fields.Sprite_point:setURL("frame_kfqc_img_01.png")
	end
end
function kohMigrateKingdomSingle:btnSeeClick()
	local checkCastleLv = kohMigrateCtrl:getLvLimit()
	if checkCastleLv > SoraDGetCastleLv() then
		local buildLogic = include("buildLogic")
		kohMigrateCtrl = nil
		;(nil).num = buildLogic.getBuildLvStr(checkCastleLv)
		SoraDShowMsgTip(i18n("common_text_1795", nil))
		return
	end
	kohMigrateCtrl = i18n("common_text_1795", nil)
	i18n("common_text_1795", nil).kid = self.data.kid
	i18n("common_text_1795", nil).isPrivilege = self.isPrivilege
	uiManager:show("kohMigrateKingdomDetail", i18n("common_text_1795", nil))
end
function kohMigrateKingdomSingle:onEventTouchBegin(context)
	context:captureTouch()
	_ENV, _ENV = context, context.captureTouch
	context.icon = "icon_powerLimit.png"
	context.name = i18n("across_move_powerLimit_name")
	_ENV = nil
	;(nil).var1 = string.formatnumberthousands(self.data.setup.playerStrengthLimit)
	context.captureTouch[1], context.des = context, i18n("across_move_powerLimit_desc", nil)
	local data = context.captureTouch
	SoraDShowKohMigrateIconTips(context, data)
end
function kohMigrateKingdomSingle:onEventTouchEnd(context)
	SoraDCloseKohMigrateIconTips()
end
return kohMigrateKingdomSingle
