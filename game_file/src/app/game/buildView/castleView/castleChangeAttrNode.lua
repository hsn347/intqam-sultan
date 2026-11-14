local attrltCtrl = include("attrltCtrl")
local propParser = include("propParser")
_ENV = "propParser"
;("propParser").maxtextw = 280
;("propParser").nodeWidth = 600
;("propParser").nodeHeight = 40
;("propParser").titleWFit = 100
;("propParser").colorNameActive = cc.c3b(230, 200, 165)
;("propParser").colorValueActive = cc.c3b(0, 190, 30)
local _ENV, ("propParser").colorDeactive, _defaultParamWide = cc.c3b(120, 120, 120), cc.c3b(120, 120, 120), "propParser"
cc.c3b(120, 120, 120).maxtextw = 300
cc.c3b(120, 120, 120).nodeWidth = 520
cc.c3b(120, 120, 120).nodeHeight = 40
cc.c3b(120, 120, 120).titleWFit = 100
cc.c3b(120, 120, 120).colorNameActive = cc.c3b(230, 200, 165)
cc.c3b(120, 120, 120).colorValueActive = cc.c3b(0, 190, 30)
local _ENV, cc.c3b(120, 120, 120).colorDeactive, _defaultParamNarrow = cc.c3b(120, 120, 120), cc.c3b(120, 120, 120), cc.c3b(120, 120, 120)
cc.c3b(120, 120, 120).wide = 1
local cc.c3b(120, 120, 120).narrow, NodeStyle = 2, cc.c3b(120, 120, 120)
local castleChangeAttrNode = class("castleChangeAttrNode", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("castleChangeAttrNode")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
_ENV, castleChangeAttrNode.NodeStyle = "castleChangeAttrNode", NodeStyle
;("castleChangeAttrNode").title = 1
;("castleChangeAttrNode").attr = 2
;("castleChangeAttrNode").none = 3
;("castleChangeAttrNode").attr_custom = 4
castleChangeAttrNode.NodeType, ("castleChangeAttrNode").describe = "castleChangeAttrNode", 5
function castleChangeAttrNode:ctor()
	self:createUI()
	self.nodeAttr = SoraDGetChildByName(self, "node_attr")
	self.itemBg = SoraDGetChildByName(self, "Item_Bg")
	self.itemName = SoraDGetChildByName(self, "Item_Name")
	self.itemValue = SoraDGetChildByName(self, "Item_Value")
	self.nodeTitle = SoraDGetChildByName(self, "node_title")
	self.txtTitle = SoraDGetChildByName(self, "txt_title")
	self.imgLine1 = SoraDGetChildByName(self, "img_line_1")
	self.imgLine2 = SoraDGetChildByName(self, "img_line_2")
	self.imgLine1.oriSize = self.imgLine1:getContentSize()
	self.imgLine2.oriSize = self.imgLine2:getContentSize()
	self.nodeWidth = 640
	self.nodeHeight = 40
	self.nodeStyle = NodeStyle.wide
end
function castleChangeAttrNode:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function castleChangeAttrNode:init(data)
	self.data = data
	if data.nodeStyle then
		self.nodeStyle = data.nodeStyle
		self.nodeAttr:setPositionX(260)
		self.nodeTitle:setPositionX(260)
	end
	local _defaultParam = _defaultParamWide
	if self.nodeStyle == NodeStyle.narrow then
		_defaultParam = _defaultParamNarrow
	end
	if self.data.nodeType == castleChangeAttrNode.NodeType.title then
		self.nodeTitle:setVisible(true)
		self.nodeAttr:setVisible(false)
		self.txtTitle:setString(self.data.title)
		local deltaW = (self.txtTitle:getContentSize().width - _defaultParam.titleWFit) / 2
		self.imgLine1:setContentSize(cc.size(self.imgLine1.oriSize.width - deltaW, self.imgLine1.oriSize.height))
		self.imgLine2:setContentSize(cc.size(self.imgLine2.oriSize.width - deltaW, self.imgLine1.oriSize.height))
		_defaultParamNarrow = self.imgLine2
		self.imgLine2[1] = self.txtTitle
		self.imgLine2[2] = self.imgLine2
		NodeStyle = self.imgLine2
		self.imgLine2[1] = 10
		SoraDAlignNodeArray(self.imgLine2, true, self.imgLine2)
		_defaultParamNarrow = self.imgLine2
		self.imgLine2[1] = self.txtTitle
		self.imgLine2[2] = self.imgLine1
		NodeStyle = self.imgLine1
		self.imgLine1[1] = 10
		SoraDAlignNodeArray(self.imgLine2, false, self.imgLine1)
	elseif self.data.nodeType == castleChangeAttrNode.NodeType.attr or self.data.nodeType == castleChangeAttrNode.NodeType.attr_custom then
		self.nodeTitle:setVisible(false)
		self.nodeAttr:setVisible(true)
		if self.data.nodeType == castleChangeAttrNode.NodeType.attr then
			self.itemName:setString(attrltCtrl.getAttrDes(self.data.attrID) .. ":")
			local strValue = propParser.getFormatByAttrIDAndValue(self.data.attrID, self.data.attrValue)
			self.itemValue:setString(strValue)
		elseif self.data.nodeType == castleChangeAttrNode.NodeType.attr_custom then
			self.itemName:setString(self.data.attrName)
			self.itemValue:setString(self.data.attrValue)
		end
		self.itemName:setVisible(true)
		if data._nameSize then
			self.itemName:setTextAreaSize(data._nameSize)
			print("已经预先测量 _titleSize")
		else
			SoraDGetAutoHeightLabelNew(self.itemName, _defaultParam.maxtextw)
		end
		local lablH = self.itemName:getContentSize().height
		local totalH = lablH + 10
		totalH = math.max(totalH, _defaultParam.nodeHeight)
		self.nodeHeight = totalH
		self.itemBg:setContentSize(cc.size(600, self.nodeHeight))
		self.itemName:setPositionY(self.nodeHeight / 2)
		self.itemValue:setPositionY(self.nodeHeight / 2)
		if data.isActive == false then
			self.itemName:setColor(_defaultParam.colorDeactive)
			self.itemValue:setColor(_defaultParam.colorDeactive)
		else
			self.itemName:setColor(_defaultParam.colorNameActive)
			self.itemValue:setColor(_defaultParam.colorValueActive)
		end
		self.itemValue:setPositionX(SoraDFPosX(-100, 0))
	elseif self.data.nodeType == castleChangeAttrNode.NodeType.describe then
		self.nodeTitle:setVisible(false)
		self.nodeAttr:setVisible(true)
		self.itemName:setAnchorPoint(self.itemName:getAnchorPoint().x, 1)
		self.itemName:setString(self.data.describe)
		SoraDGetAutoHeightLabelNew(self.itemName, 400)
		self.itemName:setColor(_defaultParam.colorNameActive)
	elseif self.data.nodeType == castleChangeAttrNode.NodeType.none then
		self.nodeTitle:setVisible(false)
		self.nodeAttr:setVisible(true)
		self.itemName:setVisible(false)
		self.itemName:setString("")
		self.itemValue:setString(i18n("skin_text_04"))
		self.itemValue:setPositionX(SoraDFPosX(self.itemValue:getContentSize().width / 2, 0))
		self.itemValue:setColor(_defaultParam.colorDeactive)
	end
	if self.data.isShowBg then
		self.itemBg:setVisible(true)
	else
		self.itemBg:setVisible(false)
	end
end
function castleChangeAttrNode:updateColor()
end
function castleChangeAttrNode:onMessageListener()
end
function castleChangeAttrNode:setScroll(scroll)
	self.scroll = scroll
end
function castleChangeAttrNode:getNodeWidth()
	return self.nodeWidth
end
function castleChangeAttrNode:getNodeHeight()
	return self.nodeHeight
end
function castleChangeAttrNode.measureSize(data)
	local _defaultParam = _defaultParamWide
	if data.nodeStyle == NodeStyle.narrow then
		_defaultParam = _defaultParamNarrow
	end
	if data.nodeWidth and data.nodeHeight and data.nodeWidth ~= 0 and data.nodeHeight ~= 0 then
		return
	end
	if data.nodeType ~= castleChangeAttrNode.NodeType.attr and data.nodeType ~= castleChangeAttrNode.NodeType.attr_custom then
		data.nodeWidth = _defaultParam.nodeWidth
		data.nodeHeight = _defaultParam.nodeHeight
	else
		local isRA = SoraDFIsRA()
		local _defaultParamWide, textAlign = nil, isRA and cc.TEXT_ALIGNMENT_RIGHT or cc.TEXT_ALIGNMENT_LEFT
		;(nil).fontName = ""
		;(nil).fontSize = 20
		;(nil).fontAlignmentH = textAlign
		;(nil).fontAlignmentV = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
		;(nil).fontDimensions = cc.size(_defaultParam.maxtextw, 0)
		local (nil).isHtml, txtContentInfo = false, nil
		local strTitle
		if data.nodeType == castleChangeAttrNode.NodeType.attr_custom then
			strTitle = data.attrName
		else
			strTitle = attrltCtrl.getAttrDes(data.attrID) .. ":"
		end
		local measureSize = cc.Device:measureText(strTitle, txtContentInfo)
		data._nameSize = measureSize
		local totalH = measureSize.height + 10
		totalH = math.max(totalH, _defaultParam.nodeHeight)
		print("测量 totalH = ", measureSize.height + 10)
		data.nodeWidth = _defaultParam.nodeWidth
		data.nodeHeight = totalH
	end
	return cc.size(data.nodeWidth, data.nodeHeight)
end
return castleChangeAttrNode
