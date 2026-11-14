local baseComponent = require("fgui.base.baseComponent")
local Com_head = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonNew/Com_head", Com_head)
fgui.register_extension("ui://CommonNew/Com_headFrame", Com_head)
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
function Com_head:onInit()
	self:addClickListener(handler(self, self.onTouchHeadBack))
	self.imgAvatarFrame = self.fields.Load_avatarFrame
	if self.imgAvatarFrame then
		self.imgAvatarFrame:setVisible(false)
	end
end
function Com_head:onShow()
end
function Com_head:setSelfHead()
	self:setHeadSprite()
	self:setPlayerID()
	if self.imgAvatarFrame then
		local dressCtrl = SoraDGetCtrl("dressCtrl")
		local avatarFrameId = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_FRAME)
		self:setAvatarFrame(avatarFrameId)
	end
end
function Com_head:setHeadSprite(imageId, avatar)
	local info = lordInfoCtrl:getHeadInfo()
	local imageId = imageId or info.imageId
	local avatar = avatar or info.avatar
	if type(imageId) == "number" then
		SoraDGetHeadFromManager(self.fields.Load_head, imageId, avatar)
	elseif type(imageId) == "string" then
		self.fields.Load_head:setURL(imageId)
	end
	self.fields.Load_head:setVisible(true)
end
function Com_head:setAvatarFrame(avatarFrameId)
	if not self.imgAvatarFrame then
		return
	end
	if not avatarFrameId then
		self.imgAvatarFrame:setVisible(false)
		return
	end
	local chatSkinRead = include("chatSkinRead")
	local cfg = chatSkinRead.getAvatarFrameCfg(avatarFrameId)
	if not cfg then
		avatarFrameId = chatSkinRead.getHeadIDByCid(avatarFrameId)
		cfg = chatSkinRead.getAvatarFrameCfg(avatarFrameId)
	end
	if not cfg then
		self.imgAvatarFrame:setVisible(false)
		return
	end
	self.imgAvatarFrame:setVisible(true)
	self.imgAvatarFrame:setURL(cfg.img)
end
function Com_head:setImage(image, touch)
	local touch = touch or true
	self:setTouchEnabled(touch)
	self.fields.Load_head:setVisible(true)
	self.fields.Load_head:setURL(image)
end
function Com_head:setPlayerID(id)
	local id = id or gametop.playertop_:getPlayerID()
	self.playerID = id
end
function Com_head:setKid(kid)
	self.kid = kid
end
function Com_head:setHandle(handle)
	self.handle = handle
end
function Com_head:onTouchHeadBack(button, event)
	SoraDPlaySound()
	print("==Com_head:onTouchHeadBack==")
	if self.handle then
		self.handle()
	elseif self.playerID then
		_ENV = "==Com_head:onTouchHeadBack=="
		;("==Com_head:onTouchHeadBack==").msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
		;("==Com_head:onTouchHeadBack==").playerID = self.playerID
		;("==Com_head:onTouchHeadBack==").kid = self.kid
		SoraDSendMessage("==Com_head:onTouchHeadBack==")
	end
end
function Com_head:getLoadHead(...)
	return self.fields.Load_head
end
return Com_head
