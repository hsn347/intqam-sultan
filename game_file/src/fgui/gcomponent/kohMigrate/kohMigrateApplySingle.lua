local nationalFlagRead = include("nationalFlagRead")
local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local baseComponent = require("fgui.base.baseComponent")
local kohMigrateApplySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://kohMigrate/kohMigrateApplySingle", kohMigrateApplySingle)
function kohMigrateApplySingle:onInit()
	self.fields.Button_chat:setString(i18n("prison_btn_02"))
	self.fields.Button_chat:addClickListener(handler(self, self.btnChatClick))
	self.fields.Button_see:setString(i18n("common_text_829"))
	self.fields.Button_see:addClickListener(handler(self, self.btnSeeClick))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.Image_flag:setPositionX(12)
		self.fields.Image_kid:fix()
	end
end
function kohMigrateApplySingle:onShow()
end
function kohMigrateApplySingle:initData(data, otherData)
	dump(data, "==kohMigrateApplySingle:initData data==")
	local kingdomData = data.kingdomData
	self.kingdomData = kingdomData
	local imageName = nationalFlagRead.getAcrossListImageByID(kingdomData.kingdomFlag)
	if imageName then
		self.fields.Image_flag:setURL(imageName)
	end
	self.isGreenPoint = kohMigrateCtrl:checkFlagPoint(kohMigrateCtrl:getKingdomDataByID(kingdomData.kid))
	self:refreshFlagPoint()
	self.fields.Text_kid:setString(string.format("#%d", kingdomData.kid))
	local kingName = ""
	if kingdomData.kingUid and kingdomData.kingUid > 0 then
		kingName = kingdomData.kingName
		if kingdomData.kingAbbr then
			_ENV = string.format("#%d", kingdomData.kid)
			string.format("#%d", kingdomData.kid).abbr = kingdomData.kingAbbr
			string.format("#%d", kingdomData.kid).name = kingName
			kingName = i18n("common_text_186", string.format("#%d", kingdomData.kid))
		end
		_ENV = string.format("#%d", kingdomData.kid)
		string.format("#%d", kingdomData.kid).power = string.formatnumberthousands(kingdomData.kingTotalFc)
		self.fields.Text_power:setString(i18n("common_text_1418", string.format("#%d", kingdomData.kid)))
		self.fields.Button_chat:setVisible(true)
	else
		_ENV = true
		;(true).abbr = i18n("common_text_480")
		;(true).name = ""
		kingName = i18n("common_text_186", true)
		self.fields.Button_chat:setVisible(false)
	end
	_ENV = "common_text_480"
	;("common_text_480").kingName = kingName
	self.fields.Text_king:setString(i18n("common_text_529", "common_text_480"))
	if data.status == 0 then
		self.controllers.c_type:setSelectedIndex(0)
		self.fields.Text_isApply:setString(i18n("across_move_applied_name"))
	elseif data.status == 1 then
		self.controllers.c_type:setSelectedIndex(1)
		self.fields.Text_isAgree:setString(i18n("across_approvaled_name"))
	elseif data.status == 2 then
		self.controllers.c_type:setSelectedIndex(2)
		self.fields.Text_isAgree:setString(i18n("across_notApproval_name"))
	end
end
function kohMigrateApplySingle:refreshFlagPoint(...)
	if self.isGreenPoint then
		self.fields.Sprite_point:setURL("frame_zhuangshi_01.png")
	else
		self.fields.Sprite_point:setURL("frame_kfqc_img_01.png")
	end
end
function kohMigrateApplySingle:onTouchFlagBack(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).kid = self.kingdomData.kid
	uiManager:show("kohMigrateKingdomDetail", nil)
end
function kohMigrateApplySingle:btnChatClick()
	SoraDPlaySound()
	_ENV = SoraDPlaySound
	SoraDPlaySound.targetType = gMailType.CHAT
	SoraDPlaySound.target = self.kingdomData.kingUid
	SoraDPlaySound.nickName = self.kingdomData.kingName
	local SoraDPlaySound.allianceAbbr, data = self.kingdomData.kingAbbr, SoraDPlaySound
	SoraDCreateChatView(data)
end
function kohMigrateApplySingle:btnSeeClick()
	self:onTouchFlagBack()
end
return kohMigrateApplySingle
