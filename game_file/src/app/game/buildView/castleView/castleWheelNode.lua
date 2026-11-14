local gametop = gModuleMgr.getObject("gametop")
local dressCtrl = gametop.playertop_:getModule("dressCtrl")
local shopCtrl = gametop.playertop_:getModule("shopCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local castleSkinRead = include("castleSkinRead")
local dressltCtrl = include("dressltCtrl")
_ENV = "dressltCtrl"
;("dressltCtrl").shop = 1
local ("dressltCtrl").bag, SelType = 2, "dressltCtrl"
local castleWheelNode = class("castleWheelNode", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("castleWheelNode")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
local nodeSize = cc.size(138, 138)
function castleWheelNode:ctor()
	self:createUI()
	self.contentNode = SoraDGetChildByName(self, "contentNode")
	self.iconBg = SoraDGetChildByName(self, "icon_bg")
	self.iconItem = SoraDGetChildByName(self, "icon_item")
	self.iconTag = SoraDGetChildByName(self, "icon_tag")
	self.iconG = SoraDGetChildByName(self, "icon_g")
	self.spriteRed = SoraDGetChildByName(self, "Sprite_red")
	self.spriteTime = SoraDGetChildByName(self, "Sprite_time")
	self.iconG:setVisible(false)
	self.spriteRed:setVisible(false)
	self.nodeWidth = nodeSize.width
	self.nodeHeight = nodeSize.height
end
function castleWheelNode:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function castleWheelNode:init(data)
	self.data = data
	self.iconItem:setFlippedX(false)
	print("castleSkinRead.getDressTypeBySubType(self.data.subType)  = ", castleSkinRead.getDressTypeBySubType(self.data.subType))
	if castleSkinRead.getDressTypeBySubType(self.data.subType) == tonumber(gDressType.CASTLE_NAMEPLATE) then
		print("这个是-----铭牌-----")
		self.iconItem:ignoreContentAdaptWithSize(true)
		self.iconItem:setScale(0.7)
	else
		self.iconItem:ignoreContentAdaptWithSize(false)
		self.iconItem:setContentSize(cc.size(120, 120))
		self.iconItem:setScale(0.9)
	end
	self.iconItem:getVirtualRenderer():setState(0)
	self.iconItem:loadTexture(castleSkinRead.getIconBySubType(self.data.subType), ccui.TextureResType.plistType)
	local skinQuality = castleSkinRead.getSkinQualityBySubType(self.data.subType)
	local skinQualityCfg = castleSkinRead.getSkinQualityCfg(skinQuality)
	if skinQualityCfg then
		self.iconTag:setSpriteFrame(SoraDFIsRA() and skinQualityCfg.ar or skinQualityCfg.en)
		self.iconTag:setVisible(true)
	else
		self.iconTag:setVisible(false)
	end
	self.spriteTime:setVisible(false)
	if self.data.selType == SelType.bag then
		local isActive = self:isActive()
		if isActive then
			self.iconG:setVisible(true)
		else
			self.iconG:setVisible(false)
			self.spriteTime:setVisible(self:isNeedShowTime())
		end
	else
		self.iconG:setVisible(false)
	end
	self:updateRedPoint()
end
function castleWheelNode:updateRedPoint()
	if self.data.isNew then
		self.spriteRed:setVisible(true)
		if self.iconTag:isVisible() then
			self.spriteRed:setPosition(cc.p(116, 139))
		else
			self.spriteRed:setPosition(cc.p(106, 119))
		end
	else
		self.spriteRed:setVisible(false)
	end
end
function castleWheelNode:isActive()
	local dressTable = dressCtrl:getDressWardrobeData()
	if not dressTable[tonumber(self.data.dressType)] then
		local dressCtrl, dressDatas = dressTable[tonumber(self.data.dressType)], dressTable[tonumber(self.data.dressType)]
	end
	local subType = self.data.subType
	for _, v in ipairs(dressDatas) do
		local subType2 = v.subType or castleSkinRead.getSubType(v.dressID)
		if v.active == true then
			print("找到了激活的：", subType2)
		end
		if subType == subType2 and v.active == true then
			return true
		end
	end
	return false
end
function castleWheelNode:isNeedShowTime()
	local curDressData = self.data.data[1]
	if curDressData and curDressData.remainTime and curDressData.remainTime > 0 then
		return true
	end
	return false
end
function castleWheelNode:setScroll(scroll)
	self.scroll = scroll
end
function castleWheelNode.measureSize(data)
	if data.nodeWidth and data.nodeHeight and data.nodeWidth ~= 0 and data.nodeHeight ~= 0 then
		return cc.size(data.nodeWidth, data.nodeHeight)
	end
	return nodeSize
end
function castleWheelNode:getNodeWidth()
	return self.nodeWidth
end
function castleWheelNode:getNodeHeight()
	return self.nodeHeight
end
function castleWheelNode:setContentScale(scale)
	self.contentNode:setScale(scale)
end
function castleWheelNode:setContentOffset(offsetX, offsetY)
	if offsetX then
		self.contentNode:setPositionX(self.nodeWidth / 2 + offsetX)
	end
	if offsetY then
		self.contentNode:setPositionY(self.nodeHeight / 2 + offsetY)
	end
end
function castleWheelNode:setContentOpacity(opacity)
	if not self.contentNode:isCascadeOpacityEnabled() then
		self.contentNode:setCascadeOpacityEnabled(true)
	end
	self.contentNode:setOpacity(opacity)
end
return castleWheelNode
