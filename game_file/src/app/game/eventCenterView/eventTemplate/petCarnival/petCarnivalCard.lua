local gametop = gModuleMgr.getObject("gametop")
local petCarnivalCtrl = gametop.playertop_:getModule("petCarnivalCtrl")
local petCarnivalCard = class("petCarnivalCard", function(target)
	if target == nil then
		return SoraDCreateBasePanel("petCarnivalCard")
	end
	return target
end)
_UPVALUE10_ = "petCarnivalCard"
;("petCarnivalCard")[1] = "baozi"
;("petCarnivalCard")[2] = "daxiang"
;("petCarnivalCard")[3] = "lang"
;("petCarnivalCard")[4] = "milu"
;("petCarnivalCard")[5] = "she"
;("petCarnivalCard")[6] = "shizi"
;("petCarnivalCard")[7] = "xiong"
;("petCarnivalCard")[8] = "yang"
;("petCarnivalCard")[9] = "yangtuo"
local ("petCarnivalCard")[10], aniSpine = "ying", "petCarnivalCard"
function petCarnivalCard:ctor()
	self.param, _ENV, self.randomTime = nil, nil, 0
	self.index = 0
	self.type = 0
	self.isInGuide = false
	self.location = nil
	self.Node_card = SoraDGetChildByName(self, "Node_card")
	self.dh_mengchong7_28_2 = SoraDGetChildByName(self, "dh_mengchong7_28_2")
	self.dh_mengchong7_28_2:setVisible(false)
	self.frame_kapai = SoraDGetChildByName(self, "frame_kapai")
	self.Image_shadow = SoraDGetChildByName(self, "Image_shadow")
	self.Image_num = SoraDGetChildByName(self, "Image_num")
	self.Image_bg = SoraDGetChildByName(self, "Image_bg")
	self.Image_cover_bg = SoraDGetChildByName(self, "Image_cover_bg")
	self:showOneSide(false)
	self.Node_two_bg = SoraDGetChildByName(self, "Node_two_bg")
	self.Node_three_bg = SoraDGetChildByName(self, "Node_three_bg")
	self.Node_two_bg:setVisible(false)
	self.Node_three_bg:setVisible(false)
	self.imgAni = SoraDGetChildByName(self, "imgAni")
	self.imgAni:setVisible(false)
	self.Node_flash = SoraDGetChildByName(self, "Node_flash")
	self.Node_flash:setVisible(true)
	self.Button_card = SoraDGetChildByName(self, "Button_card")
	self.FileNode_double = SoraDGetChildByName(self, "FileNode_double")
	self.FileNode_double:setVisible(false)
	SoraDCreatAnimationEx("petCarnivalCardDouble", self.FileNode_double, true)
	self.FileNode_double.action:pause()
	self.Node_etCard = SoraDGetChildByName(self, "Node_etCard")
	self:initFlash()
	SoraDCreatAnimationEx(self.__cname, self, true)
	self.action:pause()
	self.action:setFrameEventCallFunc(handler(self, self.hideFlash))
end
function petCarnivalCard:hideFlash()
	self.dh_mengchong7_28_2:setVisible(false)
end
function petCarnivalCard:initData(data, param, isInGuide)
end
function petCarnivalCard:initFlash()
	local flash = SoraDCreatePanel("petCarnivalCardFlash")
	flash:setPosition(cc.p(0, 0))
	flash:addTo(self.Node_flash)
	self.Node_Ani_once = flash
end
function petCarnivalCard:showOneSide(flag)
	self.Image_num:setVisible(flag)
	self.Image_bg:setVisible(flag)
	self.Image_cover_bg:setVisible(flag)
end
function petCarnivalCard:setPoint(point, index, type)
	self.index = index
	self.point = point
	self.type = type
	self:setVisible(true)
	self:showOneSide(false)
	self.imgAni:setVisible(false)
	self.frame_kapai:setSpriteFrame("zhengmian.png")
	self:setScale(1, 1)
	if point == 0 then
		self:setScale(0, 0)
	end
	if point < 1 then
		return
	end
	if point < 10 then
		self.Image_num:loadTexture("frame_petFlip_0" .. point .. ".png", ccui.TextureResType.plistType)
	else
		self.Image_num:loadTexture("frame_petFlip_10.png", ccui.TextureResType.plistType)
	end
end
function petCarnivalCard:showCoverFlash(flag)
	self.FileNode_double:setVisible(flag)
	if flag then
		self.FileNode_double.action:gotoFrameAndPlay(0, true)
	end
end
function petCarnivalCard:show3DFlip(double, long)
	self.FileNode_double:setVisible(false)
	self.FileNode_double.action:pause()
	self:setScale(1, 1)
	self.Node_card:setVisible(false)
	if self.openNode == nil then
		local cssFilePath = long and getCCSPath("petCarnivalCardOenpLong") or getCCSPath("petCarnivalCardOen")
		local action = cc.CSLoader:createTimeline(cssFilePath)
		local Node = cc.uiloader:load(cssFilePath)
		Node.action = action
		local node = SoraDGetChildByName(Node, "Node_open")
		local bg = SoraDGetChildByName(Node, "Image_bg")
		local cover = SoraDGetChildByName(Node, "dld_fanpai_001_1")
		local flash = SoraDGetChildByName(Node, "Sprite_double")
		local animal = SoraDGetChildByName(Node, "ima_Animal")
		Node.node = node
		Node.bg = bg
		Node.cover = cover
		Node.animal = animal
		Node.flash = flash
		bg:setVisible(true)
		cover:setVisible(true)
		animal:setVisible(false)
		flash:setVisible(double)
		self.openNode = Node
		action:setFrameEventCallFunc(handler(self, self.setCard))
		action:gotoFrameAndPlay(0, false)
		Node:addTo(self, 20)
		Node:runAction(action)
		self:setAnimal(animal, self.point)
	end
end
function petCarnivalCard:setAnimal(card, point)
	print("设置牌", point)
	if point < 1 then
		return
	end
	if point < 10 then
		card:setSpriteFrame("frame_petFlip_0" .. point .. ".png")
	else
		card:setSpriteFrame("frame_petFlip_10.png")
	end
end
function petCarnivalCard:showAnimalSpine()
	if self.openSpine ~= nil then
		self.openSpine:removeFromParent()
	end
	local spine_bz = sp.SkeletonAnimation:create("spine/yangtuo.skel", "spine/yangtuo.atlas", 1)
	spine_bz:setPosition(cc.p(0, -85))
	spine_bz:addTo(self, 25)
	spine_bz:setVisible(true)
	spine_bz:setScale(0.76)
	spine_bz:setAnimation(0, aniSpine[self.point] .. "01", false)
	self.openSpine = spine_bz
end
function petCarnivalCard:setCard(frame)
	local eventName = frame:getEvent()
	if eventName == "end" then
		self.openNode.animal:setVisible(true)
		_ENV = self.openNode.animal
		self.openNode.animal.msg = "MESSAGE_PETCARNIVAL_OPENONE"
		self.openNode.animal.doneIndex = self.index
		SoraDSendMessage(self.openNode.animal)
	elseif eventName == "show" then
		print("翻牌动画结束")
		self:showOneSide(true)
		self.Node_card:setVisible(true)
		if self.openNode ~= nil then
			self.openNode:removeFromParent()
			self.openNode = nil
		end
	end
end
function petCarnivalCard:showAnimal(type)
	print("播放" .. self.index)
	self:setScale(1.2, 1.2)
	self.action:gotoFrameAndPlay(0, true)
	self.Node_two_bg:setVisible(type == 2)
	self.Node_three_bg:setVisible(type == 3)
	self.dh_mengchong7_28_2:setVisible(type == 3)
	self.imgAni:setVisible(true)
	self.Node_Ani_once:showFlash(type)
	self.Image_num:setVisible(false)
	self:showAnimalSpine()
end
function petCarnivalCard:stopAnimal()
	if self.openSpine ~= nil then
		self.openSpine:removeFromParent()
	end
	self.openSpine = nil
	self:setScale(1, 1)
	self.imgAni:setVisible(false)
	self.action:pause()
	self.Node_two_bg:setVisible(false)
	self.Node_three_bg:setVisible(false)
	self.Image_num:setVisible(true)
	self.Node_Ani_once:stopAnimal()
end
function petCarnivalCard:hideCard()
	self.frame_kapai:setSpriteFrame("zhengmian.png")
	self:setVisible(false)
end
return petCarnivalCard
