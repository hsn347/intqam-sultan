local gametop = gModuleMgr.getObject("gametop")
local petCarnivalCtrl = SoraDGetCtrl("petCarnivalCtrl")
local petCarnivalRead = include("petCarnivalRead")
_ENV = "petCarnivalRead"
;("petCarnivalRead").noClaim = 1
;("petCarnivalRead").noReach = 2
local ("petCarnivalRead").claimed, giftStatus = 3, "petCarnivalRead"
local petCarnivalOpenTenItem = class("petCarnivalOpenTenItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("petCarnivalOpenTenItem")
	end
	return target
end)
function petCarnivalOpenTenItem:ctor(...)
	self.award, _ENV = nil, nil
	self.Text_no = SoraDGetChildByName(self, "Text_no")
	self.FileNode_1 = SoraDGetChildByName(self, "FileNode_1")
	self.Node_ani = SoraDGetChildByName(self, "Node_ani")
	self.Node_Three = SoraDGetChildByName(self.FileNode_1, "Node_Three")
	self.Node_Two = SoraDGetChildByName(self.FileNode_1, "Node_Two")
	self.Node_Three_ar = SoraDGetChildByName(self.FileNode_1, "Node_Three_ar")
	self.Node_Two_ar = SoraDGetChildByName(self.FileNode_1, "Node_Two_ar")
	self.Node_Three:setVisible(false)
	self.Node_Two:setVisible(false)
	self.Node_Three_ar:setVisible(false)
	self.Node_Two_ar:setVisible(false)
	SoraDCreatAnimationEx("Node_petCarnivalTenItem_loop", self.FileNode_1, true)
	self.Node_award = SoraDGetChildByName(self, "Node_award")
	self.CCS_commonItemAward_1 = SoraDGetChildByName(self, "CCS_commonItemAward_1")
	self.CCS_commonItemAward_1:setVisible(false)
	self.Image_45 = SoraDGetChildByName(self, "Image_45")
	self.Image_45_0 = SoraDGetChildByName(self, "Image_45_0")
	self.Image_45_1 = SoraDGetChildByName(self, "Image_45_1")
	self.Node_two_bg_1 = SoraDGetChildByName(self, "Node_two_bg_1")
	self.Node_two_bg_2 = SoraDGetChildByName(self, "Node_two_bg_2")
	self.Node_three_bg_1 = SoraDGetChildByName(self, "Node_three_bg_1")
	self.Node_three_bg_2 = SoraDGetChildByName(self, "Node_three_bg_2")
	self.Node_three_bg_3 = SoraDGetChildByName(self, "Node_three_bg_3")
end
function petCarnivalOpenTenItem:onMessageListener(...)
end
function petCarnivalOpenTenItem:initData(data, otherData)
	self.view = otherData.view
	self.scroll = otherData.scroll
	local card = clone(data.card)
	local reward = data.reward
	local double = data.double
	if #card == 3 then
		self.Node_Three:setVisible(false)
		self.Node_Two:setVisible(false)
		self.Node_Three_ar:setVisible(false)
		self.Node_Two_ar:setVisible(false)
		self.Node_three_bg_1:setVisible(false)
		self.Node_three_bg_2:setVisible(false)
		self.Node_three_bg_3:setVisible(false)
		self.Node_two_bg_1:setVisible(false)
		self.Node_two_bg_2:setVisible(false)
	elseif #card == 2 then
		card[3] = card[2]
		card[2] = card[1]
		self.Node_Two:setVisible(not SoraDFIsRA())
		self.Node_Two_ar:setVisible(SoraDFIsRA())
		self.Node_three_bg_1:setVisible(false)
		self.Node_three_bg_2:setVisible(false)
		self.Node_three_bg_3:setVisible(false)
		self.Node_two_bg_1:setVisible(true)
		self.Node_two_bg_2:setVisible(true)
		_UPVALUE3_ = SoraDFIsRA()
		SoraDFIsRA()[1] = cca.delay((data.index - 1) * 5 / 60)
		SoraDFIsRA()[2] = cca.callFunc(function(...)
			self:initFlash(self.Image_45, 2)
			self:initFlash(self.Image_45_0, 2)
		end)
		SoraDFIsRA()[3] = cca.delay(0.16666666666666666)
		SoraDFIsRA()[4] = cca.callFunc(function(...)
			SoraDCreatAnimationEx(self.__cname, self, true)
		end)
		SoraDFIsRA()[5] = cca.callFunc(function(...)
			SoraDCreatAnimationEx(self.__cname, self, true)
		end)
		SoraDFIsRA()[6] = cca.callFunc(function(...)
			SoraDCreatAnimationEx(self.__cname, self, true)
		end)
		self:runAction(cca.seq(SoraDFIsRA()))
	else
		card[3] = card[1]
		card[2] = card[1]
		self.Node_Three:setVisible(not SoraDFIsRA())
		self.Node_Three_ar:setVisible(SoraDFIsRA())
		self.Node_three_bg_1:setVisible(true)
		self.Node_three_bg_2:setVisible(true)
		self.Node_three_bg_3:setVisible(true)
		self.Node_two_bg_1:setVisible(false)
		self.Node_two_bg_2:setVisible(false)
		_UPVALUE3_ = SoraDFIsRA()
		SoraDFIsRA()[1] = cca.delay((data.index - 1) * 5 / 60)
		SoraDFIsRA()[2] = cca.callFunc(function(...)
			self:initFlash(self.Image_45, 3)
			self:initFlash(self.Image_45_0, 3)
			self:initFlash(self.Image_45_1, 3)
		end)
		SoraDFIsRA()[3] = cca.delay(0.16666666666666666)
		SoraDFIsRA()[4] = cca.callFunc(function(...)
			SoraDCreatAnimationEx(self.__cname, self, true)
		end)
		SoraDFIsRA()[5] = cca.callFunc(function(...)
			SoraDCreatAnimationEx(self.__cname, self, true)
		end)
		SoraDFIsRA()[6] = cca.callFunc(function(...)
			SoraDCreatAnimationEx(self.__cname, self, true)
		end)
		self:runAction(cca.seq(SoraDFIsRA()))
	end
	self.Node_award:removeAllChildren()
	self.Text_no:setString(data.index)
	for index = 1, table.nums(reward) do
		local data = reward[index]
		itemAward = include("commonItemAward").new()
		itemAward:setVisible(true)
		itemAward:setRealScale(0.5)
		if double then
			local x2 = cc.Sprite:createWithSpriteFrameName("icon_mcdkh_double_01.png")
			x2:setPosition(35, 40)
			x2:addTo(itemAward, 15)
		end
		itemAward:setOwnScroll(otherData.scroll)
		itemAward:setOwnView(otherData.view)
		itemAward:setPosition(0, 0)
		itemAward:addTo(self.Node_award)
		itemAward:initData(data.id, data.count)
		self.award[index] = itemAward
	end
	for index = 1, 3 do
		local img = SoraDGetChildByName(self, "Image_" .. index)
		if card[index] < 10 then
			img:loadTexture("frame_petFlip_0" .. card[index] .. ".png", ccui.TextureResType.plistType)
		else
			img:loadTexture("frame_petFlip_10.png", ccui.TextureResType.plistType)
		end
	end
	SoraDautoSortPos(self.Node_award, 3, SoraDFIsRA() and 2 or 0, cc.size(55, 55))
end
function petCarnivalOpenTenItem:initFlash(parent, showType)
	local flash = SoraDCreatePanel("petCarnivalCardFlash")
	flash:showFlash(showType)
	flash:setPosition(cc.p(parent:getContentSize().width / 2, parent:getContentSize().height / 2))
	if showType == 2 then
		flash:setPosition(cc.p(parent:getContentSize().width / 2 + 5, parent:getContentSize().height / 2 + 5))
	end
	flash:addTo(parent)
end
return petCarnivalOpenTenItem
