local masteryLockPopView = class("masteryLockPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("masteryLockPopView")
	end
	return target
end)
function masteryLockPopView:ctor()
	self:initWidget()
end
function masteryLockPopView:initWidget()
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	local effectNode = SoraDCreatAnimation("lockEffect", nil, false)
	effectNode:addTo(self.Center_Node)
	effectNode:setPosition(cc.p(320, 0))
	local Node_down = SoraDGetChildByName(effectNode, "Node_down")
	for i, v in ipairs(Node_down:getChildren()) do
		SoraDMixtureGLONE(v)
	end
	local Node_up = SoraDGetChildByName(effectNode, "Node_up")
	for i, v in ipairs(Node_up:getChildren()) do
		SoraDMixtureGLONE(v)
	end
	_UPVALUE1_ = ipairs(Node_up:getChildren())
	ipairs(Node_up:getChildren())[1] = "Node_build"
	self.Node_build = SoraDGetChildByFullPath(self.Center_Node, ipairs(Node_up:getChildren()))
	self.Node_build:removeFromParent()
	self.Node_build:addTo(SoraDGetChildByName(effectNode, "Node_build"))
	self.Node_build:setPosition(cc.p(0, 0))
	_UPVALUE1_ = cc.p(0, 0)
	cc.p(0, 0)[1] = "Image_build"
	self.Image_build = SoraDGetChildByFullPath(self.Node_build, cc.p(0, 0))
	_UPVALUE1_ = cc.p(0, 0)
	cc.p(0, 0)[1] = "Text_3"
	self.Text_build = SoraDGetChildByFullPath(self.Node_build, cc.p(0, 0))
	_UPVALUE1_ = cc.p(0, 0)
	cc.p(0, 0)[1] = "Text_4"
	SoraDGetChildByFullPath(self.Node_build, cc.p(0, 0)):setString(i18n("specialization_text_24"))
	self:setCloseCallBack(handler(self, self.exitView))
end
function masteryLockPopView:initData(data)
	self.bid = data.bid
	self.needBack = data.needBack
	local specializationRead = include("specializationRead")
	self.Text_build:setString(specializationRead.getMasteryName(self.bid))
	SoraChangeSpriteImage(self.Image_build, specializationRead.getBuildIcon(self.bid))
end
function masteryLockPopView:exitView(...)
	local mainCityFunctions = include("mainCityFunctions")
	mainCityFunctions.masteryJumpToDetailView(self.bid, nil, self.needBack)
end
function masteryLockPopView:gameGuide_getTarget(itemName, parameters)
	if itemName == "Button_close" then
		return self
	end
end
return masteryLockPopView
