local gametop = gModuleMgr.getObject("gametop")
local godArmsCtrl = gametop.playertop_:getModule("godArmsCtrl")
local equipDesRead = include("equipDesRead")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local divineBeastRead = include("divineBeastRead")
local commonDivinebeast = class("commonDivinebeast", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonDivinebeast")
	end
	return target
end)
function commonDivinebeast:ctor()
	self.divineID = 0
	self.myMode = gHeroSelectBannerStyle.inner
	self.speireIcon = SoraDGetChildByName(self, "Sprite_divinebeast")
	self.btnAdd = SoraDGetChildByName(self, "Button_add")
	self.spAdd = SoraDGetChildByName(self, "Sprite_add")
	self.starBase = SoraDGetChildByName(self, "Node_type2_stars")
	self.showType1Node = SoraDGetChildByName(self, "Node_type_1")
	_UPVALUE2_, self.showType2Node = SoraDGetChildByName(self, "Node_type_2"), SoraDGetChildByName(self, "Node_type_2")
	self.showTypeNodes, SoraDGetChildByName(self, "Node_type_2")[1] = SoraDGetChildByName(self, "Node_type_2"), self.showType1Node
	self.showTypeNodes, SoraDGetChildByName(self, "Node_type_2")[2] = SoraDGetChildByName(self, "Node_type_2"), self.showType2Node
	self.btnAdd:setVisible(false)
	self.btnAdd:addTouchEventListener(handler(self, self.btnAddCallBack))
end
function commonDivinebeast:setShowType(showType)
	if self.showType == showType then
		return
	end
	self.showType = showType
	self.showType1Node:setVisible(showType == 1)
	self.showType2Node:setVisible(showType == 2)
	local parentNode = self.showTypeNodes[showType]
	self.stars, _ENV = self.showType2Node, self.showType2Node
	for i = 1, 8 do
		self.stars[i] = SoraDGetChildByName(parentNode, "Sprite_star" .. i)
	end
	self.txtStepLv = SoraDGetChildByName(parentNode, "Text_db_lv")
	self.starDesc = SoraDGetChildByName(parentNode, "Text_db_star")
	self.txtStarLv = SoraDGetChildByName(parentNode, "Text_db_star_value")
	self.star = SoraDGetChildByName(parentNode, "Sprite_star1")
	if showType == 2 then
		self.starDesc:setString(i18n("Divine_beast_text_36"))
		if SoraDFIsRA() then
			self.star:setPositionX(self.starDesc:getPositionX() - self.starDesc:getContentSize().width - 12)
			self.txtStarLv:setPositionX(self.star:getPositionX() - 15)
		else
			self.star:setPositionX(self.starDesc:getPositionX() + self.starDesc:getContentSize().width + 5)
			self.txtStarLv:setPositionX(self.star:getPositionX() + 15)
		end
	end
end
function commonDivinebeast:initData(divineBeastInfo, showType)
	dump(divineBeastInfo, "commonDivinebeast:initData")
	showType = showType or 1
	self:setShowType(showType)
	self.divineID = divineBeastInfo.beastId
	if showType == 1 then
		_ENV = nil
		;(nil).num = divineBeastInfo.stepLv or 0
		self.txtStepLv:setString(i18n("Divine_beast_text_66", nil))
	else
		_ENV = i18n("Divine_beast_text_66", nil)
		i18n("Divine_beast_text_66", nil).num = divineBeastInfo.stepLv or 0
		self.txtStepLv:setString(i18n("Divine_beast_text_37", i18n("Divine_beast_text_66", nil)))
	end
	self.txtStarLv:setString("" .. (divineBeastInfo.starLv or 0))
	self.speireIcon:setScale(1)
	self.speireIcon:setSpriteFrame(divineBeastRead.getIcon(self.divineID))
end
function commonDivinebeast:btnAddCallBack(button, type)
	if self.clickCallback then
		self.clickCallback(button, type, self.clickData)
	end
end
function commonDivinebeast:setClickCallback(clickCallback, data)
	self.clickCallback = clickCallback
	self.clickData = data
	self.btnAdd:setVisible(true)
end
return commonDivinebeast
