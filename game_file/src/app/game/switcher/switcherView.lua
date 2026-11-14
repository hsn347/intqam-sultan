local switcherView = class("switcherView", function(params)
	local baseView = include("baseView")
	local switcherView = baseView.new(display.realSize, false)
	return switcherView
end)
_ENV, _ENV = function(params)
	local baseView = include("baseView")
	local switcherView = baseView.new(display.realSize, false)
	return switcherView
end, "switcherView"
;(function(params)
	local baseView = include("baseView")
	local switcherView = baseView.new(display.realSize, false)
	return switcherView
end).bg = "#switcher_bg.png"
;(function(params)
	local baseView = include("baseView")
	local switcherView = baseView.new(display.realSize, false)
	return switcherView
end).bgex = "#switcher_bg_ex.png"
;(function(params)
	local baseView = include("baseView")
	local switcherView = baseView.new(display.realSize, false)
	return switcherView
end).title = "#switcher_bg_title_en.png"
;(function(params)
	local baseView = include("baseView")
	local switcherView = baseView.new(display.realSize, false)
	return switcherView
end).scale = 0.7
;(function(params)
	local baseView = include("baseView")
	local switcherView = baseView.new(display.realSize, false)
	return switcherView
end).yOffset = 380
_ENV, ("switcherView").en, (function(params)
	local baseView = include("baseView")
	local switcherView = baseView.new(display.realSize, false)
	return switcherView
end).yOffsetex = function(params)
	local baseView = include("baseView")
	local switcherView = baseView.new(display.realSize, false)
	return switcherView
end, function(params)
	local baseView = include("baseView")
	local switcherView = baseView.new(display.realSize, false)
	return switcherView
end, 190
;(function(params)
	local baseView = include("baseView")
	local switcherView = baseView.new(display.realSize, false)
	return switcherView
end).bg = "#switcher_bg.png"
;(function(params)
	local baseView = include("baseView")
	local switcherView = baseView.new(display.realSize, false)
	return switcherView
end).bgex = "#switcher_bg_ex.png"
;(function(params)
	local baseView = include("baseView")
	local switcherView = baseView.new(display.realSize, false)
	return switcherView
end).title = "#switcher_bg_title_arab.png"
;(function(params)
	local baseView = include("baseView")
	local switcherView = baseView.new(display.realSize, false)
	return switcherView
end).scale = 0.7
;(function(params)
	local baseView = include("baseView")
	local switcherView = baseView.new(display.realSize, false)
	return switcherView
end).yOffset = 340
_ENV, _ENV, ("switcherView").ar, (function(params)
	local baseView = include("baseView")
	local switcherView = baseView.new(display.realSize, false)
	return switcherView
end).yOffsetex = nil, function(params)
	local baseView = include("baseView")
	local switcherView = baseView.new(display.realSize, false)
	return switcherView
end, function(params)
	local baseView = include("baseView")
	local switcherView = baseView.new(display.realSize, false)
	return switcherView
end, 180
local resConfig = "switcherView"
;(nil).bg = "#switcher_bg_pre.png"
;(nil).bgex = "#switcher_bg_ex_pre.png"
;(nil).title = "#switcher_bg_title_en_normal.png"
;(nil).yOffset = 310
_ENV, (function(params)
	local baseView = include("baseView")
	local switcherView = baseView.new(display.realSize, false)
	return switcherView
end).en, (nil).yOffsetex = nil, nil, 160
;(nil).bg = "#switcher_bg_pre.png"
;(nil).bgex = "#switcher_bg_ex_pre.png"
;(nil).title = "#switcher_bg_title_arab_normal.png"
;(nil).yOffset = 330
_ENV, (function(params)
	local baseView = include("baseView")
	local switcherView = baseView.new(display.realSize, false)
	return switcherView
end).ar, (nil).yOffsetex = nil, nil, 200
local function resPreConfig(params)
	local baseView = include("baseView")
	local switcherView = baseView.new(display.realSize, false)
	return switcherView
end
;(nil).borderWidth = 0
;(nil).fillColor = cc.c4f(1, 1, 1, 1)
local (nil).borderColor, shapparams = cc.c4f(0, 0, 0, 1), nil
function switcherView:ctor(params)
	local showType = SoraDFIsRA() and "ar" or "en"
	local cfg = resPreConfig[showType]
	if RAMADAN_SWITCH then
		cfg = resConfig[showType]
	end
	self:setPosition(cc.p(display.cx, display.rcy))
	self.viewName = "switcherView"
	self:setName(self.viewName)
	self.size = self:getContentSize()
	self.backColor = cc.c3b(203, 177, 127)
	self.index = 1
	self.isStartAction = false
	self.dir = 0
	if display.rheight <= 960 then
		self.img_bg = display.newSprite(cfg.bgex)
		self.img_bg:setPosition(0, math.abs(960 - display.rheight) / 2)
	else
		self.img_bg = display.newSprite(cfg.bg)
		self.img_bg:setPosition(0, math.abs(1386 - display.rheight) / 2)
	end
	local bgHeight = math.max(display.rheight, 1386)
	self.img_bg:setScaleY(bgHeight / 1386)
	self.img_bg:setAnchorPoint(cc.p(0.5, 1))
	self.imgWidth = self.img_bg:getContentSize().width
	self.imgHeight = self.img_bg:getContentSize().height
	self.img_title = display.newSprite(cfg.title)
	self.img_title:setAnchorPoint(cc.p(0.5, 1))
	if cfg.scale then
		self.img_title:setScale(cfg.scale or 1)
	end
	local offset = self.imgHeight - cfg.yOffset
	if display.rheight <= 960 then
		offset = self.imgHeight - cfg.yOffsetex
	end
	self.img_title:setPosition(cc.p(self.imgWidth / 2, offset))
	self.img_title:addTo(self.img_bg, 2)
	resConfig, _UPVALUE4_ = self.img_title, self.img_title.addTo
	resConfig, self.img_title[1] = 0, 0
	resConfig, self.img_title[2] = 0, 0
	resConfig, (0)[1] = 0, 0
	resConfig, (0)[2] = 0, 0
	resConfig, (0)[1] = 0, 0
	resConfig, (0)[2] = 0, 0
	;(0)[1] = 0
	;(0)[2] = 0
	self.img_title.addTo[1] = self.img_title
	self.img_title.addTo[2] = 0
	self.img_title.addTo[3] = 0
	local self.img_title.addTo[4], points = 0, self.img_title.addTo
	local shapNode = display.newPolygon(points, shapparams)
	self.cliperNode = cc.ClippingNode:create()
	self.cliperNode:setStencil(shapNode)
	self.cliperNode:setInverted(false)
	self.shapNode = shapNode
	self.cliperNode:setAnchorPoint(cc.p(0.5, 1))
	self.cliperNode:setPosition(cc.p(display.cx, display.rheight))
	self.cliperNode:addChild(self.img_bg)
	self.cliperNode:addTo(self, 5)
	self.spriteRoller = display.newSprite("#switcher_01.png")
	self.spriteRoller:setAnchorPoint(cc.p(0.5, 1))
	self.spriteRoller:setPosition(cc.p(display.cx, display.rheight))
	self.spriteRollerHeight = self.spriteRoller:getContentSize().height
	self:addChild(self.spriteRoller, 5)
	if params and params.kingdomClass then
		self:setKingdomClassTips(params.kingdomClass, params.kingdomID)
	end
	SoradCreateTimer(self, handler(self, self.update), true)
end
function switcherView:update(dt)
	if not self or tolua.isnull(self) then
		return
	end
	if self.isStartAction == false then
		return
	end
	if not self.spriteRoller or tolua.isnull(self.spriteRoller) then
		self.isStartAction = false
		return
	end
	local curHeight = self.spriteRoller:getPositionY()
	local cutHeight = curHeight - display.rheight
	if self.shapNode and not tolua.isnull(self.shapNode) then
		_ENV, _UPVALUE4_ = self.shapNode, tolua.isnull(self.shapNode)
		self.shapNode.x = -self.imgWidth / 2
		_ENV, self.shapNode.y = -self.imgWidth / 2, 0
		;(-self.imgWidth / 2).x = self.imgWidth / 2
		_ENV, (-self.imgWidth / 2).y = self.imgWidth / 2, 0
		;(self.imgWidth / 2).x = self.imgWidth / 2
		_ENV, (self.imgWidth / 2).y = self.imgWidth / 2, cutHeight
		;(self.imgWidth / 2).x = -self.imgWidth / 2
		;(self.imgWidth / 2).y = cutHeight
		tolua.isnull(self.shapNode)[1] = self.shapNode
		tolua.isnull(self.shapNode)[2] = -self.imgWidth / 2
		tolua.isnull(self.shapNode)[3] = self.imgWidth / 2
		local tolua.isnull(self.shapNode)[4], points = self.imgWidth / 2, tolua.isnull(self.shapNode)
		self.shapNode:clear()
		self.shapNode:drawPolygon(points, shapparams)
	end
	local curOpcity = 255 * self.index / 40
	if curOpcity < 0 then
		curOpcity = 0
	elseif 255 < curOpcity then
		curOpcity = 255
	end
	self:setBackGround(math.min(255, curOpcity), self.backColor)
	local index = math.abs((self.index + 1) % 5)
	if index == 0 then
		index = 5
	end
	if curHeight > self.spriteRollerHeight and not tolua.isnull(self.spriteRoller) then
		self.spriteRoller:setSpriteFrame(string.format("switcher_%02d.png", index))
		self.index = self.index + self.dir
	end
	if self.dir == 1 and curHeight <= self.spriteRollerHeight or self.dir == -1 and curHeight >= display.rheight + self.spriteRollerHeight then
		self.isStartAction = false
		return
	end
end
function switcherView:showSwitcher(parent)
	parent = parent or display.getRunningScene()
	parent:addChild(self, 200)
	self.dir = 1
	self.isStartAction = true
	self.spriteRoller:runAction(cca.moveTo(0.3, display.cx, self.spriteRollerHeight))
	AudioEngine.stopMusic()
	SoraDPlaySound("worldmap", 1)
end
function switcherView:showSwitcherInUncharted(parent)
	parent = parent or display.getRunningScene()
	parent:addChild(self, 5)
	self.dir = 1
	self.isStartAction = true
	self.spriteRoller:runAction(cca.moveTo(0.3, display.cx, self.spriteRollerHeight))
end
function switcherView:closeSwitcher()
	self.dir = -1
	self.isStartAction = true
	_UPVALUE2_ = nil
	;(nil)[1] = cca.moveTo(0.4, display.cx, display.rheight + self.spriteRollerHeight)
	;(nil)[2] = cca.delay(0.1)
	;(nil)[3] = cca.callFunc(function()
		self:stepOnGuid()
		self:removeFromParent()
	end)
	;(nil)[4] = cca.callFunc(function()
		self:stepOnGuid()
		self:removeFromParent()
	end)
	;(nil)[5] = cca.callFunc(function()
		self:stepOnGuid()
		self:removeFromParent()
	end)
	local seq = transition.sequence(nil)
	self.spriteRoller:runAction(seq)
	SoraDPlaySound("worldmap", 16)
end
function switcherView:setKingdomClassTips(kingdomClass, kingdomID)
	if not self.txtWarTips then
		local node = display.newNode()
		node:setPositionY(-display.rheight * 0.5)
		self.cliperNode:addChild(node, 100)
		local img_bg = display.newSprite("#frame_login_text.png")
		img_bg:addTo(node)
		_ENV = img_bg
		img_bg.text = ""
		img_bg.color = cc.c3b(239, 129, 19)
		img_bg.size = 24
		local text = display.newTTFLabel(img_bg)
		text:setAnchorPoint(cc.p(0.5, 0.5))
		text:addTo(node, 2)
		self.txtWarTips = text
	end
	if self.txtWarTips then
		local worldMapWarDef = include("worldMapWarDef")
		local strTips = worldMapWarDef.getKingdomClassTips(kingdomClass, kingdomID) or "common_text_3318"
		self.txtWarTips:setString(i18n(strTips))
	end
end
function switcherView:stepOnGuid()
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_GUIDE_STEP_ON"
	;(nil).step = 2026
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_GUIDE_STEP_ON"
	;(nil).step = 2035
	SoraDSendMessage(nil)
	if SoraDCurrentSceneShowView("worldMapView") then
		print("刷新外城弱引导")
		gModuleMgr.sharedMgr("mildGuideManager"):updatePanelShow("worldMapView")
	elseif SoraDCurrentSceneShowView("mainCityView") then
		print("刷新内城弱引导")
		gModuleMgr.sharedMgr("mildGuideManager"):updatePanelShow("mainCityView")
		local gametop = gModuleMgr.getObject("gametop")
		local guideCtrl = gametop.playertop_:getModule("guideCtrl")
		local princeGiftCtrl = gametop.playertop_:getModule("princeGiftCtrl")
		local cityBuildFunction = include("cityBuildFunction")
		if not princeGiftCtrl:isGuideFinish() then
			cityBuildFunction:checkPopUnlockPrinceGift()
		end
	end
end
return switcherView
