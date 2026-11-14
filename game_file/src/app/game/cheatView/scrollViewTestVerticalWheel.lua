local DNodeItem = class("DNodeItem", function(target)
	if target == nil then
		return display.newNode()
	end
	return target
end)
function DNodeItem:ctor()
	local contentNode = display.newNode()
	contentNode:addTo(self)
	self.contentNode = contentNode
	self.contentNode:setAnchorPoint(cc.p(0.5, 0.5))
	self.contentNode:setContentSize(cc.size(150, 150))
	self.contentNode:setPosition(cc.p(75, 75))
	local layout = ccui.Layout:create()
	layout:addTo(self, -1)
	layout:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
	layout:setBackGroundColor(cc.c3b(math.random(255), math.random(255), math.random(255)))
	self.layout = layout
	local labelName = ccui.Text:create()
	labelName:setFontSize(18)
	labelName:setColor(cc.c3b(255, 0, 0))
	labelName:setString(i18n("common_text_2731"))
	labelName:addTo(self.contentNode, 15)
	self.labelName = labelName
	local labelScale = ccui.Text:create()
	labelScale:setFontSize(18)
	labelScale:setColor(cc.c3b(255, 0, 0))
	labelScale:setString("")
	labelScale:addTo(self.contentNode, 18)
	_ENV, _ENV, self.labelScale = labelScale, labelScale.addTo, labelScale
	labelScale.color = cc.c3b(120, 250, 120)
	_ENV, labelScale.addTo[1], labelScale.nodeWidth = labelScale, labelScale, 150
	labelScale.color = cc.c3b(250, 250, 120)
	_ENV, labelScale.addTo[2], labelScale.nodeWidth = labelScale, labelScale, 150
	labelScale.color = cc.c3b(120, 250, 220)
	self.nodeTypeCfg, labelScale.addTo[3], labelScale.nodeWidth = labelScale.addTo, labelScale, 150
	self.spBg = display.newSprite("#frame_zb_01.png")
	self.spBg:addTo(self.contentNode, 16)
	self.spBg:setPosition(cc.p(75, 75))
	self:updateWithNodeType(1)
end
function DNodeItem:init(data)
	self.data = data
	self.index = data.index
	self.nodeType = data.nodeType
	self.labelName:setString(string.format("%d, nodeType =%d", self.index, self.nodeType))
	self:updateWithNodeType(self.nodeType)
end
function DNodeItem:updateWithNodeType(nodeType)
	self.nodeHeight = 150
	local cfg = self.nodeTypeCfg[nodeType]
	self.nodeWidth = cfg.nodeWidth
	self.layout:setContentSize(cc.size(self.nodeWidth, self.nodeHeight))
	self.labelName:setPositionX(self.nodeWidth / 2)
	self.labelName:setPositionY(self.nodeHeight - 10)
	self.labelScale:setPositionX(self.nodeWidth / 2)
	self.labelScale:setPositionY(self.nodeHeight / 2)
end
function DNodeItem:getNodeWidth()
	return self.nodeWidth
end
function DNodeItem:getNodeHeight()
	return self.nodeHeight
end
function DNodeItem:setContentScale(scale)
	self.contentNode:setScale(scale)
	self.labelScale:setString(string.format("%.3f", scale))
end
function DNodeItem:setContentOffset(offsetX, offsetY)
	if offsetX then
		self.contentNode:setPositionX(self.nodeWidth / 2 + offsetX)
	end
	if offsetY then
		self.contentNode:setPositionY(self.nodeHeight / 2 + offsetY)
	end
end
function DNodeItem:setContentOpacity(opacity)
	if not self.contentNode:isCascadeOpacityEnabled() then
		self.contentNode:setCascadeOpacityEnabled(true)
	end
	self.contentNode:setOpacity(opacity)
end
local scrollViewTest = class("scrollViewTest", function(target)
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
function scrollViewTest:ctor()
	self:createUI()
	self.Top_Size_Tile_Image_bg = SoraDGetChildByName(self, "Top_Size_Tile_Image_bg")
	self.Top_Size_Tile_Image_bg:setFillType(0)
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.commonFramTitle_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.Top_Size_Tile_Image_bg:loadTexture("frame_chat_12.png", ccui.TextureResType.plistType)
	self:init()
end
function scrollViewTest:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function scrollViewTest:init(data)
	local labelName = ccui.Text:create()
	labelName:setFontSize(18)
	labelName:setColor(cc.c3b(255, 0, 0))
	labelName:setString(i18n("未选中节点"))
	labelName:addTo(self, 15)
	labelName:setPosition(cc.p(320, 600))
	self.labelName = labelName
	self.scrollView = ccui.ScrollView:create()
	self.scrollView:setAnchorPoint(0, 0)
	self.scrollView:setBounceEnabled(true)
	self.scrollView:setDirection(1)
	self.scrollView:setPosition(cc.p(130, 100))
	self.scrollView:addTo(self, 1)
	self.scrollView:setContentSize(cc.size(300, 580))
	self.scrollView:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
	self.scrollView:setBackGroundColor(cc.c3b(128, 128, 128))
	self.listData, _ENV, self.itemsData, _ENV = self.scrollView.setBackGroundColor, self.scrollView.setBackGroundColor, self.scrollView.setBackGroundColor, self.scrollView.setBackGroundColor
	self.wGet = false
	self.sIndex = 1
	self.scroll = include("commonScrollView").new(self.scrollView)
	local nodeSize = cc.size(150, 150)
	_ENV = cc.c3b(128, 128, 128)
	cc.c3b(128, 128, 128).listData = self.listData
	cc.c3b(128, 128, 128).nodeSizeType = gScrollViewNodeSizeType.dynamic
	cc.c3b(128, 128, 128).createNodeHandler = handler(self, self.createSingleNode)
	cc.c3b(128, 128, 128).nodeDirection = gScrollViewNodeDirection.top
	cc.c3b(128, 128, 128).dragTipType = gScrollViewDragTipType.bottom
	cc.c3b(128, 128, 128).requestHandler = handler(self, self.requestHandler)
	cc.c3b(128, 128, 128).widthNotice = 0
	cc.c3b(128, 128, 128).heightNotice = 0
	cc.c3b(128, 128, 128).scrollViewType = gScrollViewType.wheel
	cc.c3b(128, 128, 128).selWheelNodeHandler = handler(self, self.onSelWheelNode)
	cc.c3b(128, 128, 128).paddingTop = self.scroll:getContentSize().height / 2 - nodeSize.height / 2
	cc.c3b(128, 128, 128).paddingBottom = self.scroll:getContentSize().height / 2 - nodeSize.height / 2
	self.scroll:init(cc.c3b(128, 128, 128))
	self:req4Data(self.sIndex)
	_UPVALUE3_ = self.scroll:getContentSize().height / 2 - nodeSize.height / 2
	;(self.scroll:getContentSize().height / 2 - nodeSize.height / 2)[1] = cca.delay(1.5)
	;(self.scroll:getContentSize().height / 2 - nodeSize.height / 2)[2] = cca.callFunc(function()
		self.scroll:scrollToWheelIndex(5)
	end)
	;(self.scroll:getContentSize().height / 2 - nodeSize.height / 2)[3] = cca.delay(0.5)
	;(self.scroll:getContentSize().height / 2 - nodeSize.height / 2)[4] = cca.callFunc(function()
		print("getNearestIndex = ", self.scroll:getNearestIndex())
	end)
	;(self.scroll:getContentSize().height / 2 - nodeSize.height / 2)[5] = cca.callFunc(function()
		print("getNearestIndex = ", self.scroll:getNearestIndex())
	end)
	self:runAction(cca.seq(self.scroll:getContentSize().height / 2 - nodeSize.height / 2))
end
function scrollViewTest:onSelWheelNode(index, itemData)
	print(debug.traceback())
	print("scrollViewTest:onSelWheelNode(index, itemData)", index)
	self.labelName:setString("选中了" .. index)
end
function scrollViewTest:requestHandler()
	if self.wGet then
		self:req4Data(self.sIndex)
	end
end
function scrollViewTest:req4Data(startIndex)
	SoraDCloseLoading(self)
	local _ENV, ret = SoraDCloseLoading, SoraDCloseLoading
	local idx = startIndex
	local wget
	if 30 < startIndex then
		wget = false
	else
		wget = true
	end
	print("req4Data startIndex = ", startIndex, "wget = ", wget)
	if wget then
		local count = 10
		if startIndex <= 30 then
			for i = 1, count do
				_ENV = nil
				;(nil).nodeType = math.random(3)
				;(nil).name = "name_" .. startIndex + i - 1
				table.insert(ret, nil)
			end
		end
		idx = idx + count
	end
	_ENV = 1
	;(1).idx = idx
	;(1).wget = wget
	;(1).dataList = ret
	self:rspData(nil, 1)
end
function scrollViewTest:rspData(target, data)
	dump(data, "scrollViewTest:rspData(target, data)")
	self.sIndex = data.idx
	self.wGet = data.wget
	if next(data.dataList) ~= nil then
		local cpyTbl = clone(data.dataList)
		for i, v in ipairs(cpyTbl) do
			table.insert(self.itemsData, v)
		end
		self.listData, _ENV = ipairs(cpyTbl)
		for i, v in ipairs(self.itemsData) do
			_ENV = v
			v.index = i
			v.nodeType = v.nodeType
			v.data = v
			table.insert(self.listData, v)
		end
		self.scroll:refreshList(self.listData)
	end
	print(" self.wGet  = ", self.wGet)
	if not self.wGet then
		self.scroll:setHasMore(false)
	end
end
function scrollViewTest:createSingleNode()
	return DNodeItem.new()
end
return scrollViewTest
