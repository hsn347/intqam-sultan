local publicRead = include("publicRead")
local djRead = include("djRead")
local djCtrl = SoraDGetCtrl("djCtrl")
local baseComponent = require("fgui.base.baseComponent")
local djChatTextNode = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://DjView/djChatTextNode", djChatTextNode)
function djChatTextNode:onInit()
	self.fields.Lab_monthVip:setVisible(false)
	self.fields.Lab_honor:setVisible(false)
	self:addClickListener(handler(self, self.onClick))
	self:fixChildrenPos()
end
function djChatTextNode:onShow()
end
function djChatTextNode:initData(data)
	self.data = data
	local textW = 600
	local djUid = djCtrl:getCurDJInfo().uid
	local isCurDJ = djUid == self.data.uid
	local monthVip = not isCurDJ and self.data.monthVip or 0
	local lifeVip = not isCurDJ and self.data.lifeVip or 0
	self.fields.Lab_monthVip:setVisible(0 < monthVip)
	self.fields.Lab_honor:setVisible(0 < lifeVip)
	if 0 < monthVip then
		self.fields.Lab_monthVip:initData(monthVip)
		textW = textW - 170
	end
	if 0 < lifeVip then
		local cfg = djRead.getLifeLvCfg(lifeVip)
		self.fields.Lab_honor:setTitle(i18n(cfg.nameLife))
		self.fields.Lab_honor:setIcon(cfg.picLife)
		self.fields.Lab_honor:setPositionX(SoraDFPosX(0 < monthVip and 450 or 620, 640))
		textW = textW - 120
	end
	self.fields.title:setWidth(textW)
	self.message = self.data.text or ""
	if self.data.text then
		local retStr = string.htmlspecialchars(self.data.text)
		retStr = RemoveStringSpecial(retStr)
		if self.data.nickName then
			local name = _p(self.data.nickName) .. _p(" #" .. self.data.kid .. ": ")
			local nameStr = fguiHelper.getColorString(isCurDJ and "#E2C53D" or "#00FFFF", name)
			self.fields.title:setString(nameStr .. retStr)
		else
			self.fields.title:setString(retStr)
		end
	elseif self.data.itemID and self.data.count then
		djCtrl = self.fields.title
		self.fields.title.name = ""
		self.fields.title.item = publicRead.getName(self.data.itemID)
		self.message = i18n("Anchor_text_97", self.fields.title)
		djCtrl = self.data.itemID
		self.data.itemID.name = self.data.nickName
		djCtrl = SoraDFPosX(0 < monthVip and 450 or 620, 640)
		SoraDFPosX(0 < monthVip and 450 or 620, 640).name = publicRead.getName(self.data.itemID)
		SoraDFPosX(0 < monthVip and 450 or 620, 640).count = self.data.count
		self.data.itemID.item = fguiHelper.getColorString("#E2C53D", i18n("pickup_star_028", SoraDFPosX(0 < monthVip and 450 or 620, 640)))
		self.fields.title:setString(i18n("Anchor_text_97", self.data.itemID))
	end
end
function djChatTextNode:onClick()
	if self.data.uid and self.data.uid ~= SoraDGetPlayerID() then
		SoraDPlaySound()
		if djCtrl:isDJAnchor() then
			_ENV = nil
			;(nil).uid = self.data.uid
			;(nil).message = self.message
			uiManager:show("DjAudienceManage", nil)
		else
			_ENV, _ENV = self.message
			self.message.bycomplainid = self.data.uid
			self.message.complainid = SoraDGetPlayerID()
			self.message.message = self.message
			self.message.serverid = self.data.kid
			self.message.chatChannel = gChatChannel.DJ
			self.message.complaintype = 6
			self.message.targetName = self.data.nickName
			;(nil).data, self.message.messagetime = self.message, serviceFunctions.systemTime()
			uiManager:show("chatReportView", nil)
		end
	end
end
return djChatTextNode
