local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local UI_Com_head = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Com_head", UI_Com_head)
function UI_Com_head:onInit()
	self.fields.Load_avatarFrame:setVisible(false)
	self:addClickListener(handler(self, self.onTouchHeadBack))
end
function UI_Com_head:onShow()
end
function UI_Com_head:setSelfHead(isShowDress)
	self:setHeadSprite()
	self:setPlayerID()
	if isShowDress then
		local dressCtrl = SoraDGetCtrl("dressCtrl")
		local avatarFrameId = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_FRAME)
		self:setAvatarFrame(avatarFrameId)
	end
end
function UI_Com_head:setHeadSprite(imageId, avatar)
	local info = lordInfoCtrl:getHeadInfo()
	local imageId = imageId or info.imageId
	local avatar = avatar or info.avatar
	if type(imageId) == "number" then
		SoraDGetHeadFromManager(self.fields.Load_head, imageId, avatar)
	elseif type(imageId) == "string" then
		self.fields.Load_head:setSpriteFrame(imageId)
	end
	self.fields.Load_head:setVisible(true)
end
function UI_Com_head:setAvatarFrame(avatarFrameId)
	self.fields.Load_avatarFrame:setVisible(false)
	local chatSkinRead = include("chatSkinRead")
	local cfg = chatSkinRead.getAvatarFrameCfg(avatarFrameId)
	if not cfg then
		avatarFrameId = chatSkinRead.getHeadIDByCid(avatarFrameId)
		cfg = chatSkinRead.getAvatarFrameCfg(avatarFrameId)
	end
	if not cfg then
		self.fields.Load_avatarFrame:setVisible(false)
		return
	end
	self.fields.Load_avatarFrame:setVisible(true)
	self.fields.Load_avatarFrame:setSpriteFrame(cfg.img)
	local dressltCtrl = include("dressltCtrl")
	local fixCfg = dressltCtrl.getAvatarFrameCfg(cfg.index)
	if fixCfg then
		self.fields.Load_avatarFrame:setPositionY(50 - fixCfg.offsetY)
		self.fields.Load_avatarFrame:setScale(fixCfg.scale or 1)
	end
end
function UI_Com_head:setImage(image, touch)
	local touch = touch or true
	self:setTouchEnabled(touch)
	self.fields.Load_head:setVisible(true)
	self.fields.Load_head:setSpriteFrame(image)
end
function UI_Com_head:setPlayerID(id)
	self.playerID = id or SoraDGetPlayerID()
end
function UI_Com_head:setKid(kid)
	self.kid = kid
end
function UI_Com_head:setHandle(handle)
	self.handle = handle
end
function UI_Com_head:setBoard(ret)
	self.controllers.c1:setSelectedIndex(ret and 0 or 1)
end
function UI_Com_head:getLoadHead()
	return self.fields.Load_head
end
function UI_Com_head:onTouchHeadBack()
	SoraDPlaySound()
	if self.handle then
		self.handle()
	elseif self.playerID then
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
		;(nil).playerID = self.playerID
		;(nil).kid = self.kid
		SoraDSendMessage(nil)
	end
end
return UI_Com_head
