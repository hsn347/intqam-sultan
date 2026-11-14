_ENV = nil
local (nil).vipLocalizedOn, _defaultParam = false, nil
local chatVipNode = class("chatVipNode", function(target)
	local target = include("chatBaseNode").new("chatVipNode")
	return target
end)
_ENV = "chatVipNode"
;("chatVipNode").height = 30
;("chatVipNode").width = 100
;("chatVipNode").vipScale = 0.85
local ("chatVipNode").padding_ar, _defaultParam = 2, "chatVipNode"
function chatVipNode:ctor()
	self.retainOnCache = true
	self.isDebug = gChatDebug
	self.spriteVip = SoraDSetVipImage(1)
	self.spriteVip:setAnchorPoint(cc.p(0, 0.5))
	self.spriteVip:addTo(self)
	self.spriteVip_ar = ccui.ImageView:create("icon_SVIP_word_01_ar.png.png", ccui.TextureResType.plistType)
	self.spriteVip_ar:setAnchorPoint(cc.p(0, 0.5))
	self.spriteVip_ar:setScale(_defaultParam.vipScale)
	self.spriteVip_ar:addTo(self)
	_ENV = self.spriteVip_ar
	self.spriteVip_ar.text = ""
	self.spriteVip_ar.font = "res/fonts/pve_fnt_title.fnt"
	self.spriteVip_ar.align = cc.TEXT_ALIGNMENT_CENTER
	self.spriteVip_ar.x = 0
	self.spriteVip_ar.y = 0
	self.spriteVip_ar_font = display.newBMFontLabel(self.spriteVip_ar)
	self.spriteVip_ar_font:setAnchorPoint(cc.p(1, 0.5))
	self.spriteVip_ar_font:addTo(self)
	self.spriteVip_ar_font:setScale(0.5)
	self.width = self.spriteVip:getContentSize().width
	self.height = self.spriteVip:getContentSize().height
	self.spriteVip:setPosition(cc.p(0, self.height / 2))
	self.spriteVip_ar_font:setPosition(cc.p(0, self.height / 2))
	self.spriteVip_ar:setPosition(cc.p(0, self.height / 2))
	self.isInit = false
end
function chatVipNode:reset()
	self:hideVipParticle()
end
function chatVipNode:init(data)
	if self.isInit == true then
		return
	end
	self.data = data
	self.vipLv = data.vipLv
	if data.isDebug ~= nil then
		self.isDebug = data.isDebug
	end
	local isVip = data.isVip
	local vipLv = data.vipLv or 0
	if isVip and 0 < vipLv then
		self:setVipImg(self.vipLv)
	end
	self:initDebugView()
end
function chatVipNode:setVipImg(vipLv)
	local isAR = SoraDFIsRA()
	if not _defaultParam.vipLocalizedOn then
		isAR = false
	end
	self.spriteVip:setVisible(not isAR)
	self.spriteVip_ar_font:setVisible(isAR)
	self.spriteVip_ar:setVisible(isAR)
	if isAR then
		local vipLocalData = include("vipLocalData")
		local vipNum, isSVip = vipLocalData:getVipNum(vipLv)
		local img = vipLocalData:getVipImg(vipLv)
		self.spriteVip_ar:loadTexture(img, ccui.TextureResType.plistType)
		self.spriteVip_ar:setScale(_defaultParam.vipScale)
		self.spriteVip_ar_font:setString(vipNum)
		self:showVipParticle(self.spriteVip_ar, vipLv)
		self.height = math.max(self.spriteVip_ar:getContentSize().height * _defaultParam.vipScale, self.spriteVip_ar_font:getContentSize().height)
		self.spriteVip_ar_font:setAnchorPoint(cc.p(0, 0.5))
		self.spriteVip_ar_font:setPositionX(0)
		_UPVALUE2_ = self.spriteVip_ar_font
		self.spriteVip_ar_font[1] = self.spriteVip_ar_font
		self.spriteVip_ar_font[2] = self.spriteVip_ar
		_defaultParam = self.spriteVip_ar
		self.spriteVip_ar[1] = _defaultParam.padding_ar
		local totalWidth = SoraDAlignNodeArray(self.spriteVip_ar_font, false, self.spriteVip_ar)
		self.width = totalWidth
		self.spriteVip_ar_font:setPositionY(self.height / 2)
		self.spriteVip_ar:setPositionY(self.height / 2)
		self:setContentSize(cc.size(self.width, self.height))
	else
		SoraDSetVipImage(vipLv, self.spriteVip)
		self:showVipParticle(self.spriteVip, vipLv)
		self.width = self.spriteVip:getContentSize().width
		self.height = self.spriteVip:getContentSize().height
		self.spriteVip:setPosition(cc.p(0, self.height / 2))
		self:setContentSize(cc.size(self.width, self.height))
	end
	self.isInit = true
	self:setTag(vipLv)
end
function chatVipNode:alignContent()
end
function chatVipNode:setIsDebug(isDebug)
	self.isDebug = isDebug
end
function chatVipNode:showVipParticle(text_vip, vipLv)
	SoraDGetVIPEffectByLv(text_vip, vipLv)
end
function chatVipNode:hideVipParticle()
	_UPVALUE6_ = nil
	;(nil)[1] = "vip_particle_8"
	;(nil)[2] = "vip_particle_9"
	;(nil)[3] = "vip_particle_e"
	;(nil)[4] = "vip_particle_l"
	;(nil)[5] = "effect_vip_bling_bg"
	local (nil)[6], tableParticleName = "effect_vip_bling_top", nil
	local isAR = SoraDFIsRA()
	if not _defaultParam.vipLocalizedOn then
		isAR = false
	end
	for i, v in ipairs(tableParticleName) do
		local particleNode
		if isAR then
			particleNode = SoraDGetChildByName(self.spriteVip_ar, v)
		else
			particleNode = SoraDGetChildByName(self.spriteVip, v)
		end
		if particleNode then
			particleNode:setVisible(false)
		end
	end
end
function chatVipNode:initDebugView()
	if not self.isDebug then
		return
	end
	if not self._debugNode then
		local drawNode = cc.DrawNode:create()
		drawNode:setName("debugNode")
		drawNode:addTo(self, 2)
		drawNode:setPosition(cc.p(0, 0))
		self._debugNode = drawNode
	end
	self._debugNode:clear()
	local lb = cc.p(0, 0)
	local lt = cc.p(0, self.height)
	local rt = cc.p(self.width, self.height)
	local rb = cc.p(self.width, 0)
	_UPVALUE4_ = self.width
	self.width[1] = lb
	self.width[2] = lt
	self.width[3] = rt
	local self.width[4], tbPoints = rb, self.width
	_UPVALUE4_ = rt
	rt[1] = lb
	rt[2] = lt
	rt[3] = rt
	rt[4] = rb
	self._debugNode:drawPoly(rt, 4, true, cc.c4f(0, 1, 0, 1))
end
function chatVipNode.measureSize(data, target)
end
return chatVipNode
