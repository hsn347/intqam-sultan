local mailCtrl = SoraDGetCtrl("mailCtrl")
local MailShareBox = class("mailShareBox", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("mailShareBox")
	end
	return target
end)
function MailShareBox:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self:createUI()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setSize(cc.size(560, 420))
	self.ccs_bg:setTitleName(i18n("common_text_533"))
	self.Node_Content = SoraDGetChildByName(self, "Node_Content")
	self.Node_Content:setPositionY(47)
	self.ccs_bg:setPositionY(-289)
	self.labelAlliance = SoraDGetChildByName(self, "Text_world")
	self.checkBoxAlliance = SoraDGetChildByName(self, "CheckBox_world")
	self.checkBoxTeam = SoraDGetChildByName(self, "CheckBox_alliance")
	self.labelTeam = SoraDGetChildByName(self, "Text_alliance")
	self.Sprite_line = SoraDGetChildByName(self, "Sprite_line")
	self.btnShare = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_share")
	self.btnShare:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.checkBoxAlliance:addEventListener(handler(self, self.btnCheckClickCallBack))
	self.checkBoxTeam:addEventListener(handler(self, self.btnCheckClickCallBack))
	_ENV = handler(self, self.btnCheckClickCallBack)
	handler(self, self.btnCheckClickCallBack).text = i18n("common_text_533")
	self.btnShare:initData(handler(self, self.btnCheckClickCallBack))
	self.shareMid = 0
	self.labelAlliance:setString(i18n("common_text_1487"))
	self.labelTeam:setString(i18n("worldwar_text_18"))
	self:setCheck(true)
	self.labelCD = SoraDGetChildByName(self, "Text_cd")
	self.bg_cd = SoraDGetChildByName(self, "bg_cd")
	self.Sprite_line_2 = SoraDGetChildByName(self, "Sprite_line_2")
	self.Sprite_line_sheer = SoraDGetChildByName(self, "Sprite_line_sheer")
	self.Button_FaceBook = SoraDGetChildByName(self, "Button_FaceBook")
	_UPVALUE6_, self.Button_Whatsapp = SoraDGetChildByName(self, "Button_Whatsapp"), SoraDGetChildByName(self, "Button_Whatsapp")
	SoraDGetChildByName(self, "Button_Whatsapp")[1] = self.Button_FaceBook
	SoraDGetChildByName(self, "Button_Whatsapp")[2] = self.Button_Whatsapp
	SoraDGetChildByName(self, "Button_Whatsapp")[3] = self.Sprite_line_2
	SoraDGetChildByName(self, "Button_Whatsapp")[4] = self.Sprite_line_sheer
	SoraDGetChildByName(self, "Button_Whatsapp")[5] = self.labelCD
	local SoraDGetChildByName(self, "Button_Whatsapp")[6], hiddleNode = self.bg_cd, SoraDGetChildByName(self, "Button_Whatsapp")
	SoraDSetNodeArrayVisible(hiddleNode, false)
end
function MailShareBox:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function MailShareBox:init(mid)
	self.shareMid = mid
end
function MailShareBox:setCheck(isAlliance)
	self.checkBoxAlliance:setSelected(isAlliance)
	self.checkBoxAlliance:setTouchEnabled(not isAlliance)
	self.checkBoxTeam:setSelected(not isAlliance)
	self.checkBoxTeam:setTouchEnabled(isAlliance)
end
function MailShareBox:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local channel = self.checkBoxAlliance:isSelected() and gChatChannel.ALLIANCE or gChatChannel.TEAM
		local isNotInCD = mailCtrl:checkShareMail(self.shareMid, channel)
		if isNotInCD then
			mailCtrl:shareMail(self.shareMid, channel)
			self:removeFromParent()
		end
	end
end
function MailShareBox:btnCheckClickCallBack(button, type)
	if type == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		if button == self.checkBoxAlliance then
			self:setCheck(true)
		else
			self:setCheck(false)
		end
	end
end
return MailShareBox
