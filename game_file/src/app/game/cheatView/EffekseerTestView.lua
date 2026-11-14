local EffekseerTestView = class("EffekseerTestView", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("commonTestView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function EffekseerTestView:ctor()
	self.isHideCurrentSceneView = true
	self:createUI()
	self.Top_Size_Tile_Image_bg = SoraDGetChildByName(self, "Top_Size_Tile_Image_bg")
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.commonFramTitle_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self:init()
end
function EffekseerTestView:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function EffekseerTestView:init(data)
	self:testBone()
end
function EffekseerTestView:testParticle()
	local emitter = cc.EffectEmitter:create("Laser01.efk")
	emitter:setPlayOnEnter(true)
	emitter:setIsLooping(true)
	emitter:setRotation3D(cc.vec3(0, 90, 0))
	emitter:setPosition(cc.p(320, 300))
	emitter:setScale(14)
	self:addChild(emitter, 2)
end
function EffekseerTestView:testBone()
	self.curYAngle = 0
	self.node_pet = ccui.Layout:create()
	self.node_pet:addTo(self, -1)
	self.node_pet:setLocalZOrder(1)
	self.node_pet:setPosition(cc.p(320, display.height - 450))
	self.panel_pet = ccui.Layout:create()
	self.panel_pet:setAnchorPoint(cc.p(0.5, 0))
	self.panel_pet:setPosition(cc.p(320, display.height - 578))
	self.panel_pet:addTo(self, 0)
	self.panel_pet:setContentSize(cc.size(500, 400))
	self.panel_pet:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
	self.panel_pet:setBackGroundColor(cc.c3b(128, 128, 128))
	self.panel_pet:setOpacity(120)
	self.panel_pet:setTouchEnabled(true)
	self.panel_pet:addTouchEventListener(handler(self, self.onLayoutItem))
	self:loadEagle()
end
function EffekseerTestView:loadEagle()
	local petDesRead = include("petDesRead")
	local petEagleCfg = petDesRead.getPetCfg(1253, 4)
	dump(petEagleCfg, "老鹰配置", 10)
	self.curYAngle = 0
	local filePath = petEagleCfg.file
	filePath = "3d/pet/eagle/et_eagle04.c3b"
	local x = 320
	local y = 650
	local sprite = cc.Sprite3D:create(filePath)
	sprite:setScale(4)
	_ENV = 4
	;(4).x = 0
	;(4).y = 0
	;(4).z = 0
	sprite:setRotation3D(4)
	_ENV = 4
	;(4).x = 0
	;(4).y = 0
	;(4).z = 0
	sprite:setPosition3D(4)
	sprite:addTo(self.node_pet, 1)
	local spriteImg = display.newSprite("#chat_icon_red_white_grid.png")
	spriteImg:addTo(self.node_pet, 3)
	spriteImg:setLocalZOrder(10)
	spriteImg:setPosition(cc.p(0, 60))
	local rankBg = "chat_icon_red_white_grid.png"
	local img_bg = ccui.ImageView:create()
	img_bg:loadTexture(rankBg, ccui.TextureResType.plistType)
	img_bg:addTo(self, 10)
	img_bg:setScale(1)
	img_bg:setPosition(cc.p(320, display.height - 450))
	local animation = cc.Animation3D:create(filePath)
	if nil ~= animation then
		print("idle: start = " .. petEagleCfg.idle.startFrame .. ", end = ", petEagleCfg.idle.endFrame)
		print("动画时长: = ", animation:getDuration())
		local animate = cc.Animate3D:createWithFrames(animation, 0, 85)
		animate:setSpeed(0.8)
		sprite:runAction(cc.RepeatForever:create(animate))
	end
	sprite:setCullFaceEnabled(false)
	self.sprite_animal = sprite
	print("bone Bip001 Spine", sprite:getAttachNode("Bip001 Spine"))
	local attachNode = sprite:getAttachNode("Bip001 Spine")
	local emitter = cc.EffectEmitter:create("Laser01.efk")
	emitter:setPlayOnEnter(true)
	emitter:setIsLooping(true)
	emitter:setRotation3D(cc.vec3(0, 90, 0))
	emitter:setPosition(cc.p(0, 0))
	emitter:setScale(14)
	attachNode:addChild(emitter)
end
function EffekseerTestView:onLayoutItem(target, event)
	if event == ccui.TouchEventType.ended then
		self.curYAngle = self.sprite_animal:getRotation3D().y
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = math.abs(touchmovePoint.x - touchBeganPoint.x)
		local degree = distance / 320 * 270
		if touchmovePoint.x - touchBeganPoint.x < 0 then
			degree = -degree
		end
		if math.abs(degree) > 1 and self.sprite_animal then
			_ENV = nil
			;(nil).x = 0
			;(nil).y = self.curYAngle + degree
			;(nil).z = 0
			self.sprite_animal:setRotation3D(nil)
		end
	elseif event == ccui.TouchEventType.canceled then
		self.curYAngle = self.sprite_animal:getRotation3D().y
	elseif event == ccui.TouchEventType.began then
	end
end
return EffekseerTestView
