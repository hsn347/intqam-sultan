local playerNameBox = class("playerNameBox", function(target)
	if target == nil then
		return display.newNode()
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function playerNameBox:ctor()
	self.imgGMWidth = 54
	self.imgGMHeight = 32
	self.imgGMPosY = -3
	self.spriteVip = SoraDSetVipImage(1)
	self.spriteVip:setAnchorPoint(SoraDFAP(0, 0))
	self.spriteVip:setPosition(cc.p(115, 0))
	self.spriteVip:addTo(self)
	_ENV = self.spriteVip
	self.spriteVip.text = ""
	self.spriteVip.size = 20
	self.spriteVip.color = cc.c3b(48, 47, 47)
	self.spriteVip.align = SoraDFLabelR()
	self.spriteVip.valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
	self.spriteVip.x = 0
	self.spriteVip.y = 0
	self.textPlayerName = display.newTTFLabel(self.spriteVip)
	self.textPlayerName:setAnchorPoint(SoraDFAP(0, 0))
	self.textPlayerName:addTo(self)
	self.itemWidth = 300
	self.itemHeight = 25
end
function playerNameBox:getItemWidth()
	return self.itemWidth
end
function playerNameBox:getItemHeight()
	return self.itemHeight
end
function playerNameBox:initWithData(data)
	local isVip = data.isVip
	local vipLv = data.vipLv or 0
	local name = data.name
	local align = data.align
	local isGM = data.isGM
	local kid = data.kid
	local gametop = gModuleMgr.getObject("gametop")
	local currentKid = gametop.playertop_:getKingdomID()
	if kid ~= nil and kid ~= currentKid then
		name = name .. "#" .. kid
	end
	self:hideVipParticle()
	self:hideGM()
	self.spriteVip:setVisible(false)
	self.itemWidth = 0
	if isVip == nil or isVip == false then
		if isGM == true then
			self:showGM()
			self.textPlayerName:setString(name)
			local nameWidth = self.textPlayerName:getContentSize().width
			self.itemWidth = self.itemWidth + nameWidth
			self.itemWidth = self.itemWidth + self.imgGMWidth
			self.textPlayerName:setAnchorPoint(SoraDFAP(0, 0))
			self.textPlayerName:setPosition(SoraDFPoint(0, 0, self.itemWidth))
			self.spriteGM:setAnchorPoint(SoraDFAP(0, 0))
			self.spriteGM:setPosition(SoraDFPoint(nameWidth, self.imgGMPosY, self.itemWidth))
		else
			self.spriteVip:setVisible(false)
			self.textPlayerName:setString(name)
			local nameWidth = self.textPlayerName:getContentSize().width
			self.itemWidth = nameWidth
			self.textPlayerName:setAnchorPoint(SoraDFAP(0, 0))
			self.textPlayerName:setPosition(SoraDFPoint(0, 0, self.itemWidth))
		end
	elseif isGM == true then
		self:showGM()
		self.textPlayerName:setString(name)
		self.spriteVip:setVisible(true)
		SoraDSetVipImage(vipLv, self.spriteVip)
		self:showVipParticle(self.spriteVip, vipLv)
		local nameWidth = self.textPlayerName:getContentSize().width
		nameWidth = nameWidth + 5
		self.itemWidth = self.itemWidth + nameWidth
		local vipWidth = self.spriteVip:getContentSize().width * self.spriteVip:getScaleX()
		self.itemWidth = self.itemWidth + vipWidth
		self.itemWidth = self.itemWidth + self.imgGMWidth
		self.spriteVip:setPosition(SoraDFPoint(nameWidth, 0, self.itemWidth))
		self.textPlayerName:setAnchorPoint(SoraDFAP(0, 0))
		self.textPlayerName:setPosition(SoraDFPoint(0, 0, self.itemWidth))
		self.spriteGM:setAnchorPoint(SoraDFAP(0, 0))
		self.spriteGM:setPosition(SoraDFPoint(nameWidth + vipWidth - 10, self.imgGMPosY, self.itemWidth))
	else
		self.textPlayerName:setString(name)
		SoraDSetVipImage(vipLv, self.spriteVip)
		self:showVipParticle(self.spriteVip, vipLv)
		self.spriteVip:setVisible(true)
		local nameWidth = self.textPlayerName:getContentSize().width
		nameWidth = nameWidth + 5
		self.itemWidth = self.itemWidth + nameWidth
		self.itemWidth = self.itemWidth + self.spriteVip:getContentSize().width * self.spriteVip:getScaleX()
		self.spriteVip:setPosition(SoraDFPoint(nameWidth, 0, self.itemWidth))
		self.textPlayerName:setAnchorPoint(SoraDFAP(0, 0))
		self.textPlayerName:setPosition(SoraDFPoint(0, 0, self.itemWidth))
	end
end
function playerNameBox:showVipParticle(text_vip, vipLv)
	text_vip = SoraDGetVIPEffectByLv(text_vip, vipLv)
end
function playerNameBox:hideVipParticle()
	_UPVALUE6_ = nil
	;(nil)[1] = "vip_particle_8"
	;(nil)[2] = "vip_particle_9"
	;(nil)[3] = "vip_particle_e"
	;(nil)[4] = "vip_particle_l"
	;(nil)[5] = "effect_vip_bling_bg"
	local (nil)[6], tableParticleName = "effect_vip_bling_top", nil
	for i, v in ipairs(tableParticleName) do
		local particleNode = SoraDGetChildByName(self.spriteVip, v)
		if particleNode then
			particleNode:setVisible(false)
		end
	end
end
function playerNameBox:showGM()
	if self.spriteGM then
		self.spriteGM:setVisible(true)
	else
		self.spriteGM = display.newSprite("#" .. "icon_chat_gm.png")
		self.spriteGM:addTo(self)
		self.spriteGM:setAnchorPoint(SoraDFAP(0, 0))
		self.spriteGM:setPosition(cc.p(115, 0))
	end
end
function playerNameBox:hideGM()
	if self.spriteGM then
		self.spriteGM:setVisible(false)
	end
end
return playerNameBox
