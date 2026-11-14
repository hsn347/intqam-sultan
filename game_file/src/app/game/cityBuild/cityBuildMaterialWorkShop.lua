local gametop = gModuleMgr.getObject("gametop")
local cityBuildViewDef = include("cityBuildViewDef")
local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildMaterialWorkShop = class("cityBuildMaterialWorkShop", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildMaterialWorkShop:ctor()
	self:setBuildIndex(cityBuildConstDef.buildIndexDef.index_Material_WorkShop)
	self.bid = BUILDID.MATERIAL_WORKSHOP
	self:addCheAnimation()
end
function cityBuildMaterialWorkShop:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_MATERIAL_WORKSHOP_VIEW", handler(self, self.msgUpdateView))
	self:updateView()
end
function cityBuildMaterialWorkShop:loadView()
	self:loadBaseView()
end
function cityBuildMaterialWorkShop:msgUpdateView(target, data)
	print("接收到消息 MESSAGE_MAINCITYVIEW_UPDATE_MATERIAL_WORKSHOP_VIEW")
	self:updateView()
end
function cityBuildMaterialWorkShop:updateView()
	self:updateIsLock()
	self:updateActivity()
end
function cityBuildMaterialWorkShop:addCheAnimation()
	local fengche = display.newSprite("#gongfangfengche_01.png")
	fengche:setPosition(cc.p(86, 40))
	fengche:addTo(self, 5)
	local frames = display.newFrames("gongfangfengche_%.2d.png", 1, 8)
	local animation = display.newAnimation(frames, 1 / #frames)
	fengche:playAnimationForever(animation, 0)
	local shuiche = display.newSprite("#gongfangshuiche_01.png")
	shuiche:setPosition(cc.p(10, 100))
	shuiche:addTo(self, -1)
	local frames = display.newFrames("gongfangshuiche_%.2d.png", 1, 7)
	local animation = display.newAnimation(frames, 1 / #frames)
	shuiche:playAnimationForever(animation, 0)
end
function cityBuildMaterialWorkShop:showAnimWorkingSpecific()
	local runIconAction = function(node)
		node:stopAllActions()
		local zFrame = 80
		local deltaY = 45
		local delay = 0.1
		_UPVALUE1_ = nil
		;(nil)[1] = cc.EaseOut:create(cca.moveBy(90 / zFrame, 0, deltaY), 1.0)
		;(nil)[2] = cc.EaseOut:create(cca.moveBy(110 / zFrame, 0, -deltaY), 1.0)
		;(nil)[3] = cc.EaseOut:create(cca.moveBy(110 / zFrame, 0, -deltaY), 1.0)
		;(nil)[4] = cc.EaseOut:create(cca.moveBy(110 / zFrame, 0, -deltaY), 1.0)
		;(nil)[5] = cc.EaseOut:create(cca.moveBy(110 / zFrame, 0, -deltaY), 1.0)
		;(nil)[6] = cc.EaseOut:create(cca.moveBy(110 / zFrame, 0, -deltaY), 1.0)
		;(nil)[7] = cc.EaseOut:create(cca.moveBy(110 / zFrame, 0, -deltaY), 1.0)
		local seq = cca.seq(nil)
		node:runAction(cca.repeatForever(seq))
	end
	local aid, acount = self:getTrainingAidAndCount()
	if aid ~= nil then
		local itemDesRead = include("itemDesRead")
		local iconName = itemDesRead.getBIcon(aid)
		if iconName ~= nil then
			if self.materialIcon then
				self.materialIcon:setSpriteFrame(iconName)
				self.materialIcon:setVisible(true)
				self.materialIcon:setScale(0.8)
				self.materialIcon:setPosition(cc.p(0, 30))
				runIconAction(self.materialIcon)
			else
				self.materialIcon = display.newSprite("#" .. iconName)
				self.materialIcon:setScale(0.8)
				self.materialIcon:addTo(self, 5)
				self.materialIcon:setPosition(cc.p(0, 30))
				runIconAction(self.materialIcon)
			end
		end
	end
end
function cityBuildMaterialWorkShop:hideAnimWorkingSpecific()
	if self.materialIcon then
		self.materialIcon:setVisible(false)
	end
end
function cityBuildMaterialWorkShop:updateActivity()
	local isLocked = self:getIsLocked()
	if isLocked then
		return
	end
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	if self.hideEffectActivity then
		self:hideEffectActivity()
	end
end
function cityBuildMaterialWorkShop:showEffectActivity()
	local et_node = self:getChildByName("et_Activity")
	if et_node then
		et_node:setVisible(true)
		return
	end
	_ENV, _ENV = et_node, et_node.setVisible
	_ENV, et_node.plist = true, "et_gangklingqu_display_01.plist"
	;(true).x = 3
	_ENV, et_node.pos, (true).y = true, true, 20
	;(true).x = 1.0
	et_node.scale, (true).y = true, 1.0
	_ENV, et_node.setVisible[1], et_node.rotate = et_node, et_node, 0
	_ENV, et_node.plist = true, "et_gangklingqu_display_02.plist"
	;(true).x = 0
	_ENV, et_node.pos, (true).y = true, true, 20
	;(true).x = 1.0
	et_node.scale, (true).y = true, 1.0
	et_node.setVisible[2], et_node.rotate = et_node, 0
	local param = et_node.setVisible
	local et_node = SoraDCreateEffectNode(param)
	et_node:setName("et_Activity")
	et_node:setScale(1.8)
	et_node:addTo(self, 3)
end
function cityBuildMaterialWorkShop:hideEffectActivity(isRemove)
	local et_node = self:getChildByName("et_Activity")
	if et_node then
		et_node:setVisible(false)
		if isRemove then
			et_node:removeFromParent()
		end
	end
end
return cityBuildMaterialWorkShop
