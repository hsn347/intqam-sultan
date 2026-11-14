local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local christmasTreeCtrl = gametop.playertop_:getModule("christmasTreeCtrl")
local itemDesRead = include("itemDesRead")
local christmasTreeMakingView = class("christmasTreeMakingView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end)
_ENV, _ENV = function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end, "christmasTreeMakingView"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end).selected = "btn_zzsds_01.png"
_ENV, ("christmasTreeMakingView")[1], (function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end).normal = function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end, "btn_zzsds_05.png"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end).selected = "btn_zzsds_02.png"
_ENV, ("christmasTreeMakingView")[2], (function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end).normal = function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end, "btn_zzsds_06.png"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end).selected = "btn_zzsds_03.png"
_ENV, ("christmasTreeMakingView")[3], (function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end).normal = function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end, "btn_zzsds_07.png"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end).selected = "btn_zzsds_04.png"
_ENV, ("christmasTreeMakingView")[4], (function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end).normal = function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end, "btn_zzsds_08.png"
local btnImg = "christmasTreeMakingView"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end)[1] = "8515.png"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end)[2] = "8516.png"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end)[3] = "8517.png"
local _ENV, _ENV, (function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end)[4], treeName = nil, nil, "8518.png", function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeMakingView")
	end
	return target
end
;(nil).light = "frame_zzsds_02.png"
_ENV, (nil)[2], (nil).dark = nil, nil, "frame_zzsds_03.png"
;(nil).light = "frame_zzsds_04.png"
_ENV, (nil)[3], (nil).dark = nil, nil, "frame_zzsds_05.png"
;(nil).light = "frame_zzsds_06.png"
_ENV, (nil)[4], (nil).dark = nil, nil, "frame_zzsds_07.png"
local decorationName
;(nil)[1] = 851501
;(nil)[2] = 851601
;(nil)[3] = 851701
local (nil)[4], treeId = 851801, nil
function christmasTreeMakingView:ctor()
	self:initControls()
	self:initFourDecorations()
end
function christmasTreeMakingView:initControls()
	self.bg = SoraDGetChildByName(self, "Image_bg")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_eventCenter")
	self.btnQuest = SoraDGetChildByName(self, "btn_quest")
	self.btnLeft = SoraDGetChildByName(self, "btn_left")
	self.btnRight = SoraDGetChildByName(self, "btn_right")
	self.btnMaking = SoraDGetChildByName(self, "btn_making")
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.txtHave = SoraDGetChildByName(self, "text_remain")
	self.panel = SoraDGetChildByName(self, "Panel_4")
	self.imageDown = SoraDGetChildByName(self, "Image_10")
	self.imageCloud = SoraDGetChildByName(self, "BG_zzsds_04_4")
	self.imageLine = SoraDGetChildByName(self, "frame_king_road_line_01_5")
	self.imageOwn = SoraDGetChildByName(self, "frame_SJDT_mingpai_2")
	self.imageTree = SoraDGetChildByName(self, "BG_zzsds_17_2")
	self.imageTreeOwn = SoraDGetChildByName(self, "frame_zzsds_02_1")
	self.spriteTree = SoraDGetChildByName(self, "Sprite_16")
	self.txtOwnNum = SoraDGetChildByName(self, "text_ownNum")
	self.spriteRound = SoraDGetChildByName(self, "frame_common_round_15")
	self.btnJump = SoraDGetChildByName(self, "btn_jumpto")
	self.bg:setFillType(1)
	self.nodeTitle:setTitle(i18n("christmas_tree_text_01"))
	self.btnMaking:setTitleText(i18n("christmas_tree_btn_01"))
	self.btnQuest:addTouchEventListener(handler(self, self.questClickCallBack))
	self.btnLeft:addTouchEventListener(handler(self, self.leftClickCallBack))
	self.btnRight:addTouchEventListener(handler(self, self.rightClickCallBack))
	self.btnMaking:addTouchEventListener(handler(self, self.makingClickCallBack))
	self.btnJump:addTouchEventListener(handler(self, self.jumpClickCallBack))
	self.tableBtnChoose, _ENV = self.btnJump.addTouchEventListener, self.btnJump.addTouchEventListener
	self.tableBtnChoose = SoraDGetChildsArrayByName(self, "btn_choose_0", 4, 1)
	for i, v in ipairs(self.tableBtnChoose) do
		v:addTouchEventListener(handler(self, self.btnChooseClickCallBack))
		v:setTag(i)
	end
	self.chooseIndex = 1
	self.btnLeft:setVisible(false)
	self.btnJump:setTag(treeId[self.chooseIndex])
	self.spriteTree:setSpriteFrame("8515.png")
	self.spriteTree:setScale(0.8)
	self.spriteTree:setPositionY(60)
	self.txtOwnNum:setString(backpackCtrl:getItemCount(treeId[1]))
	self.txtHave:setString(itemDesRead.getName(treeId[1]))
	self.imageTreeOwn:setVisible(false)
	if display.height > 960 then
		self.imageDown:setContentSize(cc.size(640, 300))
		self.imageCloud:setPositionY(280)
		self.imageLine:setPositionY(270)
		self.imageOwn:setPositionY(320)
		self.imageTree:setPositionY(-600)
		self.spriteRound:setPositionY(365)
	end
	if device.isIphoneXMode() then
		self.imageDown:setContentSize(cc.size(640, 510))
		self.imageCloud:setPositionY(490)
		self.imageLine:setPositionY(480)
		self.imageOwn:setPositionY(530)
		self.imageTree:setPositionY(-600)
		self.spriteRound:setPositionY(565)
	end
	self.txtTable, _ENV, self.treeList = require("app." .. LocalTblPath .. ".config_server.christmas_tree_make"), require("app." .. LocalTblPath .. ".config_server.christmas_tree_make"), require("app." .. LocalTblPath .. ".config_server.christmas_tree_make")
	self.nodeTitle:setLocalZOrder(2)
	local effectSnow = SoraDCreatAnimation("snowDown")
	effectSnow:setPosition(cc.p(320, -550))
	self.topNode:addChild(effectSnow, 1)
end
function christmasTreeMakingView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_TREE_MAKING_REFRESH", function(target, data)
		SoraDCloseLoading()
		self:initData(self.chooseIndex)
	end)
end
function christmasTreeMakingView:initFourDecorations()
	if next(self.txtTable) then
		for k, v in pairs(self.txtTable) do
			v:setVisible(false)
		end
		self.txtTable, _ENV = pairs(self.txtTable)
	end
	local needMaterials = self:getNeedMaterialsTable(self.chooseIndex)
	for i = 1, 4 do
		local beginTreeIndex = 851001
		local comStr = ""
		local single = SoraDCreatePanel("eventGeocentricCell")
		single:initData(beginTreeIndex + i * 100, 1)
		single:hideInChristmasTreeMaking()
		single:setClickDelegate(handler(self, self.singleCellClick))
		single:sendParentToButton(self)
		single:setScale(0.8)
		if display.height > 960 then
			single:setPosition(cc.p(150 * (i - 1) + 50, 250))
		else
			single:setPosition(cc.p(150 * (i - 1) + 50, 210))
		end
		if device.isIphoneXMode() then
			single:setPosition(cc.p(150 * (i - 1) + 50, 300))
		end
		single:addTo(self.panel)
		_ENV = single
		single.text = 0
		single.size = 20
		single.align = cc.ui.TEXT_ALIGN_CENTER
		single.color = cc.c3b(255, 255, 255)
		local txtNum = cc.ui.UILabel.new(single)
		txtNum:setAnchorPoint(0.5, 0.5)
		txtNum:setPosition(cc.p(150 * (i - 1) + 90, single:getPositionY() - 100))
		txtNum:addTo(self.panel)
		if needMaterials[2 * i - 1] and needMaterials[2 * i] then
			local itemID = needMaterials[2 * i - 1]
			local needCount = tonumber(needMaterials[2 * i])
			local ownCount = backpackCtrl:getItemCount(itemID)
			comStr = string.format("%d/%d", ownCount, needCount)
			txtNum:setString(comStr)
			if needCount > ownCount then
				txtNum:setColor(cc.c3b(255, 0, 0))
			end
		else
			local itemID = needMaterials[2 * i - 1]
			local ownCount = backpackCtrl:getItemCount(itemID)
			txtNum:setColor(cc.c3b(120, 120, 120))
			comStr = string.format("%d/%d", ownCount, 0)
			txtNum:setString(comStr)
		end
		table.insert(self.txtTable, txtNum)
	end
end
function christmasTreeMakingView:singleCellClick(pItem)
end
function christmasTreeMakingView:questClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.CHRISTMAS_TREE_MAKING)
	end
end
function christmasTreeMakingView:btnChooseClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.chooseIndex = button:getTag()
		self.btnRight:setVisible(true)
		self.btnLeft:setVisible(true)
		if self.chooseIndex <= 1 then
			self.btnLeft:setVisible(false)
		elseif self.chooseIndex >= 4 then
			self.btnRight:setVisible(false)
		end
		self:initData(self.chooseIndex)
	end
end
function christmasTreeMakingView:makingClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local treeData = christmasTreeCtrl:getChristmasTreeData()
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CHRISTMAS_TREE_PRODUCTION) then
			if self:isMaterialsEnough() then
				christmasTreeCtrl:sendMakingTreesMsg(self.chooseIndex, 1)
				SoraDShowLoading()
			else
				SoraDShowMsgTip(i18n("christmas_tree_tips_01"))
			end
		else
			SoraDShowMsgTip(i18n("common_text_1859"))
		end
	end
end
function christmasTreeMakingView:leftClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.chooseIndex = self.chooseIndex - 1
		self.btnRight:setVisible(true)
		if self.chooseIndex <= 1 then
			self.btnLeft:setVisible(false)
		end
		self:initData(self.chooseIndex)
	end
end
function christmasTreeMakingView:jumpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local ownCount = backpackCtrl:getItemCount(button:getTag())
		if 0 < ownCount then
			SoraDRemoveAllPrePanelFromManager(self)
			_ENV = button:getTag()
			button:getTag().target = target
			if not include("itemLogic").checkItemSpecial(button:getTag(), 1, button:getTag()) then
				backpackCtrl:reqUseItem(button:getTag(), 1)
			end
		else
			SoraDShowMsgTip(i18n("common_text_2512"))
		end
	end
end
function christmasTreeMakingView:isMaterialsEnough()
	local needMaterials = self:getNeedMaterialsTable(self.chooseIndex)
	for i = 1, #needMaterials / 2 do
		local itemID = needMaterials[2 * i - 1]
		local needCount = tonumber(needMaterials[2 * i])
		local ownCount = backpackCtrl:getItemCount(itemID)
		if needCount > ownCount then
			return false
		end
	end
	return true
end
function christmasTreeMakingView:getNeedMaterialsTable(index)
	if self.treeList[index] then
		return self.treeList[index].Need
	end
	return self.treeList[1].Need
end
function christmasTreeMakingView:rightClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.chooseIndex = self.chooseIndex + 1
		self.btnLeft:setVisible(true)
		if self.chooseIndex >= 4 then
			self.btnRight:setVisible(false)
		end
		self:initData(self.chooseIndex)
	end
end
function christmasTreeMakingView:initData(index)
	for i, button in ipairs(self.tableBtnChoose) do
		if i == index then
			button:loadTextureNormal(btnImg[i].selected, ccui.TextureResType.plistType)
		else
			button:loadTextureNormal(btnImg[i].normal, ccui.TextureResType.plistType)
		end
	end
	self.imageTreeOwn:stopAllActions()
	self.imageTreeOwn:setVisible(index ~= 1)
	if 1 < index then
		self.imageTreeOwn:setSpriteFrame(decorationName[index].light)
	end
	self.btnJump:setTag(treeId[index])
	self.spriteTree:setSpriteFrame(treeName[index])
	self.txtOwnNum:setString(backpackCtrl:getItemCount(treeId[index]))
	self.txtHave:setString(itemDesRead.getName(treeId[index]))
	self:initFourDecorations()
end
function christmasTreeMakingView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CHRISTMAS_TREE_PRODUCTION) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return christmasTreeMakingView
