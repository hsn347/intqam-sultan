local baseComponent = require("fgui.base.baseComponent")
local Com_Mail_ItemDetailFight = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://mailView/Com_Mail_ItemDetailFight", Com_Mail_ItemDetailFight)
function Com_Mail_ItemDetailFight:onInit()
	self.fields.Button_left:addClickListener(handler(self, self.onClick_Button_left))
	self.fields.Button_right:addClickListener(handler(self, self.onClick_Button_right))
	self:fixChildrenPos()
end
function Com_Mail_ItemDetailFight:onShow()
end
function Com_Mail_ItemDetailFight:initManorData(data)
	local leftData = data.playerInfo2.uinfo
	local rightData = data.playerInfo1.uinfo
	local isShowLeft = leftData and leftData.gardenLv and leftData.gardenLv > 0
	local isShowRight = rightData and rightData.gardenLv and rightData.gardenLv > 0
	self.controllers.c1:setSelectedIndex(isShowLeft and isShowRight and 0 or isShowLeft and 1 or isShowRight and 2)
	print("Com_Mail_ItemDetailFight:initManorData", isShowLeft, isShowRight)
	if isShowLeft then
		if not self.gardenLeftHead then
			self.fields.head_left1:setURL("ui://mailView/Com_Mail_Head")
			self.gardenLeftHead = self.fields.head_left1:getComponent()
		end
		self.gardenLeftHead:setIcon("icon_mail_manor.png")
		self.gardenLeftHead:setTitle(leftData.gardenLv)
		self.fields.Text_Title_left:setString(i18n("mail_2_text_98"))
		function self.leftDetailCallback()
			_ENV = nil
			;(nil).gardenData = data.playerInfo2.gardenBuff
			uiManager:show("MailManorRecount", nil)
		end
	end
	if isShowRight then
		if not self.gardenRightHead then
			self.fields.head_right1:setURL("ui://mailView/Com_Mail_Head")
			self.gardenRightHead = self.fields.head_right1:getComponent()
		end
		self.gardenRightHead:setIcon("icon_mail_manor.png")
		self.gardenRightHead:setTitle(rightData.gardenLv)
		self.fields.Text_Title_right:setString(i18n("mail_2_text_98"))
		function self.rightDetailCallback()
			_ENV = nil
			;(nil).gardenData = data.playerInfo1.gardenBuff
			uiManager:show("MailManorRecount", nil)
		end
	end
end
function Com_Mail_ItemDetailFight:onClick_Button_left(context)
	SoraDPlaySound()
	if self.leftDetailCallback then
		self.leftDetailCallback()
	end
end
function Com_Mail_ItemDetailFight:onClick_Button_right(context)
	SoraDPlaySound()
	if self.rightDetailCallback then
		self.rightDetailCallback()
	end
end
return Com_Mail_ItemDetailFight
