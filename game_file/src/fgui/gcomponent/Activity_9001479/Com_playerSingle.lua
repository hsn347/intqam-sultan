local lordLocalData = include("lordLocalData")
local baseComponent = require("fgui.base.baseComponent")
local Com_playerSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001479/Com_playerSingle", Com_playerSingle)
function Com_playerSingle:onInit()
	self.fields.Image_bust:addClickListener(handler(self, self.onTouchHeadBack))
end
function Com_playerSingle:onShow()
end
function Com_playerSingle:onTouchHeadBack(EventContext)
	SoraDPlaySound()
	if self.handle then
		self.handle()
	elseif self.data then
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
		;(nil).playerID = self.data.uid
		;(nil).kid = self.data.kid
		SoraDSendMessage(nil)
	end
end
function Com_playerSingle:initData(rank, data)
	self.data = data
	self.fields.Text_rank:setString(rank)
	if data then
		self.controllers.c_someone:setSelectedIndex(0)
		_ENV = nil
		;(nil).kingdomName = data.nickName
		;(nil).kid = data.kid
		self.fields.Text_name:setString(i18n("Nebula_Competition_text_06", nil))
		_ENV = i18n("Nebula_Competition_text_06", nil)
		i18n("Nebula_Competition_text_06", nil).num = string.formatnumberthousands(data.score)
		self.fields.Text_score:setString(i18n("common_text_2556", i18n("Nebula_Competition_text_06", nil)))
		self.fields.Image_bust:setURL(lordLocalData.getBust(data.headid))
		self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
		self.fields.Com_head:setPlayerID(data.uid)
		self.fields.Com_head:setKid(data.kid)
	else
		self.controllers.c_someone:setSelectedIndex(1)
		self.fields.Text_noData:setString(i18n("common_text_480"))
		local defaultId = 1401
		self.fields.Image_bust:setURL(lordLocalData.getBust(defaultId))
		self.fields.Com_head:setHeadSprite(defaultId)
	end
end
return Com_playerSingle
